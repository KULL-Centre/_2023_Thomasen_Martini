#!/bin/bash
source /opt/gromacs-2021.5/gromacs_exec/bin/GMXRC

rm -f tpr.dat
touch tpr.dat
rm -f pullf.dat
touch pullf.dat
rm -f pullx.dat
touch pullx.dat

for i in $(eval echo "{6..34..2}")
do
  j=$i
  echo "../../PW/${j}/$j.tpr"  >> tpr.dat
  echo "../../PW/${j}/${j}_pullf.xvg"  >> pullf.dat
  echo "../../PW/${j}/${j}_pullx.xvg"  >> pullx.dat
done

for i in $(eval echo "{1..5..1}")
do
        gmx_mpi wham -b $((($i-1) * 2000000)) -e $(($i * 2000000)) -if pullf.dat -it tpr.dat -o profile_2000_${i}.xvg -hist -unit kJ -bins 2000 -min 0.6 -max 3.4
done

