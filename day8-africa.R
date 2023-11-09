library(tidyverse)
library(leaflet)

conflict <- filter(conflict_data_cod, !row_number() == 1)
conflict$latitude <- as.numeric(conflict$latitude)
conflict$longitude <- as.numeric(conflict$longitude)

leaflet(data=conflict) %>%
  addProviderTiles("CartoDB") %>%
  setView(lng = 23.6,
          lat = -3.516667,
          zoom = 5) %>%
  addCircleMarkers(~longitude, ~latitude,
                   radius = 5,
                   color = 'red',
                   stroke = FALSE,
                   fillOpacity = 0.2)
