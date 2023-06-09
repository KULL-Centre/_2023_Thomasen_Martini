#!/bin/bash

t=303


cd two_ubq_init

qsub ../relax_grompp.sh -v temp=$t
cd ..



