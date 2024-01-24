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

qsub ../prodrun_grompp.sh -v temp=$t

cd ..

done
