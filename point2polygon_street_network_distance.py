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
env.workspace = "H:/Personal/Street_Network.gdb"

# convert parks from polygons to lines
arcpy.PolygonToLine_management("parks_dissolved", "parksAsLine")

# merge parks and LION file
arcpy.Merge_management(["Lion_2013/Lion_2013_base", "parksAsLine"], "parkLION_merge")

