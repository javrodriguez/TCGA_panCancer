#!/bin/bash
#SBATCH -J procPredScores
#SBATCH --mem=20gb 
#SBATCH --time=48:00:00 
#SBATCH -c 12 
#SBATCH --output=logs-process_prediction_scores/%J.out
#SBATCH --error=logs-process_prediction_scores/%J.err

module load python/cpu/3.8.11
module load r/4.1.2
Rscript process_prediction_scores_tcga.R
