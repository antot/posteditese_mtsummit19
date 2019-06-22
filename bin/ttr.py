#!/usr/bin/env python3

import random
import re
import numpy as np, scipy.stats as st # confint
import sys



def random_subset ( data, size ):
	num_words = 0
	num_lines = 0
	subset = list()
	#random.shuffle(data) # without replacement
	data = [random.choice(data) for _ in range(len(data))] # with replacement

	for line in data:
		subset.append(line)
		num_words += len(line.split())
		num_lines += 1
		#print num_words, size
		if (num_words > size):
			break
	
	#print num_lines, num_words, size
	return subset
	#return data


def ttr ( data ):
	words = list()
	for line in data:
		words += line.split() #re.findall(r'\w+', line)

	uniq_words = set(words)

	#print sorted(words)
	#print len(uniq_words), len(words)

	return len(uniq_words) / float(len(words))


def mystats ( a ):
	M = np.mean(a)
	SD = np.std(a)
	CI = st.t.interval(0.95, len(a)-1, loc=np.mean(a), scale=st.sem(a))
	print ("%f\t%f\t%f\t%f" % (M, SD, CI[0], CI[1]))



R = int(sys.argv[1])
size = int(sys.argv[2])

data = [line.strip() for line in sys.stdin]
ttrs = []
for i in range(R):
	subset = random_subset ( data, size )
	ratio = ttr ( subset )
	ttrs.append(ratio)
	#print (ratio)

mystats(ttrs)

