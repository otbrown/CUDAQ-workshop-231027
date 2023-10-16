#!/bin/bash

module load nvidia/nvhpc-nompi/22.11
module load openmpi/4.1.4-cuda-11.8
module load intel-20.4/cmkl
module swap -f gcc/8.2.0 gcc/10.2.0 
