set prot [atomselect top "name BB or name SC1 or name SC2 or name SC3 or name SC4 or name SC5"]
set memb [atomselect top "resname POPC" ]
set water [atomselect top "resname W"]
set protMinMax2 [measure minmax $prot]
set memMinMax2 [measure minmax $memb]
set protMax2 [lindex $protMinMax2 1]
set protZmax2 [lindex $protMax2 2]
set memMin2 [lindex $memMinMax2 0]
set memZmin2 [lindex $memMin2 2]
set watermax [expr $protZmax2 + 15]
set watermin [expr $memZmin2 - 15]
set zheight [expr $watermax - $watermin]
set outfile [open zheightfile w]
puts $outfile "$zheight"
close $outfile
set sel [atomselect top "not (resname W and (same residue as (abs(z)<$watermin or abs(z)>$watermax or within 6.5 of (resname POPC))))"] 
$sel writepdb deleted_water.pdb
exit

