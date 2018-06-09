#!/bin/bash

## Modify the following paths appropriately
PARSEC_PATH=~/Downloads/parsec-3.0
PIN_EXE=~/Downloads/pin-2.14-71313-gcc.4.4.7-linux/pin.sh
PIN_TOOL=~/Downloads/advcomparch-2015-16-ex1-helpcode/pintool/obj-intel64/cslab_cache.so
CMDS_FILE=./cmds_simlarge.txt
outDir="./outputs2/"

export LD_LIBRARY_PATH=$PARSEC_PATH/pkgs/libs/hooks/inst/amd64-linux.gcc-serial/lib/

## Triples of <cache_size>_<associativity>_<block_size>
CONFS="256_4_128 512_4_128 512_8_64 512_8_128 512_8_256 1024_8_64 1024_8_128 1024_8_256 1024_16_128 2048_8_64 2048_8_128 2048_8_256 2048_16_128"

L1size=32
L1assoc=8
L1bsize=64

for BENCH in $@; do
	cmd=$(cat ${CMDS_FILE} | grep "$BENCH")
for conf in $CONFS; do
	## Get parameters
    size=$(echo $conf | cut -d'_' -f1)
    assoc=$(echo $conf | cut -d'_' -f2)
    bsize=$(echo $conf | cut -d'_' -f3)

	outFile=$(printf "%s.dcache_cslab.L1_%04d_%02d_%03d.L2_%04d_%02d_%03d.out" $BENCH ${size} $assoc $bsize $L1size $L1assoc $L1bsize)
	outFile="$outDir/$outFile"

	pin_cmd="$PIN_EXE -t $PIN_TOOL -o $outFile -L1c ${L1size} -L1a ${L1assoc} -L1b ${L1bsize} -L2c ${size} -L2a ${assoc} -L2b ${bsize} -- $cmd"
	$pin_cmd
done
done
