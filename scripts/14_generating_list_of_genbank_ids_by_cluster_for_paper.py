
## Author: Julia Gustavsen
## Description: Use this script to attach genbank accession numbers associated with the OTUs from environmental sequences. 
## Uses the output .uc file from uclust to assign Genbank numbers to a cluster. Generates the clusters and accession numbers found in the methods section. 
## Usage: python 14_generating_list_of_genbank_ids_by_cluster_for_paper.py uc_file.uc groups_of_clusters.tsv


import sys

file=sys.argv[1]
cluster_out_file=sys.argv[2]

uclust = open(file, 'r')

OTUDictionary = {}
for otu_id in uclust:
    fields = otu_id.split()
    otu_id = fields[1]
    if fields[0] == 'S': #add query to dictionary as new sequence
        OTUDictionary[otu_id] = [fields[8]]  
    elif fields[0] == 'H': #add hit to match list
        OTUDictionary[otu_id].append(fields[8]) 
print OTUDictionary,
          
	
	
cluster_out=cluster_out_file

for (cluster, name) in OTUDictionary.iteritems():
    print cluster
    print str(name)	
    with open(cluster_out, "a") as f:
         print ('Contact %s at %s' % (cluster, str(name)))
         f.write(cluster + "\t")
         f.write(str(name) + "\n")
		 
		 
		 
