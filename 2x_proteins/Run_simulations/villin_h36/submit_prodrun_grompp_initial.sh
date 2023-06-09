#!/bin/bash

t=298


cd two_villin_h36_init

qsub ../prodrun_grompp_initial.sh -v temp=$t
cd ..



