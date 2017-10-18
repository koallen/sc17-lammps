#!/bin/bash

module purge
module load GCC
source /opt/intel2018/compilers_and_libraries/linux/bin/compilervars.sh intel64

#mpirun -np 16 -host cluster-phi ../../machines/rwth-sb_phi/lammps-10Mar16/src/lmp_intel_phi_default_vector -in in.tersoff-acc -pk intel 1 mode $1 -sf intel -v p vanilla | tee acc-$1
OMP_NUM_THREADS=1 mpirun -np 24 ../../machines/sc17-bw/lammps-10Mar16/src/lmp_intel_cpu_default_vector -in in.tersoff-acc -pk intel 0 mode $1 -sf intel -v p vanilla | tee acc-$1
