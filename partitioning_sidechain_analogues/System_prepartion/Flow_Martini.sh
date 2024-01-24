#!/bin/bash
#

gmx=/storage1/francesco/software/GMX_2021.1/bin/gmx

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

for aa in ALA CYS VAL LEU ILE MET ASN GLN THR SER
do

#rm -r $aa
mkdir $aa
cd $aa

for ffmod in Unmodified PW
do

mkdir $ffmod
cd $ffmod

cp ../../CHEX_W_${ffmod}.top .
echo "${aa}S        1" >> CHEX_W_${ffmod}.top

#Run energy minimization
$gmx grompp -f ../../minimization.mdp -p CHEX_W_${ffmod}.top -c ../../CHEX_W_singlebead.gro -o min.tpr -pp all_PRO.top -r ../../CHEX_W_singlebead.gro
nohup $gmx mdrun -deffnm min -ntomp 2 &

cd ..

done

cd ..

done



for aa in TRP TYR PHE TRP HIS
do

$gmx editconf -f CHEX_W_${aa}.pdb -o CHEX_W_${aa}.gro -bt cubic -box 5 5 5

#rm -r $aa
mkdir $aa
cd $aa

for ffmod in Unmodified PW
do

mkdir $ffmod
cd $ffmod

cp ../../CHEX_W_${ffmod}.top .
echo "${aa}S        1" >> CHEX_W_${ffmod}.top

#Run energy minimization
$gmx grompp -f ../../minimization.mdp -p CHEX_W_${ffmod}.top -c ../../CHEX_W_${aa}.gro -o min.tpr -pp all_PRO.top -r ../../CHEX_W_${aa}.gro
#nohup $gmx mdrun -deffnm min -ntomp 2 &
taskset -c 0 nohup $gmx mdrun -deffnm min -ntmpi 1 & #for TRP
cd ..

done

cd ..

done
