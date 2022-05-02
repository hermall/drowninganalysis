rm(list=ls())

setwd("C:/Users/14148/Documents/Iowa/FA21/Data Wrangling/Project")

#Read in data
data <- read.csv("finaldata.csv", row.names = 1)

data$PovertyLevel <- cut(data$PovertyRatio, breaks = 3, c("Low","Mid", "High"))

#Make scatter plot
library(ggplot2)
library(RColorBrewer)
qqplot(data$Population, data$DrowningDeaths, main = "Drowning Deaths per County in the Midwest", xlab = "County Population", ylab = "Number of Drowning Deaths", col = "blue")
qqplot(data$Poverty, data$DeathRatio, main = "Drowning Ratio vs. Population in Midwest Counties", xlab = "Number of People in Poverty", ylab = "Drowning Death Ratio", col = "orange")
boxplot(data$Poverty)

#Run correlation test
drowning$DeathRatio <- gsub("%", "", drowning$DeathRatio) 
drowning$PovertyRatio <- gsub("%", "", drowning$PovertyRatio)

str(drowning)

drowning$DeathRatio <- as.numeric(drowning$DeathRatio)
drowning$PovertyRatio <- as.numeric(drowning$PovertyRatio)

cor.test(drowning$Population, drowning$DeathRatio)
cor.test(drowning$Poverty, drowning$DeathRatio)

#dplyr
library(dplyr)

summary(data$Population)

data$popSize <- cut(data$Population, breaks = c(0,41624,158926,6000000),  c("Small","Medium","Large"))

data$popSize

summary(data$popSize) 

summary(data$Population) 

data$PovertyRatio<- gsub("%"," ",data$PovertyRatio)
data$PovertyRatio<- as.numeric(data$PovertyRatio)

PovertySUM <- data %>%  
  group_by(popSize)  %>%
  summarise(Average = mean(PovertyRatio),Max = max(PovertyRatio),Min = min(PovertyRatio),Median = median(PovertyRatio))

#Save .rda file
save.image("project_data-analysis.rda")
