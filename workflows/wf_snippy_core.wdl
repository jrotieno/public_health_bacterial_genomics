version 1.0

import "../tasks/phylogenetic_inference/task_snippy_core.wdl" as snippy_core
import "../tasks/task_versioning.wdl" as versioning

workflow snippy_core_wf {
  input {
    Array[File] read1
    Array[File] read2
    Array[String] samplename
    File reference
    }
    call snippy_core.snippy_core as snippy_core_task {
        input:
            read1 = read1,
            read2 = read2,
            samplename = samplename,
            reference = reference
  }
  call versioning.version_capture{
    input:
  }
  output {
    # Version Capture
    String snippy_core_wf_version = version_capture.phbg_version
    String snippy_core_wf_analysis_date = version_capture.date
    # snippy_core_outputs
    File snippy_core_alignment = snippy_core_task.snippy_core_alignment
    File snippy_core_full_alignment = snippy_core_task.snippy_core_full_alignment
    File snippy_core_ref = snippy_core_task.snippy_core_ref
    File snippy_core_tab = snippy_core_task.snippy_core_tab
    File snippy_core_txt = snippy_core_task.snippy_core_txt
    File snippy_core_vcf = snippy_core_task.snippy_core_vcf
    File snippy_out = snippy_core_task.snippy_out
    String snippy_core_docker_image = snippy_core_task.snippy_core_docker_image
  }
}