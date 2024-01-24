import MDAnalysis as mda
import MDAnalysis.analysis.encore as encore
import pickle as pkl

recalculate_RMSD = True

def save_pickle(filename, pickle_obj):
    with open(filename, 'wb') as f:
        pkl.dump(pickle_obj, f)

u1 = mda.Universe('prodrun_AA_lambda1.00_CA.gro', 'prodrun_AA_lambda1.00_CA_skip10.xtc')
u2 = mda.Universe('prodrun_AA_lambda0.88_CA.gro', 'prodrun_AA_lambda0.88_CA_skip10.xtc')
u3 = mda.Universe('pnas2018b_asyn_a03ws_protein_CA.gro', 'pnas2018b_asyn_a03ws_protein_CA_skip10.xtc')
u4 = mda.Universe('pnas2018b_asyn_a99SBdisp_protein_CA.gro', 'pnas2018b_asyn_a99SBdisp_protein_CA_skip10.xtc')

if recalculate_RMSD == True:
    rmsd_matrix = encore.get_distance_matrix(encore.utils.merge_universes([u1, u2, u3, u4]), save_matrix="encore_rmsd_skip10.npz", n_jobs=40)
else:
    rmsd_matrix = encore.get_distance_matrix(encore.utils.merge_universes([u1, u2, u3, u4]), load_matrix="encore_rmsd_skip10.npz", n_jobs=40)

HES, details_HES = encore.hes([u1, u2, u3, u4], align=True)
save_pickle('HES_skip10.pkl', {'results':HES, 'details':details_HES})

CES, details_CES = encore.ces([u1, u2, u3, u4], distance_matrix = rmsd_matrix, ncores=40)
save_pickle('CES_skip10.pkl', {'results':CES, 'details':details_CES})

DRES, details_DRES = encore.dres([u1, u2, u3, u4], distance_matrix = rmsd_matrix, ncores=40)
save_pickle('DRES_skip10.pkl', {'results':DRES, 'details':details_DRES})
