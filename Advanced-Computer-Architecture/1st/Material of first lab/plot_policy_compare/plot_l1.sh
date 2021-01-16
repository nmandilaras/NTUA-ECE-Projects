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
mpki_Axis = []
lfu_Axis = []

for outFile in sys.argv[1:]:
	fp = open(outFile)
	line = fp.readline()
	while line:
		tokens = line.split()
		if(outFile.startswith("ra")):
			if (line.startswith("IPC:")):
				ipc = float(tokens[1])
			elif (line.startswith("  L1-Data Cache")):
				sizeLine = fp.readline()
				l1_size = sizeLine.split()[1]
				bsizeLine = fp.readline()
				l1_bsize = bsizeLine.split()[2]
				assocLine = fp.readline()
				l1_assoc = assocLine.split()[1]
		elif (outFile.startswith("lfu")):
			if (line.startswith("IPC:")):
				lfu = float(tokens[1])
		else:
			if (line.startswith("IPC:")):
				mpki = float(tokens[1])

		line = fp.readline()

	fp.close()
        if(outFile.startswith("ra")):
		l1ConfigStr = '{}K.{}.{}B'.format(l1_size,l1_assoc,l1_bsize)
		print l1ConfigStr
		x_Axis.append(l1ConfigStr)
		ipc_Axis.append(ipc)
	elif (outFile.startswith("lfu")):
		lfu_Axis.append(lfu)
	else:
		mpki_Axis.append(mpki)

print x_Axis
print ipc_Axis
print mpki_Axis
print lfu_Axis

fig, ax1 = plt.subplots()
ax1.grid(True)
ax1.set_xlabel("CacheSize.Assoc.BlockSize")

xAx = np.arange(len(x_Axis))
ax1.xaxis.set_ticks(np.arange(0, len(x_Axis), 1))
ax1.set_xticklabels(x_Axis, rotation=45)
ax1.set_xlim(-0.5, len(x_Axis) - 0.5)
ax1.set_ylim(min(min(ipc_Axis),min(mpki_Axis)) - 0.05 * min(ipc_Axis), max(max(mpki_Axis),max(ipc_Axis)) + 0.05 * max(ipc_Axis))
##ax1.set_ylabel("$Noallocate$")
line1 = ax1.plot(ipc_Axis, label="Random", color="red",marker='x')

ax2 = ax1.twinx()
ax2.xaxis.set_ticks(np.arange(0, len(x_Axis), 1))
ax2.set_xticklabels(x_Axis, rotation=45)
ax2.set_xlim(-0.5, len(x_Axis) - 0.5)
ax2.set_ylim(min(min(ipc_Axis),min(mpki_Axis)) - 0.05 * min(ipc_Axis), max(max(mpki_Axis),max(ipc_Axis)) + 0.05 * max(ipc_Axis))
##ax2.set_ylabel("$Allocate$")
line2 = ax2.plot(mpki_Axis, label="LRU", color="blue",marker='o')

lns = line1 + line2
labs = [l.get_label() for l in lns]

plt.title("LRU vs Random")
lgd = plt.legend(lns, labs)
lgd.draw_frame(False)
name=outFile
plt.savefig("L1_noall_"+name+".png",bbox_inches="tight")
