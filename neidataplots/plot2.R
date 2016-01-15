#reading in the required data files (SCC is not needed for plot2)
NEI <- readRDS("summarySCC_PM25.rds")

library(dplyr)
#filter out only the data for Baltimore and
#group the data according to year and sum up per year
baltimoreperyear <- summarise(group_by(filter(NEI,fips == "24510"),year),sum(Emissions))


#free up memory by removing unneeded data
rm(NEI)

#create a proper label
colnames(baltimoreperyear) <- c("year","total.emissions")

#Keeping the division by 1000 in this plot to make the comparison to the
#entire United States easier
baltimoreperyear$total.emissions <- baltimoreperyear$total.emissions / 1000

#draw into png file
png(filename = "plot2.png", width = 600, height = 480)

#create a bit more space between axis labels and axis values
#and around the image
par(mgp=c(4,1,0),mar=c(5,6,4,1)+0.1, oma=c(1,1,1,2))

#create base plot omitting the x axis labels for now
plot(baltimoreperyear$year,baltimoreperyear$total.emissions,type="p",xlab="Year",
     ylab="Total Emissions (in 1000 tons)", xaxt="n",las=1, 
     col="darkred",pch=19)
#add x axis labels to show the exact years we're interested in
axis(1,at=baltimoreperyear$year,labels=baltimoreperyear$year)

#give the plot a good title
title(main=expression(paste("Total Emissions of Pollutants (",PM[2.5], 
                            ") in Baltimore (1999 - 2008)")))

#close file
dev.off()