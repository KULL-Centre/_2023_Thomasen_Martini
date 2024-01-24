#!/bin/bash
#SBATCH --partition=qgpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=24:00:00
echo "========= Job started  at `date` =========="
cd $SLURM_SUBMIT_DIR
source /comm/specialstacks/gromacs-volta/bin/modules.sh
module load gromacs-gcc-8.2.0-openmpi-4.0.3-cuda-10.1

gmx_mpi make_ndx -f prodrun.tpr -o tmp_COMdist.ndx <<EOF
ri 1
ri 2
q
EOF

gmx_mpi distance -f prodrun.xtc -s prodrun.tpr -n tmp_COMdist.ndx -oall ../../data/COMdist_${system}_${ffmod}.xvg -select 'com of group "r_1" plus com of group "r_2"'

rm tmp_COMdist.ndx
