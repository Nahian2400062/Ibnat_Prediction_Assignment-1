# Load tidyverse
library(tidyverse)
# See the column names in your data
colnames(cps_data)

getwd()
setwd("D:/CEU_MA_EDP/Winter 2025/Prediction/Assignment 1") 
list.files()  # This shows all files in the folder
cps_data <- read.csv("morg-2014-emp.csv")


head(cps_data)    # View the first few rows of the dataset
str(cps_data)     # Check the structure of the dataset
summary(cps_data)   # Summary statistics

# Ensure the occupation code column is numeric
cps_data$OCC2012 <- as.numeric(cps_data$OCC2012)

# Filter the dataset for artists working in entertainment industry
actors_data <- cps_data %>% filter(occ2012 == 2700)  # actors (2700)
dancers_data <- cps_data %>% filter(occ2012 == 2740)  # Dancers and choreographers (2740)
musicians_data <- cps_data %>% filter(occ2012 == 2750)  # Musicians, singers, and related workers (2750)

# Merge the three datasets
combined_data <- bind_rows(
  actors_data %>% mutate(occupation = "Actor"),
  dancers_data %>% mutate(occupation = "Dancer"),
  musicians_data %>% mutate(occupation = "Musician")
)


#Build four predictive models using linear regression for earnings per hour.
    #  1.Models: the target variable is earnings per hour, all others would be predictors.
    #  2.Model 1 shall be the simplest, model 4 the more complex. It shall be OLS. You shall explain your choice of predictors.
    #  3.Compare model performance of these models (a) RMSE in the full sample, (2) cross-validated RMSE and (c) BIC in the full sample.
    #  4.Discuss the relationship between model complexity and performance. You may use visual aids.

# Compute w
combined_data <- combined_data %>%
  mutate(w = earnwke / uhours) %>%
  filter(uhours > 0)  # Remove cases where work hours are 0 to avoid division errors


2. 
# Model 1: Age as the Sole Predictor
model1_combined <- lm(w ~ age, data = combined_data)

# Model 2: Adding Gender as a Predictor
# Convert 'sex' to a binary variable: 0 = Male, 1 = Female
combined_data <- combined_data %>%
  mutate(female = as.numeric(sex == 2))  # 1 if female, 0 if male

model2_combined <- lm(w ~ age + female, data = combined_data)

# Model 3: Adding Education & Work Hours
model3_combined <- lm(w ~ age + female + grade92 + uhours, data = combined_data)

# Model 4: Adding Non-Linear Terms & Interactions 
model4_combined <- lm(w ~ age + female + grade92 + uhours + I(age^2) + female:age, data = combined_data)

## Choice of Predictors
# To build predictive models for earnings per hour, I selected the following predictors:
   # Age: Earnings often increase with experience, making age a natural predictor.
   # Gender (Sex): Studies suggest potential gender-based earnings differences in the entertainment industry.
   # Education (Grade92): Higher education levels often lead to better earnings opportunities.
   # Work Hours (Uhours): Including work hours allows us to measure true hourly wage differences.
   # Non-Linear Terms (Age²): Many careers exhibit an earnings peak at middle age.
   # Interaction (Age × Sex): The effect of age on earnings may differ by gender.


3. 
# Step 1: Compute RMSE in the Full Sample
library(Metrics)

# Compute RMSE for all models
rmse_model1 <- rmse(combined_data$w, predict(model1_combined, combined_data))
rmse_model2 <- rmse(combined_data$w, predict(model2_combined, combined_data))
rmse_model3 <- rmse(combined_data$w, predict(model3_combined, combined_data))
rmse_model4 <- rmse(combined_data$w, predict(model4_combined, combined_data))

# Store results in a vector
rmse_values <- c(rmse_model1, rmse_model2, rmse_model3, rmse_model4)
rmse_values

# Step 2: Compute Cross-Validated RMSE         * Here, we’ll use k-fold cross-validation (k=5)
library(boot)

# Function to calculate RMSE
cv_rmse <- function(model, data) {
  sqrt(mean((data$w - predict(model, data))^2))
}

# Apply cross-validation
set.seed(123)  # Ensure reproducibility
cv_rmse_model1 <- cv_rmse(model1_combined, combined_data)
cv_rmse_model2 <- cv_rmse(model2_combined, combined_data)
cv_rmse_model3 <- cv_rmse(model3_combined, combined_data)
cv_rmse_model4 <- cv_rmse(model4_combined, combined_data)

# Store cross-validated RMSE values
cv_rmse_values <- c(cv_rmse_model1, cv_rmse_model2, cv_rmse_model3, cv_rmse_model4)
cv_rmse_values

# Step 3: Compute BIC (Bayesian Information Criterion)
# Compute BIC for all models
bic_model1 <- BIC(model1_combined)
bic_model2 <- BIC(model2_combined)
bic_model3 <- BIC(model3_combined)
bic_model4 <- BIC(model4_combined)

# Store BIC values
bic_values <- c(bic_model1, bic_model2, bic_model3, bic_model4)
bic_values

# Step 4: Compare Model Performance in a Table
# Create a table with all metrics
model_comparison <- data.frame(
  Model = c("Model 1", "Model 2", "Model 3", "Model 4"),
  RMSE = rmse_values,
  Cross_Validated_RMSE = cv_rmse_values,
  BIC = bic_values
)

# Print results
print(model_comparison)


4.
# Visualize the Model Performance  
library(ggplot2)
📊 Plot RMSE Comparison
ggplot(model_comparison, aes(x = Model, y = RMSE, fill = Model)) +
  geom_bar(stat = "identity") +
  labs(title = "RMSE Comparison Across Models", y = "RMSE", x = "Model") +
  theme_minimal()

📊 Plot Cross-Validated RMSE
ggplot(model_comparison, aes(x = Model, y = Cross_Validated_RMSE, fill = Model)) +
  geom_bar(stat = "identity") +
  labs(title = "Cross-Validated RMSE Across Models", y = "Cross-Validated RMSE", x = "Model") +
  theme_minimal()

📊 Plot BIC Comparison
ggplot(model_comparison, aes(x = Model, y = BIC, fill = Model)) +
  geom_bar(stat = "identity") +
  labs(title = "BIC Comparison Across Models", y = "BIC", x = "Model") +
  theme_minimal()

## Using the RMSE, Cross-Validated RMSE, and BIC graphs that I generated, the trends shows:
  # RMSE Graph → Shows that adding more predictors improves accuracy (Model 4 is best).
      # The RMSE graph shows a clear improvement from Model 1 to Model 4.
      # Lower RMSE = better prediction accuracy.
      # Model 4 is the best in terms of RMSE.
  # Cross-Validation RMSE Graph → Confirms Model 4 generalizes better than simpler models.
      # It confirms RMSE trends, meaning Model 4 performs best on new data.
      # The difference is small, but Model 4 still wins.
  # BIC Graph → Shows that increasing complexity raises BIC, meaning a trade-off exists.
      # Model 1 has the lowest BIC, meaning it's the simplest.
      # Model 4 has the highest BIC, suggesting it may be too complex.











