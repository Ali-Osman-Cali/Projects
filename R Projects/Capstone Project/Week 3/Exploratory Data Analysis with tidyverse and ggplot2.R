library(readr)
library(tidyverse)


seoul_bike_sharing <- "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-RP0321EN-SkillsNetwork/labs/datasets/seoul_bike_sharing.csv" 
seoul_bike_sharing_df <- read_csv(seoul_bike_sharing)

#Task 1 - Load the dataset
#Ensure you read DATE as type character.
seoul_bike_sharing_df$DATE <- as.character(seoul_bike_sharing_df$DATE)


#Task 2 - Recast DATE as a date
#Use the format of the data, namely "%d/%m/%Y".
seoul_bike_sharing_df$DATE <- as.Date(seoul_bike_sharing_df$DATE, format = "%d/%m/%Y")

#Task 3 - Cast HOURS as a categorical variable
#Also, coerce its levels to be an ordered sequence. 
#This will ensure your visualizations correctly utilize HOURS as a discrete variable with the expected ordering.
seoul_bike_sharing_df$HOUR <- factor(seoul_bike_sharing_df$HOUR, ordered = TRUE)

#Check the structure of the dataframe
str(seoul_bike_sharing_df)

#Finally, ensure there are no missing values
sum(is.na(seoul_bike_sharing_df))


#Task 4 - Dataset Summary
#Use the base R summary() function to describe the seoul_bike_sharing dataset.

summary(seoul_bike_sharing_df)

#Task 5 - Based on the above stats, calculate how many Holidays there are.

length(unique(seoul_bike_sharing_df$HOLIDAY))


#Task 6 - Calculate the percentage of records that fall on a holiday.

num_holidays <- sum(seoul_bike_sharing_df$HOLIDAY == "Yes")
total_records <- nrow(seoul_bike_sharing_df)
holiday_percentage <- (num_holidays / total_records) * 100
print(paste("Percentage of Records on Holiday:", round(holiday_percentage, 2), "%"))

#Task 7 - Given there is exactly a full year of data, determine how many records we expect to have.

earliest_date <- min(seoul_bike_sharing_df$DATE)
latest_date <- max(seoul_bike_sharing_df$DATE)
days_in_year <- as.numeric(difftime(latest_date, earliest_date, units = "days")) + 1
expected_records <- days_in_year * 24
print(paste("Expected Number of Records for a Full Year:", expected_records))

#Task 8 - Given the observations for the 'FUNCTIONING_DAY' how many records must there be?

functioning_days <- sum(seoul_bike_sharing_df$FUNCTIONING_DAY == "Yes")
expected_records_per_day <- 24
expected_records <- functioning_days * expected_records_per_day
print(paste("Expected Number of Records based on FUNCTIONING_DAY:", expected_records))


#Task 9 - Load the dplyr package, group the data by SEASONS, and use the summarize() function 
#to calculate the seasonal total rainfall and snowfall.

library(dplyr)

seasonal_summary <- seoul_bike_sharing_df %>%
  group_by(SEASONS) %>%
  summarize(total_rainfall = sum(RAINFALL),
            total_snowfall = sum(SNOWFALL))

print(seasonal_summary)

#Task 10 - Create a scatter plot of RENTED_BIKE_COUNT vs DATE.
library(ggplot2)

ggplot(seoul_bike_sharing_df, aes(x = DATE, y = RENTED_BIKE_COUNT)) +
  geom_point(alpha = 0.2) +  # Adjust opasity
  labs(x = "Date", y = "Rented Bike Count") + 
  ggtitle("Scatter Plot of Rented Bike Count vs Date")

#Task 11 - Create the same plot of the RENTED_BIKE_COUNT time series, but now add HOURS as the colour.

ggplot(seoul_bike_sharing_df, aes(x = DATE, y = RENTED_BIKE_COUNT, color = HOUR)) +
  geom_point(alpha = 0.7) +  
  labs(x = "Date", y = "Rented Bike Count", color = "Hour") +  
  ggtitle("Time Series Plot of Rented Bike Count vs Date (Color by Hour)") 

#Task 12 - Create a histogram overlaid with a kernel density curve

ggplot(seoul_bike_sharing_df, aes(x = RENTED_BIKE_COUNT)) +
  geom_histogram(aes(y = ..density..), bins = 30, fill = "white", color = "black", alpha = 0.6) +
  geom_density(color = "black", alpha = 0.3) +
  labs(x = "Rented Bike Count", y = "Density") +
  ggtitle("Histogram of Rented Bike Count with Kernel Density Curve")

#We can see from the histogram that most of the time there are relatively few bikes rented. Indeed, the 'mode', 
#or most frequent amount of bikes rented, is about 250.Judging by the 'bumps' at about 700, 900, and 1900, and 3200 bikes, 
#it looks like there may be other modes hiding within subgroups of the data.Interestingly, judging from the tail of 
#the distribution, on rare occasions there are many more bikes rented out than usual.




#Task 13 - Use a scatter plot to visualize the correlation between RENTED_BIKE_COUNT and TEMPERATURE by SEASONS.
#Correlation between two variables (scatter plot)
#Start with RENTED_BIKE_COUNT vs. TEMPERATURE, then generate four plots corresponding to the SEASONS 
#by adding a facet_wrap() layer. 
#Also, make use of colour and opacity to emphasize any patterns that emerge. Use HOUR as the color.


ggplot(seoul_bike_sharing_df, aes(x = TEMPERATURE, y = RENTED_BIKE_COUNT, color = HOUR, alpha = 0.6)) +
  geom_point() +
  facet_wrap(~ SEASONS) +
  labs(x = "Temperature", y = "Rented Bike Count") +
  ggtitle("Scatter Plot of Rented Bike Count vs Temperature by Seasons")

#Visually, we can see some strong correlations as approximately linear patterns.

#Note: Comparing this plot to the same plot below, but without grouping by SEASONS, 
#shows how important seasonality is in explaining bike rental counts.

ggplot(seoul_bike_sharing_df) +
  geom_point(aes(x=TEMPERATURE,y=RENTED_BIKE_COUNT,colour=HOUR),alpha=0.5)

#Outliers (boxplot)¶
#Task 14 - Create a display of four boxplots of RENTED_BIKE_COUNT vs. HOUR grouped by SEASONS.
#Use facet_wrap to generate four plots corresponding to the seasons.

ggplot(seoul_bike_sharing_df, aes(x = HOUR, y = RENTED_BIKE_COUNT)) +
  geom_boxplot() +
  facet_wrap(~ SEASONS) +
  labs(x = "Hour", y = "Rented Bike Count") +
  ggtitle("Boxplot of Rented Bike Count vs Hour by Seasons")

#Although the overall scale of bike rental counts changes with the seasons, key features remain very similar.
#For example, peak demand times are the same across all seasons, at 8 am and 6 pm.



#Task 15 - Group the data by DATE, and use the summarize() function to calculate the daily total rainfall and snowfall.
#Also, go ahead and plot the results if you wish.

daily_summary <- seoul_bike_sharing_df %>%
  group_by(DATE) %>%
  summarize(total_rainfall = sum(RAINFALL),
            total_snowfall = sum(SNOWFALL))


ggplot(daily_summary, aes(x = DATE)) +
  geom_line(aes(y = total_rainfall, color = "Rainfall"), size = 1) +
  geom_line(aes(y = total_snowfall, color = "Snowfall"), size = 1) +
  labs(x = "Date", y = "Total Amount", color = "Type") +
  ggtitle("Daily Total Rainfall and Snowfall")


#Task 16 - Determine how many days had snowfall

days_with_snowfall <- seoul_bike_sharing_df %>%
  filter(SNOWFALL > 0) %>%
  summarise(days_with_snowfall = n_distinct(DATE))

print(paste("Number of days with snowfall:", days_with_snowfall$days_with_snowfall))






