
#library(ggplot2)
#library(reshape)
args <- commandArgs()

dfile <- paste0("vmstat 1 20 >> ", args[6])
t1 <- try(system(dfile, intern = TRUE))

myData <- read.csv2(args[6], header = TRUE, sep = "", quote = "\"",
                dec = ".", fill = TRUE, comment.char = "", skip = 1L)
spaltennamenvektor <-  as.vector(myData[c(2),])

max <- as.data.frame(max(myData$us))

if (max > 50 ){

##png(paste0("/home/dogbert/Desktop/", "test.png"))
#print (ggplot(aes(x = myData$us, y = myData$r,  label = "Luftfeuchte", 
            #      color = "red"), 
            #  data = myData) + 
        # geom_line() + 
         #geom_point() + 
        # geom_text(vjust = -1,size=3) + 
       #  ggtitle(paste("Overview", "Prozessor" ,"pr%", "year")))
#dev.off()

message <-paste0("182 Auslastung in % - ", max)
code <- paste0(" java -jar /home/dogbert/administration/sender.jar spaska.forteva@geo.uni-marburg.de forteva@staff.uni-marburg.de smtp.staff.uni-marburg.de Prozessor '", message, "'")
t1 <- try(system(code, intern = TRUE))
} else{
	d <- paste0("rm ",args[6])
	try(system(d, intern = TRUE))
}
