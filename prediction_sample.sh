#!/bin/bash
#SBATCH -J predSample
#SBATCH --mem=1gb 
#SBATCH --time=4:00:00 
#SBATCH --output=logs-prediction-sample/%J.log
#SBATCH --error=logs-prediction-sample/%J.out

model=$1
seq=$2
outdir=$3

sample=$(awk "NR==${SLURM_ARRAY_TASK_ID} {print \$1}" sample_sheet.txt)
atac=$(awk "NR==${SLURM_ARRAY_TASK_ID} {print \$2}" sample_sheet.txt)
ctcf=$(awk "NR==${SLURM_ARRAY_TASK_ID} {print \$3}" sample_sheet.txt)

n_points=`cat target_points.txt | wc -l`

sleep 5
sbatch --array=1-$n_points prediction_point.sh ${model} ${seq} ${outdir} ${sample} ${atac} ${ctcf}
