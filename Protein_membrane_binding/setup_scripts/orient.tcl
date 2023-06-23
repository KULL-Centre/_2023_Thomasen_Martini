package require Orient
  namespace import Orient::orient

  set sel [atomselect top "all"]
  set I [draw principalaxes $sel]
  set A [orient $sel [lindex $I 2] {0 0 1}]
  $sel move $A
  set I [draw principalaxes $sel]
  set A [orient $sel [lindex $I 1] {0 1 0}]
  $sel move $A
  set I [draw principalaxes $sel]
  $sel writepdb protein_orient_along_principalaxes.pdb
  exit
