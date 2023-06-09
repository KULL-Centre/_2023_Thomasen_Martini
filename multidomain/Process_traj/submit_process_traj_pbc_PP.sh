#!/bin/bash

for i in TIA1 hnRNPA1 hSUMO_hnRNPA1 THB_C2 Gal-3 mTurq_GS0_mNeon mTurq_GS8_mNeon mTurq_GS16_mNeon mTurq_GS24_mNeon mTurq_GS32_mNeon mTurq_GS48_mNeon Ubq2 Ubq3 Ubq4 C5_C6_C7
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

