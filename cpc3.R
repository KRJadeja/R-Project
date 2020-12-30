#Set Working directory (Yours will differ)
setwd("C:/Users/KJadeja/Desktop/Kiran GCU Assignment/MIS-650-XC0523R2-Performing Analytics Using Statistical a Language/week8")

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

#code for CPC3

#County vector for looping
counties<-c("Morris County","Salem County","Gloucester County")

#vote your counties, columns and your parties votes over the past 3 elections
years<-c(2008,2012,2016)
vote.columns<-c("dem_2008","dem_2012","dem_2016")
l<-list()

#Going to loop through the counties vector created above
for(county in counties)
{
  #Load votes into a vector
  votes<-as.numeric(my.data.wide[my.data.wide$county==county, vote.columns])
  
  #create a data frame with the static year and the votes
  df<-data.frame(years,votes,actual=1)
  
  #Build a linear model
  vote.model<-lm(votes~years,data=df)
  print(vote.model$coefficients)
  confint(vote.model)
  l[[county]]<-list(intercept=vote.model$coefficients[1],years.multiplier=vote.model$coefficients[2])
  
  #Add a new row data to predict for 2020 Election and use model for prediction
  df<-rbind(df,c(2020,0,0))
  predict2020<-predict(vote.model,newdata = df[4,])
  
  
  #update new row in votes with prediction for 2020 
  df$votes[4]<-round(predict2020,0)
  
  #plot, using ifelse on actual to make predicted point different color
  plot(df$years, df$votes, pch=ifelse(df$actual==0,12,18),
       col=ifelse(df$actual==0,"Red","orange"),
       xlab = "Year", ylab = "Votes", main = county, xlim=c(2004,2024)
      )
  
  #Add text to data points
  text(df$years,df$votes,df$votes,adj=c(1,1))
  
  #Draw abline for the model line and years
  abline(vote.model,col="red",lty=5)
  abline(v=df$years,col="grey",lty=5)
  
}

