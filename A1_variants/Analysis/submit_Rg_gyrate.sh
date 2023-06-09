#!/bin/bash

mkdir calc_Rg

for protein in WT m10R m10Rp10K m12Fp12Y m6Rp6K p7Fm7Y p7Kp12D
do

cd $protein

for ff in martini_v300_mod_PP_0.88  martini_v300_original
do

cd $ff

cp ../../make_Rg_gyrate.sh .
qsub make_Rg_gyrate.sh -v protein=$protein,ff=$ff
rm \#*

cd ..

done

cd ..

done

