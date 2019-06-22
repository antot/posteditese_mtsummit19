#!/bin/bash

# perplexity on pos-tagged text source - target
SRILM_DIR=$HOME/software/srilm/bin/i686-m64/
EVALLM_COMMAND=$SRILM_DIR/ngram
BUILDLM_COMMAND=$SRILM_DIR/ngram-count



# ---------------------------------------------------------------------
function ppl_diff {
	SL=$1
	TL=$2
	F=$3
	ORDER=$4

	SRILM_EVAL_OPTS="-order $ORDER -unk"

	BF=$(basename $F)

	PPLSL=$($EVALLM_COMMAND $SRILM_EVAL_OPTS -lm ../lm/$SL-8.lm -ppl $F \
	| tail -n 1 | rev | cut -f3 -d" " | rev)
	PPLTL=$($EVALLM_COMMAND $SRILM_EVAL_OPTS -lm ../lm/$TL-8.lm -ppl $F \
	| tail -n 1 | rev | cut -f3 -d" " | rev)
	PPLDIFF=$(echo "$PPLSL - $PPLTL" | bc -l)
	echo -e "$ORDER\t$BF\t$SL\t$TL\t$PPLSL\t$PPLTL\t$PPLDIFF"
}

function test_lm_trx {
	DIR=../results/tagger-output/

	SL=de
	TL=en
	OUT=../results/pos-sequences/pos_sequences_trx_$SL$TL.out
	echo "test_lm trx $SL-$TL"
	echo -e "Order\tFile\tSL\tTL\tPPL_SL\tPPL_TL\tPPL_DIFF" > $OUT
	for ORDER in 6 8; do
		for F in $DIR/trx/wmt*$SL-$TL*forlm; do
			ppl_diff $SL $TL $F $ORDER >> $OUT
		done
	done

	SL=en
	TL=de
	OUT=../results/pos-sequences/pos_sequences_trx_$SL$TL.out
	echo "test_lm trx $SL-$TL"
	echo -e "Order\tFile\tSL\tTL\tPPL_SL\tPPL_TL\tPPL_DIFF" > $OUT
	for ORDER in 6 8; do
		for F in $DIR/trx/wmt*$SL-$TL*forlm; do
			ppl_diff $SL $TL $F $ORDER >> $OUT
		done
	done

	SL=es
	TL=de
	OUT=../results/pos-sequences/pos_sequences_trx_$SL$TL.out
	echo "test_lm trx $SL-$TL"
	echo -e "Order\tFile\tSL\tTL\tPPL_SL\tPPL_TL\tPPL_DIFF" > $OUT
	for ORDER in 6 8; do
		for F in $DIR/trx/wmt*$SL-$TL*forlm; do
			ppl_diff $SL $TL $F $ORDER >> $OUT
		done
	done

	SL=de
	TL=es
	OUT=../results/pos-sequences/pos_sequences_trx_$SL$TL.out
	echo "test_lm trx $SL-$TL"
	echo -e "Order\tFile\tSL\tTL\tPPL_SL\tPPL_TL\tPPL_DIFF" > $OUT
	for ORDER in 6 8; do
		for F in $DIR/trx/wmt*$SL-$TL*forlm; do
			ppl_diff $SL $TL $F $ORDER >> $OUT
		done
	done
}


function test_lm_ms {
	DIR=../results/tagger-output/
	OUT=../results/pos-sequences/pos_sequences_ms_zhen.out

	SL=zh
	TL=en
	echo "test_lm ms $SL-$TL"
	echo -e "Order\tFile\tSL\tTL\tPPL_SL\tPPL_TL\tPPL_DIFF" > $OUT
	for ORDER in 6 8; do
		for F in $DIR/MS/*ms.zh-en.*lm; do
			ppl_diff $SL $TL $F $ORDER >> $OUT
		done
	done
}

function test_lm_iwslt {
	DIR=../results/tagger-output/

	SL=en
	for TL in de fr; do
		OUT=../results/pos-sequences/pos_sequences_iwslt_$SL$TL.out
		echo "test_lm iwslt $SL-$TL"
		echo -e "Order\tFile\tSL\tTL\tPPL_SL\tPPL_TL\tPPL_DIFF" > $OUT
		
		for ORDER in 6 8; do
			for F in $DIR/iwslt/*$TL.tag.forlm; do
				ppl_diff $SL $TL $F $ORDER >> $OUT
			done
		done
	done
}


test_lm_trx
#test_lm_ms
#test_lm_iwslt





