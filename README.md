This repository hosts necessary tools for Coinami to work on miners. 

**Dockerfile**: Generate the docker image by building this file. Generated image includes rabix/bunny, bwa and samtools. Also, coinami workflow consisting of all cwl files represented in this repository.

**coinami.cwl**: Defines the workflow of Coinami in Common Workflow Language. Docker container uses rabix to execute this workflow.

**coinami.json**: Parameters for workflow. By changing these parameters, one can run same alignment procedure used by Coinami to align any set of reads against a reference genome.

## Docker Image

Includes 3 different volumes: input, output, reference.

- We recommend to place reads and customized coinami.json file inside input volume.
- Output volume is designated output folder for rabix. Rabix executor bunny caches and also outputs its result into this directory.
- Reference volume is seperated from input directory for convenience.

