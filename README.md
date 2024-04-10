# BF528 Final Project: ATAC-Seq snakemake workflow
Author: Johnathan Zhang

## Project Proposal
This section contain a short project proposal that outlines 
(1) the bioinformatics workflow for processing ATAC-Seq data from (...), and
(2) a list of questions that this analyses will address and the project deliverables.


### Methods
Raw sequencing reads for the study's two ATAC-Seq replicates can be obtained from GEO accession (...).
To perform quality assessment, [FastQC v(...)]() was used to inspect a number of quality metrics for each fastq file.
[Trimmomatic v(...)]() was used in (paired-end/single-end) mode to quality filter and remove remaining adapter sequence from raw sequencing files.
To perform read mapping, human genome reference GRChg38 was first indexed using [Bowtie2 v(...)]() `build` with default parameters.
Using the index, post-trimmomatic sequencing reads were aligned to the reference using Bowtie2 and the `-X 2000` flag to increase max fragment length and enhance signal capture.
[Samtools v(...)]() `flagstat` generated a report on each replicate alignment's quality, and these reports were combined with the FastQC reports with [MultiQC v(...)]() to generate a concatenated quality assessment report.
Alignment files were sorted using Samtools `sort` and then filtered to remove any reads that aligned to the mitochondrial chromosome using Samtools `view`.
To deal with tagmentation, [DeepTools v(...)]() `alignmentSieve` was used to filter alignments (_elaborate..._)
To perform quality control on the fragment distribution sizes, Bioconductor package [ATACSeqQC v(...)]() in [R v(...)]() was used to generate a quality assessment report.
Peak calling was performed using [MACS3 v(3..)]() with default parameters for each replicate.
[BedTools v(...)]() `intersect` with flags `-r (..)` was used to generate a list of reproducible peaks, and to remove blacklisted regions.
[HOMER v(...)]() `annotatePeaks` was used to annotate peaks with Gencode's v45 human reference annotation file (gtf).
HOMER `findMotifsGenome.pl` performed motif analysis to analyze and present any recurring motifs in open chromatin regions.
Gene enrichment analysis on annotated peaks was performed using Bioconductor package [fGSEA v(...)](). 
R was used to generate a figure for deliverable #8

### Deliverables
1. Produce a fragment length distribution plot for each of the samples

2. Produce a table of how many alignments for each sample before and after filtering alignments falling on the mitochondrial chromosome

3. Create a signal coverage plot centered on the TSS (plotProfile) for the nucleosome-free regions (NFR) and the nucleosome-bound regions (NBR)

- You may consider fragments (<100bp) to be those from the NFR and the rest as the NBR.
4. A table containing the number of peaks called in each replicate, and the number of reproducible peaks

5. A single BED file containing the reproducible peaks you determined from the experiment.

6. Perform motif finding on your reproducible peaks
- Create a single table / figure with the most interesting results

7. Perform a gene enrichment analysis on the annotated peaks using a well-validated gene enrichment tool
- Create a single table / figure with the most interesting results

8. Produce a figure that displays the proportions of regions that appear to have accessible chromatin called as a peak (Promoter, Intergenic, Intron, Exon, TTS, etc.)


## Misc Notes
Filter mitochondrial chr reads:
`samtools view -o sorted_no_chrM.bam -e 'rname != "chrM"' sorted_bam.bam`


