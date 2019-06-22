#!/bin/bash

TTR="python3 ./ttr.py"

DTRX=../datasets/taraxu/taraxu-set/
DMS=../datasets/MS/
DTED=../datasets/wit3/

function ttr {
	F=$1
	R=$2
	SIZE=$3

	BF=$(basename $F)
	RES=$($TTR $R $SIZE < $F)
	echo -e "TTR $BF\t$RES"
}



# Using normalised data
function ttrs {

	R=1000

	# ----- TRX -----
	SIZE=5500
	echo "TTR trx en-de SIZE=$SIZE"
	for F in $DTRX/*ref.en-de.norm.tok $DTRX/*edit.en-de.norm.tok $DTRX/*hyp.en-de.norm.tok; do
		ttr $F $R $SIZE
	done

	SIZE=5000
	echo "TTR trx de-en SIZE=$SIZE"
	for F in $DTRX/*ref.de-en.norm.tok $DTRX/*edit.de-en.norm.tok $DTRX/*hyp.de-en.norm.tok; do
		ttr $F $R $SIZE
	done

	SIZE=2000
	echo "TTR trx es-de SIZE=$SIZE"
	for F in $DTRX/*ref.es-de.norm.tok $DTRX/*edit.es-de.norm.tok $DTRX/*hyp.es-de.norm.tok; do
		ttr $F $R $SIZE
	done

	SIZE=1000
	echo "TTR trx de-es SIZE=$SIZE"
	for F in $DTRX/*ref.de-es.norm.tok $DTRX/*edit.de-es.norm.tok $DTRX/*hyp.de-es.norm.tok; do
		ttr $F $R $SIZE
	done



	# ----- MS -----
	SIZE=29000
	echo "TTR ms zh-en SIZE=$SIZE"
	for F in $DMS/orig.*en.norm.tok; do
		ttr $F $R $SIZE
	done

	# ----- IWSLT -----
	SIZE=10000
	echo "TTR ted en-de SIZE=$SIZE"
	for F in $DTED/*de.norm.tok; do
		ttr $F $R $SIZE
	done

	SIZE=12000
	echo "TTR ted en-fr SIZE=$SIZE"
	for F in $DTED/*fr.norm.tok; do
		ttr $F $R $SIZE
	done
}


ttrs
