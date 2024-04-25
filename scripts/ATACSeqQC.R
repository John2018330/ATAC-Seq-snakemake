library(ATACseqQC)

args<- commandArgs(trailingOnly=TRUE)

bamfile_path <- args[1]
outPath <- args[2]

bamfile_labels <- gsub("_sieved_sorted.bam", "", basename(bamfile_path))

pdf(file.path(outPath, paste0(bamfile_labels, ".fragment.size.distribution.pdf")),
    width =10, height=8) 
fragSize <- fragSizeDist(bamfile_path, bamFiles.labels = bamfile_labels)
dev.off()