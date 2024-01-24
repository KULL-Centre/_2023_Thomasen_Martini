#PBS -l nodes=1:ppn=40
#PBS -l walltime=72:00:00
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
$gmx grompp -f ../relax_Martini_${temp}K.mdp -p all_PRO.top -c min.gro -o relax.tpr -maxwarn 2 -v
$gmx mdrun -s relax.tpr -deffnm relax -ntomp 40 -maxh 70.9 -v
