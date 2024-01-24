#PBS -l nodes=1:ppn=1:thinnode
#PBS -l mem=4gb
#PBS -l walltime=480:00:00
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

gmx=/home/projects/ku_10001/apps/GMX20203/bin/gmx_mpi

threads=40
frame_skip=1

$gmx pdb2gmx -f ../../two_${protein}_init/two_${protein}.pdb -merge all -o AA.gro -ignh -water none -ff charmm27 -quiet

start_frame=0
for i in $(seq 1 $threads)
do

mkdir start_frame_${start_frame}
cd start_frame_${start_frame}
cp ../../../Backmap_parallel.py .

echo "#!/bin/sh" > temp
echo "#PBS -W group_list=ku_10001 -A ku_10001" >> temp
echo "#PBS -N ${protein}_BM_${start_frame}" >> temp
cat ../../../Backmap_parallel.sh >> temp
mv temp Backmap_parallel.sh

skip_frame=$((${threads}*${frame_skip}))
qsub Backmap_parallel.sh -v start_frame=$start_frame,skip_frame=$skip_frame,protein=$protein

start_frame=$((${start_frame}+${frame_skip}))

cd ..
done
