#!/usr/bin/env python

import sys
import numpy as np

## We need matplotlib:
## $ apt-get install python-matplotlib
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

x_Axis = []
ipc_Axis = []
i=0
for outFile in sys.argv[1:]:
	fp = open(outFile)
	line = fp.readline()
	while line:
		tokens = line.split()
		if (line.startswith("IPC:")):
			ipc = float(tokens[1])
			ipc_Axis.append(ipc)
			i+=1
			l1ConfigStr = ' '
			x_Axis.append(l1ConfigStr)
			
		fp.readline()
		fp.readline()
		fp.readline()
		fp.readline()
		fp.readline()
		line = fp.readline()

	fp.close()

	##print l1ConfigStr
	

print x_Axis
print ipc_Axis


fig, ax1 = plt.subplots()
ax1.grid(True)
ax1.set_xlabel("10 M sets")

xAx = np.arange(len(x_Axis))
ax1.xaxis.set_ticks(np.arange(0, len(x_Axis), 1))
ax1.set_xticklabels(x_Axis, rotation=45)
ax1.set_xlim(-0.5, len(x_Axis) - 0.5)
ax1.set_ylim(min(ipc_Axis) - 0.05 * min(ipc_Axis), max(ipc_Axis) + 0.05 * max(ipc_Axis))
ax1.set_ylabel("$IPC$")
line1 = ax1.plot(ipc_Axis, label="ipc", color="red",marker='x')


lns = line1
labs = [l.get_label() for l in lns]

plt.title("IPC in Time")
lgd = plt.legend(lns, labs)
lgd.draw_frame(False)
name=outFile
plt.savefig("L1_noall_"+name+".png",bbox_inches="tight")
