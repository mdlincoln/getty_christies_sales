library(dplyr)
library(stringr)
library(ggplot2)
library(lubridate)

#### Load data tables ####

# Correct column headers
correct_cols <- c("Catalogue No.","Lot Number","Artist Name 1","Artist Name 2","Artist Name 3","Artist Name 4","Artist Name 5","Title","Annotations","Object Type","Object Notes","Inscription","Seller","Transaction","Buyer","Lot Notes","Previous Owner","Previous Sales","Post Owner","Post Sales","Sale Date","Expert","Commissaire Pr.","Auction House","Sale Location","Lugt Number")

base_dutch_paintings <- read.csv(
  "../data/dutch_paintings.csv",
  skip=1,
  header=FALSE,
  col.names=correct_cols,
  encoding="UTF-8",
  stringsAsFactors=FALSE
)

dutch_paintings <- base_dutch_paintings

#### Generate date columns ####
date_pattern <- "^(.{11})"
dutch_paintings$Date <- ymd(str_extract(dutch_paintings$Sale.Date, date_pattern))
dutch_paintings$Year <- as.integer(year(dutch_paintings$Date))
dutch_paintings$Month <- as.factor(month(dutch_paintings$Date))

# Periods

period <- 1770
while(period<1840) {
  start <- period
  end <- period + 10
  per_name <- paste(start,"-",end)
  print(per_name)
  dutch_paintings$Period[dutch_paintings$Year>=start & dutch_paintings$Year<end] <- per_name
  period <- end
}

dutch_paintings$Period <- as.factor(dutch_paintings$Period)
ggplot(dutch_paintings, aes(x=Month)) + geom_bar(stat="bin") + facet_wrap(~ Period)

#### Group and plot by year and month ####
by_year <- dutch_paintings %.% group_by(Year) %.% summarize(count=n())
ggplot(by_year, aes(x=Year, y=count)) + geom_point()

by_month <- dutch_paintings %.% group_by(Month) %.% summarize(count=n())
ggplot(by_month, aes(x=Month, y=count)) + geom_bar(stat="identity")
