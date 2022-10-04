version 1.0

task snippy_pe {
  input {
    File reference
    File read1_cleaned
    File read2_cleaned
    String samplename
    String docker = "staphb/snippy:4.6.0"
    Int cpus = 4
    Int memory = 8
    String? subsample_ratio
    Int map_quality = 60
    Int base_quality = 13
    Int min_coverage = 10
    Float min_fraction = 0
    Int min_quality = 100
    Int max_soft_clip = 10

  }
  command <<<
    snippy --version | head -1 | tee VERSION
    snippy \
    --reference ~{reference} \ #Supports FASTA, GenBank, EMBL (not GFF)
    --R1 ~{read1_cleaned} \
    --R2 ~{read2_cleaned} \
    --cpus ~{cpus} \
    --ram ~{memory} \
    --prefix ~{samplename} \
    --mapqual ~{map_quality} \ #Minimum read mapping quality to consider (default '60')
    --basequal ~{base_quality} \ #Minimum base quality to consider (default '13')
    --mincov ~{min_coverage} \ #Minimum site depth to for calling alleles (default '10')
    --minfrac ~{min_fraction} \ #Minumum proportion for variant evidence (0=AUTO) (default '0')
    --minqual ~{min_quality} \ #Minumum QUALITY in VCF column 6 (default '100')
    --maxsoft ~{max_soft_clip} #Maximum soft clipping to allow (default '10')


  >>>
  output {
	  File assembly_fasta = "out/~{samplename}_contigs.fasta"
	  File contigs_gfa = "out/~{samplename}_contigs.gfa"
    String shovill_version = read_string("VERSION")
  }
  runtime {
      docker: "~{docker}"
      memory: "16 GB"
      cpu: 4
      disks: "local-disk 100 SSD"
      preemptible: 0
  }
}

task shovill_se {
  input {
    File read1_cleaned
    String samplename
    String docker = "quay.io/staphb/shovill-se:1.1.0"
    Int min_contig_length = 200
  }
  command <<<
    shovill-se --version | head -1 | tee VERSION
    shovill-se \
    --outdir out \
    --se ~{read1_cleaned} 
    --minlen ~{min_contig_length}
    mv out/contigs.fa out/~{samplename}_contigs.fasta
    mv out/contigs.gfa out/~{samplename}_contigs.gfa
  >>>
  output {
	  File assembly_fasta = "out/~{samplename}_contigs.fasta"
	  File contigs_gfa = "out/~{samplename}_contigs.gfa"
    String shovill_version = read_string("VERSION")
  }
  runtime {
      docker: "~{docker}"
      memory: "16 GB"
      cpu: 4
      disks: "local-disk 100 SSD"
      preemptible: 0
  }
}