version 1.0

task cauris_cladetyper {
  input {
    File assembly_fasta
    String samplename
    Int kmer_size = 19
    String docker_image = "quay.io/biocontainers/hesslab-gambit:0.5.1--py37h8902056_0"
    Int memory = 16
    Int cpu = 8
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
  }
  command <<<
    # date and version control
    date | tee DATE
    gambit --version | tee VERSION

    gambit signatures create -o my-signatures.h5 -k 11 -p ATGAC ~{ref_clade1} ~{ref_clade2} ~{ref_clade3} ~{ref_clade4} ~{ref_clade5} ~{assembly_fasta}
    gambit dist --qs my-signatures.h5 --square -o ~{samplename}_matrix.csv
    
    cat ~{samplename}_matrix.csv | sort -k7 -t ',' | head -3 | tail -1 | rev | cut -d '/' -f1 | rev | cut -d ',' -f1 | cut -d '_' -f3 | tee CLADETYPE
    
    if [ $CLADETYPE="I" ]
    then
    echo Clade1 | tee CLADETYPE
    fi
    if [ $CLADETYPE="II" ]
    then
    echo Clade2 | tee CLADETYPE
    fi
    if [ $CLADETYPE="III" ]
    then
    echo Clade3 | tee CLADETYPE
    fi
    if [ $CLADETYPE="IV" ]
    then
    echo Clade4 | tee CLADETYPE
    fi
    if [ $CLADETYPE="V" ]
    then
    echo Clade5 | tee CLADETYPE
    fi
    
  >>>
  output {
    String gambit_cladetype = read_string("CLADETYPE")
    String date = read_string("DATE")
    String version = read_string("VERSION")
    String gambit_cladetyper_docker_image = docker_image
  }
  runtime {
    docker: docker_image
    memory: "~{memory} GB"
    cpu: cpu
    disks: "local-disk 100 SSD"
    preemptible: 0
  }
}
