#!/bin/bash

for i in WT #m10R m10Rp10K m12Fp12Y m6Rp6K p7Fm7Y p7Kp12D
do

cd $i

for j in martini_v300_mod_PP_0.88  martini_v300_original #martini_v300_mod_PP_0.80_YRG_1.0  martini_v300_mod_PP_0.86_YRG_1.0  martini_v300_mod_PP_0.88  martini_v300_original
do

cd $j

qsub prodrun_mdrun.sh

cd ..

done

cd ..

done

