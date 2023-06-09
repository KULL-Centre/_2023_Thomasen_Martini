#!/bin/bash

for i in A2 aSyn FUS 
do

cd $i

for j in 1.22
do

cd lambda_${j}
cp ../../process_traj_pbc.sh .
qsub process_traj_pbc.sh
rm \#*
cd ..

done

cd ..

done

