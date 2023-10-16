#!/bin/bash
#
#SBATCH --partition=gpu
#SBATCH --qos=gpu
#SBATCH --gres=gpu:1
#SBATCH --nodes=1
#SBATCH --time=00:02:00

#SBATCH --account=tc053

# define CUDAQ_DIR and add nvq++ to path
source /work/tc053/tc053/shared/CUDAQ-workshop-231027/environment.sh

# Load the required modules
source $CUDAQ_DIR/modules.sh

# compile the CUDA Quantum code for double-precision simulation with cuquantum
# (assumes $CUDAQ_DIR/install/bin has been added to path)
nvq++ -O3 -o qft-nv64 --target nvidia-fp64 $CUDAQ_DIR/examples/qft.cpp

# run the QFT simulation
srun ./qft-nv64
