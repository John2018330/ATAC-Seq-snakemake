# BF528 Final Project: ATAC-Seq snakemake workflow
Author: Johnathan Zhang

**View final report in** `final_report/final_report.html`

## Project Proposal
This section contain a short project proposal that outlines 
(1) the bioinformatics workflow for processing ATAC-Seq data from [this article](https://www.nature.com/articles/nmeth.2688), and
(2) a list of questions that this analyses will address and the project deliverables.


### Methods
#### Raw Sequence Processing
Raw sequencing reads for the study's two ATAC-Seq replicates (rep3, rep4) can be obtained from GEO accession [GSE47753](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE47753).
To perform quality assessment of raw sequencing reads, [FastQC v(...)]() was used to inspect a number of quality metrics for each fastq file.
[Trimmomatic v(...)]() was used in paired-end mode to quality filter and remove remaining adapter sequence (NexteraPE-PE.fasta) from raw sequencing files.
Custom Trimmomatic flags included `LEADING:3, TRAILING:3, SLIDINGWINDOW:4:15, ILLUMINACLILP:2:30:10`.
Unpaired reads were discarded.

To perform read mapping, human genome reference GRChg38 was first indexed using [Bowtie2 v(...)]() `build` with default parameters.
Using the index, post-trimmomatic sequencing reads were aligned to the reference using Bowtie2 and the `-X 2000` flag to increase max fragment length and enhance signal capture.
[Samtools v(...)]() `flagstat` generated a report on each replicate alignment's quality, and these reports were combined with the FastQC reports with [MultiQC v(...)]() to generate a concatenated quality assessment report.
Alignment files were sorted using Samtools `sort` and indexed using Samtools `index`.
Reads that mapped to mitochondrial genome were removed for downstream analyses.

#### Peak Calling and Motif Analysis
To deal with tagmentation, [DeepTools v(...)]() `alignmentSieve` was used with flags `--ATACshift` to filter alignments and shift them corresponding to the 9-bp duplication created by Tn5 transposase.
To perform quality control and generate a plot on fragment distribution sizes, Bioconductor package [ATACSeqQC v(...)]() in a custom R script [R v(...)]() was used on the bams containing all fragment sizes.
Peak calling was performed using [MACS3 v(3..)]() with default parameters for each replicate.
[BedTools v(...)]() `intersect` with flags `-r (0.5)` was used to generate a list of reproducible peaks, and to remove blacklisted regions.
[HOMER v(...)]() `annotatePeaks` was used to annotate peaks with Gencode's v45 human reference annotation file (gtf), and `findMotifsGenome` was used to perform motif analysis..

#### Signal Coverage
To generate signal coverage plots of nucleosome free regions (NFR) and nucleosome bound regions (mono-nucleosomes, di-nucleosome), `alignmentSieve` was also run with flags `--minFragmentLenght` and `--maxFragmentLength` with varying values. 
For NFR, the maximum length was set to 100.
For mononucleosomes, the basepair range of fragments was [180,247].
For dinucleosomes, the basepair range of fragments was [315,473].
All produced bams were re-sorted and re-indexed using Samtools.
Each pair of bams (replicate 3, replicate 4) was combined using Deeptools `bamCompare` with flags `--operation mean --normalizeUsing RPKM --scaleFactorsMethod None -bs 10`. 
This specifies the bams to be normalized by RPKM to account for differences in sequencing depth and to take the average signal for a bin size of 10.
After merging bams, Deeptools `computeMatrix reference-point` was used to generate a signal coverage matrix of gene regions (hg38 downloaded from UCSC refseq table browser).
Regions 1000 basepairs up and down stream of the center point were analyzed using the `-a` and `-b` flags.
The matrix was used to generate a signal coverage plot using Deeptools `plot_profile`.

#### Gene Enrichment
Gene enrichment analysis on annotated peaks was performed using (Enrichr? David? GREAT?)
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

Deliverable #1: Fragment size distribution graph [here](https://bioconductor.org/packages/devel/bioc/vignettes/ATACseqQC/inst/doc/ATACseqQC.html#Fragment_size_distribution)

Deliveralbe #7: Gene enrichment analysis: http://great.stanford.edu/public/html/


