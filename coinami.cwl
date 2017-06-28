#!/usr/bin/env cwl-runner
class: Workflow
cwlVersion: v1.0

label: "Hello World"
doc: "Coinami Read Mapping Workflow to run on client machine"

requirements:
  - class: SubworkflowFeatureRequirement

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

outputs:
  indexed_output:
    type: File
    doc: "Ultimate output which should be sent to Employer"
    outputSource: alignment_5/index

steps:
  indexing_ref_sam:
    run: workflows/tools/samtools-faidx.cwl
    in:
      input: reference
    out: [index]

  indexing_ref_bwa:
    run: workflows/tools/bwa-index.cwl
    in:
      algorithm: bwtsw
      sequences: reference
    outputs: [output]

  alignment_1:
    run: workflows/tools/bwa-mem.cwl
    in:
      reference: reference
      reads: [reads_1, reads_2]
      output_filename: output.sam
    out: [output]

  alignment_2:
    run: workflows/tools/samtools-view.cwl
    in:
      isBam: true
      input: alignment_1/output
      output_name: output.bam
    out: [output]

  alignment_3:
    run: workflows/tools/samtools-sort.cwl
    in:
      input: alignment_2/output
      output_name: output.sorted
    out: [sorted]

  alignment_4:
    run: workflows/tools/samtools-rmdup.cwl
    in:
      input: alignment_3/sorted
      output_name: output.rmdup.bam
    out: [rmdup]

  alignment_5:
    run: workflows/tools/samtools-index.cwl
    in:
      input: alignment_4/rmdup
    out: [index]

s:downloadUrl: https://github.com/halilozercan/coinami-workflow/blob/master/coinami.cwl
s:codeRepository: https://github.com/halilozercan/coinami-workflow

s:author:
  class: s:Person
  s:name: Halil Ozercan
  s:email: mailto:halil.ozercan@bilkent.edu.tr
  s:worksFor:
  - class: s:University
    s:name: Bilkent University
    s:location: Cankaya, Ankara, 06800
    s:department:
    - class: s:University
      s:name: Institute of Science and Engineering
doc: |
  Coinami is designed and developed by a small group in Bilkent University