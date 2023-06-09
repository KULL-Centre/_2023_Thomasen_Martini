#!/bin/sh
#PBS -W group_list=ku_10001 -A ku_10001
#PBS -N Rg_gyrate
#PBS -l nodes=1:ppn=1:thinnode
#PBS -l walltime=48:00:00
#PBS -l mem=3gb
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

$gmx gyrate -f prodrun_nopbc.xtc -s prodrun.tpr -o ../../calc_Rg/Rg_gyrate_${protein}_${ff}.xvg <<EOF 
Protein
EOF 
 
