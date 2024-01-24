#!/bin/bash

for i in htau40 OPN
do

cd ${i}

qsub ../prodrun_mdrun.sh -N ${i}_md

cd ..

done
