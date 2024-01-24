import pyemma
import numpy as np
import pickle as pkl
import sys

sim_dir='/home/projects/ku_10001/people/fretho/MARTINI_PPrescaling/Simulations'

protein=str(sys.argv[1]) #Protein name
protein_type=str(sys.argv[2]) #IDPs or multidomain

l_un = '1.00'
l_PP = '0.88'
l_PW = '1.10'
l_PW_BB = '1.22'

def save_pickle(filename, pickle_obj):
    with open(filename, 'wb') as f:
        pkl.dump(pickle_obj, f)

#Featurize pairwise BB distances based on gro-file
pdb_file = f'{sim_dir}/unmodified/{protein_type}/{protein}/{protein}.gro'
distances_feat = pyemma.coordinates.featurizer(pdb_file)
BB_atoms = distances_feat.select('name BB')
distances_feat.add_distances(BB_atoms , periodic=False)

#Calculate pairwise BB distances for each type of force field
traj_file = f'{sim_dir}/unmodified/{protein_type}/{protein}/prodrun_lambda{l_un}.xtc'
distances_data_un = pyemma.coordinates.load(traj_file, features=distances_feat)
distances_data_un = distances_data_un[0:40001]

traj_file = f'{sim_dir}/protein_protein/{protein_type}/{protein}/prodrun_lambda{l_PP}.xtc'
distances_data_PP = pyemma.coordinates.load(traj_file, features=distances_feat)
distances_data_PP = distances_data_PP[0:40001]

traj_file = f'{sim_dir}/protein_water/{protein_type}/{protein}/prodrun_lambda{l_PW}.xtc'
distances_data_PW = pyemma.coordinates.load(traj_file, features=distances_feat)
distances_data_PW = distances_data_PW[0:40001]

traj_file = f'{sim_dir}/proteinbackbone_water/{protein_type}/{protein}/prodrun_lambda{l_PW_BB}.xtc'
distances_data_PW_BB = pyemma.coordinates.load(traj_file, features=distances_feat)
distances_data_PW_BB = distances_data_PW_BB[0:40001]

del distances_feat, BB_atoms

distances_all = np.concatenate((distances_data_un, distances_data_PP, distances_data_PW, distances_data_PW_BB), axis=0)

del distances_data_un, distances_data_PP, distances_data_PW, distances_data_PW_BB

pca = pyemma.coordinates.pca(distances_all, dim=2)

pca_output = pca.get_output()

save_pickle(f'PCA_all_proteins/{protein}.pkl', pca_output)
