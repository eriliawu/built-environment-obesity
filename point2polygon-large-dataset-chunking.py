# this script chunks large dataset into smaller bits so ArcGIS is able to compute street network distance
# a complete script of point to point street network distance is available in a the same folder
# https://github.com/eriliawu/built-environment-obesity/blob/master/operationalize-point2point-street-network-distance.md) 

import pandas as pd

closest = pd.read_csv("H:/Personal/Built Environment/Parks/street network distance/from_arc/routes.csv")
closest.columns

# vars to keep from routes features
# FacilityID, IncidentID, Total_Feet
delete = ['OID', 'FacilityRank', 'Name', 'IncidentCurbAppr', 'FacilityCurbAppr', 'Total_Seconds', 'FacilityOID',
          'IncidentOID', 'Shape_Length', 'Total_Kilometers', 'Total_Minutes', 'Total_Miles']

closest.drop(delete, axis=1, inplace=True)
closest.head()

for i in [2, 3]:
    closest2 = pd.read_csv("H:/Personal/Built Environment/Parks/street network distance/from_arc/routes_" + str(i) + ".csv")
    closest2.drop(delete, axis=1, inplace=True)
    closest2.columns = ["FacilityID2", "IncidentID", "Total_Feet2"]
    
    # merge with 2nd batch of results
    closest = pd.merge(closest, closest2, on="IncidentID")
    
    # compare results and keep only the min
    closest["dist"] = closest[["Total_Feet", "Total_Feet2"]].min(axis=1)
    if closest["dist"] < closest["Total_Feet2"]:
        closest.drop(["Total_Feet2", "FacilityID2"], axis=1, inplace=True)
        #closest.columns = ["FacilityID", "IncidentID", "Total_Feet", "dist"]
    elif closest.loc["dist"] < closest.loc["Total_Feet"]:
        closest.drop(["Total_Feet", "FacilityID"], axis=1, inplace=True)
        closest.columns = ["IncidentID", "FacilityID", "Total_Feet", "dist"]
        closest = closest["FacilityID", "IncidentID", "Total_Feet", "dist"]
    else:
        closest.drop(["Total_Feet2"], axis=1, inplace=True)
        closest.columns = ["FacilityID", "IncidentID", "Total_Feet", "FacilityID2", "dist"]
    
