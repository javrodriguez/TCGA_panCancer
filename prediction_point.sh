#!/bin/bash
#SBATCH -J predPoint
#SBATCH --mem=4gb 
#SBATCH --time=1:00:00 
#SBATCH --output=logs-prediction-point/%J.log
#SBATCH --error=logs-prediction-point/%J.out

model=$1
seq=$2
outdir=$3
sample=$4
atac=$5
ctcf=$6

chr=$(awk "NR==${SLURM_ARRAY_TASK_ID} {print \$1}" target_points.txt)
start=$(awk "NR==${SLURM_ARRAY_TASK_ID} {print \$2}" target_points.txt)

source /gpfs/home/rodrij92/home_abl/miniconda3/etc/profile.d/conda.sh
conda activate corigami_analysis

sleep 5
corigami-predict --out ${outdir} --celltype ${sample} --chr ${chr} --start ${start} --model ${model} --seq ${seq} --ctcf ${ctcf} --atac ${atac}
