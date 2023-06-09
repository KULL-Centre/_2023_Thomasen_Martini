#!/bin/bash

for i in TIA1 hnRNPA1 hSUMO_hnRNPA1 THB_C2 Ubq2 Ubq3 Ubq4 Gal-3 mTurq_GS0_mNeon mTurq_GS8_mNeon mTurq_GS16_mNeon mTurq_GS24_mNeon mTurq_GS32_mNeon mTurq_GS48_mNeon C5_C6_C7
do

cd $i

t=0

if [[ "$i" == "TIA1" || "$i" == "hnRNPA1" || "$i" == "hSUMO_hnRNPA1" ]]
then
        t=300
fi

if [[ "$i" == "mTurq_GS0_mNeon" || "$i" == "mTurq_GS8_mNeon" || "$i" == "mTurq_GS16_mNeon" || "$i" == "mTurq_GS24_mNeon" || "$i" == "mTurq_GS32_mNeon" || "$i" == "mTurq_GS48_mNeon" || "$i" == "Ubq2" || "$i" == "Ubq3" || "$i" == "Ubq4" ]]
then
        t=293
fi

if [[ "$i" == "C5_C6_C7" ]]
then
	t=298
fi

if [[ "$i" == "THB_C2" ]]
then
        t=277
fi

if [[ "$i" == "Gal-3" ]]
then
        t=303
fi

echo "$i is at ${t}K"

for j in 1.10 1.14 1.18 1.20 1.22
do

mkdir lambda_$j
cd lambda_$j
cp ../../relax_grompp.sh .
cp ../all_PRO_lambda${j}.top .
mv all_PRO_lambda${j}.top all_PRO_lambda.top
qsub relax_grompp.sh -v temp=$t
cd ..

done

cd ..

done
