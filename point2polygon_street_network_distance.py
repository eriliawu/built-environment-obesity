### street network distance
### point to polygon

import arcpy
from arcpy import env

#set working environment
env.workspace = "Street_Network.gdb"

# convert parks from polygons to lines
arcpy.PolygonToLine_management("parks_dissolved", "parksAsLine")

# merge parks and LION file
arcpy.Merge_management(["Lion_2013/Lion_2013_base", "parksAsLine"], "parkLION_merge")
