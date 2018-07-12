# built-environment-obesity
Discovering possible association between childhood obesity and children's built environment in the neighborhood around their homes.

## note
This is a follow-up project built upon the [Food Environment and Obesity](https://github.com/eriliawu/food-environment-obesity/blob/master/README.md#note) project. After examining the associations between food and weight outcomes, it's only natural to wonder how other elements of the environment could affect children's health and weight. 

## conceptual framework and how it works
Parks are essentially polygons. Like calculating point to point euclidean distance, we can also use `nncross` under `spatstat` package or `gDistance` functions under `rgeos` package to get the shortest distance from a point to the nearest polygon. While `nncross` is faster in finding the shortest distance travelled, `gDistance` is more versatile since it is able to compute distance between each point and every polygon in the data.
### point to polygon distance
I want to examine how close or far away parks are located from students and their homes, to understand how the distance between thier homes and the nearest park could be associated with their weight outcomes, i.e. are they more likely or less likely to be overweight or obese? Or is there no association? Using `nncross`, I can convert a set of x-y coordinates into a `ppp` object. With `maptools` package, I can read parks in the form of shapefiles, and convert them into `psp` objects.
### count the number of polygons within certain buffers
While it is important to know how close or far away your nearest park is, it is also critical to understand the bigger picture by looping in the number of parks you have access to within certain distances. What if you are a high school student and the nearest park is a playground that your 7-year-old sibling likes better? So you probably won't hang out with your friends at the playground, but instead you may like this other place with a basketball court, only that one is 5 more minutes of walk for you. To count the number of park polygons within in certain distances, I can use `gDistance` to first compute the distances between every student and the parks in the city, aggregate the results by the type of park(e.g. playgrounds, neighborhood parks, flagship parks like Central Park, etc.), and run a simple `apply` to count the numbers. Of course all these assume students can enter a park at any point on the edge of the polygons, which is empirically not possible, but operationally the best guess I can produce.

## data sources
There are two data sources involved:
1) students' home addresses geocoded into x-y coordinates. Again this is confidential data that I cannot publish on this site, but in essence, any geo points will do;
2) parks: New York City Department of Parks and Recreation surveys all city parks every four years and releases aerial images of the Open Space (Parks) data on NYC Open Data portal. The [most recent year](https://data.cityofnewyork.us/Recreation/Open-Space-Parks-/g84h-jbjm/data) was surveyed in 2012 and released in 2014. Archive data and details of their survey methods are available [here](https://github.com/CityOfNewYork/nyc-planimetrics/blob/master/Capture_Rules.md).
