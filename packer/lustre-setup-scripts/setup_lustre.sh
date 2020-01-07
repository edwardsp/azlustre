#!/bin/bash

mds="$1"
storage_account="$2" 
storage_key="$3"
storage_container="$4"
log_analytics_name="$5"
log_analytics_workspace_id="$6"
log_analytics_key="$7"

script_dir=/lustre-setup-scripts

# vars used in script
mdt_device=/dev/sdb
ost_device_list='/dev/nvme*n1'

lustre_version=2.12

if [ "$storage_account" = "" ]; then
	use_hsm=false
else
	use_hsm=true
fi

if [ "$log_analytics_name" = "" ]; then
	use_log_analytics=false
else
	use_log_analytics=true
fi

n_ost_devices=$(echo $ost_device_list | wc -w)
if [ "$n_ost_devices" -gt "1" ]; then
	ost_device=/dev/md10
	# RAID OST DEVICES
	$script_dir/create_raid0.sh $ost_device $ost_device_list
else
	ost_device=$ost_device_list
fi

# SETUP LUSTRE YUM REPO
#$script_dir/lfsrepo.sh $lustre_version

# INSTALL LUSTRE PACKAGES
#$script_dir/lfspkgs.sh

ost_index=1

if [ "$HOSTNAME" = "$mds" ]; then

	# SETUP MDS
	PSSH_NODENUM=0 $script_dir/lfsmaster.sh $mdt_device

else

	echo "wait for the mds to start"
	modprobe lustre
	while ! lctl ping $mds@tcp; do
		sleep 2
	done


	idx=0
	for c in $(echo ${HOSTNAME##$mds} | grep -o .); do
		echo $c		
		idx=$(($idx * 36))
		if [ -z "${c##[0-9]}" ]; then
			idx=$(($idx + $c))
		else
			idx=$(($(printf "$idx + 10 + %d - %d" "'${c^^}" "'A")))
		fi
	done
	
	ost_index=$(($idx+2))

fi

echo "ost_index=$ost_index"

mds_ip=$(ping -c 1 $mds | head -1 | sed 's/^[^)]*(//g;s/).*$//g')

PSSH_NODENUM=$ost_index $script_dir/lfsoss.sh $mds_ip $ost_device

if [ "${use_hsm,,}" = "true" ]; then

	$script_dir/lfshsm.sh "$mds_ip" "$storage_account" "$storage_key" "$storage_container" "$lustre_version"

	if [ "$HOSTNAME" = "$mds" ]; then

		# IMPORT CONTAINER
		$script_dir/lfsclient.sh $mds_ip /lustre
		$script_dir/lfsimport.sh "$storage_account" "$storage_key" "$storage_container" /lustre "$lustre_version"

	fi

fi

if [ "${use_log_analytics,,}" = "true" ]; then

	$script_dir/lfsloganalytics.sh $log_analytics_name $log_analytics_workspace_id "$log_analytics_key"

fi