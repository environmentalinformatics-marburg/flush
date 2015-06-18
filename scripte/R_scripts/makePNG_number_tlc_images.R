
require(grid)
library(ggplot2)
library(reshape)
setwd("/media/dogbert/dev/be/")
stinv <- read.table(header=FALSE, "/media/dogbert/dev/result_number_images2012.txt", sep=".",
                  stringsAsFactors = FALSE)


colnames(stinv) <- c("Month", "Val")
Group <- substr(stinv$Month, 6, 7)
stinv <- cbind(stinv, Group)
stinv$Val <- 1
stinv <- aggregate(Val ~ Group , stinv,  FUN=sum)
level = 400
colnames(stinv) <- c("Month", "Val")
var_Name_t = 'Month'
parameter_t = 'Val'

phdfig37b_long = data.frame( stinv )

year = "2012"
png(paste0("/media/dogbert/dev/",  "result_number_tlc_images_2012.png"),
    width     = 2480,
    height    = 3508,
    units     = "px",
    res       = 300,
    # pointsize = 1
)
p <- ggplot(phdfig37b_long,aes(x=Month,y=Val, color = "red",group = parameter_t, label = Val ))+geom_point()+
  scale_size_area()+
  xlab("Month")+
  ylab(paste("Number images") )+
  geom_line() + 
  geom_point() +
  geom_text(vjust = -0.5,hjust=-0.1, size=3, color="black") + 
  ggtitle(paste( "Year ", year)) +
  theme(plot.title=element_text(family="Arial", face="bold", size=10))+
  theme(plot.margin = unit(c(8,8,8,8), "mm"))+
  theme(title = element_text(vjust=1))+
  theme(legend.title=element_blank() ) +
  theme(axis.text=element_text(colour="black"))

print(p)

dev.off()
