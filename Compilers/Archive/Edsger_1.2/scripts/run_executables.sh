#!/bin/bash

#executes all produced outputs inside ./Output folder
for t in `ls  ./Output`; do
	echo "${t} :"
         ./Output/${t}/${t}
	echo
done
