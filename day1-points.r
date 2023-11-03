library(tidyverse)
library(maps)
library(mapdata)


# Import dataset
data <- read_csv("~/Data/Health_Center_Service_Delivery_and_LookAlike_Sites_11-3-2023.csv")

# Subset to only include sites in NJ
data <- subset(data, data$`Site State Abbreviation` == 'NJ')

# Site type as factor
data$'Health Center Type' <- as.factor(data$'Health Center Type Description')

# Rename x-y coordinates
data$x <- data$`Geocoding Artifact Address Primary X Coordinate`
data$y <- data$`Geocoding Artifact Address Primary Y Coordinate`

# Prepare map

usa <- map_data('usa')
states <- map_data('state')
newjersey <- subset(states, region == "new jersey")
counties <- map_data("county")
nj_counties <- subset(counties, region=="new jersey")


ggplot(data=newjersey, mapping=aes(x=long, y=lat, group=group)) + 
  coord_fixed(1.3) + 
  geom_polygon(color="black", fill="white") + 
  geom_polygon(data=nj_counties, fill=NA, color="gray") + 
  geom_polygon(color="black", fill=NA) + 
  ggtitle('New Jersey') + 
  theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(),
        axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) +
  theme(panel.background = element_blank())

