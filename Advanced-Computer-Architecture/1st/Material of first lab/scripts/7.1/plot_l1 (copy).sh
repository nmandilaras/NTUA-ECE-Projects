#!/usr/bin/env python

import sys
import numpy as np
import  os
import itertools, operator
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

x_Axis = []
ipc_Axis = []

for dirname in sys.argv[1:]:
	if dirname.endswith("/"):
		dirname = dirname[0:-1]
	basename = os.path.basename(dirname)
	output_file = dirname + "/sim.out"

	(bench, input_size, dispatch_width, window_size) = get_params_from_basename(basename)
	ipc = get_ipc_from_output_file(output_file)


	x_Axis.append(dispatch_width)
	ipc_Axis.append(ipc)

print x_Axis
print ipc_Axis

fig, ax1 = plt.subplots()
ax1.grid(True)
ax1.set_xlabel("CacheSize.Assoc.BlockSize")

xAx = np.arange(len(x_Axis))
ax1.xaxis.set_ticks(np.arange(0, len(x_Axis), 1))
ax1.set_xticklabels(x_Axis, rotation=45)
ax1.set_xlim(-0.5, len(x_Axis) - 0.5)
ax1.set_ylim(min(ipc_Axis) - 0.05 * min(ipc_Axis), max(ipc_Axis) + 0.05 * max(ipc_Axis))
ax1.set_ylabel("$IPC$")
line1 = ax1.plot(ipc_Axis, label="ipc", color="red",marker='x')


lns = line1
labs = [l.get_label() for l in lns]

plt.title("IPC")
lgd = plt.legend(lns, labs)
lgd.draw_frame(False)
name=outFile
plt.savefig("L1_"+name+".png",bbox_inches="tight")
