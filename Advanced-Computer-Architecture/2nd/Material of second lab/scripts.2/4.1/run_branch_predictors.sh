#!/bin/bash

## Modify the following paths appropriately
PARSEC_PATH=~/Downloads/parsec
PIN_EXE=~/Downloads/pin-2.14-71313-gcc.4.4.7-linux/pin.sh
PIN_TOOL=~/Downloads/advcomparch-2015-16-ex2-helpcode/pintool/obj-intel64/cslab_branch_stats.so
CMDS_FILE=./cmds_simlarge.txt
outDir="./2outputs/"

for BENCH in $@; do
	cmd=$(cat ${CMDS_FILE} | grep "$BENCH")

	outFile="${BENCH}.cslab_branch_predictors.out"
	outFile="$outDir/$outFile"

	pin_cmd="$PIN_EXE -t $PIN_TOOL -o $outFile -- $cmd"
	time $pin_cmd
done
