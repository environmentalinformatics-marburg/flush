setwd("/home/dogbert/workspace/julendat/src/julendat/rmodules/")

################### inst variables ############################
src_path = "/media/dogbert/dev/be/julendat/processing/plots/be/"
level = 400
out_path = "/home/dogbert/"
###############################################################  
  
files <- list.files( path=src_path, pattern=glob2rx(paste0("*_0", level,"*.dat")),recursive=TRUE, full.names=TRUE)
libs <- c('ggplot2', 'latticeExtra', 'gridExtra', 'MASS', 
          'colorspace', 'plyr', 'Hmisc', 'scales')
lapply(libs, require, character.only = T)

dat.list <- lapply(seq(files), function(i) {
 read.table(files[i], header = T, sep = ",", stringsAsFactors = F)
})
library(ggplot2)
library(reshape)
for (data in dat.list){
  title <- data$
  dat <- data.frame(Month = month.abb, 
                    data[, c("Ta_200", "rH_200")])
  
  dat.mlt <- melt(dat)
  dat.mlt$Month <- factor(dat.mlt$Month, levels = month.abb)
  colnames(dat.mlt)<-c('Month','variable','Temperatur')
  station <- substr(data$PlotId[1], 4,8)
  year <- substr(as.Date(data$Datetime[1]), 1,4)
  jpeg(paste0(out_path, station, year, "vis_temperatur.jpg"))
  ggplot(aes(x = Month, y = Temperatur, group = variable, label = Temperatur, 
        color = variable), 
        data = dat.mlt) + 
        geom_line() + 
        geom_point() + 
        geom_text(vjust = -1,size=3) + 
        ggtitle(paste("Overview", station ,"Temperatur", year))
  dev.off()
}