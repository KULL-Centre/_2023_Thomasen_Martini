import sys

topfile="rubberbands_all_PRO.top"
outfile="dihedrals_rubberbands_all_PRO.top"

protein = str(sys.argv[1])

#List of start and stop atoms of domain borders
#Given in the form [domain 1 start-atom, domain 1 stop-atom, domain 2 start-atom, domain 2 stop-atom]
protein_domain_bounds = {'TIA1':[10, 187, 214, 400, 444, 645],
        'hnRNPA1':[23, 207, 244, 425],
        'hSUMO_hnRNPA1':[95, 270, 299, 481, 509, 701],
        'THB_C2':[1, 98, 116, 320],
        'Ubq2':[32, 190, 198, 356],
        'Ubq3':[1, 159, 167, 325, 333, 491],
        'Ubq4':[1, 159, 167, 325, 333, 491, 499, 657],
        'Gal-3':[251, 564],
        'mTurq_GS0_mNeon':[1, 534, 595, 1123],
        'mTurq_GS8_mNeon':[1, 534, 619, 1147],
        'mTurq_GS16_mNeon':[1, 534, 643, 1171],
        'mTurq_GS24_mNeon':[1, 534, 667, 1195],
        'mTurq_GS32_mNeon':[1, 534, 691, 1219],
        'mTurq_GS48_mNeon':[1, 534, 739, 1267]
       }

start_stop_atoms = protein_domain_bounds[protein]
nr_domains = int(len(start_stop_atoms)/2)

with open(topfile, 'r') as f:
    toplines = f.readlines()

def angles_to_keep_domain(atom_start, atom_stop, toplines, start_line, end_line):

    lines_to_keep = []

    for line in toplines[start_line:end_line]:
        linesplit = line.split()

        if int(linesplit[0]) >= int(atom_start) and int(linesplit[0]) <= int(atom_stop) and int(linesplit[1]) >= int(atom_start) and int(linesplit[1]) <= int(atom_stop) and int(linesplit[2]) >= int(atom_start) and int(linesplit[2]) <= int(atom_stop):
            lines_to_keep.append(line)
    return lines_to_keep

def dihedrals_to_keep_domain(atom_start, atom_stop, toplines, start_line, end_line):

    lines_to_keep = []

    for line in toplines[start_line:end_line]:
        linesplit = line.split()

        if int(linesplit[0]) >= int(atom_start) and int(linesplit[0]) <= int(atom_stop) and int(linesplit[1]) >= int(atom_start) and int(linesplit[1]) <= int(atom_stop) and int(linesplit[2]) >= int(atom_start) and int(linesplit[2]) <= int(atom_stop) and int(linesplit[3]) >= int(atom_start) and int(linesplit[3]) <= int(atom_stop):
            lines_to_keep.append(line)
    return lines_to_keep

for i in range(len(toplines)):
    if '; SC-BB-BB and BB-BB-SC scFix' in toplines[i]:
        start_line_SCBBBB_BBBBSC = int(i+1)
        break
        
for i in range(len(toplines)):
    if ';' in toplines[i] and 'BB-BB' not in toplines[i] and i>start_line_SCBBBB_BBBBSC:
        end_line_SCBBBB_BBBBSC = int(i-1)
        break
        
print("SC-BB-BB and BB-BB-SC scFix are from line %s to line %s in %s" % (start_line_SCBBBB_BBBBSC, end_line_SCBBBB_BBBBSC, topfile))

for i in range(len(toplines)):
    if '; SC-BB-BB-SC scFix' in toplines[i]:
        start_line_SCBBBBSC = int(i+1)
        break
        
for i in range(len(toplines)):
    if '[' in toplines[i] and i>start_line_SCBBBBSC and 'BB-BB' not in toplines[i]:
        end_line_SCBBBBSC = int(i-1)
        break
        
print("SC-BB-BB-SC scFix are from line %s to line %s in %s" % (start_line_SCBBBBSC, end_line_SCBBBBSC, topfile))

with open(outfile, 'w') as f:

    #Write topology before scFix stuff
    for line in toplines[:start_line_SCBBBB_BBBBSC]:
        f.write(line)

    #Get scFix angles to keep and append write to file
    j=0
    for i in range(nr_domains):
        print("Writing scFix angles for domain %i from atom %i to %i" % (i+1, start_stop_atoms[j], start_stop_atoms[j+1]))
        angles = angles_to_keep_domain(start_stop_atoms[j], start_stop_atoms[j+1], toplines, start_line_SCBBBB_BBBBSC, end_line_SCBBBB_BBBBSC)
        for line in angles:
            f.write(line)

        j+=2

    #Write topology from scFix angles to scFix dihedrals 
    for line in toplines[end_line_SCBBBB_BBBBSC:start_line_SCBBBBSC]:
        f.write(line)
    
    #Get scFix dihedrals to keep and write to file
    j=0
    for i in range(nr_domains):
        print("Writing scFix dihedrals for domain %i from atom %i to %i" % (i+1, start_stop_atoms[j], start_stop_atoms[j+1]))
        dihedrals = dihedrals_to_keep_domain(start_stop_atoms[j], start_stop_atoms[j+1], toplines, start_line_SCBBBBSC, end_line_SCBBBBSC)
        for line in dihedrals:
            f.write(line)
        j+=2

    #Write rest of topology
    for line in toplines[end_line_SCBBBBSC:]:
        f.write(line)
