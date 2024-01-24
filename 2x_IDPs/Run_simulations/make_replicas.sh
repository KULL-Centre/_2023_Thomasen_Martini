#!/bin/bash

python=/home/projects/ku_10001/people/fretho/miniconda3/bin/python3.8

for protein in aSyn FUS p15PAF htau40
do

for i in $(seq 1 10)
do
mkdir two_${protein}_${i}
cp two_${protein}_init/all_PRO.top two_${protein}_${i}
done 

$python make_replica_startstructure.py $protein

done
