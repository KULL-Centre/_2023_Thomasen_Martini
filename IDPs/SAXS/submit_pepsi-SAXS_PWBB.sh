#!/bin/bash

for protein in A1 aSyn ColNT CoRNID FhuA Hst52 K19 K25 PNt Sic1 Hst5 ACTR
do

for l in 1.10 1.14 1.18 1.20 1.22
do 

mkdir $protein/lambda_$l/Backmapping/pepsi-SAXS
cd $protein/lambda_$l/Backmapping/pepsi-SAXS
cp ../../../../run_pepsi_constantparams.py .

echo "#!/bin/sh" > temp
echo "#PBS -W group_list=ku_10001 -A ku_10001" >> temp
echo "#PBS -N ${protein}_${l}_pepsiSAXS" >> temp
cat ../../../../pepsi-SAXS.sh >> temp
mv temp pepsi-SAXS.sh

qsub pepsi-SAXS.sh -v protein=$protein,lambda=$l

cd ../../../..

done

done

