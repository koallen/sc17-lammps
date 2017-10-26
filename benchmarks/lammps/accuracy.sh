#!/bin/bash

module purge
module load ParallelStudio

#mpirun -np 16 -host cluster-phi ../../machines/rwth-sb_phi/lammps-10Mar16/src/lmp_intel_phi_default_vector -in in.tersoff-acc -pk intel 1 mode $1 -sf intel -v p vanilla | tee acc-$1
OMP_NUM_THREADS=1 mpirun -np 44 ../../machines/sc17-bw/lammps-10Mar16/src/lmp_intel_cpu_default_vector -in in.tersoff-acc -pk intel 0 mode $1 -sf intel -v p vanilla | tee acc-$1
