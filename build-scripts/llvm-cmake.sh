#!/bin/bash

module load cmake/3.25.2
module load openmpi/4.1.4-cuda-11.8
module load nvidia/nvhpc-nompi/22.11
module swap -f gcc/8.2.0 gcc/10.2.0
module load valgrind

GCC_INSTALL_DIR=/mnt/lustre/indy2lfs/sw/gcc/10.2.0/

INSTALLDIR=/work/tc053/tc053/shared/CUDAQ-workshop-231027/install

cmake -S llvm -B build -G "Unix Makefiles" \
  -DCMAKE_C_COMPILER=gcc \
  -DCMAKE_CXX_COMPILER=g++ \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$INSTALLDIR \
  -DGCC_INSTALL_PREFIX=$GCC_INSTALL_DIR \
  -DLLVM_TARGETS_TO_BUILD=host \
  -DLLVM_INSTALL_UTILS=ON \
  -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;mlir;openmp;polly" \
  -DLIBOMP_USE_QUAD_PRECISION=False
