[martini_v300_pps](https://github.com/KULL-Centre/_2023_Thomasen_Martini/tree/main/force_field/martini_v300_pps) (protein-protein scaled) contains Gromacs force field files for Martini v3.0.0 with ε in the LJ-potentials between protein beads rescaled by a factor λ<sub>PP</sub>=0.88.

In order to rescale the interactions between protein beads only (and not e.g. the interactions with lipids), we have modified the original Martini 3.0.0 force field files by adding a new set of protein bead types (all with the suffix _PRO)
