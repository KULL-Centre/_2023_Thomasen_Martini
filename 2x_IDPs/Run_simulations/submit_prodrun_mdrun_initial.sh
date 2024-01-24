#!/bin/bash

for protein in htau40 #aSyn FUS htau40 p15PAF
do

cd two_${protein}_init

qsub ../prodrun_mdrun.sh -N 2x_${protein}_md_init

cd ..

done


