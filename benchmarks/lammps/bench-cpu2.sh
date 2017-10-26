#!/bin/bash

module purge
module load ParallelStudio

h=`hostname -s`
d=../../machines/$1/lammps-10Mar16/src

# <arch$1> <binary-type$2> <total_cores$3>

export OMP_NUM_THREADS=1
for i in `seq 0 5`; do
  e=lmp_intel_$2_default_vector
  # single core run
  for p in single double mixed; do
    echo running single thread with $p precision $i
    $d/$e -in in.tersoff -v p vanilla -sf intel -pk intel 0 mode $p > results2/$h-tersoff-$e-$p-cpu_intel-$i
  done
  echo running single thread ref $i
  $d/$e -in in.tersoff -v p vanilla > results2/$h-tersoff-$e-double-cpu_normal-$i
  # multi core run
  for s in tersoff_bench; do
    e=lmp_intel_$2_default_vector
    echo running single node with $p precision $i
    for p in mixed; do
      mpirun -np $3 -host $h $d/$e -in in.$s -v p vanilla -sf intel -pk intel 0 mode $p > results2/$h-$s-$e-$p-cpu_intel_all_mpi-$i 2>&1
    done
    echo running single node ref $i
    mpirun -np $3 -host $h $d/$e -in in.$s -v p vanilla > results2/$h-$s-$e-double-cpu_normal_all_mpi-$i 2>&1 
  done
done
