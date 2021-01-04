#!/bin/bash

# High values of I_MPI_DEBUG can output a lot of information and significantly reduce performance of your application.
# A value of I_MPI_DEBUG=5 is generally a good starting point, which provides sufficient information to find common errors.
export I_MPI_DEBUG=5
export I_MPI_PIN=yes
export I_MPI_PIN_PROCESSOR_LIST=allcores:map=scatter
  
export OMP_NUM_THREADS=1

source ~/setup-mpipr.sh

export NWCHEM=${NWCHEM_TOP}/bin/${NWCHEM_TARGET}/nwchem
export PREFIX=c240_b3lyp_cc-pvdz_energy

# https://github.com/nwchemgit/nwchem/issues/100
#export COMEX_ENABLE_GET_DATATYPE=0
#export COMEX_ENABLE_PUT_DATATYPE=0

export PPN=48

env

/home/files/slurm-job-nodes.sh > myhostfile.${SLURM_JOB_ID}

mpirun -hostfile myhostfile.${SLURM_JOB_ID} -ppn ${PPN} \
       $NWCHEM $PREFIX.nw | tee ${PREFIX.$SLURM_JOB_ID}.${SLURM_JOB_PARTITION}.${SLURM_JOB_NUM_NODES}.log
