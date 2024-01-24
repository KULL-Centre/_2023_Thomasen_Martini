#!/bin/bash
#SBATCH --partition=qgpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=24:00:00
echo "========= Job started  at `date` =========="
cd $SLURM_SUBMIT_DIR
source /comm/specialstacks/gromacs-volta/bin/modules.sh
module load gromacs-gcc-8.2.0-openmpi-4.0.3-cuda-10.1

gmx_mpi make_ndx -f prodrun.tpr -o tmp_mindist.ndx <<EOF
ri 1
ri 2
q
EOF

gmx_mpi mindist -f prodrun.xtc -s prodrun.tpr -n tmp_mindist.ndx -od ../../data/mindist_${system}_${ffmod}.xvg -on ../../data/numcont_${system}_${ffmod}.xvg -tu us -d 0.8 <<EOF
r_1
r_2
EOF

rm tmp_mindist.ndx
