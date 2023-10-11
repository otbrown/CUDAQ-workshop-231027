#!/bin/bash

set -u

module load cmake/3.25.2
module load nvidia/nvhpc-nompi/22.11
module load openmpi/4.1.4-cuda-11.8
module load intel-20.4/cmkl
module swap -f gcc/8.2.0 gcc/10.2.0

WORKSHOP_DIR=/work/tc053/tc053/shared/CUDAQ-workshop-231027
INSTALL_PREFIX=$WORKSHOP_DIR/install
CUDAQ_SOURCE_DIR=$WORKSHOP_DIR/cuda-quantum
export CUQUANTUM_INSTALL_PREFIX=$INSTALL_PREFIX/cuquantum-linux-x86_64-23.06.1.8_cuda11-archive
export CUTENSORNET_COMM_LIB=$CUQUANTUM_INSTALL_PREFIX/distributed_interfaces/libcutensornet_distributed_interface_mpi.so
LLVM_BUILD_DIR=$WORKSHOP_DIR/llvm-project/build
export LLVM_INSTALL_PREFIX=$INSTALL_PREFIX

MPI_FLAGS="-I${MPI_HOME}/include  -L${MPI_HOME}/lib -lmpi"

BUILD_TYPE=Release
CC=gcc
CXX=g++
CUDAC=nvcc

cmake -B $CUDAQ_SOURCE_DIR/build \
  -G "Unix Makefiles" \
  -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
  -DCMAKE_C_COMPILER=$CC \
  -DCMAKE_CXX_COMPILER=$CXX \
  -DCMAKE_CUDA_COMPILER="$CUDAC" \
  -DCMAKE_C_FLAGS="$MPI_FLAGS" \
  -DCMAKE_CXX_FLAGS="$MPI_FLAGS" \
  -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DCMAKE_COMPILE_WARNING_AS_ERROR=OFF \
  -DCUDAQ_ENABLE_PYTHON=FALSE \
  -DCUDAQ_BUILD_TESTS=FALSE \
  -DLLVM_DIR=$LLVM_INSTALL_PREFIX/lib/cmake/llvm/ \
  -DLLVM_EXTERNAL_LIT=$LLVM_BUILD_DIR/bin/llvm-lit
