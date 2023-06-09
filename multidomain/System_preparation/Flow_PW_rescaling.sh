#!/bin/sh
#

python=/storage1/thomasen/software/miniconda3/bin/python3.7
rescaling=/storage1/skaalum/software/python_modules_and_scripts/rescaling_PW_and_PP_martini3_v2.py
str1=PW #PW or PP
str2=ALL #ALL or specific residue (given by three letters)
str3=ALL #ALL, BB, or SC
n=1 #Number of protein in system (1 by default) 

for protein in THB_C2 Ubq2 Ubq3 Ubq4 Gal-3 mTurq_GS0_mNeon mTurq_GS8_mNeon mTurq_GS16_mNeon mTurq_GS24_mNeon mTurq_GS32_mNeon mTurq_GS48_mNeon
do

cd $protein

for l in 1.02 1.04 1.06 1.08 1.10 1.12 1.14
do

$python $rescaling -i dihedrals_rubberbands_all_PRO.top -o all_PRO_lambda${l}.top -p $str1 -q $str2 -r $str3 -f $l -n $n

done

cd ..

done

