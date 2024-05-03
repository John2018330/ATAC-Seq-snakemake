args<- commandArgs(trailingOnly=TRUE)

annotation_file <- args[1]
outdir <- args[2]

anno = read.table(annotation_file, sep="\t", header=T, quote="")
#anno = read.table('results/homer/ATACpeaks_noBlacklist_annotated.bed', 
#                  sep="\t", header=T, quote="")

pietable = table(unlist(lapply(strsplit(as.character(anno$Annotation), " \\("),"[[",1))) #take the part before first ' ('

newtable = table(c("3' UTR","5' UTR","exon","Intergenic","intron","promoter-TSS","TTS"))
newtable[names(newtable)] = 0 #reset everything to 0
newtable[names(pietable)] = pietable

names(newtable) = paste(names(newtable), "(", round(newtable/sum(newtable)*100), "%, ", newtable, ")", sep="")
png(file.path(outdir, "regions_pie_chart.png"), 
    width=700, height=600, units="px")
pie(newtable, main="mypeaks annotation")
dev.off()