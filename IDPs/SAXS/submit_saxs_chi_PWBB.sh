#!/bin/bash

dir_exp=/home/projects/ku_10001/people/torska/exp_SAXS_data 

for protein in A1 aSyn ColNT CoRNID FhuA Hst52 K19 K25 PNt Sic1 Hst5 ACTR
do

for l in 1.10 1.14 1.18 1.20 1.22
do

cd $protein/lambda_$l/Backmapping/pepsi-SAXS

cp $dir_exp/${protein}.dat .
cp $dir_exp/bift_exp/bift_${protein}.dat .

cp ../../../../saxs_chi.sh .
cp ../../../../saxs_chi.py .

echo "#!/bin/sh" > temp
echo "#PBS -W group_list=ku_10001 -A ku_10001" >> temp
echo "#PBS -N ${protein}_${l}_saxs_chi" >> temp
cat saxs_chi.sh >> temp
mv temp saxs_chi.sh

qsub saxs_chi.sh -v protein=$protein,lambda=$l

cd ../../../..

done

done
