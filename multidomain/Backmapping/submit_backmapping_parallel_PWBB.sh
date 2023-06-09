#!/bin/bash

for protein in TIA1 hnRNPA1 hSUMO_hnRNPA1 THB_C2 Gal-3 mTurq_GS0_mNeon mTurq_GS8_mNeon mTurq_GS16_mNeon mTurq_GS24_mNeon mTurq_GS32_mNeon mTurq_GS48_mNeon Ubq2 Ubq3 Ubq4 C5_C6_C7
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
