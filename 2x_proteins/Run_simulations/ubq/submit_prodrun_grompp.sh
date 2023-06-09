#!/bin/bash

t=303

for i in $(seq 1 10)
do

cd two_ubq_$i

qsub ../prodrun_grompp.sh -v temp=$t

cd ..

done

