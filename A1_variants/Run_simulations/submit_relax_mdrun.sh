#!/bin/bash

for i in WT m10R m10Rp10K m12Fp12Y m6Rp6K p7Fm7Y p7Kp12D
do

cd $i

for j in martini_v300_mod_PP_0.88 martini_v300_original
do

cd $j
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

