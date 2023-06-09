#!/bin/bash
#
#Script to coarse-grain and run energy minimization


export PATH="/lindorffgrp-isilon/thomasen/software/miniconda3/bin:$PATH"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lindorffgrp-isilon/wyong/software/openmpi401/lib

gmx=/lindorffgrp-isilon/wyong/software/GMX20194/bin/gmx_mpi
python=/lindorffgrp-isilon/thomasen/software/miniconda3/bin/python3.7

martinize=/lindorffgrp-isilon/thomasen/software/miniconda3/bin/martinize2

wget http://cgmartini.nl/images/tools/insane/insane.py
insane=insane.py

minmdp=minimization.mdp
FF=martini3001

dssp=/lindorffgrp-isilon/thomasen/software/miniconda3/bin/mkdssp

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

salt=0.15
d=5.0

#Loop through IDPs
for variant in WT m10R m10Rp10K m12Fp12Y m6Rp6K p7Fm7Y p7Kp12D 
do

#Starting structure
pdb=../Structures/${variant}.pdb

#Make directory, cp .pdb and insane.py file there and cd there
dir=${variant}
mkdir $dir
cd $dir

#Martinize
$python $martinize -f $pdb -o PRO_topol.top -x PRO_CG.pdb -ff $FF -ff-dir ../martini_v300_original/martini_v3.0.0_proteins/force_fields/ -map-dir ../martini_v300_original/martini_v3.0.0_proteins/mappings/ 

#Modify terminal backbone bead names
$python ../change_beadtypes_moleculeitp.py molecule_0.itp

#Put protein in box
$gmx editconf -f PRO_CG.pdb -o PRO_CG.gro -bt dodecahedron -d $d <<EOF
1
EOF

#Solvate using insane.py
python2.7 ../$insane -f PRO_CG.gro -o PRO_SOL_IONS.gro -pbc keep -salt $salt -sol W -center -p PRO_topol_SOL_IONS.top

for ff in martini_v300_mod_PP_0.88  martini_v300_original
do

mkdir $ff
cd $ff

cp ../PRO_topol_SOL_IONS.top .
cp ../molecule_0.itp .

ffdir=../../${ff}

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
$gmx grompp -f ../../$minmdp -p PRO_topol_SOL_IONS.top -c ../PRO_SOL_IONS.gro -o min.tpr -pp all_PRO.top -maxwarn 3 -r ../PRO_SOL_IONS.gro
nohup $gmx mdrun -deffnm min -ntomp 1 &

cd ..

done

cd ..

done

rm $insane
