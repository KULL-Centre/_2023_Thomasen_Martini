#!/bin/bash

for protein in htau40 aSyn FUS p15PAF
do

for i in $(seq 1 10)
do
cd two_${protein}_${i}
qsub ../prodrun_mdrun.sh -N 2x_${protein}_md_rep${i}
cd ..
done

done


