#!/usr/bin/env python

for outFile in sys.argv[1:]:
	fp = open(outFile)
	line = fp.readline()
	while line:
		tokens = line.split()


