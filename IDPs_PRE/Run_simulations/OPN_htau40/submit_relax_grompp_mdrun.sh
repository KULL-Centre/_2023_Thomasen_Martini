#!/bin/bash

for i in htau40 OPN
do

cd ${i}

t=0

if [[ "$i" == "htau40" ]]
then
        t=278
fi

if [[ "$i" == "OPN" ]]
then
        t=298
fi

cp ../relax_grompp_mdrun.sh .

echo "#!/bin/sh" > temp
echo "#PBS -W group_list=ku_10001 -A ku_10001" >> temp
echo "#PBS -N ${i}_eq" >> temp
cat relax_grompp_mdrun.sh >> temp
mv temp relax_grompp_mdrun.sh

qsub relax_grompp_mdrun.sh -v temp=$t

cd ..

done
