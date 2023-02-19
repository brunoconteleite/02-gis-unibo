## ------------------------------------------------------
## 01_CLASS01.R - R Script for Lecture 01 (GIS course).

# version: 1.0
# Author: Bruno Conte Leite @2022-23
# b.conte@unibo.it

## ------------------------------------------------------


# 1. BASICS OF SPATIAL DATA WITH SIMPLE FEATURES: ----

library(sf) # simple features' library
library(spData) # library of spatial datasets
library(tidyverse) # dplyr, ggplot, ...

# Cheat sheet: https://osf.io/an6b5/download

# 1.1. Creating SF GEOMETRIES (SFG):

gm.point <- st_point(c(5,2)) # a point

# Lines: require a matrix of points
linestring_matrix <-rbind(c(1, 5), c(4, 4), c(4, 1), c(2, 2), c(3, 2))
gm.line <- st_linestring(linestring_matrix)

# Polygons: require a LIST with the matrices
# (important: first and last vertices must be
# the same)
polygon_list <- list(rbind(c(1, 5), c(2, 2), c(4, 1), c(4, 4), c(1, 5)))
gm.polyg <- st_polygon(polygon_list)

# MULTI SF GEOMETRIES:

# Multipoints: a matrix with coordinates
gm.multipoints <- st_multipoint(linestring_matrix)

# Multilines: use a LIST of matrices (each with
# each lines' coordinates):
multiline_list <- list(rbind(c(1, 5), c(4, 4), c(4, 1), c(2, 2), c(3, 2)), 
                       rbind(c(1, 2), c(2, 4)))
gm.multilines <- st_multilinestring((multiline_list))

# Multipolygons: use a LIST OF LISTS:
## MULTIPOLYGON
multipolygon_list <- list(list(rbind(c(1, 5), c(2, 2), c(4, 1), c(4, 4), c(1, 5))),
                         list(rbind(c(0, 2), c(1, 2), c(1, 3), c(0, 3), c(0, 2))))
gm.multipolyg <- st_multipolygon(multipolygon_list)

# 1.2. CREATING SF COLUMNS:

# SF COMLUMN: GEOMETRY + PROJECTION:

# Remember: ALWAYS use standardized "EPSG:4326" 
# CRS (WGS 84); longitude/latitude:

gm.point <- st_point(c(11.3, 44.4)) # c(longitude,latitude)
gmc.point <- st_sfc(gm.point,crs = 'EPSG:4326')
gmc.point

# 1.3. CREATING SIMPLE FEATURES (SF):

# SIMPLE FEATURE:
#  - SF COLUMN (GEOMETRY + PROJECTION) +
#  - ATTRIBUTE (DATA FRAME)

df.attr <- data.frame(
  name = 'Bologna',
  temperature = 31,
  language = 'Italian'
)

gmsf.point <- st_sf(df.attr,geometry = gmc.point)
gmsf.point
gmsf.point[,'name']
gmsf.point %>% select(name) # dplyr syntax
st_geometry(gmsf.point)

# Plotting with ggplot():
ggplot(gmsf.point) +
  geom_sf()

ggplot(gmsf.point) +
  geom_sf(aes(color=name))

# 1.4. Combining (i.e. plotting) different
# simple features:

# Using the 'world' data from spData:
gmsf.world <- world
gmsf.world
# First plotting with plot()
plot(gmsf.world)
plot(gmsf.world[,'continent'])
plot(gmsf.world %>% select('continent')) # dplyr syntax
plot(st_geometry(gmsf.world)) # only geometry, no attributes

# using ggplot:
ggplot(gmsf.world) +
  geom_sf()
ggplot(gmsf.world) +
  geom_sf(aes(fill=continent))

# Filtering spatial data:
gmsf.EU <- gmsf.world %>% 
  filter(subregion %in% c('Southern Europe'))

ggplot(gmsf.EU) +
  geom_sf(aes(fill=name_long))

# 1.4. Plotting them together (multilayer
# ggplot):

ggplot() + # leave empty, add data to geometry
  geom_sf(data = gmsf.EU) +
  geom_sf(data = gmsf.point)

ggplot() + # leave empty, add data to geometry
  geom_sf(data = gmsf.EU, aes(fill = name_long)) +
  geom_sf(data = gmsf.point)

ggplot() + # leave empty, add data to geometry
  geom_sf(data = gmsf.EU) +
  geom_sf(data = gmsf.point, aes(color = name))

# 1.5. SF WITH EXTERNAL DATA (I.E. COORDS)

rm(list = ls()) # cleaning envrionment

# Hypothetical dataset of cities:
df.cities <- data.frame(
  name = c('Bologna', 'London', 'Madrid', 'Paris'),
  temperature = c(31, 21, 29,28),
  language = c('Italian', 'English', 'Spanish', 'French'),
  longitude = c(11.3,-0.1,-3.7,2.3),
  latitude = c(44.4,51.5, 40.4,48.8)
)

sf.cities <- st_as_sf(df.cities,coords = c('longitude', 'latitude'))
sf.cities # watch out CRS (projection)!
sf.cities <- st_as_sf(
  df.cities,
  coords = c('longitude', 'latitude'),
  crs = 'EPSG:4326'
  )
sf.cities

# Getting EU without Russia for visualization
# (using multiple filtering conditions):

sf.EU <- world %>% 
  filter(continent=='Europe' & name_long!='Russian Federation')

# Plotting as before:
ggplot() + # leave empty, add data to geometry
  geom_sf(data = sf.EU) +
  geom_sf(data = sf.cities, aes(color = name))
# multiple aesthetics (aes):
ggplot() + # leave empty, add data to geometry
  geom_sf(data = sf.EU, aes(fill=subregion)) +
  geom_sf(data = sf.cities, aes(shape = language))

# 1.6. Saving/exporting sf data:

# Save as .rdata (or .RDS) as usual 
# with save():
save(sf.cities, 'sf_cities.rdata')

# Exporting it (e.g. shapefile) with st_write():
st_write(sf.cities,'Sandbox/sf_cities.shp')


# ----

# 2. USING SF WITH EXTERNAL SPATIAL DATA ----

# 2.1. Loading different types of spatial data:

sf.provinces <- st_read('../../../Downloads/ne_110m_admin_1_states_provinces/', 'ne_110m_admin_1_states_provinces')
sf.provinces
# It has too many variables (fields)! Select those that matter!

sf.provinces <- sf.provinces %>% 
  select(name, region, region_sub)

plot(sf.provinces) # recall: plot() creates one plot for each field

ggplot(sf.provinces) +
  geom_sf(aes(fill=region))

# filtering within ggplot:

ggplot(sf.provinces %>% filter(region=='West')) +
  geom_sf(aes(fill=region_sub))

# Altering projections (for manipulation or
# visualization):

# To change the CRS of a sf: use st_transform()

sf.prov.reproj <- st_transform(sf.provinces, crs = "+proj=moll")
# Plotting it:
ggplot(sf.prov.reproj) +
  geom_sf(aes(fill=region))
rm(sf.prov.reproj)

# Changing it directly on the ggplot:
ggplot(sf.provinces) +
  geom_sf(aes(fill=region)) +
  coord_sf(crs = "+proj=moll")
# Other projections:
ggplot(sf.provinces) +
  geom_sf(aes(fill=region)) +
  coord_sf(crs = "+proj=wintri")
ggplot(sf.provinces) +
  geom_sf(aes(fill=region)) +
  coord_sf(crs = "+proj=laea +x_0=0 +y_0=0 +lon_0=-74 +lat_0=40")

# 2.2. Other types of spatial data:

# Geopackage:
sf.andorra <- st_read('../../../Downloads/gadm41_AND.gpkg')
# Has multiple layers: which one to use?
st_layers('../../../Downloads/gadm41_AND.gpkg')
sf.andorra <- st_read('../../../Downloads/gadm41_AND.gpkg', 'ADM_ADM_1')
sf.andorra

# GeoJSON - no need of layer (only directory):
sf.andorra <- st_read('../../../Downloads/gadm41_AND_1.json')

# KMZ (Google Earth) - unzip it (KML file):

# won't work
sf.andorra <- st_read('../../../Downloads/gadm41_AND_1.kmz')
# after unzipping it:
sf.andorra <- st_read('../../../Downloads/gadm41_AND_1.kml')

# ----
































# 
# 
