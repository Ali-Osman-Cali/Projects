install.packages(c('RSQLite'), repos = 'http://cran.rstudio.com',dependecies=TRUE)
library(RSQLite)
library(readr)

conn <- dbConnect(RSQLite::SQLite(),"Lab-SQL-EDA.sqlite")

SEOUL_BIKE_SHARING <- read_csv("https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-RP0321EN-SkillsNetwork/labs/datasets/seoul_bike_sharing.csv")
CITIES_WEATHER_FORECAST <- read_csv("https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-RP0321EN-SkillsNetwork/labs/datasets/cities_weather_forecast.csv")
BIKE_SHARING_SYSTEMS <- read_csv("https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-RP0321EN-SkillsNetwork/labs/datasets/bike_sharing_systems.csv")
WORLD_CITIES <- read_csv("https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-RP0321EN-SkillsNetwork/labs/datasets/world_cities.csv")

dbWriteTable(conn, "SEOUL_BIKE_SHARING", SEOUL_BIKE_SHARING, overwrite = TRUE)
dbWriteTable(conn, "CITIES_WEATHER_FORECAST", CITIES_WEATHER_FORECAST, overwrite = TRUE)
dbWriteTable(conn, "BIKE_SHARING_SYSTEMS", BIKE_SHARING_SYSTEMS, overwrite = TRUE)
dbWriteTable(conn, "WORLD_CITIES", WORLD_CITIES, overwrite = TRUE)

head(SEOUL_BIKE_SHARING)

#Task 1 - Record Count
#Determine how many records are in the seoul_bike_sharing dataset.

dbGetQuery(conn, "SELECT COUNT(*) FROM SEOUL_BIKE_SHARING")


#Task 2 - Operational Hours
#Determine how many hours had non-zero rented bike count.

dbGetQuery(conn, "SELECT COUNT(*) FROM SEOUL_BIKE_SHARING WHERE RENTED_BIKE_COUNT != 0")

#Task 3 - Weather Outlook
#Query the the weather forecast for Seoul over the next 3 hours.
#Recall that the records in the CITIES_WEATHER_FORECAST dataset are 3 hours apart, so we just need the first record from the query.

dbGetQuery(conn, "SELECT * FROM CITIES_WEATHER_FORECAST WHERE CITY = 'Seoul' LIMIT 1")

#Task 4 - Seasons
#Find which seasons are included in the seoul bike sharing dataset.

dbGetQuery(conn, "SELECT DISTINCT SEASONS FROM SEOUL_BIKE_SHARING")


#Task 5 - Date Range
#Find the first and last dates in the Seoul Bike Sharing dataset.


dbGetQuery(conn, "SELECT MIN(DATE) AS first_date, MAX(DATE) AS last_date FROM SEOUL_BIKE_SHARING")


#Task 6 - Subquery - 'all-time high'
#determine which date and hour had the most bike rentals.

dbGetQuery(conn, "
SELECT DATE,
       HOUR
FROM SEOUL_BIKE_SHARING
WHERE RENTED_BIKE_COUNT = (SELECT MAX(RENTED_BIKE_COUNT) FROM SEOUL_BIKE_SHARING)
")


#Task 7 - Hourly popularity and temperature by season
#Determine the average hourly temperature and the average number of bike rentals per hour over each season. 
#List the top ten results by average bike count.


dbGetQuery(conn, "
SELECT SEASONS,
       HOUR,
       AVG(TEMPERATURE) AS avg_temperature,
       AVG(RENTED_BIKE_COUNT) AS avg_bike_count
FROM SEOUL_BIKE_SHARING
GROUP BY SEASONS, HOUR
ORDER BY avg_bike_count DESC
LIMIT 10
")


#Task 8 - Rental Seasonality¶
#Find the average hourly bike count during each season.
#Also include the minimum, maximum, and standard deviation of the hourly bike count for each season.

#Hint : Use the SQRT(AVG(col*col) - AVG(col)*AVG(col) ) function where col refers to your column name for 
#finding the standard deviation

dbGetQuery(conn, "
SELECT SEASONS,
       HOUR,
       AVG(RENTED_BIKE_COUNT) AS avg_bike_count,
       MIN(RENTED_BIKE_COUNT) AS min_bike_count,
       MAX(RENTED_BIKE_COUNT) AS max_bike_count,
       SQRT(AVG(RENTED_BIKE_COUNT * RENTED_BIKE_COUNT) - AVG(RENTED_BIKE_COUNT) * AVG(RENTED_BIKE_COUNT)) AS std_dev_bike_count
FROM SEOUL_BIKE_SHARING
GROUP BY SEASONS, HOUR
")


#Task 9 - Weather Seasonality
#Consider the weather over each season. On average, what were the TEMPERATURE, HUMIDITY, WIND_SPEED, VISIBILITY, 
#DEW_POINT_TEMPERATURE, SOLAR_RADIATION, RAINFALL, and SNOWFALL per season?
## Include the average bike count as well , and rank the results by average bike count so you can see 
## if it is correlated with the weather at all.

dbGetQuery(conn, "
SELECT SEASONS,
       AVG(TEMPERATURE) AS avg_temperature,
       AVG(HUMIDITY) AS avg_humidity,
       AVG(WIND_SPEED) AS avg_wind_speed,
       AVG(VISIBILITY) AS avg_visibility,
       AVG(DEW_POINT_TEMPERATURE) AS avg_dew_point_temperature,
       AVG(SOLAR_RADIATION) AS avg_solar_radiation,
       AVG(RAINFALL) AS avg_rainfall,
       AVG(SNOWFALL) AS avg_snowfall,
       AVG(RENTED_BIKE_COUNT) AS avg_bike_count
FROM SEOUL_BIKE_SHARING
GROUP BY SEASONS
ORDER BY avg_bike_count DESC
")



#Task 10 - Total Bike Count and City Info for Seoul¶
#Use an implicit join across the WORLD_CITIES and the BIKE_SHARING_SYSTEMS tables to determine the total number of bikes 
#avaialble in Seoul, plus the following city information about Seoul: CITY, COUNTRY, LAT, LON, POPULATION, in a single view.
#Notice that in this case, the CITY column will work for the WORLD_CITIES table, but in general you would have to use 
#the CITY_ASCII column.Task 10 - Total Bike Count and City Info for Seoul¶
#Use an implicit join across the WORLD_CITIES and the BIKE_SHARING_SYSTEMS tables to determine the total number of bikes 
#avaialble in Seoul, plus the following city information about Seoul: CITY, COUNTRY, LAT, LON, POPULATION, in a single view.
#Notice that in this case, the CITY column will work for the WORLD_CITIES table, but in general you would have to use the CITY_ASCII column.

dbGetQuery(conn, "
SELECT WC.CITY, 
       WC.COUNTRY, 
       WC.LAT, 
       WC.LNG, 
       WC.POPULATION, 
       SUM(BS.BICYCLES) AS total_bike_count
FROM WORLD_CITIES AS WC
JOIN BIKE_SHARING_SYSTEMS AS BS ON WC.CITY = BS.CITY
WHERE WC.CITY = 'Seoul'
GROUP BY WC.CITY, WC.COUNTRY, WC.LAT, WC.LNG, WC.POPULATION
")


#Task 11 - Find all city names and coordinates with comparable bike scale to Seoul's bike sharing system
#Find all cities with total bike counts between 15000 and 20000. Return the city and country names, 
#plus the coordinates (LAT, LNG), population, and number of bicycles for each city.¶
#Later we will ask you to visualize these similar cities on leaflet, with some weather data.


dbGetQuery(conn, "
SELECT WC.CITY,
       WC.COUNTRY,
       WC.LAT,
       WC.LNG,
       WC.POPULATION,
       BS.BICYCLES AS bike_count
FROM WORLD_CITIES AS WC
JOIN BIKE_SHARING_SYSTEMS AS BS ON WC.CITY = BS.CITY
WHERE BS.BICYCLES BETWEEN 15000 AND 20000
")


dbDisconnect(conn)



