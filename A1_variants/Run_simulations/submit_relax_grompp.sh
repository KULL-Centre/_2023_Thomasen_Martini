#!/bin/bash

t=298

for i in WT m10R m10Rp10K m12Fp12Y m6Rp6K p7Fm7Y p7Kp12D
do

cd $i

for j in martini_v300_mod_PP_0.88  martini_v300_original
do

cd $j
cp ../../relax_grompp.sh .
qsub relax_grompp.sh -v temp=$t
cd ..

done

cd ..

done

