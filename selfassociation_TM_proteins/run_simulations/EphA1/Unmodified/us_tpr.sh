#!/bin/bash
source /opt/gromacs-2021.5/gromacs_exec/bin/GMXRC
#set -e 

for i in $(eval echo "{6..34..2}")
do
        gmx_mpi grompp -f md.mdp -o $i.tpr -n index1.ndx -c $i.gro -p system.top
done

