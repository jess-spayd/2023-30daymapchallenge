library(sf)
library(leaflet)


# Import metro data
metro_lines <- st_read("Metro_Lines_Regional.shp")

# View metro data
metro <- ggplot(metro_lines) +
  geom_sf()

metro_lines$NAME <- str_to_title(metro_lines$NAME)

# Map it!

leaflet(data=data) %>%
  addProviderTiles("CartoDB") %>%
  setView(lng = -77.016111, # center point of DC based on 
          # https://en.wikipedia.org/wiki/List_of_geographic_centers_of_the_United_States
          # which pulls from geohack.toolforge.org
          lat = 38.904167, 
          zoom = 11) %>%
  addPolylines(data=metro_lines,weight=10,col = metro_lines$NAME, 
               popup=~as.character(metro_lines$NAME), 
               label=~as.character(metro_lines$NAME))
