#!/bin/bash

for i in A1 ACTR aSyn ColNT CoRNID FhuA Hst5 Hst52 K19 K25 PNt Sic1 
do

cd $i


if [[ "$i" == "ColNT" ]]
then
        t=277
fi

if [[ "$i" == "ACTR" ]]
then
        t=278
fi

if [[ "$i" == "K25" || "$i" == "K19" ]]
then
        t=288
fi

if [[ "$i" == "Hst5" || "$i" == "Sic1" || "$i" == "aSyn" || "$i" == "CoRNID" ]]
then
        t=293
fi

if [[ "$i" == "A1" ]]
then
        t=296
fi

if [[ "$i" == "Hst52" || "$i" == "FhuA" || "$i" == "PNt" || "$i" == "FUS" || "$i" == "A2" ]]
then
        t=298
fi

echo "$i is at ${t}K"


for j in 1.00 0.96 0.92 0.90 0.88 0.86 0.84
do

cd lambda_${j}
cp ../../prodrun_grompp.sh .
qsub prodrun_grompp.sh -v temp=$t
cd ..

done

cd ..

done

