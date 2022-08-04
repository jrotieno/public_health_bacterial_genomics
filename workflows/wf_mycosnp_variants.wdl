version 1.0

import "../tasks/phylogenetic_inference/task_mycosnp_variants.wdl" as mycosnp_nf
import "../tasks/task_versioning.wdl" as versioning

workflow mycosnp_consensus_assembly {
  meta {
    description: "A WDL wrapper around the qc, processing and consensus assembly components of mycosnp-nf, for whole genome sequencing analysis of fungal organisms, including Candida auris."
  }
  input {
    File    read1
    File    read2
    String  samplename
  }
  call mycosnp_nf.mycosnp_varaints {
    input:
      read1 = read1,
      read2 = read2,
      samplename = samplename
  }
  call versioning.version_capture{
    input:
  }
  output {
    #Version Captures
    String mycosnp_consensus_assembly_version = version_capture.phbg_version
    String mycosnp_consensus_assembly_analysis_date = version_capture.date
    #MycoSNP QC and Assembly
    String mycosnp_version = mycosnp_varaints.mycosnp_version
    String mycosnp_docker = mycosnp_varaints.mycosnp_docker
    String analysis_date = mycosnp_varaints.analysis_date
    String reference_strain = mycosnp_varaints.reference_strain
    String reference_accession = mycosnp_varaints.reference_accession
    Int read_raw = mycosnp_varaints.read_raw
    Float gc_raw = mycosnp_varaints.gc_raw
    Float phred_raw = mycosnp_varaints.phred_raw
    Float coverage_raw = mycosnp_varaints.coverage_raw
    Int read_clean = mycosnp_varaints.read_clean
    Int read_pairs_clean = mycosnp_varaints.read_pairs_clean
    Int read_unpaired_clean = mycosnp_varaints.read_unpaired_clean
    Float gc_clean = mycosnp_varaints.gc_clean
    Float phred_clean = mycosnp_varaints.phred_clean
    Float coverage_clean = mycosnp_varaints.coverage_clean
    Float mean_coverage_depth = mycosnp_varaints.mean_coverage_depth
    Int reads_mapped = mycosnp_varaints.reads_mapped
    Int number_n = mycosnp_varaints.number_n
    Float percent_reference_coverage = mycosnp_varaints.percent_reference_coverage
    Int assembly_size = mycosnp_varaints.assembly_size
    Int consensus_n_variant_min_depth = mycosnp_varaints.consensus_n_variant_min_depth
    File vcf = mycosnp_varaints.vcf
    File vcf_index = mycosnp_varaints.vcf_index
    File multiqc = mycosnp_varaints.multiqc
    File full_results = mycosnp_varaints.full_results
  }
}
