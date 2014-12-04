


## renames the OTUs by the cluster names that were previously generated. 

## usage: python Renaming_sequences_in_alignment_for_phylogenetic_tree.py renaming_file alignment_file renamed_alignment
#renaming_fasta_file="../data/table_to_rename_sequence_data_for_readable_tree.txt"
#alignment_file= "../data/Alignments/NBCI_with_Culley_env_95_with_454_data_trimalled_no_colons.fasta"
#renamed_alignment_file= "../data/Alignments/NBCI_with_Culley_env_95_with_454_data_trimalled_no_colons_renamed.fasta"


import sys

renaming_fasta_file=sys.argv[1]
alignment_file= sys.argv[2]
renamed_alignment_file= sys.argv[3]



fasta_renames = open(renaming_fasta_file, 'r')
fasta=open(alignment_file, 'r')

rename_dict = {}
for line in fasta_renames:
    fields = line.split("\t")
    Name_for_tree = fields[0]
   # print Name_for_tree
    fasta_name=fields[1]
    rename_dict[fasta_name]=[Name_for_tree]
    
     
alignment_with_original_names = open(alignment_file, 'r')
alignment_renamed = open(renamed_alignment_file, 'w')
for line in alignment_with_original_names:
    if line.startswith('>'):
        newline=line.strip()
        sequence_name = str(newline[1:])
       # print sequence_name
        if sequence_name in rename_dict.keys():
        #print rename_dict[sequence_name]
	        new_sequence_name = ">" + str(rename_dict[sequence_name])[2:-2] + "\n"
           #     print new_sequence_name
                alignment_renamed.write(new_sequence_name)
        else:
            #write regular name   
            alignment_renamed.write(line)   
    else:
        #write the rest of the lines
        alignment_renamed.write(line)

