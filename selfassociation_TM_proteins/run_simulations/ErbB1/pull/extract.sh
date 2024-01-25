#!/bin/bash
i=1
k=0

for lines in $(cat windows.dat)
do
	word[$i]=$lines
	i=$[$i +1]
done
i=$[$i -1]

for j in $(eval echo "{1..$i..3}") #j toma valores 1,4,7
do
	k=$[$j +1] #k es el valor que corresponde a los tiempos
	echo 0 | gmx_mpi trjconv -f pull.xtc -s pull.tpr -n ../eq/index.ndx -pbc mol -dump ${word[$k]} -o ${word[$j]}.gro
done


