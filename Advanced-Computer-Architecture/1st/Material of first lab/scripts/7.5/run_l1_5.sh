#!/bin/bash

## Modify the following paths appropriately
PARSEC_PATH=~/Downloads/parsec-3.0
PIN_EXE=~/Downloads/pin-2.14-71313-gcc.4.4.7-linux/pin.sh
PIN_TOOL=~/Downloads/advcomparch-2015-16-ex1-helpcode/pintool/obj-intel64/cslab_cache.so
CMDS_FILE=./cmds_simlarge.txt
outDir="./outputs5/"

export LD_LIBRARY_PATH=$PARSEC_PATH/pkgs/libs/hooks/inst/amd64-linux.gcc-serial/lib/

## Triples of <cache_size>_<associativity>_<block_size>
CONFS="32_8_64"

L2size=1024
L2assoc=8
L2bsize=128

for BENCH in $@; do
	cmd=$(cat ${CMDS_FILE} | grep "$BENCH")
for conf in $CONFS; do
	## Get parameters
    size=$(echo $conf | cut -d'_' -f1)
    assoc=$(echo $conf | cut -d'_' -f2)
    bsize=$(echo $conf | cut -d'_' -f3)

	outFile=$(printf "%s.dcache_cslab.L1_%04d_%02d_%03d.L2_%04d_%02d_%03d.out" $BENCH ${size} $assoc $bsize $L2size $L2assoc $L2bsize)
	outFile="$outDir/$outFile"

	pin_cmd="$PIN_EXE -t $PIN_TOOL -o $outFile -L1c ${size} -L1a ${assoc} -L1b ${bsize} -L2c ${L2size} -L2a ${L2assoc} -L2b ${L2bsize} -- $cmd"
	$pin_cmd
done
done
