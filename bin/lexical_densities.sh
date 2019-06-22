#!/bin/bash

# Calculates the lexical density. Definition: https://en.wikipedia.org/wiki/Lexical_density

DD="python3 lexical_density.py"
TAGDIR=$1
OUTDIR=$2


function lex_density {
	IN=$1

	>&2 echo "lex_density $IN"

	DENSITY=$(cat $IN | $DD)
	BIN=$(basename $IN)
	echo -e "$BIN\t$DENSITY"
}


function lex_densities_trx {
	OUTF=$OUTDIR/lex_densities_trx
	rm -fr $OUTF

	for LP in "de-en" "en-de" "es-de" "de-es"; do
		echo "lex_densities_trx $LP"
		for F in $TAGDIR/trx/wmt.r*.$LP.*.tag.forlm $TAGDIR/trx/wmt.smt*.$LP.*.tag.forlm; do
			lex_density $F >>$OUTF.out 2>> $OUTF.log
		done
	done
}

function lex_densities_ms {
	OUTF=$OUTDIR/lex_densities_ms
	rm -fr $OUTF

	L=en
	echo "lex_densities_ms $L"
	for F in $TAGDIR/MS/*.tag.forlm; do
		lex_density $F >>$OUTF.out 2>> $OUTF.log
	done
}

function lex_densities_iwslt {
	OUTF=$OUTDIR/lex_densities_iwslt
	rm -fr $OUTF

	for LP in "en-de" "en-fr"; do
		echo "lex_densities_ted $LP"
		for F in $TAGDIR/iwslt/ted.$LP.*.tag.forlm; do
			lex_density $F >>$OUTF.out 2>> $OUTF.log
		done
	done
}


lex_densities_trx
lex_densities_iwslt
lex_densities_ms

