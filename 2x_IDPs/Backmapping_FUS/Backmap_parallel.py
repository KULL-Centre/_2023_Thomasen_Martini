import os
import sys
import mdtraj as md

start_frame = int(sys.argv[1])
frame_step = int(sys.argv[2])
protein = str(sys.argv[3])

cg_traj = '../../prodrun_nopbc.xtc'
cg_top = f'../../../two_{protein}_init/PRO_CG.gro'

BM='/home/projects/ku_10001/people/fretho/software/backward-v5_3.0/initram-v5_200.sh'
gmx='/home/projects/ku_10001/apps/gromacs-2018.1_AVX2_256_12JUN2018/bin/gmx_mpi'

#Load CG trajectory
traj = md.load(cg_traj, top=cg_top)

#Loop over CG trajectory frames
for i in range(start_frame,len(traj),frame_step):
    
    while os.path.isfile(f'../AA_frame{i}.pdb') == False:
         
        #Save frame to gro file
        md.Trajectory.save_gro(traj[i], 'CG_frame.gro')

        #Backmap
        os.system('bash ' + BM + ' -f CG_frame.gro -p ../topol.top -to charmm36 >/dev/null')

        os.system(str(gmx) + ' editconf -f backmapped.gro -o ../AA_frame%s.pdb -quiet' % str(i))
        #Remove files for next iteration
        os.system('rm backmapped.gro')
        os.system('rm CG_frame.gro')
        os.system('rm \#*')


