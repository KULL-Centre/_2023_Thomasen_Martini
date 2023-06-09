#!/bin/bash

for i in K25 A1 CoRNID ColNT FhuA Hst52 K19 PNt Sic1 aSyn Hst5 ACTR
do

cd $i

for j in 1.00 0.96 0.92 0.90 0.88 0.86 0.84
do

cd lambda_${j}
cp ../../make_Rg_gyrate.sh .
qsub make_Rg_gyrate.sh
rm \#*

cd ..

done

cd ..

done

