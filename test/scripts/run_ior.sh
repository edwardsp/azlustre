#!/bin/bash

hostfile=$1
nodes=$(wc -l <$hostfile)
ppn=$2
cores=$(($nodes * $ppn))

source /etc/profile.d/modules.sh
export MODULEPATH=/usr/share/Modules/modulefiles:/apps/modulefiles
module load gcc-9.2.0
module load mpi/impi_2018.4.274
module load ior

mpirun -np $cores -ppn $ppn -hostfile $hostfile ior -a POSIX -v -i 1 -B -m -d 1 -F -w -r -t 32M -b 2G -o /lustre/test
