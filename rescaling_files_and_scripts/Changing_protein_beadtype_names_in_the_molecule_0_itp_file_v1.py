# This script changes the names of termini beadtypes (and other "unmarked" beadtypes) in the molecule_0.itp file generated after martinize2.
#T. Skaalum 08.01.2022

# Read file
file = 'molecule_0.itp'

with open(file, 'r') as f:
    lines = f.readlines()

# Rename file (original file will be overwritten)
with open(f'#{file}','w') as f:
    for line in lines:
        f.write(line)

# Find start and end line for protein beads
for i,line in enumerate(lines):
    
    if '[ atoms ]' in line:
        start_line=i+1
    
    if '[' in line and 'atom' not in line and 'moleculetype' not in line:
        end_line=i-2
        break

print(f'\nSaved {file} as #{file}.')

# Make new lines for the protein beads
new_lines=[]

# Make list of aminoacid residue names
aa= ['ALA','ARG','ASN','ASP','CYS','GLN','GLU','GLY','HIS','HIH','ILE','LEU','LYS','MET','PHE','PRO','HYP','SER','THR','TRP','TYR','VAL']

for i in range(start_line,end_line+1):
    
    # Change beadtype name only if it does not consist of aminoacid resiude name
    
    if lines[i].split()[1].split('_')[0] not in aa:
        new_line = f'{lines[i].split()[0]} {lines[i].split()[3]}_{lines[i].split()[1]}_{lines[i].split()[4]}  {lines[i].split()[2]} {lines[i].split()[3]} {lines[i].split()[4]} {lines[i].split()[5]}  {lines[i].split()[6]}     \n'
            
        # Some lines may have 8 elements in line
        if len(lines[i].split())==8:
            new_line = f'{lines[i].split()[0]} {lines[i].split()[3]}_{lines[i].split()[1]}_{lines[i].split()[4]}  {lines[i].split()[2]} {lines[i].split()[3]} {lines[i].split()[4]} {lines[i].split()[5]}  {lines[i].split()[6]}   {lines[i].split()[7]}     \n'

    else:
        new_line = lines[i]
        
    new_lines.append(new_line)


# Write new file with new lines
new_file = []

for i,line in enumerate(lines):
    
    if i<start_line:
        new_file.append(line)
    
    if i==start_line:
        for j in new_lines:
            new_file.append(j)
    
    if i>end_line:
        new_file.append(line)


assert len(new_file)==len(lines), f'The output file was not the same length as the original molecule_0.itp file. There is a problem somewhere.'
    

with open(file,'w') as f:
    
    for line in new_file:
        f.write(line)

print(f'Changed protein beadtype names in {file}.\n')
