library(xml2)
library(jsonlite)


##Poverty data scraping
url<- "https://www.povertyusa.org/data/2019"
url1<- read_html(url)

county_data<- xml_text(xml_find_all(url1,"//script[@type='application/json']"))
##Website parsing
json_read<- fromJSON(county_data)
regions<-json_read$data_application$regions

regions<-subset(regions, level == 'county' &
                     parent_abbr =='OH' |
                  parent_abbr =='MI' |
                  parent_abbr =='IN' |
                  parent_abbr =='IL' |
                  parent_abbr =='WI' |
                  parent_abbr =='MN' |
                  parent_abbr =='IA' |
                  parent_abbr =='MO' |
                  parent_abbr =='ND' |
                  parent_abbr =='SD' |
                  parent_abbr =='NE' | 
                  parent_abbr =='KS' ,
                  select = c('level', 'name', 'abbr', 'id', 'parent_abbr')) ###Selects only states in the MidWest (972 counties)

##County url list creation
county_list <- subset(regions, select = c("parent_abbr", "abbr"))
counties<-as.list(regions$abbr)
states<- as.list(regions$parent_abbr)
slash <- rep("/", 72) # 1055)
slash <- as.list(slash)
midwest_combo_list<- paste(states, slash, counties)
midwest_combo_list<- gsub(" ", "", midwest_combo_list)
#midwest_combo<-as.data.frame(midwest_combo_list)

#poverty and population data collected here
n <- 0
m <- length(midwest_combo_list)
population2 <- character(0)
poverty2 <- character(0)
for (i in midwest_combo_list){
   
   if (n == m){ 
      break
   }
   n<-n+1
   url2<-paste("https://www.povertyusa.org/data/2019/",i, sep="")
   url2<-as.character(url2)
   print(url2)
   print(n)
   read_page <- read_html(url2)
   
   pop_stat<- xml_text(xml_find_all(read_page,"//script[@type='application/json']"))
   json_read2<-fromJSON(pop_stat)
   
   stat_data<-json_read2$data_application$stats
   
   population<- subset(stat_data, stat_data$path == "overview.population", select = value)
   population2<- c(population, population2)
   
   poverty<-subset(stat_data, stat_data$path == "overview.in_poverty", select = value)
   poverty2<- c(poverty, poverty2)
   
}
print("FINISHED!")


population3 <- do.call(rbind.data.frame, rev(population2))
poverty3 <-do.call(rbind.data.frame, rev(poverty2))
df<-data.frame(population3, poverty3)
df <- data.frame(regions, df)#converts all relevant info to single dataframe

colnames(df)[4] <- "FIPS"
colnames(df)[5] <- "State"
colnames(df)[6] <- "Population"
colnames(df)[7] <- "Poverty"


write.csv(df, file="povertyData.csv")