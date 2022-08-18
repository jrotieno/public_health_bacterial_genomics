version 1.0

task theiacauris_cladetyper {
  input {
    File assembly_fasta
    String samplename
    Int kmer_size = 19
    String docker_image = "quay.io/staphb/ksnp3:3.1"
    Int memory = 8
    Int cpu = 4
    Int disk_size = 100
    File ref_clade1 = "gs://theiagen-public-files/terra/candida_auris_refs/Cauris_Clade_I_reference.fasta"
    String ref_clade1_name = "ref_clade1"
    File ref_clade2 = "gs://theiagen-public-files/terra/candida_auris_refs/Cauris_Clade_II_reference.fasta"
    String ref_clade2_name = "ref_clade2"
    File ref_clade3 = "gs://theiagen-public-files/terra/candida_auris_refs/Cauris_Clade_III_reference.fasta"
    String ref_clade3_name = "ref_clade3"
    File ref_clade4 = "gs://theiagen-public-files/terra/candida_auris_refs/Cauris_Clade_IV_reference.fasta"
    String ref_clade4_name = "ref_clade4"
    File ref_clade5 = "gs://theiagen-public-files/terra/candida_auris_refs/Cauris_Clade_V_reference.fasta"
    String ref_clade5_name = "ref_clade5"
    File ref_other = "gs://theiagen-public-files/terra/candida_auris_refs/candida_auris_B11221_PGLS01000001.1.fasta"
    String ref_other_name = "ref_other"
  }
  command <<<
    
    touch ksnp3_input.tsv
    echo -e "~{ref_clade1}\t~{ref_clade1_name}" >> ksnp3_input.tsv
    echo -e "~{ref_clade2}\t~{ref_clade2_name}" >> ksnp3_input.tsv
    echo -e "~{ref_clade3}\t~{ref_clade3_name}" >> ksnp3_input.tsv
    echo -e "~{ref_clade4}\t~{ref_clade4_name}" >> ksnp3_input.tsv
    echo -e "~{ref_clade5}\t~{ref_clade5_name}" >> ksnp3_input.tsv
    echo -e "~{ref_other}\t~{ref_other_name}" >> ksnp3_input.tsv
    echo -e "~{assembly_fasta}\t~{samplename}">> ksnp3_input.tsv
    cat ksnp3_input.tsv

    kSNP3 -in ksnp3_input.tsv -outdir ksnp3 -k ~{kmer_size}
    
    # rename ksnp3 outputs with cluster name 
    mv ksnp3/core_SNPs_matrix.fasta ~{samplename}_SNPs_matrix.fasta
    mv ksnp3/tree.core.tre ~{samplename}.tree
        
      #Find and return min value col header of ~{cluster_name}.tsv
      
  >>>
  output {
    File cladetyper_matrix = "${samplename}_SNPs_matrix.fasta"
    File cladetyper_tree = "${samplename}.tree"
    String cladetyper_docker_image = docker_image
  }
  runtime {
    docker: docker_image
    memory: "~{memory} GB"
    cpu: cpu
    disks: "local-disk 100 SSD"
    preemptible: 0
  }
}
