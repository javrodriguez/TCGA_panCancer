#!/bin/bash
#SBATCH -J makeMatrix
#SBATCH --mem=40gb 
#SBATCH --time=48:00:00 
#SBATCH -c 6
#SBATCH --output=logs-make_matrix/%J.out
#SBATCH --error=logs-make_matrix/%J.err

module load r/4.1.2
Rscript make_matrix_prediction_scores_tcga.R
