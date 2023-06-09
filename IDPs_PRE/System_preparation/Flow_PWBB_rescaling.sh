#!/bin/sh
#

python=/storage1/thomasen/software/miniconda3/bin/python3.7
rescaling=/storage1/skaalum/software/python_modules_and_scripts/rescaling_PW_and_PP_martini3_v2.py
str1=PW #PW or PP
str2=ALL #ALL or specific residue (given by three letters)
str3=BB #ALL, BB, or SC
n=1 #Number of protein in system (1 by default) 
l=1.22

for protein in A2 FUS aSyn
do

cd $protein

$python $rescaling -i all_PRO.top -o all_PRO_lambda${l}.top -p $str1 -q $str2 -r $str3 -f $l -n $n


cd ..

done

