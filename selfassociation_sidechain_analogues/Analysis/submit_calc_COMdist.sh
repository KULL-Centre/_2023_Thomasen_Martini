#!/bin/bash

for system in TYR_PHE_150mMNaCl 2PHES_150mMNaCl BUTYLAMMONIUM_ACETATE GUANIDINE_ACETATE 2TYRS_150mMNaCl
do

cd $system

for ffmod in Unmodified PP PW
do

cd $ffmod

sbatch -J calc_COMdist_${system}_${ffmod} --export=system=${system},ffmod=${ffmod} ../../calc_COMdist.sh 

cd ..

done

cd ..

done
