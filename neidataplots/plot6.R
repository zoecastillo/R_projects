#reading in the required data files 
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


library(dplyr)
library(ggplot2)

#the subset of entries in SCC containing the word coal as an Emission source
idsforvehicles <- filter(SCC,grepl("Vehicles", EI.Sector, ignore.case = TRUE))
baltimoreandla <- filter(NEI,fips == "24510" | fips == "06037")

#keep all rows of NEI whose SCS id is found in idsforcoals
vehicleemi <- semi_join(baltimoreandla,idsforvehicles, by="SCC")

#free up memory by removing unneeded data
rm(NEI)
rm(SCC)
rm(baltimoreandla)


vehicleperyear <- summarise(group_by(vehicleemi,fips,year),sum(Emissions))

#create a proper label
colnames(vehicleperyear) <- c("fips", "Year","total.emissions")

#draw into png file
png(filename = "plot6.png", width = 600, height = 480)


#create the basic graphics object
g <- ggplot(vehicleperyear,aes(Year,total.emissions))

#use large dark red dots 
chosencolors <- scale_color_manual(name="fips", labels = c("Los Angeles County","Baltimore"), values = c("darkorchid","darkolivegreen3"))
g <- g + geom_point(aes(color=fips), size=3, pch=19) + chosencolors
#use bw theme 
g <- g + theme_bw() + theme(panel.margin.x = unit(0.7, "lines"),
                            plot.title = element_text(face="bold")) 
#set y and x axis labels (the later using only the years we're interested in)
g <- g + ylab("Total Emissions (in tons)") + 
  scale_x_continuous(breaks = coalperyear$Year,
                     labels = coalperyear$Year)
#add a title (in bold face as specified above)
g <- g + ggtitle("Vehicle-related Emissions in Baltimore and LA (1999 - 2008)\n")
# print the graphics object according to specification
print(g)

#close file
dev.off()