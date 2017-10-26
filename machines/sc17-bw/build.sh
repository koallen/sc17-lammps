#!/bin/bash

# load environment
module purge
module load ParallelStudio

set -o verbose
rm -rf lammps-10Mar16
cp -r ../lammps-10Mar16 .
cd lammps-10Mar16/src
make yes-USER-OMP
make yes-USER-INTEL
make no-KOKKOS
make no-GPU

binaries="intel_cpu"

function build_binaries() {
  set -o verbose
  for f in $binaries; do
    touch pair_tersoff_intel.h
    [[ -e lmp_${f}_$2 ]] && continue
    make $f "$1" -j
    mv lmp_$f lmp_${f}_$2 || exit
  done
}

build_binaries "CCFLAGS=-DLMP_INTEL_NOOP"  "default_vector" 
build_binaries "CCFLAGS=-DLMP_INTEL_TERSOFF_PACK_I=true"  "packi_vector" 
build_binaries "CCFLAGS=-DLMP_INTEL_TERSOFF_PACK_I=false"  "nopacki_vector" 

build_binaries "CCFLAGS=-LMP_INTEL_VECTOR_MIC=NONE -DLMP_INTEL_VECTOR_HOST=NONE"  "default_scalar" 
build_binaries "CCFLAGS=-DLMP_INTEL_TERSOFF_PACK_I=true -LMP_INTEL_VECTOR_MIC=NONE -DLMP_INTEL_VECTOR_HOST=NONE"  "packi_scalar" 
build_binaries "CCFLAGS=-DLMP_INTEL_TERSOFF_PACK_I=false -LMP_INTEL_VECTOR_MIC=NONE -DLMP_INTEL_VECTOR_HOST=NONE"  "nopacki_scalar" 
