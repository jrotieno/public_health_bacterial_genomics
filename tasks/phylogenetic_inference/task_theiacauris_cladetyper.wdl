version 1.0

task theiacauris_cladetyper {
  input {
    File assembly_fasta
    String samplename
    String cluster_name
    Int kmer_size = 19
    String docker_image = "quay.io/staphb/ksnp3:3.1"
    Int memory = 8
    Int cpu = 4
    Int disk_size = 100
    File ref_clade1 = "gs://theiagen-public-files/terra/candida_auris_refs/Cauris_Clade_I_reference.fasta"
    File ref_clade2 = "gs://theiagen-public-files/terra/candida_auris_refs/Cauris_Clade_II_reference.fasta"
    File ref_clade3 = "gs://theiagen-public-files/terra/candida_auris_refs/Cauris_Clade_III_reference.fasta"
    File ref_clade4 = "gs://theiagen-public-files/terra/candida_auris_refs/Cauris_Clade_IV_reference.fasta"
    File ref_clade5 = "gs://theiagen-public-files/terra/candida_auris_refs/Cauris_Clade_V_reference.fasta"
    File ref_other = "gs://theiagen-public-files/terra/candida_auris_refs/candida_auris_B11221_PGLS01000001.1.fasta"
  }
  command <<<
    
    touch ksnp3_input.tsv
    echo -e "~{ref_clade1}\tref_clade1" >> ksnp3_input.tsv
    echo -e "~{ref_clade2}\tref_clade2" >> ksnp3_input.tsv
    echo -e "~{ref_clade3}\tref_clade3" >> ksnp3_input.tsv
    echo -e "~{ref_clade4}\tref_clade4" >> ksnp3_input.tsv
    echo -e "~{ref_clade5}\tref_clade5" >> ksnp3_input.tsv
    echo -e "~{ref_other}\tref_other" >> ksnp3_input.tsv
    echo -e "~{assembly_fasta}\t~{samplename}">> ksnp3_input.tsv


    kSNP3 -in ksnp3_input.tsv -outdir ksnp3 -k ~{kmer_size} -core -vcf
    
    # rename ksnp3 outputs with cluster name 
    mv ksnp3/core_SNPs_matrix.fasta ~{cluster_name}_core_SNPs_matrix.fasta
    mv ksnp3/tree.core.tre ~{cluster_name}_core.tree
    mv ksnp3/VCF.*.vcf ~{cluster_name}_core.vcf
        
      #Find and return min value col header of ~{cluster_name}.tsv
      
  >>>
  output {
    File ksnp3_matrix = "${cluster_name}_core_SNPs_matrix.fasta"
    File ksnp3_tree = "${cluster_name}_core.tree"
    File ksnp3_vcf = "${cluster_name}_core.vcf"
    String ksnp3_docker_image = docker_image
  }
  runtime {
    docker: docker_image
    memory: "~{memory} GB"
    cpu: cpu
    disks: "local-disk 100 SSD"
    preemptible: 0
  }
}
