library(dplyr)
library(stringr)
library(ggplot2)

#### Load data tables ####

# Correct column headers
correct_cols <- c("Catalogue No.","Lot Number","Artist Name 1","Artist Name 2","Artist Name 3","Artist Name 4","Artist Name 5","Title","Annotations","Object Type","Object Notes","Inscription","Seller","Transaction","Buyer","Lot Notes","Previous Owner","Previous Sales","Post Owner","Post Sales","Sale Date","Expert","Commissaire Pr.","Auction House","Sale Location","Lugt Number")

dutch_paintings <- read.csv(
  "../data/dutch_paintings.csv",
  skip=1,
  header=FALSE,
  col.names=correct_cols,
  encoding="UTF-8",
  stringsAsFactors=FALSE
)

#### Generate year column ####
date_pattern <- "^([[:digit:]]{4})"
dutch_paintings$Year <- str_extract(dutch_paintings$Sale.Date, date_pattern)
dutch_paintings$Year <- as.integer(dutch_paintings$Year)

by_year <- group_by(dutch_paintings, Year)
per_year <- summarize(by_year, count=n())

qplot(per_year$Year, per_year$count)
