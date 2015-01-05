
## Script to get original names of OTUs for use in uploading to NCBI. 

import sys
file1=sys.argv[1]
file2=sys.argv[2]
file3=sys.argv[3]
file4=sys.argv[4]


from Bio import SeqIO
from Bio.SeqIO.FastaIO import FastaWriter

alignable_protein_OTUs = SeqIO.parse(file1, "fasta")
protein_OTUs_original_name = SeqIO.parse(file2, "fasta")
nucleotide_OTUs_original_name = SeqIO.parse(file3, "fasta")

alignable_protein_seq_list=[]
for record in alignable_protein_OTUs:
    alignable_protein_seq_list.append(str(record.seq))

original_protein_seq_list=[]
for record in protein_OTUs_original_name:
    original_protein_seq_list.append(str(record.seq))


alignable_set = set(alignable_protein_seq_list)
original_protein_set = set(original_protein_seq_list)

# ## find ids that are in both alignable and original
matching_seqs = alignable_set.intersection(original_protein_set)


protein_OTUs_original_name = SeqIO.parse(file2, "fasta")

## need to get the ids
alignable_with_original_name={}
for seq in matching_seqs:
	 protein_OTUs_original_name

alignable_with_original_name={}
for record in protein_OTUs_original_name:
	#print record
	for seq in matching_seqs:
		#print seq
		if seq == str(record.seq):
			print 'yes'
			alignable_with_original_name[record.id]=seq



alignable_original_names=alignable_with_original_name.keys()

alignable_nucleotide_seqs={}
for record in nucleotide_OTUs_original_name:
    split_id=record.id.split(";")[0] 
    print split_id
    for alignable_ids in alignable_original_names:
     if split_id == alignable_ids.split(";")[0]:
        alignable_nucleotide_seqs[split_id]=str(record.seq)	


print alignable_nucleotide_seqs

## get original name back on it...

alignable_protein_OTUs = SeqIO.parse(file1, "fasta")
protein_OTUs_original_name = SeqIO.parse(file2, "fasta")

#make new dict
reverse_dict_OTU={}
for record in alignable_protein_OTUs:
    reverse_dict_OTU[str(record.seq)]= record.id

reverse_dict_protein_name={}
for record in protein_OTUs_original_name:
    reverse_dict_protein_name[str(record.seq)]= record.id


pair_of_header_names={}
for seq, header in reverse_dict_OTU.iteritems():
	for seq_original, header_original in reverse_dict_protein_name.iteritems():
		if seq == seq_original:
			pair_of_header_names[header_original]=header


alignable_nuc_seqs_with_otu_name={}
for key, value in alignable_nucleotide_seqs.iteritems():
	for header_id, otu_id in pair_of_header_names.iteritems():
		header_id= header_id.split(";")[0] 
		if header_id == key:
			alignable_nuc_seqs_with_otu_name[otu_id]=value

nuc_with_otu_name=open(file4, 'w')
nuc_with_otu_name.close() 
nuc_with_otu_name=open(file4, 'a')


for key, value in alignable_nuc_seqs_with_otu_name.iteritems():
    print value
    nuc_with_otu_name.write(">" + key + '\n')
    nuc_with_otu_name.write(value + '\n')

nuc_with_otu_name.close()
