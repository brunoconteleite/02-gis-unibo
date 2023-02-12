# Spatial Data in Economics: Theory and Tools <img style="float: right;width: 15%" src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/Seal_of_the_University_of_Bologna.svg/800px-Seal_of_the_University_of_Bologna.svg.png">
Contents of the course on spatial data (a.k.a. [GIS Tools Laboratory](https://www.unibo.it/en/teaching/course-unit-catalogue/course-unit/2022/434986))<br>
[Bruno Conte](https://brunoconteleite.github.io/) | [b.conte@unibo.it](mailto:b.conte@unibo.it)<br>
LMEC Master - Università di Bologna
 
## Overview

This is a master/Ph.D. course on basic theory and tools for using spatial data in economic research.

All practical applications are taking place in ``R`` and ``RStudio``. **Please have both installed in your computer** before starting the course.

## Course structure

This is a 15 hours course, divided in five sessions of 3 hours. Its overall structure follows:

* **Session 1:** Introduction to spatial data and data wrangling in R
  * Basic aspects of `R` (`data.table`, `tidyverse`, `ggplot2`), spatial data, and applications in economic research
  
  * Class slides in **[html](https://brunoconteleite.github.io/02-gis-unibo/00_class01.html)** and **[pdf](https://brunoconteleite.github.io/02-gis-unibo/00_class01.pdf)**
  
  * Hands-in material **[here](https://www.dropbox.com/s/gyjmlxnqk24u312/01_class01.R?dl=1)**

* **Session 2:** Vector spatial data (points, lines, and polygons)
  * Loading and manipulating with ``sf``. Basic principles of spatial (re)projections. Basic attribute data operations (e.g. ``filter()``, ``slice()``) with ``data.table`` and data  visualization with ``ggplot2``
  
  * *Assignment:* replicating maps spatial summary statistics from academic papers. Instructions here
  
  * Class slides here
  
  * Hands-in material here

* **Session 3:** Spatial data operations with vector data
  * Spatial Subsetting and topological relations (e.g. ``st_intersects()``, ``st_overlaps()``, ``st_touches()``), spatial joining and aggregation (e.g. ``st_join()``, ``aggregate()``), and calculating distances (and spatial networks) with ``gdistance``, ``rgeos``, and ``igraph``
  
  * *Assignment:* reproducing operations with proposed data and replicating results from academic papers. Instructions here
  
  * Class slides here
  
  * Hands-in material here
  
* **Session 4:** Spatial geometry operations and miscelania
  * Basic operations with vector data (e.g. centroids, shift, rotate, buffering)
  
  * Time allowing: Reporting data work with `R`: a short introduction to `rmarkdown`
  
  * *Class follow-up:* feedback on course pace, reinforcing concepts, etc.
  
  * Class slides here
  
  * Hands-in material here

* **Session 5:** Raster data
  * Loading and manipulating raster data with ``terra``. Basic raster operations (e.g. ``resample``, ``stack``, ``brick``, ``crop``)
  
  * Managing curse of dimensionality and large disk and memory needs for dealing with raster data
  
  * Raster-vector operations with ``terra`` and ``exactextractr`` (e.g. extracting, rasterizing, vectorizing, zonal statistics)
  * *Conclusion:* follow-up on important concepts and (potentially) holding short presentations of research projects
  
  * *Assignment:* replication of results and spatial statistics from academic papers. Instructions here
  
  * Class slides here
  
  * Hands-in material here

## References

* Donaldson, D. and Storeygard, A., 2016. The view from above: Applications of satellite data in economics. *Journal of Economic Perspectives*, *30(4)*, pp.171-98.

* Lovelace, R., Nowosad, J. and Muenchow, J., 2019. Geocomputation with R. Chapman and Hall/CRC.

* Pebesma, E., 2018. Simple Features for R: Standardized Support for Spatial Vector Data. *The R Journal*, *10 (1)*, 439-446, https://doi.org/10.32614/RJ-2018-009

* Wickham, H. and Grolemund, G., 2016. R for data science: import, tidy, transform, visualize, and model data. " O'Reilly Media, Inc.".
