# FUNCTIONS
point_score = function(locus,radius=500000,M, pseudocount=0.1){
  l_edge = max((locus - radius),1)
  r_edge = min((locus + radius),nrow(M))
  l_mask = M[,l_edge:locus]
  r_mask = M[,locus:r_edge]
  center_mask = M[l_edge:locus,locus:r_edge]
  score = (max(mean(l_mask,na.rm=T),mean(r_mask,na.rm=T)) +  pseudocount) / (mean(center_mask) +  pseudocount)
  return(score)
}

region_score = function(M,resolution=8192,radius=500000 ,pseudocount=0.1){
  M = as.matrix(M)
  pixel_radius = ceiling(radius/resolution)
  scores = unlist(lapply(1:nrow(M),point_score,radius=pixel_radius,M=M,pseudocount=pseudocount))
  return(scores)
}

compute_scores = function(prediction_file,inpdir,window=2097152,resolution=8192,radius=500000){
  # Data reading
  coord = gsub(x=prediction_file,pattern = ".npy",replacement = "")
  chr_start=unlist(strsplit(coord,"_"))
  outfile= paste0("contact_maps_",coord,".pdf")
  m_pred <- as.data.frame(np$load(file.path(inpdir,prediction_file)))
  rscl = abs(min(m_pred))
  m_pred = m_pred+rscl
  
  # HiC values
  preds = m_pred[upper.tri(m_pred, diag = F)]
  
  # Insulation values
  prediction_scores = region_score(M=m_pred,resolution=resolution,radius=radius,pseudocount=pseudocount)
  
  # Bin coordinates
  n_bins=nrow(m_pred)
  resolution=window/(n_bins)
  chr=chr_start[1]
  start=as.numeric(chr_start[2])
  end=start+window-1
  start_seq = seq(start,end,resolution)
  end_seq = seq(start_seq[2]-1,end,resolution)
  
  return(list(chr=rep(chr,n_bins),start=start_seq,end=end_seq,
              pred_scores=prediction_scores,
              window=rep(coord,n_bins)))
}

make_scores_bed = function(results,inpdir){
  chr=vector(mode = "character")
  start=vector(mode = "numeric")
  end=vector(mode = "numeric")
  pred_scores=vector(mode = "numeric")
  window=vector(mode = "character")
  
  for(i in 1:length(results)){
    xi=results[[i]]
    for(j in 1:length(xi)){
      xij=unlist(xi[j])
      if(j==1){ chr = c(chr,xij) }
      if(j==2){ start = c(start,xij) }
      if(j==3){ end = c(end,xij) }
      if(j==4){ pred_scores = c(pred_scores,xij) }
      if(j==5){ window = c(window,xij) }
    }
  }
  pred_scores_bed = data.frame(chr=chr,start=start,end=end,score=pred_scores,window=window,stringsAsFactors = F)
  write.csv(pred_scores_bed,file.path(inpdir,"prediction_scores.csv"),row.names = F)
}

compute_scores_parallel = function(sample_name,n_cores=6){
  print(sample_name)
  
  inpdir = file.path(wd,sample_name,"prediction/npy/")
  print(inpdir)
  prediction_files = list.files(inpdir,pattern = ".npy")
  prediction_files = prediction_files[grep("_target.npy",prediction_files,invert = T)]
  if(length(prediction_files) != n_windows){ print(paste0("WARNING: ",sample_name)," does not have ",n_windows," matrices.") }
  
  results = mclapply(prediction_files,compute_scores,inpdir=inpdir,window=window,mc.cores = n_cores)
  make_scores_bed(results,inpdir=inpdir)
}

main = function(n_cores=6){
  lapply(sample_names,compute_scores_parallel,n_cores=n_cores)
}


### RUN #########################
library(reticulate)
library(parallel)
np <- import("numpy")

wd="/gpfs/data/abl/home/rodrij92/PROJECTS/TCGA_PanCancer/train_model/train/C.Origami_analysis/prediction_allChr_TCGA/"
window=2097152
n_windows=1359		# genome_size(chr1:chr22 + chrX) / window
resolution=8192		# 2097152 / 256
radius=500000		# insulation param
pseudocount=0.1
n_cores=12

sample_names = list.dirs(wd,full.names = F,recursive = F)
main(n_cores=n_cores)
