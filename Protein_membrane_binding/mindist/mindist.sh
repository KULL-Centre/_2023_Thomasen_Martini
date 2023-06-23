proteins=("Lysozyme" "Phospholipase2" "Arf1" "Lact_C2" "PTEN" "FERM" "TRPV4" "Complexin")
methods=("Unmodified" "PW" "PP")
replicas=("rep1" "rep2" "rep3" "rep4")

# Mindist Analysis

for prot in "${proteins[@]}"
do
	cd "${prot}/"
	for method in "${methods[@]}"
	do
		cd "${method}/"
		for replica in "${replicas[@]}"
		do
			cd "${replica}/"
			gmx mindist -f "${prot}_${method}_${rep}.xtc" -s "${prot}_${method}_${rep}.tpr" -od "mindist_${prot}_${method}_${rep}.xvg" -dt 500
			cd ../../
		done
	done
done


# To convert the xvg to csv without time column


for prot in "${proteins[@]}"
do
        cd "${prot}/"
        for method in "${methods[@]}"
        do
                cd "${method}/"
                for replica in "${replicas[@]}"
                do
                        cd "${replica}/"
                        awk '{ print $2 }' "mindist_${prot}_${method}_${rep}.xvg" > "mindist_${prot}_${method}_${rep}_column2.xvg"
                        tail -n +25 "mindist_${prot}_${method}_${rep}_column2.xvg" > "mindist_${prot}_${method}_${rep}_column2.xvg"
                        rename "s/xvg/csv/" *column2_numbers.xvg
                        rm *column2.xvg     
			cd ../../
                done
        done
done




