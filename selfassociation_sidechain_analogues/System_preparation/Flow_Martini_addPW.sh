#!/bin/bash
#

gmx=/storage1/francesco/software/GMX_2021.1/bin/gmx
minmdp=minimization.mdp
ffdir_PW=/storage1/thomasen/software/force-fields/Martini/martini_v300_pws_sidechainanalogues

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

for system in TYR_PHE_150mMNaCl 2PHES_150mMNaCl BUTYLAMMONIUM_ACETATE GUANIDINE_ACETATE 2TYRS_150mMNaCl
do

cd $system

rm -r PW
mkdir PW

#Add "#include .itp" lines to PRO_topol_SOL_IONS.top
cat <<EOF > others.top
#include "$ffdir_PW/martini_v3.0.0.itp"
#include "$ffdir_PW/martini_v3.0.0_ions_v1.itp"
#include "$ffdir_PW/martini_v3.0.0_solvents_v1.itp"
#include "$ffdir_PW/martini_v3.0.0_sidechainanalogues.itp"
EOF
cat others.top PRO_topol_SOL_IONS.top >a
mv a PW/PRO_topol_SOL_IONS.top

cd PW

#Run energy minimization
$gmx grompp -f ../minimization.mdp -p PRO_topol_SOL_IONS.top -c ../PRO_SOL_IONS.gro -o min.tpr -pp all_PRO.top -r ../PRO_SOL_IONS.gro -maxwarn 1
nohup $gmx mdrun -deffnm min -ntomp 2 &

cd ..

cd ..

done

