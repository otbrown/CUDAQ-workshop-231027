#include <iostream>
#include <argp.h>
#include <cstdlib>
#include <cudaq.h>
#include <cmath>
#include <chrono>

// ArgParse setup
const char *argp_program_version = "CUDAQ-QFT 0.1";
const char *argp_program_bug_address = "<o.brown@epcc.ed.ac.uk>";
const static char DOC[] = "CUDA Quantum QFT implementation.\nNQUBITS must be >0 and <64.";

const static struct argp_option OPTIONS[] = {
  {"nqubits", 'q', "nqubits", 0, "The number of qubits. Default is 4. Must be >0 and <64."},
  {"nq", -1, "nqubits", OPTION_ALIAS},
  {"nshots", 's', "nshots", 0, "The number of shots. Default is 100. Must be >0."},
  { 0 }
};

struct arguments {
  unsigned short nqubits;
  unsigned long nshots;
};

static error_t parse_opt (int key, char *arg, struct argp_state *state) {
  /* Get the input argument from argp_parse, which we
     know is a pointer to our arguments structure. */
  struct arguments *args = (struct arguments *) state->input;

  switch (key)
    {
      case 'q': case -1:
        args->nqubits = (unsigned short) std::strtoul(arg, nullptr, 10);
        if (args->nqubits > 63) argp_error(state, "nqubits > 63, nqubits = %hu.", args->nqubits);
        break;
      case 's':
        args->nshots = std::strtoul(arg, nullptr, 10);
        break;
      default:
        return ARGP_ERR_UNKNOWN;
    }
  return 0;
}
const static struct argp argp = { OPTIONS, parse_opt, 0, DOC };

// CUDA Quantum

__qpu__ void qft(cudaq::qspan<> qs) {
  const short int N = qs.size();
  double theta;

  for (short int target = N-1; target >= 0; --target) {
    cudaq::h(qs[target]);
    for (short int control = target-1; control >= 0; --control) {
      theta = M_PI / std::pow(2, target-control);
      cudaq::r1<cudaq::ctrl>(theta, qs[control], qs[target]);
    }
  }

  for (unsigned short int i = 0; i < N/2; ++i) {
    cudaq::swap(qs[i], qs[N-i-1]);
  }

  return;
}

struct FullQFT {
  void operator()(const unsigned short N) __qpu__ {
    cudaq::qreg qr(N);

    qft(qr);

    return;
  }

  void operator()(const unsigned short N, auto&& prepareState) __qpu__ {
    cudaq::qreg qr(N);

    prepareState(qr);

    qft(qr);

    return;
  }
};

// Main

int main (int argc, char **argv)
{
  struct arguments args;
  // default values are nqubits = 4, nshots=100.
  args.nqubits = 4;
  args.nshots = 100;

  argp_parse(&argp, argc, argv, 0, 0, &args);
  const unsigned short int NQUBITS = args.nqubits;
  const unsigned int NGATES = (NQUBITS * NQUBITS) / 2 + NQUBITS;
  const unsigned long NSHOTS = args.nshots;

  // define lambda function to prepare state
  auto prepareState = [](cudaq::qspan<> qs) __qpu__ {
    cudaq::h(qs[0]);
    return;
  };

  std::printf("Simulating %hu-qubit QFT circuit.\n", NQUBITS);
  std::printf("Gates:\n  %u Hadamard gates\n", NQUBITS);
  std::printf("  %u Controlled Phase gates\n", (NQUBITS * (NQUBITS-1))/2);
  std::printf("  %u SWAP gates\n", NQUBITS/2);
  std::printf("Total: %u gates\n\n", NGATES);

  std::printf("Results will be based on %lu shots.\n\n", args.nshots);

  std::printf("Results:\n");
  std::printf("{ Measurement:Frequency }\n");

  const auto QFT_START = std::chrono::steady_clock::now();
  cudaq::sample(NSHOTS, FullQFT{}, NQUBITS, prepareState).dump();
  const auto QFT_STOP = std::chrono::steady_clock::now();

  const std::chrono::duration<double> QFT_TIME = QFT_STOP - QFT_START;

  std::printf("Wall time: %gs\n", QFT_TIME.count());

  return 0;
}
