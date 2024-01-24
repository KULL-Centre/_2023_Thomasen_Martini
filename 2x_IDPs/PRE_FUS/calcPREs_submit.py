import os
import subprocess
import time
from jinja2 import Template
from analyse import *

submission = Template("""#!/bin/bash
#SBATCH --job-name=PRE{{name}}{{ff}}
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=7
#SBATCH --mem-per-cpu=2000
#SBATCH -t 20:00:00
#SBATCH -o PRE_{{name}}_{{ff}}_{{run}}.out
#SBATCH -e PRE_{{name}}_{{ff}}_{{run}}.err
#SBATCH --partition=sbinlab_ib

source /groups/sbinlab/giulio/.bashrc
conda activate hoomd

start=$(date +%s.%N)

python ./calcPREs.py --name {{name}} --ff {{ff}} --run {{run}}

duration=$(echo "$(date +%s.%N) - $start" | bc)
execution_time=`printf "%.2f seconds" $duration`

echo $execution_time""")

proteins = initProteins()
proteins.to_pickle('proteins.pkl')

for name in ['FUS']:
    for i in [0.88]:
        for k in range(1,11):
            with open('PRE_{:s}_{:.2f}_{:d}.sh'.format(name,i,k), 'w') as submit:
                submit.write(submission.render(name=name,ff='{:.2f}'.format(i),run=k))
            subprocess.run(['sbatch','PRE_{:s}_{:.2f}_{:d}.sh'.format(name,i,k)])
            time.sleep(2)
