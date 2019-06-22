#!/bin/bash

# This script generates all the results


# Section 3.1
function preprocess {
	bash preprocess.sh
}

# Section 3.2
function lexical_variety {
	OUTDIR=../results/lexical-variety/
	mkdir -p $OUTDIR
	bash ttr.sh > $OUTDIR/ttrs.out
}

# Section 3.3
function lexical_density {
	TAGDIR=../results/tagger-output/
	OUTDIR=../results/lexical-densities/
	mkdir -p $OUTDIR
	bash lexical_densities.sh $TAGDIR $OUTDIR
}

# Section 3.4
function length_ratio {
	#bash ./length_ratios.sh
	OUTDIR=../results/length-ratios/
	mkdir -p $OUTDIR
	python3 length_ratio_prepare.py $OUTDIR
	# TODO run Rmarkdown file length_ratio_analysis.Rmd
}

# Section 3.5
function pos_sequences {
	OUTDIR=../results/pos-sequences/
	mkdir -p $OUTDIR
	bash pos_sequences.sh
}


#preprocess
##lexical_variety
##lexical_density
##length_ratio
pos_sequences

