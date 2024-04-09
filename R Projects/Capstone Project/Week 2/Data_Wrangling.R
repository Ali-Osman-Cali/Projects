library(tidyverse)

#We download raw_bike_sharing_systems.csv
url <- "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-RP0321EN-SkillsNetwork/labs/datasets/raw_bike_sharing_systems.csv"
download.file(url, destfile = "raw_bike_sharing_systems.csv")

#We download raw_cities_weather_forecast.csv
url <- "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-RP0321EN-SkillsNetwork/labs/datasets/raw_cities_weather_forecast.csv"
download.file(url, destfile = "raw_cities_weather_forecast.csv")

#We download raw_worldcities.csv
url <- "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-RP0321EN-SkillsNetwork/labs/datasets/raw_worldcities.csv"
download.file(url, destfile = "raw_worldcities.csv")

#We download raw_seoul_bike_sharing.csv
url <- "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-RP0321EN-SkillsNetwork/labs/datasets/raw_seoul_bike_sharing.csv"
download.file(url, destfile = "raw_seoul_bike_sharing.csv")

dataset_list <- c('raw_bike_sharing_systems.csv', 'raw_seoul_bike_sharing.csv', 'raw_cities_weather_forecast.csv', 'raw_worldcities.csv')

#Write a for loop to iterate over the above datasets and convert their column names
for (dataset_name in dataset_list) {
  dataset <- read_csv(dataset_name)
  names(dataset) <- toupper(names(dataset))
  names(dataset) <- str_replace_all(names(dataset), "\\s+", "_")
  write.csv(dataset, dataset_name, row.names=FALSE)
}


for (dataset_name in dataset_list){
}
  
print(summary(dataset))



# Process the web-scraped bike sharing system dataset 

# First load the dataset
bike_sharing_df <- read_csv("raw_bike_sharing_systems.csv")

# Print its head
head(bike_sharing_df)

# Select the four columns
sub_bike_sharing_df <- bike_sharing_df %>% select(COUNTRY, CITY, SYSTEM, BICYCLES)


sub_bike_sharing_df %>% 
  summarize_all(class) %>%
  gather(variable, class)

find_character <- function(strings) grepl("[^0-9]", strings)


sub_bike_sharing_df %>% 
  select(BICYCLES) %>% 
  filter(find_character(BICYCLES)) %>%
  slice(0:10)

ref_pattern <- "\\[[A-z0-9]+\\]"
find_reference_pattern <- function(strings) grepl(ref_pattern, strings)

sub_bike_sharing_df %>% 
  select(COUNTRY) %>% 
  filter(find_reference_pattern(COUNTRY)) %>%
  slice(0:10)

sub_bike_sharing_df %>% 
  select(CITY) %>% 
  filter(find_reference_pattern(CITY)) %>%
  slice(0:10)

sub_bike_sharing_df %>% 
  select(SYSTEM) %>% 
  filter(find_reference_pattern(SYSTEM)) %>%
  slice(0:10)



# Remove undesired reference links using regular expressions
remove_ref <- function(strings) {
  ref_pattern <- "\\[\\d+\\]" 
  result <- str_replace_all(strings, ref_pattern, "")
  result <- str_trim(result)
  return(result)
}

# Use the dplyr::mutate() function to apply the remove_ref function to the CITY and SYSTEM columns
sub_bike_sharing_df <- sub_bike_sharing_df %>%
  mutate(CITY = remove_ref(CITY),
         SYSTEM = remove_ref(SYSTEM))

# Use the following code to check whether all reference links are removed:
result <- sub_bike_sharing_df %>%
  select(CITY, SYSTEM, BICYCLES) %>%
  filter(find_reference_pattern(CITY) | find_reference_pattern(SYSTEM) | find_reference_pattern(BICYCLES))


# TASK: Extract the numeric value using regular expressions
# TODO: Write a custom function using stringr::str_extract to extract the first digital substring match and convert it into numeric type
# For example, extract the value '32' from 32 (including 6 rollers) [162].

library(dplyr)
library(stringr)

extract_num <- function(columns){
  digitals_pattern <- "\\b\\d+\\b" 
  result <- str_extract(columns, digitals_pattern)
  result <- as.numeric(result)
  return(result)
}

# TODO: Use the dplyr::mutate() function to apply extract_num on the BICYCLES column
sub_bike_sharing_df <- sub_bike_sharing_df %>%
  mutate(BICYCLES = extract_num(BICYCLES))

# TODO: Use the summary function to check the descriptive statistics of the numeric BICYCLES column
summary(sub_bike_sharing_df$BICYCLES)

# TODO: Write the cleaned bike-sharing systems dataset into a csv file called bike_sharing_systems.csv
write.csv(sub_bike_sharing_df, "bike_sharing_systems.csv", row.names = FALSE)










