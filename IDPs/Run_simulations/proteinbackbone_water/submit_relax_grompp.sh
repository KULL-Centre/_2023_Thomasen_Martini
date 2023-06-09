#!/bin/bash

for i in ColNT FhuA Hst52 PNt Sic1 aSyn Hst5 ACTR CoRNID A1 K19 K25
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

for j in 1.00 1.10 1.14 1.18 1.20 1.22
do

mkdir lambda_$j
cd lambda_$j
cp ../../relax_grompp.sh .
cp ../all_PRO_lambda${j}.top .
mv all_PRO_lambda${j}.top all_PRO_lambda.top
qsub relax_grompp.sh -v temp=$t
cd ..

done

cd ..

done

