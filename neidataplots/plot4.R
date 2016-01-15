#reading in the required data files 
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


library(dplyr)
library(ggplot2)

#the subset of entries in SCC containing the word coal as an Emission source
idsforcoals <- filter(SCC,grepl("coal", EI.Sector, ignore.case = TRUE))

#keep all rows of NEI whose SCS id is found in idsforcoals
coalemi <- semi_join(NEI,idsforcoals, by="SCC")

#free up memory by removing unneeded data
rm(NEI)
rm(SCC)


coalperyear <- summarise(group_by(coalemi,year),sum(Emissions))

#create a proper label
colnames(coalperyear) <- c("Year","total.emissions")

coalperyear$total.emissions <- coalperyear$total.emissions / 1000
#draw into png file
png(filename = "plot4.png", width = 600, height = 480)

#create the basic graphics object
g <- ggplot(coalperyear,aes(Year,total.emissions))

#use large dark red dots 
g <- g + geom_point(color="darkred", size=3, pch=19) 
#use bw theme 
g <- g + theme_bw() + theme(panel.margin.x = unit(0.7, "lines"),
                             plot.title = element_text(face="bold")) 
#set y and x axis labels (the later using only the years we're interested in)
g <- g + ylab("Total Emissions (in 1000 tons)") + 
  scale_x_continuous(breaks = coalperyear$Year,
                     labels = coalperyear$Year)
#add a title (in bold face as specified above)
g <- g + ggtitle("Coal Combustion related Emissions in the United States (1999 - 2008)\n")
# print the graphics object according to specification
print(g)

#close file
dev.off()