# references
# 1] network analyst module
# https://resources.arcgis.com/en/help/main/10.2/index.html#//004800000028000000
# 2] connect anaconda and arcpy
# https://gis.stackexchange.com/questions/119503/getting-arcpy-to-work-with-anaconda#119507

import arcpy
from arcpy import env

#Check out the Network Analyst extension license
arcpy.CheckOutExtension("Network")
env.overwriteOutput = True

# set up work environment
env.workspace = "Street_Network.gdb"

# convert parks from polygons to lines
arcpy.PolygonToLine_management("parks_dissolved", "parksAsLine")

# merge parks and LION file
arcpy.Merge_management(["Lion_2013/Lion_2013_base", "parksAsLine"], "parkLION_merge")

# insersect parkLION and parksAsLine
arcpy.Intersect_analysis(["parkLION_merge", "Lion_2013/Lion_2013_base"], "parkIntersectPoints", "", "", "point")

# select intersection points by location
# select feature from
# target layer: parkIntersectPoints
# source layer: parks_dissolved
# are within a distance of the source layer feature
# search radius: 30 ft, 45 ft, 60ft
radius = ["30 feet", "45 feet", "60 feet"]
for distance in radius:
    select = arcpy.SelectLayerByLocation_management("parkIntersectPoints", "WITHIN_A_DISTANCE", "parks_dissolved", distance, "NEW_SELECTION", "NOT_INVERT")
    arcpy.FeatureClassToFeatureClass_conversion(select, r"Street_Network.gdb", "parkEntrances_"+distance)

# find closest facility
# load park points as facilities
# load students as incidents
# Access the analysis preferences by clicking on the file button next to the drop-down menu the network analyst window 
# (where you loaded the students and restaurants)
# Under the Analysis Settings tab, make sure you set Facilities to Find to 1,
# and Travel from should be Incident to Facility (Radio button)
# Click Solve in the network analyst toolbar (grid with squiggly line)

streetNetwork = r'H:/Personal/Street_Network.gdb'
incidents = r'H:/Personal/Street_Network.gdb/s_all' #use unique student x-y of all years
facilities = r'H:/Personal/Street_Network.gdb/parkEntrances_30ft'
outGeodatabase = r'H:/Personal/Street_Network.gdb/Lion_2013'

# Run FindClosestFacilities. Choose to find only the closest facility.
arcpy.na.FindClosestFacilities(incidents, facilities, "Feet", streetNetwork, outGeodatabase, "Routes", 
                               "Directions", "nearestPark_30ft",
                               Number_of_Facilities_to_Find=1)

