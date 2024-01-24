import mdtraj as md
import sys

protein = str(sys.argv[1])

step = 50

traj = md.load(f'two_{protein}_init/prodrun.xtc', top=f'two_{protein}_init/prodrun.gro')

for i in range(10):
    frame = traj[i*step]
    frame.save_gro(f'two_{protein}_{i+1}/start.gro')
