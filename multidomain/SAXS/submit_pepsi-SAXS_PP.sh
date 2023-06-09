#!/bin/bash

for protein in TIA1 hnRNPA1 hSUMO_hnRNPA1 THB_C2 Gal-3 mTurq_GS0_mNeon mTurq_GS8_mNeon mTurq_GS16_mNeon mTurq_GS24_mNeon mTurq_GS32_mNeon mTurq_GS48_mNeon Ubq2 Ubq3 Ubq4 C5_C6_C7
do

for l in 1.00 0.96 0.92 0.90 0.88 0.86 0.84
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

