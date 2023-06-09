#!/bin/bash

for protein in A1 aSyn ColNT CoRNID FhuA Hst52 K19 K25 PNt Sic1 Hst5 ACTR
do 

cd ${protein}

for j in 1.10 1.14 1.18 1.20 1.22
do
	cd lambda_${j}

	mkdir Backmapping
	cd Backmapping
	
	cp ../../../Backmap_p.sh .

	echo "#!/bin/sh" > temp
	echo "#PBS -W group_list=ku_10001 -A ku_10001" >> temp
	echo "#PBS -N ${protein}_lambda_${j}_backmap" >> temp
	cat Backmap_p.sh >> temp
	mv temp Backmap_p.sh

	qsub Backmap_p.sh -v protein=$protein,lambda=$j

	cd ../..

done

cd ..

done
