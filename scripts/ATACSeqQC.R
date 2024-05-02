library(ATACseqQC)

args<- commandArgs(trailingOnly=TRUE)

bamfile_path <- args[1]
outPath <- args[2]

bamfile_labels <- gsub("_all_sieved_sorted.bam", "", basename(bamfile_path))


#par(mar=c(1,1,1,1))
png(file.path(outPath, paste0(bamfile_labels, "_frag_size_dist.png")), 
    width=700, height=600, units="px")
fragSize <- fragSizeDist(bamfile_path, bamFiles.labels = bamfile_labels)
dev.off()
