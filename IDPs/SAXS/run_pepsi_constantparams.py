import os, sys
import numpy as np
import mdtraj as md

protein=str(sys.argv[1])
protein_lambda=f'{str(sys.argv[1])}_{str(sys.argv[2])}'
no_frames=int(sys.argv[3]) 
pepsi_path = '/home/projects/ku_10001/people/fretho/software/Pepsi-SAXS'
exp_SAXS = f'/home/projects/ku_10001/people/torska/exp_SAXS_data/{protein}.dat'
drho = 1.0
r0 = 1.025
AA_traj = '../../prodrun_AAbackmapped.xtc'
AA_top = '../../prodrun_AAbackmapped.gro'
outfile_calc = f'calc_data_{protein_lambda}.dat'
output_avgSAXS = f'SAXS_avg_{protein_lambda}.dat'

traj = md.load(AA_traj,top=AA_top)
print('Trajectory: ' + str(traj))

#Running sum of SAXS profiles
Ifit_avg = 0

#Run Pepsi with fixed average params for each frame and get chi2
#for i in range(len(traj)):
for i in np.linspace(0,len(traj)-1,no_frames,dtype=int):
    
    #Save traj frame
    traj[i].save_pdb('AA_frame.pdb')
    
    #Calculate SAXS profile with pepsi
    outfile = f'SAXS_frame{i}_fixparams.fit'
    command = pepsi_path + ' AA_frame.pdb ' + exp_SAXS + ' -o ' + outfile + ' -cst --cstFactor 0 --I0 ' + str(1.0) + ' --scaleFactor 1.0 --dro ' + str(drho) + ' --r0_min_factor ' + str(r0) + ' --r0_max_factor ' + str(r0) + ' --r0_N 1'
    os.system(command)
    
    #Read SAXS profile and add to running sum
    q,dI,Ifit =  np.genfromtxt(outfile,skip_header=6,skip_footer=0,usecols=[0,2,3],unpack=True)
    Ifit_avg += Ifit
    
    #Write header and q-values to BME calc file on first iteration
    if i==0:
        header = "# label"
        for q_value in q:
            header += " \t %e" % q_value
        header += " \n"
        
        with open(outfile_calc,'w') as f:
            f.write(header)
    
    #Write SAXS profile to BME calc file
    frame_line = f"frame_{i+1}"
    for Ifit_value in Ifit:
        frame_line += " \t %e" % Ifit_value
    frame_line += '\n'
    with open(outfile_calc,'a') as f:
        f.write(frame_line)

    #Clean up files
    #os.system('rm AA_frame.pdb')
    #os.system(f'rm SAXS_frame{i}_fixparams.*')

#Divide running sum by nr frames to get average SAXS profile
Ifit_avg = Ifit_avg/len(traj)

#Write file with average SAXS
with open(output_avgSAXS, 'w') as f:
    f.write('#q \t Ifit_avg \n')
    for i in range(len(q)):
        f.write("%e \t%e \n" % (q[i], Ifit_avg[i]))

print("Finished!")
