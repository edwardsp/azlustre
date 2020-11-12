#!/bin/bash

for i in $(seq 0 9) a b c d e f g h i j k l m n o p; do echo "lustre00000${i}"; done > oss
pssh -l lustre -h oss hostname 2>/dev/null | grep SUCCESS |sed 's/.*\[SUCCESS\] //g' | sort | tee oss.real && mv oss.real oss


