#!/bin/bash

## Modify the following paths appropriately
PARSEC_PATH=/path/to/parsec
PIN_EXE=/path/to/pin/pin.sh
PIN_TOOL=/path/to/pintool/obj-intel64/cslab_branch.so
CMDS_FILE=./cmds_simlarge.txt
outDir="./outputs/"

for BENCH in $@; do
	cmd=$(cat ${CMDS_FILE} | grep "$BENCH")

	outFile="${BENCH}.cslab_branch_predictors.out"
	outFile="$outDir/$outFile"

	pin_cmd="$PIN_EXE -t $PIN_TOOL -o $outFile -- $cmd"
	time $pin_cmd
done
