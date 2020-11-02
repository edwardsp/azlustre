#!/bin/bash

mount_point=$1
num_ost=$2

while [ "$(lfs df $mount_point | grep OST | wc -l)" != "$num_ost" ]; do
    sleep 5
done
