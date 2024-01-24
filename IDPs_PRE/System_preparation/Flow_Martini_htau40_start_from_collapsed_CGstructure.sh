#!/bin/bash
#
#Script to coarse-grain and run energy minimization


export PATH="/lindorffgrp-isilon/thomasen/software/miniconda3/bin:$PATH"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lindorffgrp-isilon/wyong/software/openmpi401/lib

gmx=/lindorffgrp-isilon/wyong/software/GMX20194/bin/gmx_mpi
python=/lindorffgrp-isilon/thomasen/software/miniconda3/bin/python3.7

martinize=/lindorffgrp-isilon/thomasen/software/miniconda3/bin/martinize2

change_termbead=/storage1/thomasen/software/force-fields/Martini/martini_v300_mod_PP_0.88/change_beadtypes_moleculeitp.py

wget http://cgmartini.nl/images/tools/insane/insane.py
insane=insane.py

minmdp=minimization.mdp
FF=martini3001
ffdir=/storage1/thomasen/software/force-fields/Martini/martini_v300_mod_PP_0.88

#dssp=/lindorffgrp-isilon/thomasen/software/miniconda3/bin/mkdssp

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

#Loop through oligomer-sizes
i=htau40
salt=0.1

echo "$i has ${salt}M salt"

#Martinize
$python $martinize -f htau40_AA.pdb -o PRO_topol.top -x trash.pdb -ff $FF -ff-dir $ffdir/martini_v3.0.0_proteins/force_fields/ -map-dir $ffdir/martini_v3.0.0_proteins/mappings/ 

rm trash.pdb
cp htau40_collapsed.pdb PRO_CG.pdb

$python $change_termbead molecule_0.itp

#Put protein in box
$gmx editconf -f PRO_CG.pdb -o PRO_CG.gro -bt dodecahedron -d 13.0 <<EOF
1
EOF

#Solvate using insane.py
python2.7 $insane -f PRO_CG.gro -o PRO_SOL_IONS.gro -pbc keep -salt $salt -sol W -center -p PRO_topol_SOL_IONS.top

#The next few blocks modify the toplogy file and molecule_0.itp file:

#Remove #include include martini.itp and substitute ion names in topology file
perl -pi -e's/#include "martini.itp"//g' PRO_topol_SOL_IONS.top
perl -pi -e's/NA\+/NA/g' PRO_topol_SOL_IONS.top
perl -pi -e's/CL-/CL/g' PRO_topol_SOL_IONS.top

#Rename molecule_0.itp to PRO.itp and rename "molecule_0" as "Protein" in PRO.itp file
mv molecule_0.itp PRO.itp
perl -pi -e's/molecule_0/Protein/g' PRO.itp

#Add "#include .itp" lines to PRO_topol_SOL_IONS.top
cat <<EOF > others.top
#include "$ffdir/martini_v3.0.0.itp"
#include "PRO.itp"
#include "$ffdir/martini_v3.0.0_ions_v1.itp"
#include "$ffdir/martini_v3.0.0_solvents_v1.itp"
EOF
cat others.top PRO_topol_SOL_IONS.top >a
mv a PRO_topol_SOL_IONS.top

#Run energy minimization
$gmx grompp -f ../$minmdp -p PRO_topol_SOL_IONS.top -c PRO_SOL_IONS.gro -o min.tpr -pp all_PRO.top -maxwarn 3 -r PRO_SOL_IONS.gro
nohup $gmx mdrun -deffnm min -v -ntomp 4 &

rm $insane

