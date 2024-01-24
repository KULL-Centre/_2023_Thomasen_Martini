#!/bin/bash
#

gmx=/storage1/francesco/software/GMX_2021.1/bin/gmx
python=/lindorffgrp-isilon/thomasen/software/miniconda3/bin/python3.7

wget http://cgmartini.nl/images/tools/insane/insane.py
insane=insane.py

minmdp=minimization.mdp
FF=martini3001
ffdir=/storage1/thomasen/software/force-fields/Martini/martini_v300_sidechainanalogues
ffdir_PP=/storage1/thomasen/software/force-fields/Martini/martini_v300_pps_sidechainanalogues

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

#Put protein in box
$gmx editconf -f GUANIDINE_ACETATE.pdb -o PRO_CG.gro -bt cubic -box 5 <<EOF
1
EOF

#Solvate using insane.py
python2.7 $insane -f PRO_CG.gro -o PRO_SOL_IONS.gro -pbc keep -salt 0.0 -sol W -center -p PRO_topol_SOL_IONS.top

perl -pi -e's/#include "martini.itp"//g' PRO_topol_SOL_IONS.top
perl -pi -e's/Protein        1/ARGS2A       1\nASPSA       1/g' PRO_topol_SOL_IONS.top
perl -pi -e's/NA\+/NA/g' PRO_topol_SOL_IONS.top
perl -pi -e's/CL-/CL/g' PRO_topol_SOL_IONS.top

#Make top for unmodified ff
rm -r Unmodified
mkdir Unmodified

#Add "#include .itp" lines to PRO_topol_SOL_IONS.top
cat <<EOF > others.top
#include "$ffdir/martini_v3.0.0.itp"
#include "$ffdir/martini_v3.0.0_ions_v1.itp"
#include "$ffdir/martini_v3.0.0_solvents_v1.itp"
#include "$ffdir/martini_v3.0.0_sidechainanalogues.itp"
EOF
cat others.top PRO_topol_SOL_IONS.top >a
mv a Unmodified/PRO_topol_SOL_IONS.top

cd Unmodified

#Run energy minimization
$gmx grompp -f ../minimization.mdp -p PRO_topol_SOL_IONS.top -c ../PRO_SOL_IONS.gro -o min.tpr -pp all_PRO.top -r ../PRO_SOL_IONS.gro -maxwarn 1
nohup $gmx mdrun -deffnm min -ntomp 1 &

cd ..

#Make top for PP rescaled ff
rm -r PP
mkdir PP

#Add "#include .itp" lines to PRO_topol_SOL_IONS.top
cat <<EOF > others.top
#include "$ffdir_PP/martini_v3.0.0.itp"
#include "$ffdir_PP/martini_v3.0.0_ions_v1.itp"
#include "$ffdir_PP/martini_v3.0.0_solvents_v1.itp"
#include "$ffdir_PP/martini_v3.0.0_sidechainanalogues.itp"
EOF
cat others.top PRO_topol_SOL_IONS.top >a
mv a PP/PRO_topol_SOL_IONS.top

cd PP

#Run energy minimization
$gmx grompp -f ../minimization.mdp -p PRO_topol_SOL_IONS.top -c ../PRO_SOL_IONS.gro -o min.tpr -pp all_PRO.top -r ../PRO_SOL_IONS.gro -maxwarn 1
nohup $gmx mdrun -deffnm min -ntomp 1 &

cd ..

rm $insane
