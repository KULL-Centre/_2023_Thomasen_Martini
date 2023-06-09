#PBS -l nodes=1:ppn=40:thinnode
#PBS -l walltime=240:00:00
#PBD -l mem=150gb
# Go to the directory from where the job was submitted (initial directory is $HOME)
echo Working directory is $PBS_O_WORKDIR
cd $PBS_O_WORKDIR
### Here follows the user commands:
# Define number of processors
NPROCS=`wc -l < $PBS_NODEFILE`
echo This job has allocated $NPROCS nodes
# Load all required modules for the job

python=/home/projects/ku_10001/people/fretho/miniconda3/bin/python3.8

$python saxs_chi.py SAXS_avg_${protein}_${lambda}.dat ${protein}.dat bift_${protein}.dat chi_SAXS_fit.dat
