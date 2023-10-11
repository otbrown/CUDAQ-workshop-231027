#!/bin/bash

module load nvidia/nvhpc-nompi/22.11
module load openmpi/4.1.4-cuda-11.8
module swap -f gcc/8.2.0 gcc/10.2.0

gcc -I${NVHPC_ROOT}/cuda/include -I${MPI_HOME}/include -L${MPI_HOME}/lib \
  -lmpi -shared -std=c99 -fPIC \
  -I../include cutensornet_distributed_interface_mpi.c \
  -o libcutensornet_distributed_interface_mpi.so

export CUTENSORNET_COMM_LIB=${PWD}/libcutensornet_distributed_interface_mpi.so
