# We install httr and rvest library
library(httr)
library(rvest)

# URL for Current Weather API
current_weather_url <- 'https://api.openweathermap.org/data/2.5/weather'

#We replace with our API key
your_api_key <- "a4aaff9c3e86d18321e58359adb3e3a8"

current_query <- list(q = "Seoul", appid = your_api_key, units="metric")

#Now we make a HTTP request to the current weather API
response <- GET(current_weather_url, query=current_query)

#If we check the response type, we can see it is in JSON format
http_type(response)

#To read the JSON HTTP response, we use the content() function to parse it as a named list in R
json_result <- content(response, as="parsed")

#We can see it is a R List object
class(json_result)

#We print the JSON result
print(json_result)

#We create some empty vectors to hold data temporarily
weather <- c()
visibility <- c()
temp <- c()
temp_min <- c()
temp_max <- c()
pressure <- c()
humidity <- c()
wind_speed <- c()
wind_deg <- c()

#We assign the values in the json_result list into different vectors

# $weather is also a list with one element, its $main element indicates the weather status such as clear or rain
weather <- c(weather, json_result$weather[[1]]$main)
visibility <- c(visibility, json_result$visibility)
temp <- c(temp, json_result$main$temp)
temp_min <- c(temp_min, json_result$main$temp_min)
temp_max <- c(temp_max, json_result$main$temp_max)
pressure <- c(pressure, json_result$main$pressure)
humidity <- c(humidity, json_result$main$humidity)
wind_speed <- c(wind_speed, json_result$wind$speed)
wind_deg <- c(wind_deg, json_result$wind$deg)

#We combine all vectors as columns of a data frame

weather_data_frame <- data.frame(weather=weather, 
                                 visibility=visibility, 
                                 temp=temp, 
                                 temp_min=temp_min, 
                                 temp_max=temp_max, 
                                 pressure=pressure, 
                                 humidity=humidity, 
                                 wind_speed=wind_speed, 
                                 wind_deg=wind_deg)

#We check the data frame
print(weather_data_frame)


#Now We write a function to return a data frame containing 5-day weather forecasts for a list of cities

# Create some empty vectors to hold data temporarily

city <- c()
weather <- c()
visibility <- c()
temp <- c()
temp_min <- c()
temp_max <- c()
pressure <- c()
humidity <- c()
wind_speed <- c()
wind_deg <- c()
forecast_datetime <- c()
season <- c()


#We get forecast data for a given city list

get_weather_forecaset_by_cities <- function(city_names){
  df <- data.frame()
  for (city_name in city_names){
    forecast_url <- 'https://api.openweathermap.org/data/2.5/forecast'
    forecast_query <- list(q = city_name, appid = your_api_key, units="metric")
    response <- GET(url = forecast_url, query = forecast_query)
    json_result <- content(response, as="parsed")
    results <- json_result$list
    for(result in results) {
      city <- c(city, city_name)
    }
  }
  return(df)
}


cities <- c("Seoul", "Washington, D.C.", "Paris", "Suzhou")
cities_weather_df <- get_weather_forecaset_by_cities(cities)

write.csv(cities_weather_df, "cities_weather_forecast.csv", row.names=FALSE)

# Download several datasets

# Download some general city information such as name and locations
url <- "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-RP0321EN-SkillsNetwork/labs/datasets/raw_worldcities.csv"
# download the file
download.file(url, destfile = "raw_worldcities.csv")

# Download a specific hourly Seoul bike sharing demand dataset
url <- "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-RP0321EN-SkillsNetwork/labs/datasets/raw_seoul_bike_sharing.csv"
# download the file
download.file(url, destfile = "raw_seoul_bike_sharing.csv")
