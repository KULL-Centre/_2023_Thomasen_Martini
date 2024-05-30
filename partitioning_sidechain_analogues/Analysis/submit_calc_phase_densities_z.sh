#!/bin/bash

for system in CYS VAL LEU MET ASN GLN THR SER TYR PHE TRP HIS ILE ALA
do

for ffmod in PW Unmodified
do

qsub calc_phase_densities_z.sh -v residue=$system,ffmod=$ffmod -N ${system}_${ffmod}_phase_dens

done
done
