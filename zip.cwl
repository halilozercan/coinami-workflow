cwlVersion: v1.0
class: CommandLineTool
baseCommand: zip

requirements:

  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing: $(inputs.srcFiles)

inputs:

  zipFileName:
    type: string
    inputBinding:
      position: 1
  
  junk:
    type: boolean
    default: true
    inputBinding:
      prefix: -j
      position: 0

  files:
    type: File[]
    inputBinding:
      separate: false
      position: 2

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.zipFileName)
