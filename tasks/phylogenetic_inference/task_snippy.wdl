version 1.0

task snippy_pe {
  input {
    File reference
    File read1
    File? read2
    String? query_gene
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
    if [ -z "~{read2}" ]; then
      snippy \
      --reference ~{reference} \
      --outdir ~{samplename} \
      --se ~{read1} \
      --cpus ~{cpus} \
      --ram ~{memory} \
      --prefix ~{samplename} \
      --mapqual ~{map_quality} \
      --basequal ~{base_quality} \
      --mincov ~{min_coverage} \
      --minfrac ~{min_fraction} \
      --minqual ~{min_quality} \
      --maxsoft ~{max_soft_clip}
    else
      snippy \
      --reference ~{reference} \
      --outdir ~{samplename} \
      --R1 ~{read1} \
      --R2 ~{read2} \
      --cpus ~{cpus} \
      --ram ~{memory} \
      --prefix ~{samplename} \
      --mapqual ~{map_quality} \
      --basequal ~{base_quality} \
      --mincov ~{min_coverage} \
      --minfrac ~{min_fraction} \
      --minqual ~{min_quality} \
      --maxsoft ~{max_soft_clip}
    fi
    # parse gene-specific outputs from snpd.vcf
    head -n 1 ./test_gbfull/snps.tab > ./gene_query.tsv
    grep ponA1 ./test_gbfull/snps.tab >> ./gene_query.tsv
    grep ~{query_gene} ~{samplename}/snps.tab | tee GENE_QUERY

  >>>
  output {
    String snippy_version = read_string("VERSION")
    String snippy_gene_query = read_string("GENE_QUERY")
    File snippy_gene_query_file = "./gene_query.tsv"
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
      memory: "~{memory} GB"
      cpu: "~{cpus}"
      disks: "local-disk 100 SSD"
      preemptible: 0
  }
}