#!/bin/bash

t=298


cd two_villin_h36_init
qsub ../relax_grompp.sh -v temp=$t
cd ..



