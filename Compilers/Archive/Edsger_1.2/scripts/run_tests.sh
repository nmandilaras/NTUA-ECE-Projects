#!/bin/bash
#executes all existing tests found under tests dir
for t in `ls ../tests `; do
         ./Edsger-x ../tests/${t}
done
