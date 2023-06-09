#!/bin/sh
#PBS -W group_list=ku_10001 -A ku_10001
#PBS -N ubq_contacts
#PBS -l nodes=1:ppn=1:thinnode
#PBS -l walltime=200:00:00
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

mkdir data

for rep in $(seq 1 10)
do

cd two_ubq_$rep

$gmx make_ndx -f prodrun.tpr -o ubq1_ubq2.ndx <<EOF
a 1-166
a 167-332
q
EOF
 
$gmx mindist -f prodrun.xtc -s prodrun.tpr -n ubq1_ubq2.ndx -od ../data/ubq1_ubq2_mindist_rep${rep}.xvg -on ../data/ubq1_ubq2_numcont_rep${rep}.xvg -tu us -d 0.8 <<EOF 
a_1-166
a_167-332
EOF

cd ..

done 

