version 1.0

task snippy_core {
	input {
		Array[File] read1
		Array[File]? read2
		Array[String] samplename
		String docker_image = "quay.io/staphb/ksnp3:3.1"
		Int memory = 8
		Int cpu = 4
		Int disk_size = 100
		File reference
	}
	command <<<
	read1s_array=(~{sep=' ' read1})
	read2s_array=(~{sep=' ' read2})
	read1s_array_len=$(echo "${#read1s_array[@]}")
	read2s_array_len=$(echo "${#read2s_array[@]}")
	samplename_array=(~{sep=' ' samplename})
	samplename_array_len=$(echo "${#samplename_array[@]}")
	
	# Ensure reads, and samplename arrays are of equal length
	if [ "$read1s_array_len" -ne "$samplename_array_len" ]; then
		echo "Reads array (length: $read1s_array_len) and samplename array (length: $samplename_array_len) are of unequal length." >&2
		exit 1
	fi

	# create file of filenames for kSNP3 input
	touch isolates.tab
	if [ -z "${read2}" ]; then
		for index in ${!read1s_array[@]}; do
			read1=${read1s_array[$index]}
			samplename=${samplename_array[$index]}
			echo -e "${samplename}\t${read1}" >> isolates.tab
		done
	else
		for index in ${!read1s_array[@]}; do
			read1=${read1s_array[$index]}
			read2=${read1s_array[$index]}
			samplename=${samplename_array[$index]}
			echo -e "${samplename}\t${read1}\t${read2}" >> isolates.tab
		done
	fi

	# prep snippy-multi script
	snippy-multi isolates.tab --ref ~{reference}
	# print snippy-multi script to stdout
	cat runme.sh
	# run snippy-multi script
	sh runme.sh

	# collect individual sample snippy outputs
	mkdir snippy_out
	for index in ${!samplename_array[@]}; do
		samplename=${samplename_array[$index]}
		mv ${samplename} snippy_out/
	done
	# zip snippy outs
	zip -r snippy_out.zip snippy_out

	>>>
	output {
		File snippy_core_alignment = "core.aln"
		File snippy_core_full_alignment = "core.full.aln"
		File snippy_core_ref = "core.ref.fa"
		File snippy_core_tab = "core.tab"
		File snippy_core_txt = "core.txt"
		File snippy_core_vcf = "core.vcf"
		File snippy_out = "snippy_out.zip"
		String snippy_core_docker_image = docker_image
	}
	runtime {
		docker: docker_image
		memory: "~{memory} GB"
		cpu: cpu
		disks: "local-disk ~{disk_size} SSD"
		preemptible: 0
		maxRetries: 3
	}
}
