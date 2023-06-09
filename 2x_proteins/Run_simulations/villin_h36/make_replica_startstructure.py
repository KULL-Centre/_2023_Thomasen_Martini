import mdtraj as md

step = 50

traj = md.load('two_villin_h36_init/prodrun.xtc', top='two_villin_h36_init/prodrun.gro')

for i in range(10):
    frame = traj[i*step]
    frame.save_gro('two_villin_h36_%s/start.gro' % str(i+1))
