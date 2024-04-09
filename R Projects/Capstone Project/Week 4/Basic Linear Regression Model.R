library(tidymodels)
library(tidyverse)
library(stringr)
library(glmnet)

dataset_url <- "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-RP0321EN-SkillsNetwork/labs/datasets/seoul_bike_sharing_converted_normalized.csv"
bike_sharing_df <- read_csv(dataset_url)
spec(bike_sharing_df)

#We won't be using the DATE column, because 'as is', it basically acts like an data entry index. (However, given more time, 
#we could use the DATE colum to create a 'day of week' or 'isWeekend' column, which we might expect has an affect on preferred 
#bike rental times.) We also do not need the FUNCTIONAL DAY column because it only has one distinct value remaining (YES) after 
#missing value processing.

bike_sharing_df <- bike_sharing_df %>% 
  select(-DATE, -FUNCTIONING_DAY)

#TASK 1: Split training and testing data
#TODO: Use the initial_split(), training(), and testing() functions to generate a training dataset 
#consisting of 75% of the original dataset, and a testing dataset using the remaining 25%.


# Split the data into training and testing sets
set.seed(123) 
bike_split <- initial_split(bike_sharing_df, prop = 0.75)

# Extract the training and testing sets
bike_train <- training(bike_split)
bike_test <- testing(bike_split)

#TASK 2: Build a linear regression model using weather variables only

# Define the linear regression model specification using weather variables

# Define linear regression model specification
lm_spec_weather <- linear_reg() %>%
  set_engine(engine = "lm") %>%
  set_mode(mode = "regression")

# Fit the model using selected weather variables
lm_model_weather <- lm_spec_weather %>%
  fit(RENTED_BIKE_COUNT ~ TEMPERATURE + HUMIDITY + WIND_SPEED + VISIBILITY + 
        DEW_POINT_TEMPERATURE + SOLAR_RADIATION + RAINFALL + SNOWFALL, data = bike_train)

# Print the fit summary
summary(lm_model_weather$fit)


#TASK 3: Build a linear regression model using all variables

#TODO: Build a linear regression model called lm_model_all using all variables RENTED_BIKE_COUNT ~ 

# Define linear regression model specification
lm_spec_all <- linear_reg() %>%
  set_engine(engine = "lm") %>%
  set_mode(mode = "regression")

# Fit the model using all variables
lm_model_all <- lm_spec_all %>%
  fit(RENTED_BIKE_COUNT ~ ., data = bike_train)

# Print the fit summary
summary(lm_model_all$fit)



#TASK 4: Model evaluation and identification of important variables


# Make predictions on the testing dataset using both models
test_results_weather <- predict(lm_model_weather, new_data = bike_test)
test_results_all <- predict(lm_model_all, new_data = bike_test)


# Define model properties for the Lasso model
lasso_spec <- linear_reg(penalty = 0.1, mixture = 1) %>% 
  set_engine("glmnet")

# Fitting the model to training data
lasso_fit <- lasso_spec %>% 
  fit(RENTED_BIKE_COUNT ~ ., data = bike_train)

# Define model properties for the Elastic-Net model
elastic_net_spec <- linear_reg(penalty = 0.1, mixture = 0.5) %>% 
  set_engine("glmnet")

# Fitting the model to training data
elastic_net_fit <- elastic_net_spec %>% 
  fit(RENTED_BIKE_COUNT ~ ., data = bike_train)

# Making predictions for the Lasso model
lasso_preds <- predict(lasso_fit, new_data = bike_test)

# Make predictions for the Elastic-Net model
elastic_net_preds <- predict(elastic_net_fit, new_data = bike_test)


# Perform predictions on training and test data
train_results <- lm_model_weather %>%
  predict(new_data = bike_train) %>%
  mutate(truth = bike_train$RENTED_BIKE_COUNT)

test_results <- lm_model_weather %>%
  predict(new_data = bike_test) %>%
  mutate(truth = bike_test$RENTED_BIKE_COUNT)

# Calculate R-squared 
rsq_train <- rsq(train_results, truth = truth,
    estimate = .pred)
rsq_test <- rsq(test_results, truth = truth,
    estimate = .pred)

# Calculate RMSE
rmse_train <- rmse(train_results, truth = truth,
     estimate = .pred)
rmse_test <- rmse(test_results, truth = truth,
     estimate = .pred)

print(rsq_train)
print(rsq_test)
print(rmse_train)
print(rmse_test)


lm_model_all$fit$coefficients

# Make coefficients positive and subtract N/A values
positive_coefficients <- abs(lm_model_all$fit$coefficients)
positive_coefficients <- positive_coefficients[!is.na(positive_coefficients)]

# Visualizing coefficients
ggplot(data = data.frame(Variable = names(positive_coefficients), Coefficient = positive_coefficients), aes(x = reorder(Variable, Coefficient), y = Coefficient)) +
  geom_bar(stat = "identity", fill = "black", width = 0.5) +
  coord_flip() +
  labs(title = "Coefficients of Variables",
       x = "Variable",
       y = "Coefficient (Positive Values)") +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 8)) 












