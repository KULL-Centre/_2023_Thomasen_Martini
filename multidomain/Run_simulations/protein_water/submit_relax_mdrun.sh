#!/bin/bash

for i in THB_C2 Gal-3 mTurq_GS0_mNeon mTurq_GS8_mNeon mTurq_GS16_mNeon mTurq_GS24_mNeon mTurq_GS32_mNeon mTurq_GS48_mNeon Ubq2 Ubq3 Ubq4 C5_C6_C7
do

cd $i

for j in 1.02 1.04 1.06 1.08 1.10 1.12 1.14
do

cd lambda_${j}
cp ../../relax_mdrun.sh .

echo "#!/bin/sh" > temp
echo "#PBS -W group_list=ku_10001 -A ku_10001" >> temp
echo "#PBS -N ${i}_${j}_relax" >> temp
cat relax_mdrun.sh >> temp
mv temp relax_mdrun.sh

qsub relax_mdrun.sh

cd ..

done

cd ..

done
