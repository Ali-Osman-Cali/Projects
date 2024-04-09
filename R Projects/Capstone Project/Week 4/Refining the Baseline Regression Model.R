library("tidymodels")
library("tidyverse")
library("stringr")

dataset_url <- "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-RP0321EN-SkillsNetwork/labs/datasets/seoul_bike_sharing_converted_normalized.csv"
bike_sharing_df <- read_csv(dataset_url)
spec(bike_sharing_df)

bike_sharing_df <- bike_sharing_df %>% 
  select(-DATE, -FUNCTIONING_DAY)

lm_spec <- linear_reg() %>%
  set_engine("lm") %>% 
  set_mode("regression")

set.seed(1234)
data_split <- initial_split(bike_sharing_df, prop = 4/5)
train_data <- training(data_split)
test_data <- testing(data_split)

ggplot(data = train_data, aes(RENTED_BIKE_COUNT, TEMPERATURE)) + 
  geom_point() 

ggplot(data=train_data, aes(RENTED_BIKE_COUNT, TEMPERATURE)) + 
  geom_point() + 
  geom_smooth(method = "lm", formula = y ~ x, color="red") + 
  geom_smooth(method = "lm", formula = y ~ poly(x, 2), color="yellow") + 
  geom_smooth(method = "lm", formula = y ~ poly(x, 4), color="green") + 
  geom_smooth(method = "lm", formula = y ~ poly(x, 6), color="blue")




# Create a linear model by adding higher degree polynomials on important variables
lm_poly_spec <- linear_reg() %>%
  set_engine("lm") %>% 
  set_mode("regression")

lm_poly_wf <- workflow() %>%
  add_model(lm_poly_spec) %>%
  add_formula(RENTED_BIKE_COUNT ~ poly(TEMPERATURE, 6) + poly(HUMIDITY, 4))

# Fit the model to training data
lm_poly_fit <- fit(lm_poly_wf, data = train_data)

# Model summary
summary(lm_poly_fit)

predictions <- predict(lm_poly_fit, new_data = test_data)


# Convert negative prediction results to zero
predictions[predictions < 0] <- 0
print(predictions)

# Calculate residuals
residuals <- predictions - test_data$RENTED_BIKE_COUNT
head(residuals)


# Extract actual values from test data
actual <- test_data$RENTED_BIKE_COUNT

# Extract predicted values from predictions
predicted <- predictions$.pred

# Calculate R-squared
mean_actual <- mean(actual)
ss_total <- sum((actual - mean_actual)^2)
ss_residual <- sum((actual - predicted)^2)
rsquared <- 1 - (ss_residual / ss_total)

# Calculate RMSE
rmse <- sqrt(mean((actual - predicted)^2))

# Print R-squared and RMSE
cat("R-squared:", rsquared, "\n")
cat("RMSE:", rmse, "\n")


# Add interaction terms to the polynomial regression model
lm_poly_wf <- workflow() %>%
  add_model(lm_poly_spec) %>%
  add_formula(
    RENTED_BIKE_COUNT ~ poly(TEMPERATURE, 6) * poly(HUMIDITY, 4) +
      TEMPERATURE * HUMIDITY
  )

# Fit the model to training data
lm_poly_fit_with_interaction <- fit(lm_poly_wf, data = train_data)

# Model summary
summary(lm_poly_fit_with_interaction)

# Predictions with interaction terms
predictions_with_interaction <- predict(lm_poly_fit_with_interaction, new_data = test_data)

# Convert negative prediction results to zero
predictions_with_interaction$.pred[predictions_with_interaction$.pred < 0] <- 0

# Calculate residuals
residuals_with_interaction <- predictions_with_interaction$.pred - test_data$RENTED_BIKE_COUNT

# Calculate R-squared and RMSE
rsquared_with_interaction <- 1 - sum(residuals_with_interaction^2) / sum((test_data$RENTED_BIKE_COUNT - mean(test_data$RENTED_BIKE_COUNT))^2)
rmse_with_interaction <- sqrt(mean(residuals_with_interaction^2))

# Print R-squared and RMSE
cat("R-squared (with interaction terms):", rsquared_with_interaction, "\n")
cat("RMSE (with interaction terms):", rmse_with_interaction, "\n")

library('glmnet')
library('Matrix')

# Define a linear regression model specification glmnet_spec using glmnet engine
# You can adjust the penalty and mixture parameters as needed
glmnet_spec <- linear_reg(penalty = 0.1, mixture = 0.5) %>%
  set_engine("glmnet") %>%
  set_mode("regression")

# Fit a glmnet model called lm_glmnet using the fit() function
# For the formula part, keep the polynominal and interaction terms you used in the previous task
lm_glmnet <- fit(glmnet_spec, RENTED_BIKE_COUNT ~ poly(TEMPERATURE, 6) * poly(HUMIDITY, 4) + TEMPERATURE * HUMIDITY, data = train_data)

# Report rsq and rmse of the `lm_glmnet` model
predictions_glmnet <- predict(lm_glmnet, new_data = test_data)
predictions_glmnet$.pred[predictions_glmnet$.pred < 0] <- 0

residuals_glmnet <- predictions_glmnet$.pred - test_data$RENTED_BIKE_COUNT
rsquared_glmnet <- 1 - sum(residuals_glmnet^2) / sum((test_data$RENTED_BIKE_COUNT - mean(test_data$RENTED_BIKE_COUNT))^2)
rmse_glmnet <- sqrt(mean(residuals_glmnet^2))

cat("R-squared (with glmnet):", rsquared_glmnet, "\n")
cat("RMSE (with glmnet):", rmse_glmnet, "\n")


# Add regularization
# Define a linear regression model specification glmnet_spec using glmnet engine

glmnet_spec <- linear_reg(penalty = 0.1, mixture = 0.5) %>%
  set_engine("glmnet") %>%
  set_mode("regression")

library('glmnet')
library('Matrix')

# Fit a glmnet model using the fit() function
lm_glmnet <- fit(glmnet_spec, RENTED_BIKE_COUNT ~ poly(TEMPERATURE, 6) * poly(HUMIDITY, 4) 
                 + TEMPERATURE * HUMIDITY, data = train_data)

# Report rsq and rmse of the `lm_glmnet` model
predictions_glmnet <- predict(lm_glmnet, new_data = test_data)
predictions_glmnet$.pred[predictions_glmnet$.pred < 0] <- 0

residuals_glmnet <- predictions_glmnet$.pred - test_data$RENTED_BIKE_COUNT
rsquared_glmnet <- 1 - sum(residuals_glmnet^2) / sum((test_data$RENTED_BIKE_COUNT - mean(test_data$RENTED_BIKE_COUNT))^2)
rmse_glmnet <- sqrt(mean(residuals_glmnet^2))

cat("R-squared (with glmnet):", rsquared_glmnet, "\n")
cat("RMSE (with glmnet):", rmse_glmnet, "\n")


# Build at least five different models using polynomial terms, interaction terms, and regularizations.

# Save their rmse and rsq values
# Define a list to store the performance of each model
model_performance_df <- data.frame()

# Define a list of penalties for the glmnet model
penalties <- c(0.1, 0.5, 1.0, 2.0, 5.0)

# Loop over the penalties
for (penalty in penalties) {
  # Define the glmnet model specification
  glmnet_spec <- linear_reg(penalty = penalty, mixture = 0.5) %>%
    set_engine("glmnet") %>%
    set_mode("regression")
  
  # Fit the glmnet model
  lm_glmnet <- fit(glmnet_spec, RENTED_BIKE_COUNT ~ poly(TEMPERATURE, 6) * poly(HUMIDITY, 4) + TEMPERATURE * HUMIDITY, data = train_data)
  
  # Make predictions
  predictions <- predict(lm_glmnet, new_data = test_data)
  
  # Calculate RMSE and R-squared
  rmse <- sqrt(mean((test_data$RENTED_BIKE_COUNT - predictions$.pred)^2))
  rsquared <- 1 - sum((test_data$RENTED_BIKE_COUNT - predictions$.pred)^2) / sum((test_data$RENTED_BIKE_COUNT - mean(test_data$RENTED_BIKE_COUNT))^2)
  
  # Add the performance to the data frame
  model_performance_df <- rbind(model_performance_df, data.frame(Model = paste("glmnet", penalty), RMSE = rmse, Rsquared = rsquared))
}

# HINT: Use ggplot() + geom_bar()
library(ggplot2)
library(reshape2)

# Reshape the data for ggplot
model_performance_long <- melt(model_performance_df, id.vars = "Model")

# Plot the performance of each model
ggplot(model_performance_long, aes(x = Model, y = value, fill = variable)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(x = "Model", y = "Value", fill = "Metric") +
  theme_minimal()

# HINT: Use ggplot() +
# stat_qq(aes(sample=truth), color='green') +
# stat_qq(aes(sample=prediction), color='red')

ggplot() +
  stat_qq(aes(sample = test_data$RENTED_BIKE_COUNT), color = 'green') +
  stat_qq(aes(sample = predictions$.pred), color = 'red') +
  labs(title = "Q-Q Plot of Predictions vs True Values", x = "Theoretical Quantiles", y = "Sample Quantiles") +
  theme_minimal()





















