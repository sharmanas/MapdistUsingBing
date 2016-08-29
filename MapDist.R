# Find distance between two addresses (or ZIP codes) using Bing's API

## Set working directory
setwd("C:/Users/mxs67/Desktop/Lennox")

## Read excel file containing addresses
address <- read.xlsx("Address.xlsx")

## Add leading zeros in order to make ZIP codes uniform with 5 digits
address$Zip.A <- sprintf('%05d', address$Zip.A)
address$Zip.B <- sprintf('%05d', address$Zip.B)

## Calculate distances using 'georoute' function in "taRifx.geo" package
address$Distance <- 0
library(taRifx.geo)
options(BingMapsKey="YourBingMapsKey") ## Get your key at https://msdn.microsoft.com/en-us/library/ff428642.aspx
mapper <- function(x) {
  for(i in 1:nrow(x)) {
    x[i, ]$Distance <- georoute(c(x[i, ]$Zip.A, x[i, ]$Zip.B), 
                                returntype = "distance", service = "bing")
  }
  x
}
distance.address <- mapper(address)
distance.address$Distance <- unlist(distance.address$Distance)
distance.address$Miles <- round(distance.address$Distance*0.62, digits=2)
write.csv(distance.address, "Distance Address.csv", row.names=FALSE)

## Sometimes the server throws following error message -
## Error in parse.json[[service]](j) : 
## Something went wrong. Bing Maps API return status code 500 - Internal Server Error 
## Try splitting the data into smaller chunks and run the function on them, one by one 