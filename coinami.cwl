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
  threads:
    type: int
    doc: "Number of threads"

outputs:
  output:
    type: File
    doc: "Final output after removing duplicates"
    outputSource: alignment_4/rmdup
  indexed_output:
    type: File
    doc: "Index of final output"
    outputSource: alignment_5/index

steps:
  alignment_1:
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

  alignment_2:
    run: samtools-view.cwl
    in:
      input: alignment_1/output
      output_name: 
        default: "output.bam"
    out: [output]

  alignment_3:
    run: samtools-sort.cwl
    in:
      input: alignment_2/output
      output_name: 
        default: "output.sorted"
      threads:
        source: threads
    out: [sorted]

  alignment_4:
    run: samtools-rmdup.cwl
    in:
      input: alignment_3/sorted
      output_name: 
        default: "output.rmdup.bam"
    out: [rmdup]

  alignment_5:
    run: samtools-index.cwl
    in:
      input: alignment_4/rmdup
    out: [index]

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