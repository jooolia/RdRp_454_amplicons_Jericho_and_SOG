## what is the purpose of this file?
## renames the OTUs by the cluster names that were previously generated. 
cluster_names_file="../data/Cluster_names_by_OTUs.txt"
fasta_file= "../data/centroids_95_longer_than_75aa_and_greater_than_5_occurences.fasta"
new_fasta_file= "../data/OTUs_95_longer_than_75aa_and_greater_than_5_occurences.fasta"


cluster_names = open(cluster_names_file, 'r')
fasta=open(fasta_file, 'r')

#~ for line in x
	#~ if line[2] matches value[0:10] in Dictionary.items() 
		#~ replace line with value[0:10] + /n
	

cluster_names_dict = {}
for line in cluster_names:
    line=line.strip()
    fields = line.split("	")
    OTU_number= fields[0]
    #cutting because this had "size" after the identifier"
    fasta_header_part=fields[1][0:14]
    cluster_names_dict[fasta_header_part]=[OTU_number]
    
    #print cluster_names_dict
    
fasta_with_qiime_names = open(fasta_file, 'r')
output_with_OTUs = open(new_fasta_file, 'w')
for line in fasta_with_qiime_names:
    if line.startswith('>'):
        sequence_name = line.split(';')[0]
	sequence_name = sequence_name[1:]
	print sequence_name
        if sequence_name in cluster_names_dict.keys():
            print cluster_names_dict[sequence_name]
	    # the [2:-2] gets rid of the dictionary remnants
	    print str(cluster_names_dict[sequence_name])[2:-2]
            new_sequence_name = ">" + str(cluster_names_dict[sequence_name])[2:-2] + "\n"
           # print new_sequence_name
            output_with_OTUs.write(new_sequence_name)
        else:
            #write regular name   
            output_with_OTUs.write(line)   
    else:
        output_with_OTUs.write(line)


