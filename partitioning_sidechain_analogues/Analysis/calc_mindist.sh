#!/bin/sh
#PBS -W group_list=ku_10001 -A ku_10001
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

$gmx mindist -f prodrun.xtc -s prodrun.tpr -od ../../data/mindist_${restype}_${ffmod}_W.xvg -on ../../data/numcont_${restype}_${ffmod}_W.xvg -d 0.8 <<EOF
W
${restype}S
EOF

$gmx mindist -f prodrun.xtc -s prodrun.tpr -od ../../data/mindist_${restype}_${ffmod}_CHEX.xvg -on ../../data/numcont_${restype}_${ffmod}_CHEX.xvg -d 0.8 <<EOF
CHEX
${restype}S
EOF
