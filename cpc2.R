#Set Working directory (Yours will differ)
setwd("C:/Users/KJadeja/Desktop/Kiran GCU Assignment/MIS-650-XC0523R2-Performing Analytics Using Statistical a Language/week6")

# load library maps (you will have to install it once using "Install pacakge(s)")
library(maps)

#Load the fips data from the maps package, this translates a fips code to a state and county anme
fips.data <- county.fips

# File has one row per country and election year
data.wide <- read.delim("ElectionData.txt", header=TRUE, sep = '\t', stringsAsFactors = FALSE)
election.data.wide <- merge(x=data.wide, y=fips.data, by.x="fips_code", by.y="fips")
election.data.wide$State = substr(election.data.wide$polyname, 1, regexpr(",", election.data.wide$polyname)-1)

#Change to your state
my.data.wide <- election.data.wide[toupper(election.data.wide$State) ==  "NEW JERSEY",]

#write.csv(my.data.wide, "MyElectionData.csv", row.names = FALSE)

#code for CPC2

counties<-c("Morris County","Salem County","Gloucester County")
col.2008<-c("dem_2008","gop_2008","oth_2008")
col.2012<-c("dem_2012","gop_2012","oth_2012")
col.2016<-c("dem_2016","gop_2016","oth_2016")
labl<-c("Dem","GOP","Other")
colors<-c("Blue","Red","Green")

for(county in counties)
{
  county.data=my.data.wide[my.data.wide$county == county,]
  
  pie(as.numeric(county.data[1,col.2008]),
      labels = labl,col = colors,main = paste(county,'2008'))
  
  pie(as.numeric(county.data[1,col.2012]),
      labels = labl,col = colors,main = paste(county,'2012'))
  
  pie(as.numeric(county.data[1,col.2016]),
      labels = labl,col = colors,main = paste(county,'2016'))
}
