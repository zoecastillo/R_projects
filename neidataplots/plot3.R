#reading in the required data files (SCC is not needed for plot3)
NEI <- readRDS("summarySCC_PM25.rds")

library(dplyr)
library(ggplot2)
#filter out only the data for Baltimore and
#group the data according to year and type and calculate the sum 
#for each group
baltimoreperyear <- summarise(group_by(filter(NEI,fips == "24510"),
                                       year,type),sum(Emissions))

#free up memory by removing unneeded data
rm(NEI)
#create a proper label
colnames(baltimoreperyear) <- c("Year","type","total.emissions")

#draw into png file
png(filename = "plot3.png", width = 700, height = 480)

#create the basic graphics object
g <- ggplot(baltimoreperyear,aes(Year,total.emissions))

#use large dark red dots and facets based on types
g <- g + geom_point(color="darkred", size=3, pch=19) + facet_grid(.~type)
#use bw theme and a slightly larger margin between facets than default
g <- g + theme_bw() + theme(panel.margin.x = unit(0.7, "lines"),
                            plot.title = element_text(face="bold")) 
#set y and x axis labels (the later using only the years we're interested in)
g <- g + ylab("Total Emissions (in tons)") + 
  scale_x_continuous(breaks = baltimoreperyear$Year,
                     labels = baltimoreperyear$Year)
#add a title (in bold face as specified above)
g <- g + ggtitle("Total Emissions by Type for Baltimore (1999 - 2008)\n")
# print the graphics object according to specification
print(g)

#close file
dev.off()