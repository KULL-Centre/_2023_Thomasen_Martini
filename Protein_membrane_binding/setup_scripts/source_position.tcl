mol new protein_cg.pdb
set memb [atomselect 0 "all"]
$memb moveby [vecinvert [measure center $memb weight mass]]
set prot [atomselect 1 "all"]
$prot moveby [vecinvert [measure center $prot weight mass]]
set protMinMax [measure minmax $prot]
set memMinMax [measure minmax $memb]
set memMin [lindex $memMinMax 0]
set memMax [lindex $memMinMax 1]
set memZmin [lindex $memMin 2]
set memZmax [lindex $memMax 2]
set protMin [lindex $protMinMax 0]
set protMax [lindex $protMinMax 1]
set protZmin [lindex $protMin 2]
set protZmax [lindex $protMax 2]
set dispz [expr $memZmax + 30 - $protZmin]
$prot moveby [list 0 0 $dispz]
$prot writepdb prot_to_be_merged.pdb
$memb writepdb memb_to_be_merged.pdb
exit

