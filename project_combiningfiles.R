rm(list=ls())

setwd("C:/Users/14148/Documents/Iowa/FA21/Data Wrangling/Project")

#Read in data
poverty <- read.csv("poverty.csv", sep=",", na.strings = c(""), stringsAsFactors = TRUE)
drowningRates <- read.csv("drowningrates.csv", sep=",", na.strings = c(""), stringsAsFactors = TRUE)

#Unify column names
colnames(drowningRates) <- c("State","County","FIPS","Deaths")
colnames(poverty) <- c("County","FIPS","State","Population","Poverty")

#Remove state abbreviations from counties
drowningRates$County <- gsub(", IL","",drowningRates$County)
drowningRates$County <- gsub(", IN","",drowningRates$County)
drowningRates$County <- gsub(", IA","",drowningRates$County)
drowningRates$County <- gsub(", KS","",drowningRates$County)
drowningRates$County <- gsub(", MI","",drowningRates$County)
drowningRates$County <- gsub(", MN","",drowningRates$County)
drowningRates$County <- gsub(", MO","",drowningRates$County)
drowningRates$County <- gsub(", NE","",drowningRates$County)
drowningRates$County <- gsub(", ND","",drowningRates$County)
drowningRates$County <- gsub(", OH","",drowningRates$County)
drowningRates$County <- gsub(", SD","",drowningRates$County)
drowningRates$County <- gsub(", WI","",drowningRates$County)

#Change state format to abbreviation
drowningRates$State <- gsub("Illinois","IL",drowningRates$State)
drowningRates$State <- gsub("Indiana","IN",drowningRates$State)
drowningRates$State <- gsub("Iowa","IA",drowningRates$State)
drowningRates$State <- gsub("Kansas","KS",drowningRates$State)
drowningRates$State <- gsub("Michigan","MI",drowningRates$State)
drowningRates$State <- gsub("Minnesota","MN",drowningRates$State)
drowningRates$State <- gsub("Missouri","MO",drowningRates$State)
drowningRates$State <- gsub("Nebraska","NE",drowningRates$State)
drowningRates$State <- gsub("North Dakota","ND",drowningRates$State)
drowningRates$State <- gsub("Ohio","OH",drowningRates$State)
drowningRates$State <- gsub("South Dakota","SD",drowningRates$State)
drowningRates$State <- gsub("Wisconsin","WI",drowningRates$State)

#Merge files
temp <- merge(drowningRates, poverty, by = "FIPS")

#Clean new dataframe
finalData <- subset(temp, select = c(FIPS,State.x,County.x,Population,Poverty,Deaths))
colnames(finalData) <- c("FIPS","State","County","Population","Poverty","DrowningDeaths")
finalData$PovertyRatio <- (finalData$Poverty / finalData$Population)
finalData$DeathRatio <- (finalData$`DrowningDeaths` / finalData$Population) 

#Write to a file
write.csv(finalData, "finaldata.csv")

#Save .rda file
save.image("project_combiningfiles.rda")
