# Ibnat_Prediction_Assignment-1
Regression Model Comparison for Predicting Earnings Per Hour


# **Prediction Assignment 1 - Regression Model Comparison**

## **Overview**
This project aims to build and compare multiple regression models to predict **hourly earnings (w)** using a dataset of actors, dancers, and musicians. The models progressively increase in complexity by adding different predictors. The evaluation criteria include **Root Mean Squared Error (RMSE), Cross-Validated RMSE, and Bayesian Information Criterion (BIC)**.

## **Files in this Repository**
- `Ibnat_Prediction_Assignment-1 Coding.R` - The R script containing all the regression models and analysis.
- `Ibnat_Prediction_Assignment_1.pdf` - The final report summarizing findings and model performance.
- `morg-2014-emp.csv` - The dataset used for analysis (if allowed to be included).
- `Rplot_BIC Comparison Across Models.png`, `Rplot_Cross-Validated RMSE Across Models.png`, `Rplot_RMSE Comparison Across Models.png` - Graphs visualizing model performance.

## **Regression Models Used**
1. Model 1 (Baseline) - Predicts hourly earnings using **age**.
   ```math
   𝑤 = β0 + β1 𝐴𝑔𝑒 + ε
   ```
2. Model 2 (+ Gender)** - Adds **gender** as a predictor.
   ```math
   𝑤 = β0 + β1 𝐴𝑔𝑒 + β2 𝑓𝑒𝑚𝑎𝑙𝑒 + ε
   ```
3. Model 3 (+ Education & Work Hours)** - Includes **education level and weekly work hours**.
   ```math
   𝑤 = β0 + β1 𝐴𝑔𝑒 + β2 𝑓𝑒𝑚𝑎𝑙𝑒 + β3 𝑔𝑟𝑎𝑑𝑒92 + β4 𝑢ℎ𝑜𝑢𝑟𝑠 + ε
   ```
4. Model 4 (+ Non-Linearity & Interaction)** - Introduces **age² and interaction between gender and age.
   ```math
 𝑤 = β0 + β1 𝐴𝑔𝑒 + β2 𝑓𝑒𝑚𝑎𝑙𝑒 + β3 𝑔𝑟𝑎𝑑𝑒92 + β4 𝑢ℎ𝑜𝑢𝑟𝑠 + β5 𝑎𝑔𝑒^2 + β6 𝑓𝑒𝑚𝑎𝑙𝑒 * 𝑎𝑔𝑒 + ε
   ```

## **Model Performance Comparison**
| Model  | RMSE (Full Sample) | Cross-Validated RMSE | BIC |
|--------|-------------------|----------------------|-----|
| Model 1 | 25.150 | 25.150 | 998.479 |
| Model 2 | 25.114 | 25.114 | 1002.838 |
| Model 3 | 24.046 | 24.046 | 1002.946 |
| Model 4 | 23.580 | 23.580 | 1008.125 |

## Key Findings
- As model complexity increases, RMSE decreases**, meaning prediction accuracy improves.
- Model 4 has the lowest RMSE but the highest BIC**, suggesting possible overfitting.
- Model 3 provides the best trade-off**, balancing accuracy and complexity.
- The **bias-variance tradeoff is evident:
  - Model 1 is too simple (high bias).
  - Model 4 is too complex (high variance).
  - Model 3 is the most balanced choice.

## How to Run the Code
1. Load the required libraries in R:
   ```r
   library(tidyverse)
   library(ggplot2)
   library(Metrics)
   library(boot)
   ```
2. Load the dataset:
   ```r
   data <- read_csv("morg-2014-emp.csv")
   ```
3. Run the script `Ibnat_Prediction_Assignment-1 Coding.R` to execute the regression models.
4. Visualize model performance using RMSE, BIC, and Cross-validation graphs.

## Contact & Contributions
For any questions or improvements, feel free to open an **issue** or submit a **pull request**.

Prepared by: Nahian Ibnat

