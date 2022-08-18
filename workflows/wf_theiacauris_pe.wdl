version 1.0

import "../tasks/phylogenetic_inference/task_theiacauris_cladetyper.wdl" as ksnp3
import "../tasks/phylogenetic_inference/task_snp_dists2.wdl" as snp_dists
import "../tasks/task_versioning.wdl" as versioning

workflow theiacauris_pe {
  input {
    File assembly_fasta
    String samplename
  }
  call ksnp3.theiacauris_cladetyper as cladetyper_task {
    input:
      assembly_fasta = assembly_fasta,
      samplename = samplename
  }
  call snp_dists.snp_dists {
    input:
      cluster_name = samplename,
      alignment = cladetyper_task.cladetyper_matrix
  }
  call versioning.version_capture{
    input:
  }
  output {
    String theiacauris_pe_wf_version = version_capture.phbg_version
    String theiacauris_pe_wf_analysis_date = version_capture.date
    File theiacauris_pe_snp_matrix = snp_dists.snp_matrix
    File theiacauris_top_match = snp_dists.top_match_clade
    File theiacauris_pe_tree = cladetyper_task.cladetyper_tree
    String theiacauris_pe_docker = cladetyper_task.cladetyper_docker_image
  }
}