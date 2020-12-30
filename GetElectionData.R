#Set Working directory (Yours will differ)
setwd("D:/MIS650")

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

#Create a Percentage column for gop
election.data.wide$gop_2016_percebt<-election.data.wide$gop_2016/election.data.wide$total_2016

election.data.wide$"GOP %"<-
  paste(formatC(election.data.wide$gop_2016_percebt*100, format='f', digits = 1), "%", sep='')

write.csv(my.data.wide, "MyElectionData.csv", 
          row.names = FALSE)

