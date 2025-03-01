#!/bin/bash

for system in TYR_PHE_150mMNaCl 2PHES_150mMNaCl BUTYLAMMONIUM_ACETATE GUANIDINE_ACETATE 2TYRS_150mMNaCl
do

cd $system

for ffmod in PW Unmodified PP 
do

cd $ffmod

sbatch -J ${system}_${ffmod} ../../relax_grompp_mdrun.sh 

cd ..

done

cd ..

done
