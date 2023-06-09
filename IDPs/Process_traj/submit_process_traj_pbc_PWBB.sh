#!/bin/bash

for i in A1 ACTR aSyn ColNT CoRNID FhuA Hst5 Hst52 K19 K25 PNt Sic1
do

cd $i

for j in 1.00 1.10 1.14 1.18 1.20 1.22 
do

cd lambda_${j}
cp ../../process_traj_pbc.sh .
qsub process_traj_pbc.sh
rm \#*
cd ..

done

cd ..

done

