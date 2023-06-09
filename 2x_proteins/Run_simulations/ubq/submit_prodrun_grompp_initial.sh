#!/bin/bash

t=303


cd two_ubq_init

qsub ../prodrun_grompp_initial.sh -v temp=$t
cd ..



