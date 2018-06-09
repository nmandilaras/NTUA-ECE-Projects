#!/usr/bin/python
import fileinput
import os

for line in fileinput.input():
	line=line.rstrip('\n')
	b=line.split(':')
	filename = "/sys/fs/cgroup/cpu/monitor/"
	filename=filename+b[3]
	if b[0]=="create" :
		if os.path.exists(filename) :
			pass
		else:
			os.makedirs(filename)
	elif b[0]=="remove":
		os.removedirs(filename)
	elif b[0]=="add":
		filename=filename+'/tasks'
		a=int(b[4])
		os.system("echo %d >> %s" % (a,filename))
	elif b[0]=="set_limit":
		filename=filename+'/cpu.shares'
		a=int(b[5])
		os.system("echo %d > %s" % (a,filename))
	else:
		print("Wrong Input")