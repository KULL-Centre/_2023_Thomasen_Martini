#!/bin/bash

for i in A1 ACTR aSyn ColNT CoRNID FhuA Hst5 Hst52 K19 K25 PNt Sic1
do

cd $i

for j in 1.00 0.96 0.92 0.90 0.88 0.86 0.84
do

cd lambda_${j}
cp ../../process_traj_pbc.sh .
qsub process_traj_pbc.sh
rm \#*
cd ..

done

cd ..

done

