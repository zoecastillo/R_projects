#reading in the required data files (SCC is not needed for plot1)
NEI <- readRDS("summarySCC_PM25.rds")

library(dplyr)
#group the data according to year and sum up per year
emissionsperyear <- summarise(group_by(NEI,year),sum(Emissions))

#free up memory by removing unneeded data
rm(NEI)

#create a proper label
colnames(emissionsperyear) <- c("year","total.emissions")

#since scientific numbers are harder to graps, I decided to divide by 1000
#and I will use a scale of (in 1000 tons) for the plot
emissionsperyear$total.emissions <- emissionsperyear$total.emissions / 1000

#draw into png file
png(filename = "plot1.png", width = 600, height = 480)

#create a bit more space between axis labels and axis values
#and around the image
par(mgp=c(4,1,0),mar=c(5,6,4,1)+0.1, oma=c(1,1,1,2))

#create base plot omitting the x axis labels for now
plot(emissionsperyear$year,emissionsperyear$total.emissions,type="p",xlab="Year",
     ylab="Total Emissions (in 1000 tons)", xaxt="n",las=1, 
     col="darkred",pch=19)
#add x axis labels to show the exact years we're interested in
axis(1,at=emissionsperyear$year,labels=emissionsperyear$year)

#give the plot a good title
title(main=expression(paste("Total Emissions of Pollutants (",PM[2.5], 
                            ") in the United States (1999 - 2008)")))

#close file
dev.off()