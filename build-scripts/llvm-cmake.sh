#!/bin/bash

module load cmake/3.25.2
module load openmpi/4.1.4-cuda-11.8
module load nvidia/nvhpc-nompi/22.11
module swap -f gcc/8.2.0 gcc/10.2.0
module load valgrind

GCC_INSTALL_DIR=/mnt/lustre/indy2lfs/sw/gcc/10.2.0/

INSTALLDIR=/work/tc053/tc053/shared/CUDAQ-workshop-231027/install

# Projects list nabbed from cuda-quantum build_llvm.sh
LLVM_PROJECTS="clang;clang-tools-extra;lld;mlir"
LLVM_COMPONENTS="clang;clang-format;clang-cmake-exports;clang-headers;clang-libraries;clang-resource-headers;"
LLVM_COMPONENTS+="mlir-cmake-exports;mlir-headers;mlir-libraries;mlir-tblgen;"
LLVM_COMPONENTS+="lld;"
LLVM_COMPONENTS+="cmake-exports;llvm-headers;llvm-libraries;"
LLVM_COMPONENTS+="llvm-config;llvm-ar;llc;FileCheck;count;not;"
echo "LLVM_PROJECTS=$LLVM_PROJECTS"
echo "LLVM_COMPONENTS=$LLVM_COMPONENTS"

cmake -S llvm -B build -G "Unix Makefiles" \
  -DCMAKE_C_COMPILER=gcc \
  -DCMAKE_CXX_COMPILER=g++ \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$INSTALLDIR \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DGCC_INSTALL_PREFIX=$GCC_INSTALL_DIR \
  -DLLVM_TARGETS_TO_BUILD=host \
  -DLLVM_INSTALL_UTILS=ON \
  -DLLVM_OPTIMIZED_TABLEGEN=ON \
  -DLLVM_BUILD_EXAMPLES=OFF \
  -DLLVM_ENABLE_OCAMLDOC=OFF \
  -DLLVM_ENABLE_BINDINGS=OFF \
  -DLLVM_ENABLE_ZLIB=OFF \
  -DLLVM_ENABLE_PROJECTS=$LLVM_PROJECTS \
  -DLLVM_DISTRIBUTION_COMPONENTS=$LLVM_COMPONENTS \
  -DLIBOMP_USE_QUAD_PRECISION=False
