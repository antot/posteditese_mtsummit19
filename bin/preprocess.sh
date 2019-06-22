#!/bin/bash

# Preprocesses the datasets
MOSESSCRIPTS=../third/mosesdecoder-RELEASE-3.0/scripts/

# TODO: UDPIPE (1.2.0 was used) and SRILM (1.7.2 was used) need to be installed
UDPIPE=~/Software/ud/udpipe-1.2.0-bin/bin-linux64/udpipe
UDMODELDIR=~/Software/ud/ud-models_22/models/
SRILM_DIR=$HOME/Software/srilm/bin/i686-m64/
EVALLM_COMMAND=$SRILM_DIR/ngram
BUILDLM_COMMAND=$SRILM_DIR/ngram-count


function ms_filenames {
	ln -s newstest2017-zhen-src.zh.txt ms.zh-en.src.zh
	ln -s Translator-HumanParityData-Combo-6.txt ms.zh-en.c6.en
	ln -s Translator-HumanParityData-Online-A-1710.txt ms.zh-en.a.en
	ln -s Translator-HumanParityData-Reference-HT.txt ms.zh-en.ht.en
	ln -s Translator-HumanParityData-Reference-PE.txt ms.zh-en.pe.en
}

function ms_lang_sets {
	for i in ms.zh-en.*; do
		paste $i lang_ids | grep "zh$" | cut -f1 > orig.$i
		paste $i lang_ids | grep "en$" | cut -f1 > trlt.$i
	done	
}

# Done with Stanford ctb segmenter. https://nlp.stanford.edu/software/segmenter.shtml
# Leads to highest BLEU in a previous experiment. http://wilkeraziz.github.io/work/2014/11/04/chinese-word-segmentation.html
function ms_segment {
	SEGMENTER=$HOME/software/stanford-segmenter-2018-02-27/segment.sh
	for F in ms.zh-en.src.zh orig.ms.zh-en.src.zh trlt.ms.zh-en.src.zh; do
		FO=$F
		echo "Segmenting $F --> $FO.out"
		$SEGMENTER -k ctb $F UTF-8 0 > $FO.seg 2>$FO.seg.log
	done
}

function prepare_ms {
	CDIR=$(pwd)
	cd ../datasets/MS/
	ms_filenames
	ms_lang_sets
	ms_segment
	cd $CDIR
}

#---------------------------------

function preproc_test_data_trx {
	DIR=../datasets/taraxu/
	ORIGDIR=$DIR
	CDIR=`pwd`
	cd $DIR

	for F in $ORIGDIR/*.de-en $ORIGDIR/*.en-de $ORIGDIR/*.de-es $ORIGDIR/*.es-de; do
		FB=$(basename $F)
		L=`echo $F | rev | cut -f1 -d- | rev`
		echo "$F $L"
		cat $F |\
	        ${MOSESSCRIPTS}/tokenizer/deescape-special-chars.perl |\
	        ${MOSESSCRIPTS}/tokenizer/normalize-punctuation.perl|\
		${MOSESSCRIPTS}/tokenizer/detokenizer.perl -l $L \
		> $FB.norm

		cat $FB.norm \
		| ${MOSESSCRIPTS}/tokenizer/tokenizer.perl -l $L \
		> $FB.norm.tok
	done
	
	cd $CDIR
}

function preproc_test_data_ms {
	DIR=../datasets/MS/
	ORIGDIR=$DIR
	CDIR=`pwd`
	mkdir -p $DIR
	cd $DIR

	for F in $ORIGDIR/ms* $ORIGDIR/orig* $ORIGDIR/trlt*; do
		FB=$(basename $F)
		echo "$F $FB"
		cat $F |\
	        ${MOSESSCRIPTS}/tokenizer/deescape-special-chars.perl |\
	        ${MOSESSCRIPTS}/tokenizer/normalize-punctuation.perl \
		> $FB.norm
	done

	L=en
	for F in *$L.norm; do
		cat $F \
		| ${MOSESSCRIPTS}/tokenizer/tokenizer.perl -l $L \
		> $F.tok
	done	

	cd $CDIR
}

function trim_norm {
	FI=$1
	FO=$2
	L=$3

	echo "norm $FI $FO"
	cat $FI |\
	awk '{$1=$1};1' | `# remove leading and trailing blanks` \
        ${MOSESSCRIPTS}/tokenizer/deescape-special-chars.perl |\
        ${MOSESSCRIPTS}/tokenizer/normalize-punctuation.perl \
	> $FO

	cat $FO \
	| ${MOSESSCRIPTS}/tokenizer/tokenizer.perl -l $L \
	> $FO.tok
}

function prepare_test_data_iwslt {
	DIR=../datasets/wit3/

	CDIR=`pwd`
	mkdir -p $DIR
	cd $DIR

	# ----- EN--FR
	ORIGDIR=$DIR/IWSLT16-HE-RELEASE/data/IWSLT16.TED.tst2015.MT_enfr/

	trim_norm $ORIGDIR/*.OrigRef.txt	ted.en-fr.ht.fr.norm	fr
	trim_norm $ORIGDIR/*.Src.txt		ted.en-fr.src.en.norm	en

	trim_norm $ORIGDIR/*PEdits/*uedin	ted.en-fr.penmt1.fr.norm	fr
	trim_norm $ORIGDIR/*PEdits/*fbk		ted.en-fr.penmt2.fr.norm	fr
	trim_norm $ORIGDIR/*PEdits/*MMT		ted.en-fr.pesmt1.fr.norm	fr
	trim_norm $ORIGDIR/*PEdits/*GT		ted.en-fr.pesmt2.fr.norm	fr
	trim_norm $ORIGDIR/*PEdits/*PJAIT	ted.en-fr.pesmt3.fr.norm	fr

	trim_norm $ORIGDIR/*SysOut/*uedin	ted.en-fr.nmt1.fr.norm	fr
	trim_norm $ORIGDIR/*SysOut/*fbk		ted.en-fr.nmt2.fr.norm	fr
	trim_norm $ORIGDIR/*SysOut/*MMT		ted.en-fr.smt1.fr.norm	fr
	trim_norm $ORIGDIR/*SysOut/*GT		ted.en-fr.smt2.fr.norm	fr
	trim_norm $ORIGDIR/*SysOut/*PJAIT	ted.en-fr.smt3.fr.norm	fr

	# ----- EN--DE
	ORIGDIR=$DIR/IWSLT15-HE-RELEASE/data/IWSLT15.TED.tst2015.MT_ende/

	trim_norm $ORIGDIR/*.OrigRef.txt	ted.en-de.ht.de.norm	de
	trim_norm $ORIGDIR/*.Src.txt		ted.en-de.src.en.norm	en

	trim_norm $ORIGDIR/*PEdits/*stanford.PE.txt	ted.en-de.penmt3.de.norm	de
	trim_norm $ORIGDIR/*SysOut/*stanford.txt	ted.en-de.nmt3.de.norm	de
	trim_norm $ORIGDIR/*PEdits/*UEDIN.PE.txt	ted.en-de.pesmt1.de.norm	de
	trim_norm $ORIGDIR/*SysOut/*UEDIN.txt		ted.en-de.smt1.de.norm	de
	trim_norm $ORIGDIR/*PEdits/*kit.PE.txt		ted.en-de.pesmt2.de.norm	de
	trim_norm $ORIGDIR/*SysOut/*kit.txt		ted.en-de.smt2.de.norm	de
	trim_norm $ORIGDIR/*PEdits/*hdu.PE.txt		ted.en-de.pesmt3.de.norm	de
	trim_norm $ORIGDIR/*SysOut/*hdu.txt		ted.en-de.smt3.de.norm	de

	ORIGDIR=$DIR/wit3/IWSLT16-HE-RELEASE/data/IWSLT16.TED.tst2015.MT_ende/

	trim_norm $ORIGDIR/*PEdits/*.PE.uedin	ted.en-de.penmt1.de.norm	de
	trim_norm $ORIGDIR/*SysOut/*.uedin	ted.en-de.nmt1.de.norm	de
	trim_norm $ORIGDIR/*PEdits/*.PE.kit	ted.en-de.penmt2.de.norm	de
	trim_norm $ORIGDIR/*SysOut/*.kit	ted.en-de.nmt2.de.norm	de
	trim_norm $ORIGDIR/*PEdits/*.PE.fbk	ted.en-de.penmt4.de.norm	de
	trim_norm $ORIGDIR/*SysOut/*.fbk	ted.en-de.nmt4.de.norm	de
	trim_norm $ORIGDIR/*PEdits/*.PE.ufal	ted.en-de.pesmt4.de.norm	de
	trim_norm $ORIGDIR/*SysOut/*.ufal	ted.en-de.smt4.de.norm	de

	cd $CDIR
}

#---------------------------------

function tag_test_data {
	DATA=$1
	UDMODEL=$2
	LANG=$3
	OUTDIR=$4

	>&2 echo "tag $DATA"
	OUTF=$(basename $DATA)

	cat $DATA | \
	$UDPIPE --tokenize --tokenizer=presegmented --tag $UDMODEL \
	> $OUTDIR/$OUTF.$LANG.tag
}

function tag_test_datas_trx {
	OUTDIR=../results/tagger-output/trx/
	mkdir -p $OUTDIR

	L=de
	rm -fr $OUTDIR/tag-trx-$L.log
	UDMODEL=$UDMODELDIR/german-gsd-ud-2.2-conll18-180430.udpipe
	for F in test_data/trx/*-$L.norm; do
		echo $F $L
		tag_test_data $F $UDMODEL $L $OUTDIR \
		>> $OUTDIR/tag-trx-$L.log 2>&1
	done

	L=en
	rm -fr $OUTDIR/tag-trx-$L.log
	UDMODEL=$UDMODELDIR/english-ewt-ud-2.2-conll18-180430.udpipe
	for F in test_data/trx/*-$L.norm; do
		echo $F $L
		tag_test_data $F $UDMODEL $L $OUTDIR \
		>> $OUTDIR/tag-trx-$L.log 2>&1
	done

	L=es
	rm -fr $OUTDIR/tag-trx-$L.log
	UDMODEL=$UDMODELDIR/spanish-ancora-ud-2.2-conll18-180430.udpipe
	for F in test_data/trx/*-$L.norm; do
		echo $F $L
		tag_test_data $F $UDMODEL $L $OUTDIR \
		>> $OUTDIR/tag-trx-$L.log 2>&1
	done

	# wmt.src.* files have been tagged with the wrong language
	rm $OUTDIR/wmt.src.*.tag
	L=de
	UDMODEL=$UDMODELDIR/german-gsd-ud-2.2-conll18-180430.udpipe
	for F in test_data/trx/wmt.src.$L-*.norm; do
		echo $F $L
		tag_test_data $F $UDMODEL $L $OUTDIR \
		>> $OUTDIR/tag-trx-$L.log 2>&1
	done

	L=en
	UDMODEL=$UDMODELDIR/english-ewt-ud-2.2-conll18-180430.udpipe
	for F in test_data/trx/wmt.src.$L-*.norm; do
		echo $F $L
		tag_test_data $F $UDMODEL $L $OUTDIR \
		>> $OUTDIR/tag-trx-$L.log 2>&1
	done

	L=es
	UDMODEL=$UDMODELDIR/spanish-ancora-ud-2.2-conll18-180430.udpipe
	for F in test_data/trx/wmt.src.$L-*.norm; do
		echo $F $L
		tag_test_data $F $UDMODEL $L $OUTDIR \
		>> $OUTDIR/tag-trx-$L.log 2>&1
	done


}

function tag_test_datas_ms {
	OUTDIR=../results/tagger-output/ms/
	mkdir -p $OUTDIR

	L=zh
	rm $OUTDIR/tag-ms-$L.log
	UDMODEL=$UDMODELDIR/chinese-gsd-ud-2.2-conll18-180430.udpipe
	for F in test_data/ms/*.$L.norm; do
		echo $F
		tag_test_data $F $UDMODEL $L $OUTDIR \
		>> $OUTDIR/tag-ms-$L.log 2>&1
	done

	L=en
	rm $OUTDIR/tag-ms-$L.log
	UDMODEL=$UDMODELDIR/english-ewt-ud-2.2-conll18-180430.udpipe
	for F in test_data/ms/*.$L.norm; do
		echo $F
		tag_test_data $F $UDMODEL $L $OUTDIR \
		>> $OUTDIR/tag-ms-$L.log 2>&1
	done

}

function tag_test_datas_iwslt {
	OUTDIR=../results/tagger-output/ted/
	mkdir -p $OUTDIR

	L=de
	rm $OUTDIR/tag-ted-$L.log
	UDMODEL=$UDMODELDIR/german-gsd-ud-2.2-conll18-180430.udpipe
	for F in test_data/ted/*.$L.norm; do
		echo $F
		tag_test_data $F $UDMODEL $L $OUTDIR \
		>> $OUTDIR/tag-ted-$L.log 2>&1
	done

	L=en
	rm $OUTDIR/tag-ted-$L.log
	UDMODEL=$UDMODELDIR/english-ewt-ud-2.2-conll18-180430.udpipe
	for F in test_data/ted/*.$L.norm; do
		echo $F
		tag_test_data $F $UDMODEL $L $OUTDIR \
		>> $OUTDIR/tag-ted-$L.log 2>&1
	done

	L=fr
	rm $OUTDIR/tag-ted-$L.log
	UDMODEL=$UDMODELDIR/french-gsd-ud-2.2-conll18-180430.udpipe
	for F in test_data/ted/*.$L.norm; do
		echo $F
		tag_test_data $F $UDMODEL $L $OUTDIR \
		>> $OUTDIR/tag-ted-$L.log 2>&1
	done
}

#---------------------------------

function download_mono_data {
	echo "Downloading monolingual data (for perplexity difference)"

	DIR=../mono_corpora/
	mkdir -p $DIR

	# de
	wget -P $DIR http://www.statmt.org/wmt15/training-monolingual-news-crawl-v2/news.2014.de.shuffled.v2.gz
	# en
	wget -P $DIR http://www.statmt.org/wmt15/training-monolingual-news-crawl-v2/news.2014.en.shuffled.v2.gz
	# es
	wget -P $DIR http://www.statmt.org/wmt14/training-monolingual-news-crawl/news.2012.es.shuffled.gz
	# fr
	wget -P $DIR http://www.statmt.org/wmt15/training-monolingual-news-crawl-v2/news.2014.fr.shuffled.v2.gz

	#zh
	wget -P $DIR http://data.statmt.org/news-crawl/zh/news.2008.zh.shuffled.deduped.gz
	wget -P $DIR http://data.statmt.org/news-crawl/zh/news.2010.zh.shuffled.deduped.gz
	wget -P $DIR http://data.statmt.org/news-crawl/zh/news.2011.zh.shuffled.deduped.gz
	wget -P $DIR http://data.statmt.org/news-crawl/zh/news.2012.zh.shuffled.deduped.gz
	wget -P $DIR http://data.statmt.org/news-crawl/zh/news.2013.zh.shuffled.deduped.gz
	wget -P $DIR http://data.statmt.org/news-crawl/zh/news.2014.zh.shuffled.deduped.gz
	wget -P $DIR http://data.statmt.org/news-crawl/zh/news.2015.zh.shuffled.deduped.gz
	wget -P $DIR http://data.statmt.org/news-crawl/zh/news.2016.zh.shuffled.deduped.gz
	wget -P $DIR http://data.statmt.org/news-crawl/zh/news.2017.zh.shuffled.deduped.gz
	wget -P $DIR http://data.statmt.org/news-crawl/zh/news.2018.zh.shuffled.deduped.gz
}

# en, de, fr
function preproc_mono_data {
	L=$1
	# en 28127448 554558348 3311920210	19.72
	#    28114126 552946126 3301599509	19.67

	# de 46059414 702485795 5033319807	15.25
	#    46045226 700912834 5022475264	15.22

	# fr 11658262 231520824 1469591069	19.86 tok/sent
	#    11645555 230154784 1460896253	19.76
	zcat ../mono_corpora/news.20*.$L.shuffled*.gz |\
	${MOSESSCRIPTS}/tokenizer/deescape-special-chars.perl |\
        ${MOSESSCRIPTS}/tokenizer/normalize-punctuation.perl|\
	grep -Ev '([^ ]+ ){80}' | grep -v '[\{\|\[\]]'| gzip \
	> ../mono_corpora/mono.$L.gz
	echo

	# the smallest corpus so far is FR (230M words). Hence that's the size we'll use for all corpora
}

function preproc_mono_data_zh {
	zcat ../mono_corpora/*zh.shuff*gz \
	| ${MOSESSCRIPTS}/tokenizer/deescape-special-chars.perl \
	| ${MOSESSCRIPTS}/tokenizer/normalize-punctuation.perl \
	| gzip > ../mono_corpora/mono.zh.gz
}
	# the smallest corpus is ZH (104MB). Hence that's the size
	# we'll use for all corpora
	# ca 16303685*100/909 =  1793584 sents
	# en 28114126*100/1384 = 2031367 sents
	# de 46045226*100/2105 = 2187421 sents
	# fr 11645555*100/595 =  1957236 sents
	# es  4189396*100/259 =  1617527 sents
	# zh 1749968 (whole)

#---------------------------------

function tag_mono_data {
	DATA=$1
	UDMODEL=$2
	LANG=$3
	LINES=$4
	OUTDIR=$5

	>&2 echo "tag $DATA ($LINES lines)"

	zcat $DATA | \
	head -n $LINES | \
	$UDPIPE --tokenize --tokenizer=presegmented --tag $UDMODEL \
	> $OUTDIR/mono.$LANG.tag
}


function tag_mono_datas {
	OUTDIR=../results/tagger-output/mono
	mkdir -p $OUTDIR

	UDMODEL=$UDMODELDIR/english-ewt-ud-2.2-conll18-180430.udpipe
	LANG=en
	DATA="../mono_corpora/mono.$LANG.gz"
	LINES=2031367 # en 28114126*100/1384 = 2031367 sents
 	tag_mono_data $DATA $UDMODEL $LANG $LINES $OUTDIR \
	> $OUTDIR/tag-mono-$LANG.log 2>&1 &

	UDMODEL=$UDMODELDIR/german-gsd-ud-2.2-conll18-180430.udpipe
	LANG=de
	DATA="../mono_corpora/mono.$LANG.gz"
	LINES=2187421 # de 46045226*100/2105 = 2187421 sents
 	tag_mono_data $DATA $UDMODEL $LANG $LINES $OUTDIR \
	> $OUTDIR/tag-mono-$LANG.log 2>&1 &

	UDMODEL=$UDMODELDIR/french-gsd-ud-2.2-conll18-180430.udpipe
	LANG=fr
	DATA="../mono_corpora/mono.$LANG.gz"
	LINES=1957236 # fr 11645555*100/595 = 1957236 sents
 	tag_mono_data $DATA $UDMODEL $LANG $LINES $OUTDIR \
	> $OUTDIR/tag-mono-$LANG.log 2>&1 &

	UDMODEL=$UDMODELDIR/spanish-ancora-ud-2.2-conll18-180430.udpipe
	LANG=es
	DATA="../mono_corpora/mono.$LANG.gz"
	LINES=1617527 # es 4189396*100/259 =  1617527 sents
 	tag_mono_data $DATA $UDMODEL $LANG $LINES $OUTDIR \
	> $OUTDIR/tag-mono-$LANG.log 2>&1 &

	UDMODEL=$UDMODELDIR/chinese-gsd-ud-2.2-conll18-180430.udpipe
	LANG=zh
	DATA="../mono_corpora/mono.$LANG.gz"
	LINES=1749968 # zh 1749968 (whole)
 	tag_mono_data $DATA $UDMODEL $LANG $LINES $OUTDIR \
	> $OUTDIR/tag-mono-$LANG.log 2>&1 &

	wait
}

#---------------------------------

function prep_data_lm {
	OUTDIR=../results/tagger-output

	for F in $OUTDIR/mono/mono.*.tag $OUTDIR/MS/*ms.zh-en.*.tag $OUTDIR/trx/*.tag $OUTDIR/iwslt/*.tag; do
		>&2 echo "prep_data_lm $F"
		cat $F | grep -v "^#" | grep -v "^$" `# comments + empty lines` \
		| grep -Ev "^[0-9]+-[0-9]+" `# remove compound lines` \
		| sed 's/\\n$/\n/' `# add a newline` \
		| cut -f4 `# keep pos tags` \
		| tr '\n' ' ' | sed 's/  /\n/g' `# horizontal format` \
		> $F.forlm
	done
}

function train_lm {
	SRILM_BUILD_OPTS="-interpolate -wbdiscount -unk"

	for ORDER in 8; do
		for L in de en es fr zh; do
			echo "train_lm $L $ORDER"
			$BUILDLM_COMMAND -order $ORDER $SRILM_BUILD_OPTS \
			-text tagger-output/mono/mono.$L.tag.forlm \
			-lm lm/$L-$ORDER.lm > lm/$L-$ORDER.lm.log 2>&1
		done
	done

	# kn discount does not work
	# one of required modified KneserNey count-of-counts is zero
	# error in discount estimator for order 1
	# http://www.speech.sri.com/projects/srilm/mail-archive/srilm-user/2004-October/3.html
	# The count-of-count statistics of your data are not suitable for KN smoothing
}

#---------------------------------

# files for this block already provided
#prepare_ms
#preproc_test_data_trx
#preproc_test_data_ms
#preproc_test_data_iwslt
#tag_test_datas_trx
#tag_test_datas_ms
#tag_test_datas_iwslt

download_mono_data
preproc_mono_data de
preproc_mono_data en
preproc_mono_data es
preproc_mono_data fr
preproc_mono_data_zh
tag_mono_datas

prep_data_lm
train_lm

