# operationalize `FindClosestFacility` in Network Analyst

## the problem
As wonderful as it it to simply run `arcpy.na.FindClosestFacility`, when we have a large dataset, often times ArcGIS returns an "out of memory" error.

### why it happens
Simply put, it's because ArcGIS is a poorly written 32-bit software that cannot access more than 2G RAM for each analysis.

## possible solutions
### increase the amount of memory ArcGIS has access to
If you have access to a device with larger memory (>2G RAM), consider flag large address aware in Microsoft Visual Studio. Everything is quite well explained in [this post](https://gisgeek.blogspot.com/2012/01/set-32bit-executable-largeaddressaware.html). Note that this post is tested with VS2010, and Microsoft currently is at VS2017. You may find different path names.
### manual solution
However, when you have tens of thousands of data points to compute like I do, even a good machine may run out of memory. When I tested running ~200k students vs. 1000 points on parks, the same "out of memory" error showed up, which means for the complete analysis which involves running ~200k students vs. ~80k points on parks, it's unlikley my 16G RAM machine can handle the computation even when ArcGIS is able to access more than 2G RAM. ArcGIS development team is of course aware of their software's limitations and provides a solution to [manually change settings](https://support.esri.com/en/technical-article/000011110) so that ArcGIS chunks its data into smaller groups and erase the memory when each chunk is completed, in order to keep the accessed memory within the limit.
### how to approach with arcpy
