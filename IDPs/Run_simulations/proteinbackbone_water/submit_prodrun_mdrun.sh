#!/bin/bash

for i in A1 ACTR aSyn ColNT CoRNID FhuA Hst5 Hst52 K19 K25 PNt Sic1 
do

cd $i

for j in 1.00 1.10 1.14 1.18 1.20 1.22
do

cd lambda_${j}
cp ../../prodrun_mdrun.sh .

echo "#!/bin/sh" > temp
echo "#PBS -W group_list=ku_10001 -A ku_10001" >> temp
echo "#PBS -N ${i}_${j}_md" >> temp
cat prodrun_mdrun.sh >> temp
mv temp prodrun_mdrun.sh

qsub prodrun_mdrun.sh

cd ..

done

cd ..

done

