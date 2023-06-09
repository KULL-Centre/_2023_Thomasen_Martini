#!/bin/bash

t=298

for i in $(seq 1 10)
do

cd two_villin_h36_$i

qsub ../prodrun_grompp.sh -v temp=$t

cd ..

done

