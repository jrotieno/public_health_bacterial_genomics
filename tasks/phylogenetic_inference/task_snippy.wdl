version 1.0

task snippy_pe {
  input {
    File reference
    File read1
    File read2
    String samplename
    String docker = "staphb/snippy:4.6.0"
    Int cpus = 4
    Int memory = 8
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
    --R1 ~{read1} \
    --R2 ~{read2} \
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
    String snippy_version = read_string("VERSION")
    File snippy_aligned_fasta = "~{samplename}/~{samplename}.aligned.fa"
    File snippy_bam = "~{samplename}/~{samplename}.bam"
    File snippy_bai = "~{samplename}/~{samplename}.bam.bai"
    File snippy_bed = "~{samplename}/~{samplename}.bed"
    File snippy_consensus_fasta = "~{samplename}/~{samplename}.consensus.fa"
    File snippy_subs_fasta = "~{samplename}/~{samplename}.consensus.subs.fa"
    File snippy_csv = "~{samplename}/~{samplename}.csv"
    File snippy_filtered_vcf = "~{samplename}/~{samplename}.filt.vcf"
    File snippy_gff = "~{samplename}/~{samplename}.gff"
    File snippy_html_report = "~{samplename}/~{samplename}.html"
    File snippy_log = "~{samplename}/~{samplename}.log"
    File snippy_raw_vcf = "~{samplename}/~{samplename}.raw.vcf"
    File snippy_subs_vcf = "~{samplename}/~{samplename}.subs.vcf"
    File snippy_tsv = "~{samplename}/~{samplename}.tab"
    File snippy_txt = "~{samplename}/~{samplename}.txt"
    File snippy_vcf = "~{samplename}/~{samplename}.vcf"
    File snippy_vcf_gz = "~{samplename}/~{samplename}.vcf.gz"
    File snippy_vcf_gz_csi = "~{samplename}/~{samplename}.vcf.gz.csi"
  }
  runtime {
      docker: "~{docker}"
      memory: "~{memory}"
      cpu: "~{cpus}"
      disks: "local-disk 100 SSD"
      preemptible: 0
  }
}