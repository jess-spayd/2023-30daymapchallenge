library(tidyverse)
library(leaflet)

# Import dataset
#data <- read_csv("~/Data/Health_Center_Service_Delivery_and_LookAlike_Sites_11-3-2023.csv")
data <- as.data.frame(Health_Center_Service_Delivery_and_LookAlike_Sites_11_3_2023)

# Subset to only include sites in NJ
data <- subset(data, data$`Site State Abbreviation` == 'NJ')

# Site type as factor
data$'Health Center Type' <- as.factor(data$'Health Center Type Description')

# Rename x-y coordinates
data$x <- data$`Geocoding Artifact Address Primary X Coordinate`
data$y <- data$`Geocoding Artifact Address Primary Y Coordinate`

# create map

leaflet(data=data) %>%
  addProviderTiles("CartoDB") %>%
  setView(lng = -74.558333, # center point of NJ based on 
          # https://en.wikipedia.org/wiki/List_of_geographic_centers_of_the_United_States
          # which pulls from geohack.toolforge.org
          lat = 40.17, # adjusted slightly from 40.07
          zoom = 8) %>%
  addMarkers(~x, ~y, popup=~as.character(data$'Site Name'), label=~as.character(data$'Site Name'))
