# compute street network distance between parks and student homes

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
# search radius: 30 ft, 45 ft, 60 ft
# feature class has to be converted to feature layer, b/c ft class cannot be used in select management
arcpy.MakeFeatureLayer_management("parkIntersectPoints", "parkIntersectPoints_layer") 
arcpy.MakeFeatureLayer_management("parks_dissolved", "parks_dissolved_layer")

radius = [30, 45, 60]
for r in radius:  
    select = arcpy.SelectLayerByLocation_management("parkIntersectPoints_layer", "WITHIN_A_DISTANCE", 
                                                    "parks_dissolved", str(r)+" feet", "NEW_SELECTION", "NOT_INVERT")
    arcpy.FeatureClassToFeatureClass_conversion(select, r"Street_Network.gdb", "parkEntrances_"+str(r))

# find closest facility
# find closest facility
# write a loop to cover 5 years
# inner loop to cover 30, 45 and 60 ft radiuses
years = ["09", "10", "11", "12", "13"]

for t in years:
    streetNetwork = r'Street_Network.gdb/Lion_20' + t +'/Lion_20' + t + '_Network'
    incidents = r'Street_Network.gdb/s' + t
    outGeodatabase = r'Street_Network.gdb'
    for r in radius:
        facilities = r'Street_Network.gdb/parkEntrances_' + str(r)
        closestFacility = "nearestPark_" + str(r) + "_" + t
        # Run FindClosestFacilities. Choose to find only the closest facility
        arcpy.na.FindClosestFacilities(incidents, facilities, "Feet", streetNetwork, outGeodatabase, "route", 
                               "directions", "closestFacility", Number_of_Facilities_to_Find=1)
        arcpy.TableToTable_conversion(outGeodatabase + "/" + closestFacility,
                                     r"output_folder",
                                     closestFacility + ".csv")
