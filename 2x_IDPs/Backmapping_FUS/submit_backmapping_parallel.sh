#!/bin/bash

protein=FUS

for i in $(seq 1 10)
do

cd two_${protein}_${i}

rm -r Backmapping
mkdir Backmapping
cd Backmapping

echo "#!/bin/sh" > temp
echo "#PBS -W group_list=ku_10001 -A ku_10001" >> temp
echo "#PBS -N ${protein}_BM" >> temp
cat ../../Backmap.sh >> temp
mv temp Backmap.sh

qsub Backmap.sh -v protein=${protein}

cd ../..

done
