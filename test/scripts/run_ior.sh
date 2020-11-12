#!/bin/bash

hostfile=$1
nodes=$(wc -l <$hostfile)
ppn=$2
sz_in_gb=$3
cores=$(($nodes * $ppn))
oss_user=$4
oss_hostfile=$5

timestamp=$(date "+%Y%m%d-%H%M%S")

source /etc/profile.d/modules.sh
export MODULEPATH=/usr/share/Modules/modulefiles:/apps/modulefiles
module load gcc-9.2.0
module load mpi/impi_2018.4.274
module load ior

pssh -t 0 -l $oss_user -h $oss_hostfile 'dstat -n -Neth0 -d -Dmd10 --output $(hostname)-'${timestamp}'.dstat' 2>&1 >/dev/null &

mpirun -np $cores -ppn $ppn -hostfile $hostfile ior -k -a POSIX -v -i 1 -B -m -d 1 -F -w -r -t 32M -b ${sz_in_gb}G -o /lustre/test

df -h /lustre

kill %1
for h in $(<${oss_hostfile}); do 
    scp ${oss_user}@${h}:'*'-${timestamp}.dstat .
done

mkdir ~/results-${timestamp}

for i in *-${timestamp}.dstat; do
    # remove the first value as it is often very high
    sed '1,8d' $i > ~/results-${timestamp}/${i%%-${timestamp}.dstat}.csv
done
