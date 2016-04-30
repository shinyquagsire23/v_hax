from datetime import datetime
import os, sys
import ast
 
def getWord(b, k, n=4):
	return sum(list(map(lambda c: b[k+c]<<(c*8),range(n))))

def findPattern(p, t, addr, size):
	pattern = []
	if not(isinstance(size, tuple)):
		size = (size,)

	skip = False
	offset = 0
	for s in size:
		if skip:
			pattern += [None] * s
		else:
			for i in range(s):
				pattern += [getWord(p, addr + (i + offset) * 4, 4)]
		offset += s
		skip = not(skip)

	size = len(pattern)

	k = 0
	# not a perfect pattern search, but most likely good enough
	for i in range(0, len(t), 4):
		candidate = getWord(t, i, 4)
		if candidate == pattern[k] or pattern[k] == None:
			if k+1 == size:
				return i-k*4
			else:
				k += 1
		elif candidate == pattern[0] or pattern[0] == None:
			k = 1
		else:
			k = 0
	return None

def outputConstantsTxt(d):
	out="{\n"
	for k in d:
		out+="\""+k[0]+"\" : \""+str(k[1])+"\",\n"
	out+="}\n"
	return out

if len(sys.argv)<4:
	print("use : "+sys.argv[0]+" <proto_code.bin> <target_code.bin> <code_base_addr> <proto_ropdb_file> <output.txt>")
	exit()

l = ast.literal_eval(open(sys.argv[-2],"r").read())

base = int(sys.argv[3], 0)
proto = bytearray(open(sys.argv[1], "rb").read())
target = bytearray(open(sys.argv[2], "rb").read())

manual = os.path.splitext(sys.argv[-1])[0] + "_manual.txt"
try:
	manual = ast.literal_eval(open(manual,"r").read())
except IOError:
	manual = None
	pass

out = []

if manual:
	for entry in manual:
		print(entry)
		out += [(entry, manual[entry])]

for entry in l:
	if len(entry) == 3:
		# gadget search
		(name, in_addr, in_size) = entry
		print(name)
		out_addr = findPattern(proto, target, in_addr - base, in_size) + base
		out += [(name, hex(out_addr))]
	if len(entry) == 4:
		# const ptr search
		(name, in_addr, in_size, in_offset) = entry
		print(name)
		out_addr = findPattern(proto, target, in_addr - base, in_size)
		out_addr = getWord(target, out_addr + in_offset*4, 4)
		out += [(name, hex(out_addr))]
	if len(entry) == 5:
		(name, in_addr, in_size, in_offset, out_offset) = entry
		print(name)
		out_addr = findPattern(proto, target, in_addr - base, in_size)
		out_addr = getWord(target, out_addr + in_offset*4, 4)
		out += [(name, hex(out_addr + out_offset))]

open(sys.argv[-1],"w").write(outputConstantsTxt(out))
