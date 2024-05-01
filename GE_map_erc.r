library(tidyverse)
library(terra)
library(sf)
library(ggnewscale)



wgs <- crs("+proj=longlat +datum=WGS84 +no_defs")


#open birdlife distribution maps

ge_maps <- list.files("/home/mahle68/Desktop/SpeciesRastersBySeason/", pattern = "Aquila_chrysaetos", recursive = T, full.names = T) %>% 
  map(rast) %>% 
  map(project, "+proj=longlat +datum=WGS84") %>% 
  map(as.data.frame, xy = TRUE)

names(ge_maps) <- c("resident", "breeding", "non_breeding")

ge_maps <- lapply(ge_maps, function(one){
  
  colnames(one)[3] <- "value"
  one[one$value == 0, "value"] <- NA
  
  one
  
})


world_map <- st_read("/home/mahle68/ownCloud - enourani@ab.mpg.de@owncloud.gwdg.de/Work/GIS_files/continent_shapefile/World_Continents.shp") %>% 
  # st_crop(xmin = -10, xmax = 40, ymin = 30, ymax = 60) %>%
  st_union()

ggplot() +
  geom_sf(data = world_map, fill = "lightgray", color = "black") +  # Plot world map
  geom_tile(data = ge_maps$resident, aes(x = x, y = y, fill = value)) +
  scale_fill_gradient(low = "red", high = "red", name = "", na.value = "transparent", guide = 'none') +  # Make NA values transparent
  new_scale_fill() +
  geom_tile(data = ge_maps$breeding, aes(x = x, y = y, fill = value)) +
  scale_fill_gradient(low = "yellow", high = "yellow",name = "", na.value = "transparent", guide = 'none') +  # Make NA values transparent
  new_scale_fill() +
  geom_tile(data = ge_maps$non_breeding, aes(x = x, y = y, fill = value)) +
  scale_fill_gradient(low = "green", high = "green",name = "", na.value = "transparent", guide = 'none') +
  theme_minimal()

