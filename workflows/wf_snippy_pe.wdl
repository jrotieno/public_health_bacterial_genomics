version 1.0

import "../tasks/phylogenetic_inference/task_snippy.wdl" as snippy
import "../tasks/task_versioning.wdl" as versioning

workflow snippy_pe_wf {
  meta {
    description: "Perform SNP analysis using snippy"
  }
  input {
    File reference
    File read1
    File? read2
    String samplename
  }
  call snippy.snippy_pe {
    input:
      samplename = samplename,
      read1 = read1,
      read2 = read2,
      reference = reference
  }
  call versioning.version_capture{
    input:
  }
  output {
    String snippy_wf_version = version_capture.phbg_version
    String snippy_version = snippy_pe.snippy_version
    String snippy_gene_query = snippy_pe.snippy_gene_query
    File snippy_aligned_fasta = snippy_pe.snippy_aligned_fasta
    File snippy_bam = snippy_pe.snippy_bam
    File snippy_bai = snippy_pe.snippy_bai
    File snippy_bed = snippy_pe.snippy_bed
    File snippy_consensus_fasta = snippy_pe.snippy_consensus_fasta
    File snippy_subs_fasta = snippy_pe.snippy_subs_fasta
    File snippy_csv = snippy_pe.snippy_csv
    File snippy_filtered_vcf = snippy_pe.snippy_filtered_vcf
    File snippy_gff = snippy_pe.snippy_gff
    File snippy_html_report = snippy_pe.snippy_html_report
    File snippy_log = snippy_pe.snippy_log
    File snippy_raw_vcf = snippy_pe.snippy_raw_vcf
    File snippy_subs_vcf = snippy_pe.snippy_subs_vcf
    File snippy_tsv = snippy_pe.snippy_tsv
    File snippy_txt = snippy_pe.snippy_txt
    File snippy_vcf = snippy_pe.snippy_vcf
    File snippy_vcf_gz = snippy_pe.snippy_vcf_gz
    File snippy_vcf_gz_csi = snippy_pe.snippy_vcf_gz_csi
  }
}
