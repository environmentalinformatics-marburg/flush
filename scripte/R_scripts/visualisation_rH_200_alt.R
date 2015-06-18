
setwd("D:/be/test/")

################### inst variables ############################
src_path = "D:/be/test/"
level = 400
out_path = "C:/Users/sforteva/Desktop/"
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
install.packages("reshape")
for (data in dat.list){
  title <- data$
  dat <- data.frame(Month = month.abb, 
                    data[, c("Ta_200", "rH_200")])
  
  dat.mlt <- melt(dat)
  dat.mlt$Month <- factor(dat.mlt$Month, levels = month.abb)
  colnames(dat.mlt)<-c('Month','variable','Temperatur')
  station <- substr(data$PlotId[1], 4,8)
  year <- substr(as.Date(data$Datetime[1]), 1,4)
  foo1 <- list(x = month.abb, y = dat$rH_200)
  foo2 <- list(x = month.abb, y = dat$rH_200)
  obj1 <- xyplot(y ~ x, foo1, type = "l")
  obj2 <- xyplot(y ~ x, foo2, type = "l")
  doubleYScale(obj1, obj2, add.ylab2 = TRUE)
  jpeg(paste0(out_path, station, year, "vis_rh_200.jpg"))
  ggplot(aes(x = Month, y = Temperatur, group = variable, label = Temperatur, 
        color = variable), 
        data = dat.mlt) + 
        geom_line() + 
        geom_point() + 
        geom_text(vjust = -1,size=3) + 
        ggtitle(paste("Overview", station ,"Temperatur", year))
  dev.off()
}