#!/bin/bash
#SBATCH --partition=qgpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=18
#SBATCH --time=24:00:00
#SBATCH --gres=gpu:v100:1
echo "========= Job started  at `date` =========="
cd $SLURM_SUBMIT_DIR
source /comm/specialstacks/gromacs-volta/bin/modules.sh
module load gromacs-gcc-8.2.0-openmpi-4.0.3-cuda-10.1

gmx_mpi mdrun -s prodrun.tpr -deffnm prodrun -ntomp 18 -maxh 23.9 -cpi prodrun.cpt -v

MAX_RESUB=30
SCRIPT_PATH=$(scontrol show job $SLURM_JOBID | awk -F= '/Command=/{print $2}')
JOB_NAME=$(scontrol show job $SLURM_JOBID | awk -F= '/JobName=/{print $3}')
bash /home/thomasen/resubmit.sh $SCRIPT_PATH $MAX_RESUB $JOB_NAME

echo "========= Job finished at `date` =========="

