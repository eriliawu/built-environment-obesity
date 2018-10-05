# euclidean distance
# calculate the nearest distance to a park
# calculate the number of parks within certain parameters

### load packages ----
suppressWarnings(library(sp)) #to prep using gDistance
suppressWarnings(library(spatstat)) #nncross
suppressWarnings(library(maptools)) #readShapeLines; read shapefiles
suppressWarnings(library(rgeos)) #gDistance

### read student data ----
students <- read.csv("students.csv", stringsAsFactors = FALSE) #clean up the data so it has two columns: x and y

### euclidean distance, nearest park ----
### use nncross
# convert students into ppp object
coords.students <- ppp(students$x, students$y, 
               window=owin(xrange=c(0, max(students$x)), 
                           yrange=c(0, max(students$y))))

# read parks
parks <- readShapeLines("parks.shp")
parks <- as.psp(parks)

# find nearest park
dist <- nncross(coords.students, parks, what="dist")
students <- cbind(students, dist)
colnames(students)[3] <- "nearest"
write.csv(students, "dist_to_nearest.csv")

### count the num of parks ----
park.info <- read.csv("list_of_parks.csv", stringsAsFactors = FALSE) #provides unique park ids (var: parknum) and the type of park (var: landuse)
names(park.info) #clean up so that park.info has 2 vars: parknum and landuse

parks <- readShapeSpatial("parks.shp") #gDistance reads polygons as SpatialPolygons feture class

#create functions to count numbr of parks within different parameters
# buffers: 40, 264, 660, 1320, 2640 ft
# these buffers roughly represent the width of a street, one city block, 1/8 of a mile, a quarter of a mile and half a mile
# how wide should a street be: 
# http://plannersweb.com/2013/09/wide-neighborhood-street-part-1/
sum40 <- function(x) { #park is right across the street
      num <- sum(x<40)
      return(num)
}

sum264 <- function(x) { #1 city block
      num <- sum(x<264)
      return(num)
}

sum660 <- function(x) { #1/8 of a mile
      num <- sum(x<660)
      return(num)
}

sum1320 <- function(x) { #1 quarter of a mile
      num <- sum(x<1320)
      return(num)
}

sum2640 <- function(x) { #half a mile
      num <- sum(x<2640)
      return(num)
}

# slice students into smaller groups to calculate student to park distance
coords.students <- SpatialPoints(students)
dist <- gDistance(parks, coords.students，byid=TRUE)
dist <- as.data.frame(dist)
row <- dim(dist)[1]
col <- dim(dist)[2]
colnames(dist)[1:col] <- park.info$parknum
# export raw results first for archive
write.csv(dist, "raw_output.csv")

# find nearest park by landuse
group <- data.frame(t(dist))
group$landuse <- park.info$landuse
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
dist.all <- cbind(students, dist.all)
write.csv(dist.all, "nearest_count_park.csv")
