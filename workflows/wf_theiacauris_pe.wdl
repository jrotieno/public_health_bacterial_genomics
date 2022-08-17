version 1.0

import "../tasks/phylogenetic_inference/task_theiacauris_cladetyper.wdl" as ksnp3
import "../tasks/phylogenetic_inference/task_snp_dists2.wdl" as snp_dists
import "../tasks/task_versioning.wdl" as versioning

workflow theiacauris_pe {
  input {
    File assembly_fasta
    String samplename
    String cluster_name
  }
  call ksnp3.ksnp3 as ksnp3_task {
    input:
      assembly_fasta = assembly_fasta,
      samplename = samplename,
      cluster_name = cluster_name
  }
  call snp_dists.snp_dists {
    input:
      cluster_name = cluster_name,
      alignment = ksnp3_task.ksnp3_matrix
  }
  call versioning.version_capture{
    input:
  }
  output {
    String theiacauris_pe_wf_version = version_capture.phbg_version
    String theiacauris_pe_wf_analysis_date = version_capture.date

    File theiacauris_pe_snp_matrix = snp_dists.snp_matrix
    File theiacauris_top_match = snp_dists.top_match_clade
    File theiacauris_pe_tree = ksnp3_task.ksnp3_tree
    File theiacauris_pe_vcf = ksnp3_task.ksnp3_vcf
    String theiacauris_pe_docker = ksnp3_task.ksnp3_docker_image
  }
}