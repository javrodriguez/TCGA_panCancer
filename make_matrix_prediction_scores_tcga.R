# FUNCTIONS 
preprocess_matrix = function(file,wd,branch,centrotelo,n_cores){
  #file=files[1]
  sample_name = gsub(x=file,pattern = wd, replacement = "")
  sample_name = gsub(x=sample_name,pattern = branch, replacement = "")
  sample_name = gsub(x=sample_name,pattern = "/", replacement = "")
  
  x=read.csv(file,stringsAsFactors = F)
  x.gr=makeGRangesFromDataFrame(x)
  ovl=as.data.frame(findOverlaps(x.gr,centrotelo))
  x=x[-ovl$queryHits,]
  x$id=paste(x$chr,x$start,x$end,sep=":")
  x=x[,c("id","score")]
  x$score=round(x$score,3)
  names(x)[2]=sample_name
  return(x)
}

library("preprocessCore")
library("GenomicRanges")
library("parallel")

wd="/Users/javrodher/Work/RStudio-PRJs/TCGA_PanCan/data/train_model/prediction_allChr_TCGA/"
branch="/prediction/npy/prediction_scores.csv"
sample_sheet_file = "/Users/javrodher/Work/RStudio-PRJs/TCGA_PanCan/data/tcga_atac/gdc_sample_sheet.2024-01-10.tsv"
fileName="prediction_scores.csv"
centrotelo_file="/Users/javrodher/Work/biodata/data-repo-hicbench/genomes/hg38/centrotelo.bed"
n_cores=6

centrotelo = read.delim(centrotelo_file,col.names = c("chr","start","end"),stringsAsFactors = F)
centrotelo = makeGRangesFromDataFrame(centrotelo)
files = list.files(wd,pattern = fileName,recursive = T,full.names = T)

M= mclapply(files,preprocess_matrix,wd=wd,branch=branch,centrotelo=centrotelo,mc.cores = n_cores)
M = Reduce(function(x, y) merge(x, y, by="id"), M)
write.csv(M,"matrix_allChr_TCGA.csv",row.names = F)
