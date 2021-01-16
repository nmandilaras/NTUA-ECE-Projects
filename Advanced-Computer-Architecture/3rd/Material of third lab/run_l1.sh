#!/usr/bin/env python

import sys, os
import itertools, operator
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

def get_params_from_basename(basename):
	tokens = basename.split('.')
	bench = tokens[0]
	input_size = 'simdev'
	dw = int(tokens[1].split('-')[0].split('_')[1])
	ws = int(tokens[1].split('-')[1].split('_')[1])
	return (bench, input_size, dw, ws)

def get_time_from_output_file(output_file):
	time = -999
	fp = open(output_file, "r")
	line = fp.readline()
	while line:
		if "Time" in line:
			time = float(line.split()[3])
		line = fp.readline()

	fp.close()
	return time

def get_energy_from_output_file(output_file):
	energy = -999
	flag=False
	unit = "geia"
	fp = open(output_file, "r")
	line = fp.readline()
	while line:
		if "total" in line:
			energy = float(line.split()[3])
			unit = line.split()[4]
		line = fp.readline()

	fp.close()
	if unit=="mJ":
		flag = True
	return (energy,flag)

def tuples_by_dispatch_width(tuples):
	ret = []
	tuples_sorted = sorted(tuples, key=operator.itemgetter(0))
	for key,group in itertools.groupby(tuples_sorted,operator.itemgetter(0)):
		ret.append((key, zip(*map(lambda x: x[1:], list(group)))))
	return ret

global_ws = [16,32,64,128,256,512]

if len(sys.argv) < 2:
	print "usage:", sys.argv[0], "<output_directories>"
	sys.exit(1)

results_tuples = []

for dirname in sys.argv[1:]:
	if dirname.endswith("/"):
		dirname = dirname[0:-1]
	basename = os.path.basename(dirname)
	output_file = dirname + "/sim.out"
	output_filetwo = dirname + "/power.total.out"	

	(bench, input_size, dispatch_width, window_size) = get_params_from_basename(basename)
	time = get_time_from_output_file(output_file)
	(energy,flag) = get_energy_from_output_file(output_filetwo)
	time = time / pow(10,9)	
	print(time)
	if flag :
		energy = energy /1000
	print(energy)
	edp = energy * time
	results_tuples.append((dispatch_width, window_size, edp))


markers = ['.', 'o', 'v', '*', 'D']
fig = plt.figure()
plt.grid(True)
ax = plt.subplot(111)
ax.set_xlabel("$Window Size$")
ax.set_ylabel("$EDP$")

i = 0
tuples_by_dw = tuples_by_dispatch_width(results_tuples)
for tuple in tuples_by_dw:
	dw = tuple[0]
	ws_axis = tuple[1][0]
	ipc_axis = tuple[1][1]
	x_ticks = np.arange(0, len(global_ws))
	x_labels = map(str, global_ws)
	ax.xaxis.set_ticks(x_ticks)
	ax.xaxis.set_ticklabels(x_labels)

	ax.plot(x_ticks, ipc_axis, label="DW_"+str(dw), marker=markers[i%len(markers)])
	i = i + 1
plt.title(bench +": EDP")
lgd = ax.legend(ncol=len(tuples_by_dw), bbox_to_anchor=(0.9, -0.1), prop={'size':8})
plt.savefig(bench+'-'+input_size+'.edp.png', bbox_extra_artists=(lgd,), bbox_inches='tight')
