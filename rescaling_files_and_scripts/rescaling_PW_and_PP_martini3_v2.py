#This is a script to rescale protein-protein and/or protein-water interactions in Martini
#F. Emil Thomasen 23.06.2021 (modified by T. Skaalum)

#Parse commandline arguments
import argparse
parser = argparse.ArgumentParser(description='This is a script to rescale protein-water interactions in Martini')
parser.add_argument("-i", "--input", type=str, help="Input: Martini topology file")
parser.add_argument("-o", "--output", type=str, help="Output: Martini topology file with rescaled protein-water interactions")
parser.add_argument("-p", "--strategy_1", type=str, help="Strategy 1: What interactions should be rescaled; PW or PP?")
parser.add_argument("-q", "--strategy_2", type=str, help="Strategy 2: What part of the protein should be rescaled (1/2); ALL or specific residues? (Input by three capital letters)")
parser.add_argument("-r", "--strategy_3", type=str, help="Strategy 3: What part of the protein should be rescaled (2/2); ALL, BB, or SC?")
parser.add_argument("-f", "--rescaling", type=float, help="Lambda: Rescaling factor for epsilon in PP/PW LJ-potential")
parser.add_argument("-n", "--nr_proteins",  type=int, default=1, help="Number of proteins in topology. One protein by default")
args = parser.parse_args()

topfile = args.input
outputfile = args.output
strategy_1 = args.strategy_1
strategy_2 = args.strategy_2
strategy_3 = args.strategy_3
rescaling = args.rescaling
nr_proteins = args.nr_proteins

#Check if there are incorrect inputs for strategy 1, 2, and 3
check_list=['PW','PP','ALL','BB','SC','ALA','ARG','ASN','ASP','CYS','GLN','GLU','GLY','HIS','HIH','ILE','LEU','LYS','MET','PHE','PRO','HYP','SER','THR','TRP','TYR','VAL']

check1=False
check2=False
check3=False

if strategy_1 in check_list[0:2]:
    check1=True
if strategy_2 in check_list[5:] or strategy_2=='ALL':
    check2=True
if strategy_3 in check_list[2:5]:
    check3=True

assert check1==True, 'Wrong input given for strategy 1.\nChoose PW or PP'
assert check2==True, 'Wrong input given for strategy 2.\nChoose ALL or aminoacid residue (e.g. ARG)'
assert check3==True, 'Wrong input given for strategy 3.\nChoose ALL, BB, or SC'

print(f'\nRescaling {strategy_3} {strategy_1} interactions of {strategy_2} residues in {topfile} with lambda={rescaling} and writing new toplogy file to {outputfile}.\n')

#Read topology file lines
with open(topfile, 'r') as f:
    toplines = f.readlines()

    
######################################
####    1. GET PROTEIN BEADS      ####
######################################

#Find start of protein molecule
proteinfound=False
for i,topline in enumerate(toplines):
    if '[ moleculetype ]' in topline:
        if 'Protein' in toplines[i+1]:
            protein_start_line = i+1
            proteinfound=True
            break           
assert proteinfound==True, 'Could not find protein molecule in topology. Make sure your protein is named something with "Protein".\n'

#Find start of protein beads
for i in range(protein_start_line,len(toplines)):
    if '[ atoms ]' in toplines[i]:
            beads_start_line = i+1
            break

#Make list of protein beads
protein_beads = []
for i in range(beads_start_line,len(toplines)):
    
    protein_beads.append(toplines[i].split()[1])
    
    if '[' in toplines[i+1] or len(toplines[i+1].split())==0:
        beads_end_line = i+1
        break

#If there is more than one protein, also get beads from other proteins
if nr_proteins > 1:
    for protein in range(nr_proteins-1):
        
        #Find start of protein molecule (but after end of previous protein)
        proteinfound=False
        for i in range(beads_end_line,len(toplines)):
            if '[ moleculetype ]' in toplines[i]:
                if 'Protein' in toplines[i+1]:
                    protein_start_line = i+1
                    proteinfound=True
                    break
        assert proteinfound==True, 'Could not find protein molecule in topology. Make sure your protein is named something with "Protein".\n'

        #Find start of protein beads
        for i in range(protein_start_line,len(toplines)):
            if '[ atoms ]' in toplines[i]:
                    beads_start_line = i+1
                    break

        #Append beads to list of protein beads
        for i in range(beads_start_line,len(toplines)):

            protein_beads.append(toplines[i].split()[1])
            
            #Stop if next line is the beginning of new toplogy stuff
            #(if your toplogy file is strangely formatted, maybe this will cause a problem)
            if '[' in toplines[i+1] or len(toplines[i+1].split())==0:
                beads_end_line = i+1
                break

# Sort protein beads by residue and by backbone and sidechain beads in dictionary
sorted_protein_beads={'ALA':{'BB':[],'SC':[]},'ARG':{'BB':[],'SC':[]},'ASN':{'BB':[],'SC':[]},'ASP':{'BB':[],'SC':[]},'CYS':{'BB':[],'SC':[]},'GLN':{'BB':[],'SC':[]},'GLU':{'BB':[],'SC':[]},'GLY':{'BB':[]},'HIS':{'BB':[],'SC':[]},'HIH':{'BB':[],'SC':[]},'ILE':{'BB':[],'SC':[]},'LEU':{'BB':[],'SC':[]},'LYS':{'BB':[],'SC':[]},'MET':{'BB':[],'SC':[]},'PHE':{'BB':[],'SC':[]},'PRO':{'BB':[],'SC':[]},'HYP':{'BB':[],'SC':[]},'SER':{'BB':[],'SC':[]},'THR':{'BB':[],'SC':[]},'TRP':{'BB':[],'SC':[]},'TYR':{'BB':[],'SC':[]},'VAL':{'BB':[],'SC':[]}}

for i in protein_beads:
    
    if 'BB' in i:
        sorted_protein_beads[i.split('_')[0]]['BB'].append(i)
        
    else:
        sorted_protein_beads[i.split('_')[0]]['SC'].append(i)

# Remove empty keys
keys_remove=[]
for i in sorted_protein_beads:
    
    if sorted_protein_beads[i]['BB']==[]:
        keys_remove.append(i)

for i in keys_remove:
    sorted_protein_beads.pop(i)

protein_beads = sorted_protein_beads

                
#####################################################
####      2. RESCALE NONBONDED INTERACTIONS      ####
#####################################################

#Find nonbonded interaction parameters
for i,topline in enumerate(toplines):
    if '[ nonbond_params ]' in topline:
        nonbonded_start_line = i+1
        break

#Make list of new toplogy lines for creating output file
new_toplines = toplines[:nonbonded_start_line]

####------- Rescale based on chosen strategies -------####

## PW ##
if strategy_1=='PW':
    
    ### PW, ALL ###
    if strategy_2=='ALL':
        
        #### PW, ALL, ALL ####
        if strategy_3=='ALL':
        
            #Loop through nonbonded lines to find interactions between W and protein beads
            for i in range(nonbonded_start_line,len(toplines)):
    
                #Check if line contains a W bead
                if 'W' in toplines[i]:
                    
                    #Check if line contains protein bead
                    if toplines[i].split()[0].split('_')[0] in protein_beads or toplines[i].split()[1].split('_')[0] in protein_beads:
                        
                        #Rescale epsilon
                        new_epsilon = float(toplines[i].split()[4])*rescaling
                        
                        #Create new line with rescaled epsilon
                        new_topline = f'    {toplines[i].split()[0]}    {toplines[i].split()[1]}  {toplines[i].split()[2]} {toplines[i].split()[3]}    {new_epsilon} ; Lambda={rescaling}, Original epsilon={toplines[i].split()[4]} \n'
                    
                    #If not, new topology line will be the same as the old one
                    else: new_topline = toplines[i]

                #If not, new topology line will be the same as the old one
                else:
                    new_topline = toplines[i]

                #Append new topology line to list
                new_toplines.append(new_topline)

                #Stop if next line is the beginning of new toplogy stuff
                #(if your toplogy file is strangely formatted, maybe this will cause a problem)
                if '[' in toplines[i+1] or ';' in toplines[i+1]:
                    nonbonded_end_line = i+1
                    break
        
        #### PW, ALL, BB ####
        if strategy_3=='BB':
            
            #Loop through nonbonded lines to find interactions between W and BB beads
            for i in range(nonbonded_start_line,len(toplines)):
            
                #Check if line contains a W and a BB bead
                if 'W' in toplines[i] and 'BB' in toplines[i]:
                
                    #Rescale epsilon
                    new_epsilon = float(toplines[i].split()[4])*rescaling
                    
                    #Create new line with rescaled epsilon
                    new_topline = f'    {toplines[i].split()[0]}    {toplines[i].split()[1]}  {toplines[i].split()[2]} {toplines[i].split()[3]}    {new_epsilon} ; Lambda={rescaling}, Original epsilon={toplines[i].split()[4]} \n'
                    
                #If not, new topology line will be the same as the old one
                else: 
                    new_topline = toplines[i]

                #Append new topology line to list
                new_toplines.append(new_topline)

                #Stop if next line is the beginning of new toplogy stuff
                #(if your toplogy file is strangely formatted, maybe this will cause a problem)
                if '[' in toplines[i+1] or ';' in toplines[i+1]:
                    nonbonded_end_line = i+1
                    break
                    
        #### PW, ALL, SC ####
        if strategy_3=='SC':
            
            #Loop through nonbonded lines to find interactions between W and SC beads
            for i in range(nonbonded_start_line,len(toplines)):
    
                #Check if line contains a W bead (and not a BB bead)
                if 'W' in toplines[i] and 'BB' not in toplines[i]:
                
                    #Check if line contains a protein bead (that is not a BB bead)
                    if toplines[i].split()[0].split('_')[0] in protein_beads or toplines[i].split()[1].split('_')[0] in protein_beads:
                        
                        #Rescale epsilon
                        new_epsilon = float(toplines[i].split()[4])*rescaling
                        
                        #Create new line with rescaled epsilon
                        new_topline = f'    {toplines[i].split()[0]}    {toplines[i].split()[1]}  {toplines[i].split()[2]} {toplines[i].split()[3]}    {new_epsilon} ; Lambda={rescaling}, Original epsilon={toplines[i].split()[4]} \n'
                    
                    #If not, new topology line will be the same as the old one
                    else: new_topline = toplines[i]

                #If not, new topology line will be the same as the old one
                else:
                    new_topline = toplines[i]

                #Append new topology line to list
                new_toplines.append(new_topline)

                #Stop if next line is the beginning of new toplogy stuff
                #(if your toplogy file is strangely formatted, maybe this will cause a problem)
                if '[' in toplines[i+1] or ';' in toplines[i+1]:
                    nonbonded_end_line = i+1
                    break
        
    ### PW, RES ###
    else:
        
        #### PW, RES, ALL ####
        if strategy_3=='ALL':
            
            #Loop through nonbonded lines to find interactions between W and protein beads
            for i in range(nonbonded_start_line,len(toplines)):
    
                #Check if line contains a W bead
                if 'W' in toplines[i]:
                    
                    #Check if line contains specified residue
                    if toplines[i].split()[0].split('_')[0]==strategy_2 or toplines[i].split()[1].split('_')[0]==strategy_2:
                        
                        #Rescale epsilon
                        new_epsilon = float(toplines[i].split()[4])*rescaling
                        
                        #Create new line with rescaled epsilon
                        new_topline = f'    {toplines[i].split()[0]}    {toplines[i].split()[1]}  {toplines[i].split()[2]} {toplines[i].split()[3]}    {new_epsilon} ; Lambda={rescaling}, Original epsilon={toplines[i].split()[4]} \n'
                    
                    #If not, new topology line will be the same as the old one
                    else: new_topline = toplines[i]

                #If not, new topology line will be the same as the old one
                else:
                    new_topline = toplines[i]

                #Append new topology line to list
                new_toplines.append(new_topline)

                #Stop if next line is the beginning of new toplogy stuff
                #(if your toplogy file is strangely formatted, maybe this will cause a problem)
                if '[' in toplines[i+1] or ';' in toplines[i+1]:
                    nonbonded_end_line = i+1
                    break
        
        #### PW, RES, BB ####
        if strategy_3=='BB':
        
            #Loop through nonbonded lines to find interactions between W and BB beads
            for i in range(nonbonded_start_line,len(toplines)):
    
                #Check if line contains a W and BB bead
                if 'W' in toplines[i] and 'BB' in toplines[i]:
                    
                    #Check if line contains the specified residue
                    if toplines[i].split()[0].split('_')[0]==strategy_2 or toplines[i].split()[1].split('_')[0]==strategy_2:
                        
                        #Rescale epsilon
                        new_epsilon = float(toplines[i].split()[4])*rescaling
                        
                        #Create new line with rescaled epsilon
                        new_topline = f'    {toplines[i].split()[0]}    {toplines[i].split()[1]}  {toplines[i].split()[2]} {toplines[i].split()[3]}    {new_epsilon} ; Lambda={rescaling}, Original epsilon={toplines[i].split()[4]} \n'
                    
                    #If not, new topology line will be the same as the old one
                    else: new_topline = toplines[i]

                #If not, new topology line will be the same as the old one
                else:
                    new_topline = toplines[i]

                #Append new topology line to list
                new_toplines.append(new_topline)

                #Stop if next line is the beginning of new toplogy stuff
                #(if your toplogy file is strangely formatted, maybe this will cause a problem)
                if '[' in toplines[i+1] or ';' in toplines[i+1]:
                    nonbonded_end_line = i+1
                    break
        
        #### PW, RES, SC ####
        if strategy_3=='SC':
            
            #Loop through nonbonded lines to find interactions between W and protein beads
            for i in range(nonbonded_start_line,len(toplines)):
    
                #Check if line contains a W bead (and not a BB bead)
                if 'W' in toplines[i] and 'BB' not in toplines[i]:
                    
                    #Check if line contains protein bead
                    if toplines[i].split()[0].split('_')[0]==strategy_2 or toplines[i].split()[1].split('_')[0]==strategy_2:
                        
                        #Rescale epsilon
                        new_epsilon = float(toplines[i].split()[4])*rescaling
                        
                        #Create new line with rescaled epsilon
                        new_topline = f'    {toplines[i].split()[0]}    {toplines[i].split()[1]}  {toplines[i].split()[2]} {toplines[i].split()[3]}    {new_epsilon} ; Lambda={rescaling}, Original epsilon={toplines[i].split()[4]} \n'
                    
                    #If not, new topology line will be the same as the old one
                    else: new_topline = toplines[i]

                #If not, new topology line will be the same as the old one
                else:
                    new_topline = toplines[i]

                #Append new topology line to list
                new_toplines.append(new_topline)

                #Stop if next line is the beginning of new toplogy stuff
                #(if your toplogy file is strangely formatted, maybe this will cause a problem)
                if '[' in toplines[i+1] or ';' in toplines[i+1]:
                    nonbonded_end_line = i+1
                    break
                    
## PP ##
if strategy_1=='PP':
    
    ### PP, ALL ###
    if strategy_2=='ALL':
        
        #### PP, ALL, ALL #### ; All PP interactions are rescaled
        if strategy_3=='ALL':
            
            #Loop through nonbonded lines to find interactions between protein beads
            for i in range(nonbonded_start_line,len(toplines)):
                    
                #Check if line contains two protein bead
                if toplines[i].split()[0].split('_')[0] in protein_beads and toplines[i].split()[1].split('_')[0] in protein_beads:

                    #Rescale epsilon
                    new_epsilon = float(toplines[i].split()[4])*rescaling

                    #Create new line with rescaled epsilon
                    new_topline = f'    {toplines[i].split()[0]}    {toplines[i].split()[1]}  {toplines[i].split()[2]} {toplines[i].split()[3]}    {new_epsilon} ; Lambda={rescaling}, Original epsilon={toplines[i].split()[4]} \n'

                #If not, new topology line will be the same as the old one
                else: new_topline = toplines[i]

                #Append new topology line to list
                new_toplines.append(new_topline)

                #Stop if next line is the beginning of new toplogy stuff
                #(if your toplogy file is strangely formatted, maybe this will cause a problem)
                if '[' in toplines[i+1] or ';' in toplines[i+1]:
                    nonbonded_end_line = i+1
                    break
            
        #### PP, ALL, BB #### ; Only interactions between two BB beads are rescaled
        if strategy_3=='BB':
            
            #Loop through nonbonded lines to find interactions between protein beads
            for i in range(nonbonded_start_line,len(toplines)):
                
                #Check if line contains two BB beads
                if 'BB' in toplines[i].split()[0] and 'BB' in toplines[i].split()[1]:
                    
                    #Rescale epsilon
                    new_epsilon = float(toplines[i].split()[4])*rescaling

                    #Create new line with rescaled epsilon
                    new_topline = f'    {toplines[i].split()[0]}    {toplines[i].split()[1]}  {toplines[i].split()[2]} {toplines[i].split()[3]}    {new_epsilon} ; Lambda={rescaling}, Original epsilon={toplines[i].split()[4]} \n'

                #If not, new topology line will be the same as the old one
                else: new_topline = toplines[i]
                    
                #Append new topology line to list
                new_toplines.append(new_topline)

                #Stop if next line is the beginning of new toplogy stuff
                #(if your toplogy file is strangely formatted, maybe this will cause a problem)
                if '[' in toplines[i+1] or ';' in toplines[i+1]:
                    nonbonded_end_line = i+1
                    break
        
        #### PP, ALL, SC #### ; Only interactions between two SC beads are rescaled
        if strategy_3=='SC':
                    
            #Loop through nonbonded lines to find interactions between W and protein beads
            for i in range(nonbonded_start_line,len(toplines)):
                    
                #Check if line contains two protein bead
                if toplines[i].split()[0].split('_')[0] in protein_beads and toplines[i].split()[1].split('_')[0] in protein_beads:
                    
                    #Check that line does NOT contain BB beads
                    if 'BB' not in toplines[i]:

                        #Rescale epsilon
                        new_epsilon = float(toplines[i].split()[4])*rescaling

                        #Create new line with rescaled epsilon
                        new_topline = f'    {toplines[i].split()[0]}    {toplines[i].split()[1]}  {toplines[i].split()[2]} {toplines[i].split()[3]}    {new_epsilon} ; Lambda={rescaling}, Original epsilon={toplines[i].split()[4]} \n'

                    #If not, new topology line will be the same as the old one
                    else: new_topline = toplines[i]

                #If not, new topology line will be the same as the old one
                else: new_topline = toplines[i]
                    
                #Append new topology line to list
                new_toplines.append(new_topline)

                #Stop if next line is the beginning of new toplogy stuff
                #(if your toplogy file is strangely formatted, maybe this will cause a problem)
                if '[' in toplines[i+1] or ';' in toplines[i+1]:
                    nonbonded_end_line = i+1
                    break
    
    ### PP, RES ###
    else:
        
        #### PP, RES, ALL #### ; All PP interactions, where one (or both) is the specified residue, are rescaled
        if strategy_3=='ALL':
            
            #Loop through nonbonded lines to find interactions between protein beads
            for i in range(nonbonded_start_line,len(toplines)):
                    
                #Check if line contains two protein bead, where at least one is the specified residue
                if strategy_2 in toplines[i].split()[0].split('_')[0] and toplines[i].split()[1].split('_')[0] in protein_beads or strategy_2 in toplines[i].split()[1].split('_')[0] and toplines[i].split()[0].split('_')[0] in protein_beads:
                    
                    #Check if line contains only one bead of the specified residue
                    if strategy_2 not in toplines[i].split()[0].split('_')[0] or strategy_2 not in toplines[i].split()[1].split('_')[0]:
                        
                        #Rescale epsilon
                        new_epsilon = float(toplines[i].split()[4])*rescaling

                        #Create new line with rescaled epsilon
                        new_topline = f'    {toplines[i].split()[0]}    {toplines[i].split()[1]}  {toplines[i].split()[2]} {toplines[i].split()[3]}    {new_epsilon} ; Lambda={rescaling}, Original epsilon={toplines[i].split()[4]} \n'

                    #Check if line contains two beads of the specified residue
                    if strategy_2 in toplines[i].split()[0].split('_')[0] and strategy_2 in toplines[i].split()[1].split('_')[0]:
                        
                        #Rescale epsilon
                        new_epsilon = float(toplines[i].split()[4])*rescaling**2

                        #Create new line with rescaled epsilon
                        new_topline = f'    {toplines[i].split()[0]}    {toplines[i].split()[1]}  {toplines[i].split()[2]} {toplines[i].split()[3]}    {new_epsilon} ; Lambda={rescaling**2}, Original epsilon={toplines[i].split()[4]} \n'
                    
                    #If not, new topology line will be the same as the old one
                    #else: new_topline = toplines[i]
                        
                #If not, new topology line will be the same as the old one
                else: new_topline = toplines[i]

                #Append new topology line to list
                new_toplines.append(new_topline)

                #Stop if next line is the beginning of new toplogy stuff
                #(if your toplogy file is strangely formatted, maybe this will cause a problem)
                if '[' in toplines[i+1] or ';' in toplines[i+1]:
                    nonbonded_end_line = i+1
                    break
        
        #### PP, RES, BB #### ; All PP interactions, where one is the backbone of the specified residue, are rescaled
        if strategy_3=='BB':
            
            #Loop through nonbonded lines to find interactions between protein beads
            for i in range(nonbonded_start_line,len(toplines)):

                #Check if any two interacting protein beads are BB beads from the specified residue
                if toplines[i].split()[0] in protein_beads[strategy_2]['BB'] and toplines[i].split()[1].split('_')[0] in protein_beads or toplines[i].split()[1] in protein_beads[strategy_2]['BB'] and toplines[i].split()[0].split('_')[0] in protein_beads:
                    
                    #Check if line only contains one BB bead from the specified residue
                    if toplines[i].split()[0] in protein_beads[strategy_2]['BB'] and toplines[i].split()[1] not in protein_beads[strategy_2]['BB'] or toplines[i].split()[1] in protein_beads[strategy_2]['BB'] and toplines[i].split()[0] not in protein_beads[strategy_2]['BB']:
                        
                        #Rescale epsilon
                        new_epsilon = float(toplines[i].split()[4])*rescaling

                        #Create new line with rescaled epsilon
                        new_topline = f'    {toplines[i].split()[0]}    {toplines[i].split()[1]}  {toplines[i].split()[2]} {toplines[i].split()[3]}    {new_epsilon} ; Lambda={rescaling}, Original epsilon={toplines[i].split()[4]} \n'

                    #Check if line contains two BB beads from the specified residue
                    if toplines[i].split()[0] in protein_beads[strategy_2]['BB'] and toplines[i].split()[1] in protein_beads[strategy_2]['BB']:
                        
                        #Rescale epsilon
                        new_epsilon = float(toplines[i].split()[4])*rescaling**2

                        #Create new line with rescaled epsilon
                        new_topline = f'    {toplines[i].split()[0]}    {toplines[i].split()[1]}  {toplines[i].split()[2]} {toplines[i].split()[3]}    {new_epsilon} ; Lambda={rescaling**2}, Original epsilon={toplines[i].split()[4]} \n'
                    
                    #If not, new topology line will be the same as the old one
                    #else: new_topline = toplines[i]
                        
                #If not, new topology line will be the same as the old one
                else: new_topline = toplines[i]

                #Append new topology line to list
                new_toplines.append(new_topline)

                #Stop if next line is the beginning of new toplogy stuff
                #(if your toplogy file is strangely formatted, maybe this will cause a problem)
                if '[' in toplines[i+1] or ';' in toplines[i+1]:
                    nonbonded_end_line = i+1
                    break
            
        #### PP, RES, SC #### ; All PP interactions, where one is the sidechain of the specified residue, are rescaled
        if strategy_3=='SC':
            
            #Loop through nonbonded lines to find interactions between protein beads
            for i in range(nonbonded_start_line,len(toplines)):
                    
                #Check if any two interacting protein beads are SC beads from the specified residue
                if toplines[i].split()[0] in protein_beads[strategy_2]['SC'] and toplines[i].split()[1].split('_')[0] in protein_beads or toplines[i].split()[1] in protein_beads[strategy_2]['SC'] and toplines[i].split()[0].split('_')[0] in protein_beads:
                    
                    #Check if line only contains one SC bead from the specified residue
                    if toplines[i].split()[0] in protein_beads[strategy_2]['SC'] and toplines[i].split()[1] not in protein_beads[strategy_2]['SC'] or toplines[i].split()[1] in protein_beads[strategy_2]['SC'] and toplines[i].split()[0] not in protein_beads[strategy_2]['SC']:
                        
                        #Rescale epsilon
                        new_epsilon = float(toplines[i].split()[4])*rescaling

                        #Create new line with rescaled epsilon
                        new_topline = f'    {toplines[i].split()[0]}    {toplines[i].split()[1]}  {toplines[i].split()[2]} {toplines[i].split()[3]}    {new_epsilon} ; Lambda={rescaling}, Original epsilon={toplines[i].split()[4]} \n'

                    #Check if line contains two SC beads from the specified residue
                    if toplines[i].split()[0] in protein_beads[strategy_2]['SC'] and toplines[i].split()[1] in protein_beads[strategy_2]['SC']:
                        
                        #Rescale epsilon
                        new_epsilon = float(toplines[i].split()[4])*rescaling**2

                        #Create new line with rescaled epsilon
                        new_topline = f'    {toplines[i].split()[0]}    {toplines[i].split()[1]}  {toplines[i].split()[2]} {toplines[i].split()[3]}    {new_epsilon} ; Lambda={rescaling**2}, Original epsilon={toplines[i].split()[4]} \n'

                    #If not, new topology line will be the same as the old one
                    #else: new_topline = toplines[i]
                        
                #If not, new topology line will be the same as the old one
                else: new_topline = toplines[i]

                #Append new topology line to list
                new_toplines.append(new_topline)

                #Stop if next line is the beginning of new toplogy stuff
                #(if your toplogy file is strangely formatted, maybe this will cause a problem)
                if '[' in toplines[i+1] or ';' in toplines[i+1]:
                    nonbonded_end_line = i+1
                    break
            
####################################
####  3. WRITE OUTPUT FILE      ####
####################################

#Make sure new toplogy and old topology have the same length
assert len(new_toplines+toplines[nonbonded_end_line:])==len(toplines), 'Output topology was not the same length as input. There is a problem somewhere.'

#Write new topology file
with open(outputfile,'w') as f:
    for line in new_toplines:
        f.write(line)
    for line in toplines[nonbonded_end_line:]:
        f.write(line)
        
print('Finished!')
