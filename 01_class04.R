## ------------------------------------------------------
## 01_CLASS04.R - R Script for Lecture 04 (GIS course).

# version: 1.0
# Author: Bruno Conte Leite @2022-23
# b.conte@unibo.it

## ------------------------------------------------------

library(sf) # simple features' library
library(spData) # library of spatial datasets
library(tidyverse) # dplyr, ggplot, ...

# 1. UNARY GEOMETRY OPERATIONS ----

# 1.1. Simplification
sf.river <- seine
# Rivers in France:
ggplot() + 
  geom_sf(data = world %>% filter(iso_a2=='FR')) +
  geom_sf(data = sf.river)

# Simplifying (reducing resolution)
sf.river.simple <- st_simplify(
  sf.river,
  dTolerance = 2000 # tolerance (in meters): the largest, the lower the resol
  )
rm(sf.river.simple)

# 1.2. Centroids

sf.usstates <- us_states
sf.usstates
sf.us.centroids <- st_centroid(sf.usstates)
sf.us.centroids

# Fields (variables) are kept:
names(sf.usstates)
names(sf.us.centroids)

# Visualizing
ggplot() +
  geom_sf(data = sf.usstates) +
  geom_sf(data = sf.us.centroids, aes(color = 'Centroids'), shape = 16)

# Important: centroids might not overlap
# with the geometry!

ggplot() +
  geom_sf(data = sf.river) +
  geom_sf(data = st_centroid(sf.river), shape = 3)

# Use st_point_on_surface():

sf.river.centroid.surface <- st_point_on_surface(sf.river)

ggplot() +
  geom_sf(data = sf.river) +
  geom_sf(data = st_centroid(sf.river), shape = 3) +
  geom_sf(data = sf.river.centroid.surface, shape = 3, color='red')


# 1.3. Buffers:

# Use st_buffer()

sf.river.buffer <- st_buffer(
  sf.river,
  dist = 5000 # 5 km (distance is in meters!)
  )

ggplot() +
  geom_sf(data = sf.river) +
  geom_sf(data = sf.river.buffer, aes(fill=name), alpha=.5) +
  theme_bw()

# 1.4. Affine transformations: shifting, scaling, 
# rotating; see Chapter 5.2.4 of
# https://r.geocompx.org/geometry-operations.html

# ----

# 2. BINARY GEOMETRY OPERATIONS: ----

# 2.1. Clipping:

sf.circles <- st_centroid(seine) %>% 
  st_buffer(dist=100000)

ggplot() + 
  geom_sf(data = sf.circles, aes(fill=name),alpha=.5) +
  theme_bw()

# Clipping: must use unitary geometries!

sf.circle.1 <- sf.circles[1,]
sf.circle.2 <- sf.circles[2,]

sf.intersection <- st_intersection(
  sf.circle.1,
  sf.circle.2
  )
# look at the name of the fields (variables)
sf.intersection

ggplot() + 
  geom_sf(data = sf.circles, aes(fill=name),alpha=.5) +
  geom_sf(data = sf.intersection, aes(fill='Intersection'),alpha=.95) +
  theme_bw()

# Trying other clipping topological
# relationship (difference)
sf.difference <- st_difference(
  sf.circle.1,
  sf.circle.2
)

ggplot() + 
  geom_sf(data = sf.circles, aes(fill=name),alpha=.5) +
  geom_sf(data = sf.difference, aes(fill='Difference'),alpha=.95) +
  theme_bw()

# 2.2. Unions:

# Recall: attribute (or spatial) aggregation
# do unite (dissolve) touching geometries (i.e.
# polygons).

# However, if one wants to unite two TOUCHING
# polygons, use st_union():

sf.union <- st_union(
  sf.circle.1,
  sf.circle.2
)

ggplot() + 
  geom_sf(data = sf.circles, aes(fill=name),alpha=.5) +
  geom_sf(data = sf.union, aes(fill='Union'),alpha=.95) +
  theme_bw()

# ----

# 3. HANDS-IN EXERCISE ----

# 3.1. Merging and aggregating the
# world's data (attribute operations)

sf.world <- world %>% filter(!is.na(iso_a2))
df.wb <- worldbank_df %>% filter(!is.na(iso_a2))

sf.merged <- sf.world %>% 
  left_join(df.wb) %>% 
  filter(continent %in% c('North America', 'South America')) %>% 
  group_by(subregion) %>% 
  summarise(total_urban = sum(urban_pop,na.rm=T), total_pop = sum(pop,na.rm=T)) %>% 
  mutate(urban_rate = total_urban/total_pop)

p<-ggplot(sf.merged) +
  geom_sf(aes(fill=urban_rate)) +
  scale_fill_distiller(palette = 'Spectral') +
  coord_sf(crs = "+proj=laea +x_0=0 +y_0=0 +lon_0=-74 +lat_0=40") +
  theme_bw()
p

# 3.2. Spatial operations:

sf.great.london <- lnd
sf.bikes <- cycle_hire

# Watch out with names:
names(sf.great.london)
names(sf.bikes)

sf.great.london <- sf.great.london %>% 
  rename(name_london = NAME)
sf.bikes <- sf.bikes %>% 
  rename(name_bike = name)

# Spatial filtering:
sf.filtered <- sf.great.london %>% 
  st_filter(sf.bikes)

ggplot() +
  geom_sf(data = sf.filtered) +
  geom_sf(data = sf.bikes)

# Spatial join:

sf.bikes.join <- sf.bikes %>% 
  st_join(sf.great.london)

ggplot() +
  geom_sf(data = sf.filtered) +
  geom_sf(data = sf.bikes.join, aes(color = name_london))

sf.bikes.join <- sf.bikes %>% 
  st_join(sf.great.london)

# Spatial join + aggregation:

sf.glnd.join <- sf.great.london %>% 
  st_join(sf.bikes) %>% 
  group_by(name_london) %>% 
  summarize(
    total_bikes = sum(nbikes,na.rm = T),
    total_empty = sum(nempty,na.rm = T)
    )

ggplot() +
  geom_sf(data = sf.glnd.join, aes(fill=total_bikes)) +
  scale_fill_distiller(name = 'Total\nbikes',direction = 1)



# ----




























# 
# 
