library(tidyverse)
bike_sharing_df <- read_csv("https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-RP0321EN-SkillsNetwork/labs/datasets/raw_seoul_bike_sharing.csv")

summary(bike_sharing_df)
dim(bike_sharing_df)

# Drop rows with `RENTED_BIKE_COUNT` column == NA
bike_sharing_df <- na.omit(bike_sharing_df, cols = "RENTED_BIKE_COUNT")

# Print the dataset dimension again after those rows are dropped
summary(bike_sharing_df)
dim(bike_sharing_df)

#take a look at the missing values in the TEMPERATURE column
bike_sharing_df %>% 
  filter(is.na(TEMPERATURE))

# Calculate the summer average temperature
summer_mean_temp <- mean(bike_sharing_df$TEMPERATURE[bike_sharing_df$SEASONS == "Summer"], na.rm = TRUE)
print(summer_mean_temp)

# Impute missing values for TEMPERATURE column with summer average temperature
bike_sharing_df$TEMPERATURE[is.na(bike_sharing_df$TEMPERATURE) & bike_sharing_df$SEASONS == "Summer"] <- summer_mean_temp

# Print the summary of the dataset again to make sure no missing values in all columns
summary(bike_sharing_df)

# Save the dataset as `seoul_bike_sharing.csv`
write_csv(bike_sharing_df, "seoul_bike_sharing.csv")

names(bike_sharing_df) <- toupper(names(bike_sharing_df))

# Using mutate() function to convert HOUR column into character type
bike_sharing_df <- bike_sharing_df %>%
  mutate(HOUR = as.character(HOUR))

# Convert SEASONS, HOLIDAY, FUNCTIONING_DAY, and HOUR columns into indicator columns.
# Create indicator variables for SEASONS
bike_sharing_df <- bike_sharing_df %>%
  mutate(Spring = ifelse(SEASONS == "Spring", 1, 0),
         Summer = ifelse(SEASONS == "Summer", 1, 0),
         Autumn = ifelse(SEASONS == "Autumn", 1, 0),
         Winter = ifelse(SEASONS == "Winter", 1, 0))

# Create indicator variables for HOLIDAY
bike_sharing_df <- bike_sharing_df %>%
  mutate(Holiday = ifelse(HOLIDAY == "Holiday", 1, 0))

# Print the dataset summary again to make sure the indicator columns are created properly
summary(bike_sharing_df)

# Save the dataset as `seoul_bike_sharing_converted.csv`
write_csv(bike_sharing_df, "seoul_bike_sharing_converted.csv")


# Use the `mutate()` function to apply min-max normalization on columns 
# `RENTED_BIKE_COUNT`, `TEMPERATURE`, `HUMIDITY`, `WIND_SPEED`, `VISIBILITY`, `DEW_POINT_TEMPERATURE`, `SOLAR_RADIATION`, `RAINFALL`, `SNOWFALL`
min_max_normalize <- function(x) {
  if (is.numeric(x)) {
    return((x - min(x)) / (max(x) - min(x)))
  } else {
    warning("Input is not numeric. Skipping normalization.")
    return(x)
  }
}

numeric_columns <- c("RENTED_BIKE_COUNT", "TEMPERATURE", "HUMIDITY", "WIND_SPEED", 
                     "VISIBILITY", "DEW_POINT_TEMPERATURE", "SOLAR_RADIATION", 
                     "RAINFALL", "SNOWFALL")

# Exclude non-numeric columns from normalization
numeric_columns <- numeric_columns[!sapply(bike_sharing_df[numeric_columns], function(x) any(!is.numeric(x)))]

bike_sharing_df[numeric_columns] <- lapply(bike_sharing_df[numeric_columns], min_max_normalize)

summary(bike_sharing_df)
write_csv(bike_sharing_df, "seoul_bike_sharing_converted_normalized.csv")

# Dataset list
dataset_list <- c('seoul_bike_sharing.csv', 'seoul_bike_sharing_converted.csv', 'seoul_bike_sharing_converted_normalized.csv')

for (dataset_name in dataset_list){
  # Read dataset
  dataset <- read_csv(dataset_name)
  # Standardized its columns:
  # Convert all columns names to uppercase
  names(dataset) <- toupper(names(dataset))
  # Replace any white space separators by underscore, using str_replace_all function
  names(dataset) <- str_replace_all(names(dataset), " ", "_")
  # Save the dataset back
  write.csv(dataset, dataset_name, row.names=FALSE)
}








