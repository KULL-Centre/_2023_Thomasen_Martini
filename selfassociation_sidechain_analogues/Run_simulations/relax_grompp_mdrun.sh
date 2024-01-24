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

gmx_mpi grompp -f ../../relax.mdp -p all_PRO.top -c min.gro -o relax.tpr -v
gmx_mpi mdrun -s relax.tpr -deffnm relax -ntomp 18 -maxh 23.9 -v

echo "========= Job finished at `date` =========="

