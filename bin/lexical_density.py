#!/usr/bin/env python3

import sys


c_content = c_all = 0.0
for line in sys.stdin:
	for token in line.split():
		if token == "ADJ" or token == "ADV" or token == "NOUN" or token == "PROPN" or token == "VERB":
			c_content+=1
		#c_all+=1

		# count only words, so no punctuation
		if token != "PUNCT":
			c_all+=1

#		print(token)
density = c_content/c_all
print(density)
#	sys.exit()


