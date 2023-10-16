# NVIDIA CUDA Quantum Workshop 27/10/2023

Note that on Cirrus, only the /work filesystem is visible to the compute nodes. As such we recommend navigating to your /work/tc053/tc053/<username> directory as soon as you log in.

## Set up your environment
In order to add the CUDA Quantum nvq++ compiler to your path, and load the relevant modules, please run the following two commands.

```bash
source /work/tc053/tc053/shared/CUDAQ-workshop-231027/environment.sh
source /work/tc053/tc053/shared/CUDAQ-workshop-231027/modules.sh
```

## Run the QFT example on the login node
In order to check you can compile and run CUDA Quantum codes, you can try out the example QFT code using the CPU based simulator on the login node.

```bash
nvq++ -O3 -o qft $CUDAQ_DIR/examples/qft.cpp
./qft
```

You should see an output resembling the following.

```
Simulating 4-qubit QFT circuit.
Gates:
  4 Hadamard gates
  6 Controlled Phase gates
  2 SWAP gates
Total: 12 gates

Results will be based on 100 shots.

Results:
{ Measurement:Frequency }
{ 1010:4 1101:1 1000:11 0111:13 1111:12 1100:12 0110:2 0101:1 1011:7 0100:7 0010:6 0011:9 0000:15 }
Wall time: 0.0993949s
```

## Run the QFT example on a GPU
In order to check you can run CUDA Quantum codes using the nvidia cuquantum statevector backend, you can use the provided slurm script.

```bash
cp $CUDAQ_DIR/cudaq.slurm ./
sbatch cudaq.slurm
```

Once the job has completed you should get a slurm outfile containing output similar to the following.

```
Loading nvidia/nvhpc-nompi/22.11
  Loading requirement: gcc/8.2.0
Loading intel-20.4/cmkl
  Loading requirement: intel-license
Unloading gcc/8.2.0
  WARNING: Dependent 'nvidia/nvhpc-nompi/22.11' is loaded
tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Simulating 4-qubit QFT circuit.
Gates:
  4 Hadamard gates
  6 Controlled Phase gates
  2 SWAP gates
Total: 12 gates

Results will be based on 100 shots.

Results:
{ Measurement:Frequency }
{ 0111:12 0101:2 1001:2 1010:8 0010:8 1111:13 1100:5 1011:12 0100:9 1101:3 1000:12 0011:5 0000:9 }
Wall time: 4.37929s
```
