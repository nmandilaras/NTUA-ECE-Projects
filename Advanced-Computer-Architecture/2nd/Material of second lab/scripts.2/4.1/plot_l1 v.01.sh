#!/usr/bin/env python

import sys
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np


fp = open(sys.argv[1])
line = fp.readline()
while line:
	tokens = line.split()
	if line.startswith("Total-Branches:"):
		total_bra = long(tokens[2])
       	elif line.startswith("Conditional-Taken-Branches:"):
		total_taken = long(tokens[2])
	elif line.startswith("Conditional-NotTaken-Branches:"):
		total_notTaken = long(tokens[2])	
x=[1]
y=[total_bra]

xt=[2]
yt=[total_taken]

xn=[3]
yn=[total_notTaken]

plt.bar(x,y,label='Total-Branches')
plt.bar(xt,yt,label='Taken-Branches:')
plt.bar(xn,yn,label='NotTaken-Branches:')

plt.xlabel('x')
plt.ylabel('y')
plt.title('Taken vs Not-Taken')
plt.legend()
#plt.show()
name=sys.argv[1]
plt.savefig("L1_"+name+".png",bbox_inches="tight")
