library(sf)
library(tidyverse)
library(maps)
library(mapdata)
library(mapproj)

# Load and view dataset

us_roads <- st_read('tl_2019_us_primaryroads.shp')

ggplot(us_roads) +
  geom_sf()

#us_roads_48 <- st_crop(us_roads,
 #                      xmin = 29.5, xmax = 45.5,
  #                     ymin = 37.5, ymax = -96)

# Load USA map data

usa <- map_data('state')

ggplot(usa, aes(long, lat, group=group)) +
  geom_polygon(color='black', fill='white') +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(),
        axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) +
  theme(panel.background = element_blank())

# Layer maps


ggplot(us_roads) +
  geom_polygon(usa, mapping=aes(long, lat, group=group), fill='white', color='black') +
  geom_sf(color='red') +
  theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(),
        axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) +
  theme(panel.background = element_blank()) +
  labs(title='U.S. Roads')

