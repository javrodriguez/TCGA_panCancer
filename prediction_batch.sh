#!/bin/bash
#SBATCH -J predBatch
#SBATCH --mem=1gb 
#SBATCH --time=4:00:00 
#SBATCH --output=logs-prediction-batch/%J.log
#SBATCH --error=logs-prediction-batch/%J.out

sample_sheet=/gpfs/data/abl/home/rodrij92/PROJECTS/TCGA_PanCancer/train_model/train/C.Origami_analysis/sample_atac_ctcf.txt
model=/gpfs/data/abl/home/rodrij92/PROJECTS/TCGA_PanCancer/train_model/train/C.Origami/checkpoints_k562_v2/models/epoch=40-step=12218.ckpt
target_points=/gpfs/data/abl/home/rodrij92/PROJECTS/TCGA_PanCancer/train_model/train/C.Origami_analysis/chr10_startPos_w2097152.txt
seq=/gpfs/data/abl/home/rodrij92/PROJECTS/TCGA_PanCancer/train_model/train/C.Origami/data/hg38/dna_sequence/
outdir="prediction_chr10_TCGA"

cp $sample_sheet sample_sheet.txt
cp $target_points target_points.txt

#n_samples=`cat sample_sheet.txt| wc -l`

#sbatch --array=1-50 prediction_sample.sh ${model} ${seq} ${outdir}
#sleep 600
#sbatch --array=51-100 prediction_sample.sh ${model} ${seq} ${outdir}
#sleep 600
#sbatch --array=101-150 prediction_sample.sh ${model} ${seq} ${outdir}
#sleep 600
#sbatch --array=151-200 prediction_sample.sh ${model} ${seq} ${outdir}
#sleep 600
sbatch --array=201-250 prediction_sample.sh ${model} ${seq} ${outdir}
sleep 600
sbatch --array=251-300 prediction_sample.sh ${model} ${seq} ${outdir}
sleep 600
sbatch --array=301-350 prediction_sample.sh ${model} ${seq} ${outdir}
sleep 600
sbatch --array=351-400 prediction_sample.sh ${model} ${seq} ${outdir}
sleep 600
sbatch --array=401-409 prediction_sample.sh ${model} ${seq} ${outdir}
