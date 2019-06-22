#!/usr/bin/env python3

# Prepares CSV files of sentence length ratios (between source text and each translation). These will then be analysed in R.

import sys
outdir=sys.argv[1]



def gen_csv(filenames, header, outfile):
    """
    TODO comment
    """
    f = open(outfile,"w")
    print(header, file=f)
    files = [open(i, "r") for i in filenames]
    for rows in zip(*files):
        i=0
        for row in rows:
            #print(row)
            row = row.strip() # some lines in the dataset have leading and/or trailing spaces
            #print(row)
            if i==0:
                print(len(row), end='', file=f)
                len_src = len(row)
            else:
                print('', end=',', file=f)
                print(len(row), end=',', file=f)
                diff = len(row) - len_src
                diff_abs = abs(diff)
                diff_nabs = diff_abs / float(len_src) # normalised diff
                print(diff, end= ',', file=f)
                print(diff_abs, end= ',', file=f)
                print(diff_nabs, end= '', file=f)
            i+=1
        print("", flush=True, file=f)
        #break
    f.close()

        


#--------------------------------------------
data_ende15 = "../datasets/wit3/IWSLT15-HE-RELEASE/data/IWSLT15.TED.tst2015.MT_ende/"
data_ende16 = "../datasets/wit3/IWSLT16-HE-RELEASE/data/IWSLT16.TED.tst2015.MT_ende/"
src_ende = data_ende15 + "IWSLT15.TED.tst2015.MT_ende.Src.txt"
ht_ende = data_ende15 + "IWSLT15.TED.tst2015.MT_ende.OrigRef.txt"

penmt1_ende = data_ende16 + "IWSLT16.TED.tst2015.MT_ende.PEdits/IWSLT16.TED.tst2015.MT_en-de.PE.uedin"
penmt2_ende = data_ende16 + "IWSLT16.TED.tst2015.MT_ende.PEdits/IWSLT16.TED.tst2015.MT_en-de.PE.kit"
penmt3_ende = data_ende15 + "IWSLT15.TED.tst2015.MT_ende.PEdits/IWSLT15.TED.tst2015.MT_ende.stanford.PE.txt"
penmt4_ende = data_ende16 + "IWSLT16.TED.tst2015.MT_ende.PEdits/IWSLT16.TED.tst2015.MT_en-de.PE.fbk"
pesmt1_ende = data_ende15 + "IWSLT15.TED.tst2015.MT_ende.PEdits/IWSLT15.TED.tst2015.MT_ende.UEDIN.PE.txt"
pesmt2_ende = data_ende15 + "IWSLT15.TED.tst2015.MT_ende.PEdits/IWSLT15.TED.tst2015.MT_ende.kit.PE.txt"
pesmt3_ende = data_ende15 + "IWSLT15.TED.tst2015.MT_ende.PEdits/IWSLT15.TED.tst2015.MT_ende.hdu.PE.txt"
pesmt4_ende = data_ende16 + "IWSLT16.TED.tst2015.MT_ende.PEdits/IWSLT16.TED.tst2015.MT_en-de.PE.ufal"

nmt1_ende = data_ende16 + "IWSLT16.TED.tst2015.MT_ende.SysOut/IWSLT16.TED.tst2015.MT_en-de.uedin"
nmt2_ende = data_ende16 + "IWSLT16.TED.tst2015.MT_ende.SysOut/IWSLT16.TED.tst2015.MT_en-de.kit"
nmt3_ende = data_ende15 + "IWSLT15.TED.tst2015.MT_ende.SysOut/IWSLT15.TED.tst2015.MT_ende.stanford.txt"
nmt4_ende = data_ende16 + "IWSLT16.TED.tst2015.MT_ende.SysOut/IWSLT16.TED.tst2015.MT_en-de.fbk"
smt1_ende = data_ende15 + "IWSLT15.TED.tst2015.MT_ende.SysOut/IWSLT15.TED.tst2015.MT_ende.UEDIN.txt"
smt2_ende = data_ende15 + "IWSLT15.TED.tst2015.MT_ende.SysOut/IWSLT15.TED.tst2015.MT_ende.kit.txt"
smt3_ende = data_ende15 + "IWSLT15.TED.tst2015.MT_ende.SysOut/IWSLT15.TED.tst2015.MT_ende.hdu.txt"
smt4_ende = data_ende16 + "IWSLT16.TED.tst2015.MT_ende.SysOut/IWSLT16.TED.tst2015.MT_en-de.ufal"

       
def iwslt_ende():
    filenames_ende = [src_ende, ht_ende, \
                 penmt1_ende,penmt2_ende,penmt3_ende,penmt4_ende,\
                 pesmt1_ende,pesmt2_ende,pesmt3_ende,pesmt4_ende,\
                 nmt1_ende,nmt2_ende,nmt3_ende,nmt4_ende,\
                 smt1_ende,smt2_ende,smt3_ende,smt4_ende]
    header_ende = "len_src,\
          len_ht,diff_ht,absdiff_ht,nabsdiff_ht,\
          len_penmt1,diff_penmt1,absdiff_penmt1,nabsdiff_penmt1,\
          len_penmt2,diff_penmt2,absdiff_penmt2,nabsdiff_penmt2,\
          len_penmt3,diff_penmt3,absdiff_penmt3,nabsdiff_penmt3,\
          len_penmt4,diff_penmt4,absdiff_penmt4,nabsdiff_penmt4,\
          len_pesmt1,diff_pesmt1,absdiff_pesmt1,nabsdiff_pesmt1,\
          len_pesmt2,diff_pesmt2,absdiff_pesmt2,nabsdiff_pesmt2,\
          len_pesmt3,diff_pesmt3,absdiff_pesmt3,nabsdiff_pesmt3,\
          len_pesmt4,diff_pesmt4,absdiff_pesmt4,nabsdiff_pesmt4,\
          len_nmt1,diff_nmt1,absdiff_nmt1,nabsdiff_nmt1,\
          len_nmt2,diff_nmt2,absdiff_nmt2,nabsdiff_nmt2,\
          len_nmt3,diff_nmt3,absdiff_nmt3,nabsdiff_nmt3,\
          len_nmt4,diff_nmt4,absdiff_nmt4,nabsdiff_nmt4,\
          len_smt1,diff_smt1,absdiff_smt1,nabsdiff_smt1,\
          len_smt2,diff_smt2,absdiff_smt2,nabsdiff_smt2,\
          len_smt3,diff_smt3,absdiff_smt3,nabsdiff_smt3,\
          len_smt4,diff_smt4,absdiff_smt4,nabsdiff_smt4\
          "
    
    gen_csv(filenames_ende, header_ende, outdir + "/length_ratios_iwslt_en-de.csv")


#--------------------------------------------
data_enfr16 = "../datasets/wit3/IWSLT16-HE-RELEASE/data/IWSLT16.TED.tst2015.MT_enfr/"
src_enfr = data_enfr16 + "IWSLT16.TED.tst2015.MT_enfr.Src.txt"
ht_enfr = data_enfr16 + "IWSLT16.TED.tst2015.MT_enfr.OrigRef.txt"

penmt1_enfr = data_enfr16 + "IWSLT16.TED.tst2015.MT_enfr.PEdits/IWSLT16.TED.tst2015.MT_en-fr.PE.uedin"
penmt2_enfr = data_enfr16 + "IWSLT16.TED.tst2015.MT_enfr.PEdits/IWSLT16.TED.tst2015.MT_en-fr.PE.fbk"
pesmt1_enfr = data_enfr16 + "IWSLT16.TED.tst2015.MT_enfr.PEdits/IWSLT16.TED.tst2015.MT_en-fr.PE.MMT"
pesmt2_enfr = data_enfr16 + "IWSLT16.TED.tst2015.MT_enfr.PEdits/IWSLT16.TED.tst2015.MT_en-fr.PE.GT"
pesmt3_enfr = data_enfr16 + "IWSLT16.TED.tst2015.MT_enfr.PEdits/IWSLT15.TED.tst2015.MT_en-fr.PE.PJAIT"

nmt1_enfr = data_enfr16 + "IWSLT16.TED.tst2015.MT_enfr.SysOut/IWSLT16.TED.tst2015.MT_en-fr.uedin"
nmt2_enfr = data_enfr16 + "IWSLT16.TED.tst2015.MT_enfr.SysOut/IWSLT16.TED.tst2015.MT_en-fr.fbk"
smt1_enfr = data_enfr16 + "IWSLT16.TED.tst2015.MT_enfr.SysOut/IWSLT16.TED.tst2015.MT_en-fr.MMT"
smt2_enfr = data_enfr16 + "IWSLT16.TED.tst2015.MT_enfr.SysOut/IWSLT16.TED.tst2015.MT_en-fr.GT"
smt3_enfr = data_enfr16 + "IWSLT16.TED.tst2015.MT_enfr.SysOut/IWSLT15.TED.tst2015.MT_en-fr.PJAIT"

def iwslt_enfr():
    filenames_enfr = [src_enfr, ht_enfr, \
                      penmt1_enfr, penmt2_enfr, pesmt1_enfr, pesmt2_enfr, pesmt3_enfr,\
                      nmt1_enfr, nmt2_enfr, smt1_enfr, smt2_enfr, smt3_enfr]
    header_enfr = "len_src,\
        len_ht,diff_ht,absdiff_ht,nabsdiff_ht,\
        len_penmt1,diff_penmt1,absdiff_penmt1,nabsdiff_penmt1,\
        len_penmt2,diff_penmt2,absdiff_penmt2,nabsdiff_penmt2,\
        len_pesmt1,diff_pesmt1,absdiff_pesmt1,nabsdiff_pesmt1,\
        len_pesmt2,diff_pesmt2,absdiff_pesmt2,nabsdiff_pesmt2,\
        len_pesmt3,diff_pesmt3,absdiff_pesmt3,nabsdiff_pesmt3,\
        len_nmt1,diff_nmt1,absdiff_nmt1,nabsdiff_nmt1,\
        len_nmt2,diff_nmt2,absdiff_nmt2,nabsdiff_nmt2,\
        len_smt1,diff_smt1,absdiff_smt1,nabsdiff_smt1,\
        len_smt2,diff_smt2,absdiff_smt2,nabsdiff_smt2,\
        len_smt3,diff_smt3,absdiff_smt3,nabsdiff_smt3\
        "
    gen_csv(filenames_enfr, header_enfr, outdir + "/length_ratios_iwslt_en-fr.csv")


#--------------------------------------------
def trx(lp):
    data_taraxu = "../datasets/taraxu/taraxu-set/"
    src = data_taraxu + "wmt.src." + lp
    ht = data_taraxu + "wmt.ref." + lp
    
    pesmt1 = data_taraxu + "wmt.smt1.edit." + lp
    pesmt2 = data_taraxu + "wmt.smt2.edit." + lp
    perbmt1 = data_taraxu + "wmt.rbmt1.edit." + lp
    perbmt2 = data_taraxu + "wmt.rbmt2.edit." + lp
    
    smt1 = data_taraxu + "wmt.smt1.hyp." + lp
    smt2 = data_taraxu + "wmt.smt2.hyp." + lp
    rbmt1 = data_taraxu + "wmt.rbmt1.hyp." + lp
    rbmt2 = data_taraxu + "wmt.rbmt2.hyp." + lp


    filenames = [src, ht, \
                      pesmt1, pesmt2, perbmt1, perbmt2,\
                      smt1, smt2, rbmt1, rbmt2]
    header = "len_src,\
        len_ht,diff_ht,absdiff_ht,nabsdiff_ht,\
        len_pesmt1,diff_pesmt1,absdiff_pesmt1,nabsdiff_pesmt1,\
        len_pesmt2,diff_pesmt2,absdiff_pesmt2,nabsdiff_pesmt2,\
        len_perbmt1,diff_perbmt1,absdiff_perbmt1,nabsdiff_perbmt1,\
        len_perbmt2,diff_perbmt2,absdiff_perbmt2,nabsdiff_perbmt2,\
        len_smt1,diff_smt1,absdiff_smt1,nabsdiff_smt1,\
        len_smt2,diff_smt2,absdiff_smt2,nabsdiff_smt2,\
        len_rbmt1,diff_rbmt1,absdiff_rbmt1,nabsdiff_rbmt1,\
        len_rbmt2,diff_rbmt2,absdiff_rbmt2,nabsdiff_rbmt2\
        "
    gen_csv(filenames, header, outdir + "/length_ratios_trx_" + lp + ".csv")


#--------------------------------------------
def ms():
    data_ms = "../datasets/MS/"
    src = data_ms + "orig.ms.zh-en.src.zh.seg"
    ht = data_ms + "orig.ms.zh-en.ht.en"
    
    pemt = data_ms + "orig.ms.zh-en.pe.en"
    
    nmt1 = data_ms + "orig.ms.zh-en.c6.en"
    nmt2 = data_ms + "orig.ms.zh-en.a.en"


    filenames = [src, ht, \
                      pemt, \
                      nmt1, nmt2]
    header = "len_src,\
        len_ht,diff_ht,absdiff_ht,nabsdiff_ht,\
        len_pemt,diff_pemt,absdiff_pemt,nabsdiff_pemt,\
        len_nmt1,diff_nmt1,absdiff_nmt1,nabsdiff_nmt1,\
        len_nmt2,diff_nmt2,absdiff_nmt2,nabsdiff_nmt2\
        "
    gen_csv(filenames, header, outdir + "/length_ratios_ms_zh-en.csv")


#--------------------------------------------
iwslt_ende()
iwslt_enfr()
trx("en-de")
trx("de-en")
trx("es-de")
trx("de-es")
ms()

