# test script for R training workshop
# r-novice-inflammation

setwd("S:/Personal/hw1220/R-training/r-novice-inflammation/r-novice-inflammation-data/data")
data <- read.csv("inflammation-01.csv", header=FLASE, stringsAsFactor=FALSE)
dim(data) #shape() in Python
head(data, n=10) #read the first 10 lines of the dataset
length() #to get the length of a vector or a list; dim() only works for a data.frame
max(data[2, ])
summary(data[, 2])
apply(data, 1, mean) #calculate the mean value for each row; 

# plot data
avg_patient <- apply(data, 1, mean)
plot(avg_patient) #R will automatically plot the data on y-axis and use the indices on x-axis
dev.new() #open a new window so that a new plot will show up in the new window and not override the old plot

#write a function
#note: if intend to return multiple values from a new function,
#it has to be assigned to a vector instead of just separate values
fahr_to_celcius <- function(temp) {
  new <- fahr_to_kelvin(temp)
  new <- kelvin_to_celcius(temp)
  return(new)
}

fence <- function(original, wrapper="**") {
  new <- c(wrapper, original, wrapper)
  return(new)
  print(new)
}

# loops
analyze <- function(filename) {
  #plot the mean, min, max
  # read .csv file
  data <- read.csv(file=filename, header=FALSE)
  avg_day_inflammation <- apply(data, 2, mean)
  min_day_inflammation <- apply(data, 2, min)
  max_day_inflammation <- apply(data, 2, max)
  plot(avg_day_inflammation, main=paste(filename, "-avg", sep=""))
  dev.new()
  plot(min_day_inflammation, main=paste(filename, "-min", sep=""))
  dev.new()
  plot(max_day_inflammation, main=paste(filename, "-max", sep=""))
}

# writing loops
print_sentence <- function(sentence) {
  for (i in sentence) {
    return(i)
    print(i)
  }
}

print_number <- function(num) {
  for (i in 0:num) {
    #return(i)
    print(i)
    new_num <- new_num + i
  }
  return(new_num)
}

#see what files and folders are available
analyze_all <- function(path=".", pattern) {
  files <- list.files(path=path, pattern=pattern)
  for (file in files) {
    pdf(file=paste("/personal/hw1220", filename, ".pdf", sep="")) #
    analyze(file)
    dev.off() #so that the plot isnt printed on the screen
  }
}

#logical operator
#boolean
sign <- function(x) {
  if (!is.numeric(x)) {
    stop("error msg: x has to be numeric")
    #return(NULL)
  }
  if (x<0) {
    return(-1)
  } else if (x==0) {
    return(0)
  } else {
    return(1)
  }
}

plot_dist <- function(data, threshold=10) {
    if (length(data)<=threshold) {
      stripchart(data)
    } else {
      boxplot(data)
    }
}


















