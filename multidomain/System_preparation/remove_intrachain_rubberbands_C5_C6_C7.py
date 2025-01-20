#Topology file with rubberbands
topfile = 'dihedrals_rubberbands_all_PRO.top'

#Output topology with modified rubberbands
outfile = 'dihedrals_rubberbands_all_PRO.top'

#List of start and stop atoms of domain borders
#Given in the form [chain 1 start-atom, chain 1 stop-atom, chain 2 start-atom, chain 2 stop-atom]
start_stop_atoms = [110,191]

#Make list of atoms to remove
list_atoms = list(range(start_stop_atoms[0],start_stop_atoms[1]+1))

#Read topfile as lines and write the original again (the other file will be overwritten 
with open(topfile, 'r') as f:
    toplines = f.readlines()
    
with open('dihedrals_rubberbands_before_removing_intrachain_bands_all_PRO.top', 'w') as f:
    for line in toplines:
        f.write(line)

#Find the index range of the rubberband list
for i in range(len(toplines)):
    if '; Rubber band' in toplines[i]:
        start_line = int(i+1)
        break

for i in range(len(toplines)):
    if ';' in toplines[i] and i>start_line:
        end_line = int(i-1)
        break

#Only write rubberbands if lines DO NOT contain atoms within the intrachain-linker      

new_rubberbands=[]
removed_elements=0

for i in range(start_line,end_line):
    if int(toplines[i].split()[0]) in list_atoms or int(toplines[i].split()[1]) in list_atoms:
        removed_elements+=1
        continue
    else:
        new_rubberbands.append(toplines[i])

#Write new topfile
new_toplines = []

for i in range(start_line):
    new_toplines.append(toplines[i])
for line in new_rubberbands:
    new_toplines.append(line)
for i in range(end_line,len(toplines)):
    new_toplines.append(toplines[i])
    
assert len(toplines)==len(new_toplines)+removed_elements

with open(outfile, 'w') as f:
    for line in new_toplines:
        f.write(line)
        
print(f'\nRemoved rubberbands for atom {start_stop_atoms[0]} to atom {start_stop_atoms[1]}\n')
