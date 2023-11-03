library(tidyverse)
library(usmap)

# Import dataset
data <- read_csv("~/Data/Health_Center_Service_Delivery_and_LookAlike_Sites_11-3-2023.csv")

# Exclude DV shelters without geo information
map_data <- subset(data, data$`Site State Abbreviation` != 'XX')

# Exclude territories outside 50 US states
territories <- c("AS", "GU", "MP", "PR", "FM", "PW", "VI", "MH")
map_data <- subset(map_data, !(map_data$`Site State Abbreviation` %in% territories))

# Isolate migrant HCs
map_data <- subset(map_data, 'Migrant Health Centers HRSA Grant Subprogram Indicator' == 'Y')

# Prepare map
map_data_transformed <- usmap_transform(map_data,
                                        input_names = c('Geocoding Artifact Address Primary X Coordinate',
                                                        'Geocoding Artifact Address Primary Y Coordinate'))

plot_usmap(regions = 'states',
           data = map_data_transformed, 
           values = "hits",  color = orange, labels=FALSE) +
  theme(panel.background=element_blank())





