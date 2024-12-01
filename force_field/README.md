[martini_v300_pps](https://github.com/KULL-Centre/_2023_Thomasen_Martini/tree/main/force_field/martini_v300_pps) (protein-protein scaled) contains Gromacs force field files for Martini v3.0.0 with ε in the LJ-potentials between protein beads rescaled by a factor λ<sub>PP</sub>=0.88.

[martini_v300_pws](https://github.com/KULL-Centre/_2023_Thomasen_Martini/tree/main/force_field/martini_v300_pws) (protein-water scaled) contains Gromacs force field files for Martini v3.0.0 with ε in the LJ-potentials between protein and water beads rescaled by a factor λ<sub>PW</sub>=1.10.

In order to rescale the interactions between protein beads only (and not e.g. the interactions with lipids), we have modified the original Martini 3.0.0 force field files by adding a new set of protein bead types (all with the suffix _PRO). 

**IMPORTANT: This means that you must generate your protein .itp files using our modified force field files (e.g. using martinize2), so the protein bead types are correctly assigned as _PRO beads. Use the martinize2 flags `-ff-dir martini_v3.0.0_proteins/force_fields/ -map-dir martini_v3.0.0_proteins/mappings/` to use the mappings and parameters from the updated force field.** After generating the files, you can check that the beads of your protein are correctly assigned under the [ atoms ] header.

You can download a tar of the PPS (λ<sub>PP</sub>=0.88) force field files here: https://github.com/KULL-Centre/_2023_Thomasen_Martini/blob/main/force_field/martini_v300_pps.tar.gz

or the PWS (λ<sub>PW</sub>=1.10) force field files here: https://github.com/KULL-Centre/_2023_Thomasen_Martini/blob/main/force_field/martini_v300_pws.tar.gz
