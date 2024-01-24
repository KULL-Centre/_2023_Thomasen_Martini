#!/bin/bash

for system in ALA CYS VAL LEU ILE MET ASN GLN THR SER TYR PHE TRP HIS
do

cd $system

for ffmod in PW Unmodified
do

cd $ffmod

qsub ../../prodrun_grompp.sh -N ${system}_${ffmod}_grompp

cd ..

done

cd ..

done
