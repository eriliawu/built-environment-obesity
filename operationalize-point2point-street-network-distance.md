# operationalize `FindClosestFacility` in Network Analyst

## the problem
As wonderful as it it to simply run `arcpy.na.FindClosestFacility`, when we have a large dataset, often times ArcGIS returns an "out of memory" error.

### why it happens
Simply put, it's because ArcGIS is a poorly written 32-bit software that cannot access more than 2G RAM for each analysis.

## manual solution
ArcGIS development team is of course aware of their software's limitations and provides a solution to [manually change settings](https://support.esri.com/en/technical-article/000011110) so that ArcGIS chunks its data into smaller groups and erase the memory when each chunk is completed, in order to keep the accessed memory within the limit.

## how to approach with arcpy
