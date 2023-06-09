#!/bin/bash

for i in WT m10R m10Rp10K m12Fp12Y m6Rp6K p7Fm7Y p7Kp12D
do

cd $i

for j in martini_v300_mod_PP_0.88  martini_v300_original
do

cd $j
cp ../../process_traj_pbc.sh .
qsub process_traj_pbc.sh
rm \#*
cd ..

done

cd ..

done

