#!/bin/bash

declare -a commands=('blackscholes')

for t in `ls | grep "out_*"`; do
        printf "%s\n" "${t}"
        time ../sniper-6.1/tools/advcomparch_mcpat.py -d ${t} -t total -o ${t}/power > ${t}/power.total.out
done
