#!/usr/bin/python

import fileinput

suma=0
limit=2000
lol=[]
for line in fileinput.input():
	b=line.split(':')
	suma+=int(b[3])
	lol.append(["set_limit",b[1],"cpu.shares",b[3]])
print("score:%f" % float(limit-suma))
for x in lol:
	a=int(x[3])
	x[3]=str(a*limit/suma)
	print(":".join(x))