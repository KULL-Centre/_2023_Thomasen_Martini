#!/bin/bash

for i in ColNT FhuA Hst52 PNt Sic1 aSyn Hst5 ACTR CoRNID A1 K19 K25
do

cd $i

for j in 1.00 1.10 1.14 1.18 1.20 1.22
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

