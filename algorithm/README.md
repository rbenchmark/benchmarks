# Algorithms

Data mining algorithms implemented by different ways.

## ICA - Independent Component Analysis
Algorithms are based on FastICA R package http://cran.r-project.org/web/packages/fastICA/

 - ica.R: directly using fastICA package interface
 - ica_lapplyR: Using lapply based iterative algorithm 

## kmeans

 - k-means.R: Using R built-in function.
 - k-means_lapply.R: Using lapply based iterative algorithm
 - k-means_vec.R standard iterative algorithm with vector programming
 - k-means-1D*.R: the corresponding k-means for 1D samples

## k-NN

 - NN.R: Using R built-in knn1
 - NN.lapply: Using lapply based algorithm
 - k-NN.R: Using R built-in knn
 - k-NN_lapply: Using lapply based algorithm

# LogitRegression - Logistic Regression

 - LogitRegre_lapply: Using lapply based iterative algorithm
 - LogitRegre2_lapply: Using lapply based iterative algorithm from SparkR project
 - LogitRegre-1var*.R: the corresponding algorithms for 1 variable analysis

## LR - Linear Regression

 - LR.R Using built-in lm function
 - LR_lms_lapply.R: LMS(least mean square) lapply based iterative algorithm
 - LR_ols_lapply.R: LS(Ordinary Least Squares) lapply based direct method
 - LR-1var*.R: the corresponding algorithms for 1 variable analysis

## PCA - Principle Component Analysis

  - PCA_lapply.R: Standard direct method based lapply

## Pi - Calculating Pi with monte-carlo method

  - Pi_lapply.R: Standard monte-carlo method based on lapply
  
