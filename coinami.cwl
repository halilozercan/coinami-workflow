#!/usr/bin/env cwl-runner
class: Workflow
cwlVersion: v1.0

label: "Coinami"

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  reference:
    type: File
    doc: "Reference file to start processing"
  reads_1:
    type: File
    doc: "First strand reads from Illumina Sequence"
  reads_2:
    type: File
    doc: "Second strand reads from Illumina Sequence"
  output_loc:
    type: string
    doc: "Location to write final compressed result"
  threads:
    type: int
    doc: "Number of threads"

outputs:
  zipped_output:
    type: File
    doc: "Final zipped output"
    outputSource: zip/output

steps:
  bwa_mem_alignment:
    run: bwa-mem.cwl
    in:
      reference: 
        source: reference
      reads: [reads_1, reads_2]
      output_filename:
        default: "output.sam"
      threads:
        source: threads
    out: [output]

  samtools_view:
    run: samtools-view.cwl
    in:
      input: bwa_mem_alignment/output
      output_name: 
        default: "output.bam"
    out: [output]

  samtools_sort:
    run: samtools-sort.cwl
    in:
      input: samtools_view/output
      output_name: 
        default: "output.sorted"
      threads:
        source: threads
    out: [sorted]

  picard_markdump:
    run: picard.cwl
    in:
      inputFileName_markDups: samtools_sort/sorted
      metricsFile:
        default: metrics.txt
      outputFileName_markDups: 
        default: "output.markdump.bam"
    out: [markDups_output]

  samtools_index:
    run: samtools-index.cwl
    in:
      input: picard_markdump/markDups_output
    out: [index]

  zip:
    run: zip.cwl
    in:
      files: [samtools_index/index, picard_markdump/markDups_output]
      zipFileName: 
        source: output_loc
    out: [output]

$namespaces:
  s: http://schema.org/

$schemas:
- http://schema.org/docs/schema_org_rdfa.html

s:downloadUrl: https://github.com/halilozercan/coinami-workflow/blob/master/coinami.cwl
s:codeRepository: https://github.com/halilozercan/coinami-workflow

s:author:
  class: s:Person
  s:name: Halil Ozercan
  s:email: mailto:halil.ozercan@bilkent.edu.tr

doc: |
  Coinami is designed and developed by a small group in Bilkent University
