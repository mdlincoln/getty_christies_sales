library(dplyr)
library(stringr)
library(ggplot2)
library(lubridate)

#### Load data tables ####

# Correct column headers
correct_cols <- c("Catalogue No.","Lot Number","Artist Name 1","Artist Name 2","Artist Name 3","Artist Name 4","Artist Name 5","Title","Annotations","Object Type","Object Notes","Inscription","Seller","Transaction","Buyer","Lot Notes","Previous Owner","Previous Sales","Post Owner","Post Sales","Sale Date","Expert","Commissaire Pr.","Auction House","Sale Location","Lugt Number")

# Read in CSV, fixing encoding and using corrected column headers
base_sales <- read.csv(
  "../data/sales.csv",
  skip=1,
  header=FALSE,
  col.names=correct_cols,
  encoding="UTF-8",
  stringsAsFactors=FALSE
)

# Create working data frame
sales <- base_sales

#### Generate date columns ####
date_pattern <- "^(.{11})"
sales$Date <- ymd(str_extract(sales$Sale.Date, date_pattern))
sales$Year <- as.integer(year(sales$Date))
sales$Month <- as.factor(month(sales$Date))

#### Plot all by year and month ####
by_year <- sales %.% group_by(Year) %.% summarize(count=n())
sales_by_year <- ggplot(by_year, aes(x=Year, y=count)) + 
  geom_point() +
  geom_smooth() +
  ggtitle("Christie's Sales per Year")
svg("../plots/sales_by_year.svg", width=11, height=8.5)
sales_by_year
dev.off()

sales_by_month <- ggplot(sales, aes(x=Month)) + 
  geom_bar(stat="bin") +
  ggtitle("Christie's Sales by Month")
svg("../plots/sales_by_month.svg", width=11, height=8.5)
sales_by_month
dev.off()

#### Generate period facets ####
period <- 1770
while(period<1840) {
  start <- period
  end <- period + 10
  per_name <- paste(start,"-",end)
  print(per_name)
  sales$Period[sales$Year>=start & sales$Year<end] <- per_name
  period <- end
}

faceted_months <- ggplot(sales, aes(x=Month)) + 
  geom_bar(stat="bin") + 
  facet_wrap(~ Period) +
  ggtitle("Christie's Sales by Month, Faceted By Decade")
svg("../plots/faceted_sales_by_month.svg", width=11, height=8.5)
faceted_months
dev.off()
