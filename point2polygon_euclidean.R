
setwd("")

### load packages ----
suppressWarnings(library(sp)) #to prep using gDistance
suppressWarnings(library(spatstat)) #nncross
suppressWarnings(library(maptools)) #readShapeLines; read shapefiles
suppressWarnings(library(rgeos)) #gDistance
suppressWarnings(library(rgdal))
suppressWarnings(library(geosphere))

### read student data ----
students <- read.csv("students0.csv", stringsAsFactors = FALSE) #clean up the data so it has two columns: x and y

### euclidean distance, nearest park ----
### use nncross
# convert students into ppp object
coords.students <- ppp(students$x, students$y, 
                       window=owin(xrange=c(0, max(students$x)), 
                                   yrange=c(0, max(students$y))))

# read parks
parks <- readOGR("C:/Users/klv248/Downloads/Open Space (Parks) (1)", "geo_export_42d3128f-1214-47cc-864d-0191f081860d")
parks <- as(parks,"SpatialLines")
parks <- as.psp(parks)


# find nearest park
dist <- nncross(coords.students, parks)
students <- cbind(students, dist)
colnames(students)[3] <- "nearest"
write.csv(students, "dist_to_nearest0.csv")


#get coordinates for nearest park boundary by student
coords.parks <-xy.coords(parks, x)
which.parks<- nnwhich(coords.students,parks)
which.students<- cbind(students,which.parks)
write.csv(coords.parks,"park coordinates.csv")

### count the num of parks ----
park.info <- read.csv("parks_with_landuse.csv", stringsAsFactors = FALSE) #provides unique park ids (var: parknum) and the type of park (var: landuse)
names(park.info) #clean up so that park.info has 2 vars: parknum and landuse

parks <- readOGR(".","parks_with_landuse") #gDistance reads polygons as SpatialPolygons feture class

#create functions to count numbr of parks within different parameters
# buffers: 40, 264, 660, 1320, 2640 ft
# these buffers roughly represent the width of a street, one city block, 1/8 of a mile, a quarter of a mile and half a mile
# how wide should a street be: 
mdesc

# export raw results first for archive
write.csv(dist, "raw_output0.csv")

# find nearest park by landuse
group <- data.frame(t(dist))
group$landuse <- parks$landuse
group <- aggregate(group, by=list(group$landuse), min)
group$Group.1 <- NULL
group <- data.frame(t(group))
colnames(group) <- as.character(unlist(group["landuse", ]))
group <- group[-(row+1), ]
dist <- cbind(dist, group)

# find nearest park and count the num of parks
dist$nearest <- apply(dist[, 1:col], 1, min) #this is essentially the same as using nncross in the previous part of the script
dist$n40 <- apply(dist[, 1:col], 1, sum40)
dist$n264 <- apply(dist[, 1:col], 1, sum264)
dist$n660 <- apply(dist[, 1:col], 1, sum660)
dist$n1320 <- apply(dist[, 1:col], 1, sum1320)
dist$n2640 <- apply(dist[, 1:col], 1, sum2640)

dist <- dist[, -c(1:col)]
dist.all <- cbind(students, dist)
write.csv(dist.all, "nearest_count_park0.csv")
