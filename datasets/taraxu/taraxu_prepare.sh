#!/bin/bash

# Taraxu's data for different translation directions is concatenated.
# This script splits this data into separate files for each direction.

MYPWD=$PWD
cd taraxu-set/

FILES="wmt.rbmt1.edit  wmt.rbmt1.hyp  wmt.rbmt2.edit  wmt.rbmt2.hyp  wmt.ref  wmt.smt1.edit  wmt.smt1.hyp  wmt.smt2.edit  wmt.smt2.hyp  wmt.src"

# Lines 001-240: DE->EN #240
# Lines 241-280: DE->ES #40
# Lines 281-552: EN->DE #272
# Lines 553-653: ES->DE #101

for F in $FILES; do
	echo $F
	sed -n '1,240p' $F > $F.de-en
	sed -n '241,280p' $F > $F.de-es
	sed -n '281,552p' $F > $F.en-de
	sed -n '553,653p' $F > $F.es-de
done 

cd $MYPWD
