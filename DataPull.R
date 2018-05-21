library(downloader)
library(plyr)

#make temp file
temp <- tempfile()

#download zip
download.file("https://coinmetrics.io/data/all.zip",temp)

#unzip csv into reference data folder
unzip (temp, exdir = "Insert Your Own Directory for CSVs Here")

#unlink temp file
unlink(temp)

# get the csv files
csv_files <- list.files(path = "Insert Your Own CSV Directory Here", pattern = "*.csv")
financials <- c("dxy.csv", "sp500.csv", "gold.csv", "liborusd.csv")

#csv_files %in% financials
csv_files <- csv_files [!csv_files %in% financials]

#Set WD for CSV Folder
setwd("Insert Your Own CSV Directory Here")

#Column Names Manually Entered. Default is missing comma in ID Row complicating import
colnames <- c("Date", "txVolume", "txCount", "MarketCap", "Price", "exchangeVol", "generatedCoins","Fees", "activeUsers", "Null")

#Create Blank List for Tokens
token.data<-list()

#Import CSV files into R List with above noted columns
for (i in 1:length(csv_files))
{
  token.data[[i]]<-read.csv(csv_files[i], header = F, skip = 1, col.names = colnames)
}

#Name List Items
names(token.data)<- gsub('.csv', '', csv_files)

#Column Names for Financials Dataset
colnames <- c("Date", "Index", "Null")

#Create Blank List for Financials Data
financials.data<-list()

#Import CSV files into R List with above noted columns
for (i in 1:length(financials))
{
  financials.data[[i]]<-read.csv(financials[i], header = F, skip = 1, col.names = colnames)
}

#Name Financials Data List Items
names(financials.data) <-  gsub('.csv', '', financials)

#Set WD back to defauls
setwd("Reset WD back to your default directory")

#Remove Null Columns from List items

token.data <- lapply(token.data, function(x) { x["Null"] <- NULL; x }) #Remove Null Column

#Format Dates
token.data <- lapply(token.data, function(x) {
  x$Date <- as.Date(x$Date)
  x})

financials.data <- lapply(financials.data, function(x) { x["Null"] <- NULL; x }) #Remove Null Column

#Format Dates
financials.data <- lapply(financials.data, function(x) {
  x$Date <- as.Date(x$Date)
  x})
