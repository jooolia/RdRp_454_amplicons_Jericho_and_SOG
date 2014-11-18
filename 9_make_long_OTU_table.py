#!/usr/bin/env python

## Make long OTU table using the mapping output file from the qiime denoiser and from the OTUs
## picked from usearch. 
## Author: Julia Gustavsen (j.gustavsen@gmail.com )
## Notes: Using 95% identity as discussed in the paper. 



denoiser_mapping = "../data/reverse/denoiser_mapping.txt"

# has the library info
denoiser_fasta = "../data/reverse/denoised_seqs.fasta"

uclust_OTUs_fasta = "../results/usearch/95identity/RdRp_OTUs_95identity.fasta"

Uclust_uc = "../results/usearch/95identity/RdRp_OTUs_95identity.uc"



 ## HEADER ID, OTU_ID, Abundance 
uclust = open(Uclust_uc, 'r')
OTUDictionary_reformat = {}
for line in uclust:

    fields = line.split()
    otu_id = fields[1]

    name_and_size = fields[8].split(";") #split description so I can get at the number of occurrences
    OTU_name = name_and_size[0]
    OTU_abun = name_and_size[1].split("=")[1] #get rid of the "size" part of this.
    centroid_id = otu_id, OTU_abun
    OTUDictionary_reformat[OTU_name] = centroid_id 
     
print OTUDictionary_reformat


## Want to find centroid from OTUfile in denoiser_mapping_test and then expand to fill in 
## all the sequences in that OTU id, so make file of seq ids by OTU.
## For each line the first ID should match a centroid so IDs[0] should match an id in 
## the OTUfile.  
mapper = open(denoiser_mapping, 'r')
mapperID =[]
for eachline in mapper:
    IDs = eachline.split()
    IDs = IDs[0].strip(":")
   # print IDs
    mapperID.append(IDs)
print "mapperIDs as a list"
print mapperID

## Need to find which ones of these are in the uclust file and then use the mapper to id the the
## lib names back in the denoiser.fasta file


## Pull out IDs from denoiser that have made it through the process up the the uclust 

Denoiser_ID_in_uclust_output={}
for id_in_map_file in mapperID:
    #print id_in_map_file
    for key, value in OTUDictionary_reformat.iteritems():
      #  print key
        if id_in_map_file == key:
            # so found denoiser ids that are in the uclust file. 
            # now need to map those ids to other ones in the file and give them an OTU_id
            # use the Header id and the OTU id 
            Denoiser_ID_in_uclust_output[key] = value[0]


## Need to add the OTU_ids to the denoiser

# Map the denoiser reads that are in uclust to the denoiser mapping file, then get the lib id from the fasta flie
#use id and the map all the other ids in that....

mapper = open(denoiser_mapping, 'r')

denoiser_id_from_mapping_with_uclust_OTU_id={}
for eachline in mapper:
    IDs = eachline.split()
    seed_IDs = IDs[0].strip(":")
    # all the other ids
    mapped_IDs = IDs[1:len(IDs)]
    for key, value in Denoiser_ID_in_uclust_output.iteritems():
        if seed_IDs == key:
            denoiser_id_from_mapping_with_uclust_OTU_id[seed_IDs] = value
            # now to add the OTU id to each of the headers in the denoiser mapping file
            for iterate_through_mapped_ids in mapped_IDs:
                denoiser_id_from_mapping_with_uclust_OTU_id[iterate_through_mapped_ids] = value
            # so then want to print each matching value with the OTUid and the header


## now match it to the fasta headers in the denoiser.fasta
from Bio import SeqIO
denoiser_records = SeqIO.parse(open(denoiser_fasta,"rU"), "fasta")

from progress.bar import Bar
# want to see that the script is running.


lib_id_with_denoiser_header_and_OTU_number={}
bar = Bar('Processing', max=len(mapperID))
i=0
#pbar = ProgressBar(widgets=[Percentage(), Bar()], maxval=len(denoiser_mapping).start()
for denoiser_record in denoiser_records:
    bar.next()
    #print denoiser_record.description
    descrption_split = denoiser_record.description.split()
    denoiser_record_header_id = descrption_split[1]
   # print denoiser_record_header_id
    lib_id = denoiser_record.id.split("_")[0]
    #print lib_id
    for key, value in denoiser_id_from_mapping_with_uclust_OTU_id.iteritems():
	if denoiser_record_header_id == key:
            #make new dict with record id, lib and OTU number. Will then summarise afterwards
	    lib_id_with_denoiser_header_and_OTU_number[denoiser_record_header_id]=(lib_id, value)
	    
bar.finish()	

import csv
fp = file('../results/usearch/95identity/RdRp_OTUs_long_OTU_table.csv', 'wb')
w = csv.writer(fp, delimiter='\t')

for key, value in lib_id_with_denoiser_header_and_OTU_number.iteritems():
    Row = key, value[0], value[1]
   # print Row
    w.writerow(Row)

fp.close()
