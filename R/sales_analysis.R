library(dplyr)
library(stringr)
library(ggplot2)

#### Load data tables ####
dutch_paintings <- read.csv(
  "../data/dutch_paintings.csv",
  header=TRUE,
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
