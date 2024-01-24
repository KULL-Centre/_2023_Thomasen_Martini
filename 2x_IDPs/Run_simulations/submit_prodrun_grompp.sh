#!/bin/bash


for protein in htau40 aSyn FUS p15PAF
do

t=0

if [[ "$protein" == "FUS" || "$protein" == "p15PAF" ]]
then
        t=298
fi

if [[ "$protein" == "aSyn" ]]
then
        t=283
fi

if [[ "$protein" == "htau40" ]]
then
        t=278
fi

for i in $(seq 1 10)
do
cd two_${protein}_${i}
qsub ../prodrun_grompp.sh -v temp=$t
cd ..
done

done


