library(tidyverse)
library(maps)
library(mapdata)
library(mapproj)

# Import dataset
#data <- read_csv("~/Data/Health_Center_Service_Delivery_and_LookAlike_Sites_11-3-2023.csv")
map_data <- as.data.frame(Health_Center_Service_Delivery_and_LookAlike_Sites_11_3_2023)

# Exclude DV shelters without geo information
map_data <- subset(map_data, map_data$`Site State Abbreviation` != 'XX')

# Exclude territories outside 50 US states
territories <- c("AS", "GU", "MP", "PR", "FM", "PW", "VI", "MH")
map_data <- subset(map_data, !(map_data$`Site State Abbreviation` %in% territories))

# Isolate migrant HCs
map_data$migrant_prog <- map_data$`Migrant Health Centers HRSA Grant Subprogram Indicator`
map_data <- subset(map_data, migrant_prog == 'Y')

map_data$state_abbr <- map_data$`Site State Abbreviation`

# Count migrant HCs by state
migrant_hc_counts <- map_data %>%
  group_by(state_abbr) %>%
  count()

# Prepare base map
states <- map_data('state')

us_states_map <- ggplot(data=states, mapping=aes(x=long, y=lat, group=group)) + 
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  geom_polygon(color="black", fill="white") + 
  theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(),
        axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) +
  theme(panel.background = element_blank())

# Merge map data and HC data
## add state names to HC data
state_abbr <- datasets::state.abb
state_names <- datasets::state.name
state_name2abbr <- cbind(state_abbr, state_names)
state_name2abbr <- as.data.frame(state_name2abbr)
state_name2abbr$state_names <- tolower(state_name2abbr$state_names)

migrant_hc_counts <- right_join(migrant_hc_counts, state_name2abbr, by='state_abbr')
migrant_hc_counts <- migrant_hc_counts %>% mutate(n = ifelse(is.na(n), 0, n))

all_map_data <- left_join(states, migrant_hc_counts, by=c("region"="state_names"))

# Map it
ggplot(data=all_map_data, mapping=aes(x=long, y=lat, group=group, fill=n)) + 
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  geom_polygon(color="black") + 
  theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank(),
        axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) +
  theme(panel.background = element_blank()) +
  labs(title='Number of Migrant Health Center Subprogram Sites') +
  scale_fill_distiller(type='seq', direction=1, palette='Greys')



