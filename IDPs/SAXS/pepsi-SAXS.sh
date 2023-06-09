#PBS -l nodes=1:ppn=8:thinnode
#PBS -l walltime=480:00:00
#PBS -l mem=30gb
# Go to the directory from where the job was submitted (initial directory is $HOME)
echo Working directory is $PBS_O_WORKDIR
cd $PBS_O_WORKDIR
### Here follows the user commands:
# Define number of processors
NPROCS=`wc -l < $PBS_NODEFILE`
echo This job has allocated $NPROCS nodes
# Load all required modules for the job
module purge
module load tools
module load cuda/toolkit/10.2.89 openmpi/gcc/64/1.10.2
module load gcc/9.3.0

python=/home/projects/ku_10001/people/fretho/miniconda3/bin/python3.8
$python run_pepsi_constantparams.py $protein $lambda 20000 
