#!/bin/sh
#PBS -W group_list=ku_10001 -A ku_10001
#PBS -N htau40_contacts
#PBS -l nodes=1:ppn=1:thinnode
#PBS -l walltime=240:00:00
#PBS -l mem=4gb
# Go to the directory from where the job was submitted (initial directory is $HOME)
echo Working directory is $PBS_O_WORKDIR
cd $PBS_O_WORKDIR
### Here follows the user commands:
# Define number of processors
NPROCS=`wc -l < $PBS_NODEFILE`
echo This job has allocated $NPROCS nodes
# Load all required modules for the job
module load tools
module load cuda/toolkit/10.2.89 openmpi/gcc/64/1.10.2 gcc/9.3.0
gmx=/home/projects/ku_10001/apps/GMX20203/bin/gmx_mpi

for rep in $(seq 1 10)
do

cd two_htau40_$rep

$gmx make_ndx -f prodrun.tpr -o htau401_htau402.ndx <<EOF
a 1-936
a 937-1872
q
EOF
 
$gmx mindist -f prodrun.xtc -s prodrun.tpr -n htau401_htau402.ndx -od ../data/htau401_htau402_mindist_rep${rep}.xvg -on ../data/htau401_htau402_numcont_rep${rep}.xvg -tu us -d 0.8 <<EOF 
a_1-936
a_937-1872
EOF

cd ..

done 
