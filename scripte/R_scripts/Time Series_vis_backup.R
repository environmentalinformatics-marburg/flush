#t<-load(url("http://192.168.191.183:8080/tsdb/query?plot=AEG01&sensor=Ta_200&aggregation=month"))
#library("rjson")
#json_file <- paste ("http://ag-ui:UIdb!2015192.168.191.183:8080/tsdb/query?plot=HEG01&sensor=Ta_200&aggregation=month")
#json_data <- fromJSON(file=json_file, method = 'C',unexpected.escape = "error" )


require(grid)
library(ggplot2)
library(reshape)


#install.packages("RCurl")
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  require(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col)) 
    }
  }
}

################### inst variables ############################
level = 400
var_Name_t = 'Temperatur'
parameter_t = 'Ta_200'

var_Name_r = 'Luftfeuchte'
parameter_r = 'rH_200'

var_Name_w = 'Niederschlag'
parameter_w = 'P_RT_NRT'

###############################################################  

getTa_200 <- function (}, station, year) {
  tryCatch( 
            ##################### Ta_200 #####################################################################
            userpwd <- paste("ag-ui", ":", "UI!db2015", sep = "")
            txt <- RCurl::getURL(paste0(path, "/tsdb/query_csv?plot=", station,
            "&sensor=Ta_200&aggregation=hour&quality=step&interpolated=true&year=", year), userpwd = userpwd)
            con <- textConnection(txt)
            data_ta_200 <- try(read.table(con, skip = 0, header = TRUE, sep=","),TRUE)
            close(con)
            
            ##################### Ta_200_min ###################################################################
            data_ta_200_min <- data_ta_200
            colnames(data_ta_200_min) <- c("Date","Ta_200_min") # setze Spalten-Namen
            Group <- substr(data_ta_200_min$Date, 6, 7)
            data_ta_200_min <- cbind(data_ta_200_min, Group)
            data_ta_200_min <- aggregate(Ta_200_min ~ Group, data_ta_200_min,  FUN=min)
            
            ##################### Ta_200_max ###################################################################
            data_ta_200_max <- data_ta_200
            colnames(data_ta_200_max) <- c("Date","Ta_200_max") # setze Spalten-Namen
            Group <- substr(data_ta_200_max$Date, 6, 7)
            fa <- cbind(data_ta_200_max, Group)
            data_ta_200_max <- aggregate(Ta_200_max ~ Group, data_ta_200_max,  FUN=max)
            
            ##################### Ta_200 #######################################################################
            
            colnames(data_ta_200) <- c("Date","Ta_200") # setze Spalten-Namen
            Group <- substr(data_ta_200$Date, 6, 7)
            fa <- cbind(data_ta_200, Group)
            data_ta_200 <- aggregate(Ta_200~ Group, data_ta_200,  FUN=mean)
            
            Ta_200_max <- data_ta_200_max$Ta_200_max
            Ta_200_min <- data_ta_200_min$Ta_200_min
            data_ta_200 <- cbind(data_ta_200, Ta_200_max, Ta_200_min)
            
            dat_t <- data.frame( Monat=c("Jan", "Feb", "Mrz", "Apr", "Mai" ,"Jun" , "Jul", "Aug", "Sep" ,"Okt", "Nov", "Dez"), 
                                 data_ta_200[, c(paste0(parameter_t, "_max"), parameter_t, paste0(parameter_t,"_min") )])
            dat_t$Monat <- factor(dat_t$Monat, levels = c("Jan", "Feb", "Mrz", "Apr", "Mai" ,"Jun" , "Jul", "Aug", "Sep" ,"Okt", "Nov", "Dez"))
            
            
           
            dat_t.mlt_t <- melt(dat_t)
            dat_t.mlt_t$value <- round(dat_t.mlt_t$value, 1)
            t <- colnames(dat_t.mlt_t) <- c('Monat','Leg',var_Name_t)
            levels(dat_t.mlt_t$Leg) <- c("max", "mittel", "min")
      
            
            p1 <- (ggplot(aes(x = Monat, y = Temperatur, group = Leg, label = Temperatur, 
                     color = Leg), 
                     data = dat_t.mlt_t) + 
                     scale_size_area()+
                     xlab(NULL)+
                     ylab(paste(var_Name_t,"°C") )+
                     geom_line() + 
                     geom_point() + 
                     geom_text(vjust = -0.5,hjust=-0.1, size=3, color="black") + 
                     ggtitle(paste( station, " - ", year)) +
                     theme(plot.title=element_text(family="Arial", face="bold", size=10))+
                     theme(plot.margin = unit(c(8,8,8,8), "mm"))+
                     theme(title = element_text(vjust=1))+
                     theme(legend.title=element_blank() ) +
                     theme(axis.text=element_text(colour="black"))
                   #scale_colour_brewer(name = "")
            )
            #print(p1)
           )
}

getRh_200 <- function (path, station , year) {
  tryCatch( 
          ##################### rH_200 #####################################################################
          userpwd <- paste("ag-ui", ":", "UI!db2015", sep = "")
          txt <- RCurl::getURL(paste0(path, "/tsdb/query_csv?plot=", station,
                                     "&sensor=rH_200&aggregation=hour&quality=step&interpolated=true&year=", year), userpwd = userpwd)
          con <- textConnection(txt)
          data_rH_200 <- try(read.table(con, skip = 0, header = TRUE, sep=",", na.strings=0 ),TRUE)
          close(con)
          
         
          ##################### P_RT_NRT_min ###################################################################
          data_rH_200_min <- data_rH_200
          colnames(data_rH_200_min) <- c("Date","rH_200_min") # setze Spalten-Namen
          data_rH_200_min[[i]]$rH_200_min[is.na(data_rH_200_min[[i]]$rH_200_min)]<- 0.00


dat[[i]]$Ta_200[dat[[i]]$Ta_200 > 40.0] <- NA


          Group <- substr(data_rH_200_min$Date, 6, 7)
          data_rH_200_min <- cbind(data_rH_200_min, Group)
          data_rH_200_min <- aggregate(rH_200_min ~ Group, data_rH_200_min,  FUN=min)
          
          ##################### rH_200_max ###################################################################
          data_rH_200_max <- data_rH_200
          colnames(data_rH_200_max) <- c("Date","rH_200_max") # setze Spalten-Namen
          Group <- substr(data_rH_200_max$Date, 6, 7)
          data_rH_200_max <- cbind(data_rH_200_max, Group)
          data_rH_200_max <- aggregate(rH_200_max ~ Group, data_rH_200_max,  FUN=max)
          
          ##################### rH_200 #######################################################################
          
          colnames(data_rH_200) <- c("Date","rH_200") # setze Spalten-Namen
          Group <- substr(data_rH_200$Date, 6, 7)
          data_rH_200 <- cbind(data_rH_200, Group)
          data_rH_200 <- aggregate(rH_200~ Group, data_rH_200,  FUN=mean)
          data_rH_200[[i]]$Ta_200[] <- NA
          
          rH_200_max <- data_rH_200_max$rH_200_max
          rH_200_min <- data_rH_200_min$rH_200_min
          data_rH_200 <- cbind(data_rH_200, rH_200_max, rH_200_min)
          
          dat_r <- data.frame(Monat=c("Jan", "Feb", "Mrz", "Apr", "Mai" ,"Jun" , "Jul", "Aug", "Sep" ,"Okt", "Nov", "Dez"), 
                              data_rH_200[, c(paste0(parameter_r, "_max"),parameter_r, paste0(parameter_r,"_min") )])
          dat_r$Monat <- factor(dat_r$Monat, levels = c("Jan", "Feb", "Mrz", "Apr", "Mai" ,"Jun" , "Jul", "Aug", "Sep" ,"Okt", "Nov", "Dez"))
         
          
          dat_r.mlt_r <- melt(dat_r)
          dat_r.mlt_r$value <- round(dat_r.mlt_r$value, 1)
          r<- colnames(dat_r.mlt_r)<-c('Monat','Leg',var_Name_r)
          levels(dat_r.mlt_r$Leg) <- c("max", "mittel", "min")
          
          p2 <- (ggplot(aes(x = Monat, y = Luftfeuchte, group = Leg, label = Luftfeuchte, 
                            color = Leg), 
                        data = dat_r.mlt_r) + 
                   scale_size_area()+
                   xlab(NULL)+
                   ylab(paste(var_Name_r, "%") )+
                   geom_line() + 
                   geom_point() + 
                   geom_text(vjust = -0.5,hjust=-0.1, size=3, color="black") + 
                   ggtitle(paste( station , " - ", year)) +
                   theme(plot.title=element_text(family="Arial", face="bold", size=10)) +
                   theme(plot.margin = unit(c(0,8,8,8), "mm"))+
                   theme(title = element_text(vjust=1))+
                   theme(legend.title=element_blank())+
                   theme(axis.text=element_text(colour="black"))
                 #+ #, legend.text=element_text(family="Garamond",size=8), legend.position="topright")
                 # scale_colour_brewer(name = "")
          )
          #print(p2)
  )
}

getP_RT_NRT <- function(path, station, year) {
  tryCatch( 
          ##################### P_RT_NRT #################################################################
          userpwd <- paste("ag-ui", ":", "UI!db2015", sep = "")
          txt <- RCurl::getURL(paste0(path, "/tsdb/query_csv?plot=", station,"&sensor=P_RT_NRT&aggregation=month&quality=step&interpolated=true&year=", year), userpwd = userpwd)
          con <- textConnection(txt)
          
          data_P_RT_NRT <- try(read.table(con, skip = 0, header = TRUE, sep=","),TRUE)
          close(con)
          
          ##################### P_RT_NRT_max ###################################################################
          #data_P_RT_NRT_max <- data_P_RT_NRT
          #colnames(data_P_RT_NRT_max) <- c("Date","P_RT_NRT_max") # setze Spalten-Namen
          #Group <- substr(data_P_RT_NRT_max$Date, 6, 7)
          #data_P_RT_NRT_max <- cbind(data_P_RT_NRT_max, Group)
         # data_P_RT_NRT_max <- aggregate(P_RT_NRT_max ~ Group, data_P_RT_NRT_max,  FUN=max)
          
          ##################### P_RT_NRT #######################################################################
          
         # colnames(data_P_RT_NRT) <- c("Date","P_RT_NRT") # setze Spalten-Namen
          #Group <- substr(data_P_RT_NRT$Date, 6, 7)
          #data_P_RT_NRT <- cbind(data_P_RT_NRT, Group)
         # data_P_RT_NRT <- aggregate(P_RT_NRT~ Group, data_P_RT_NRT,  FUN=mean)
          
          #P_RT_NRT_max <- data_P_RT_NRT_max$P_RT_NRT_max
          #P_RT_NRT_min <- data_P_RT_NRT_min$P_RT_NRT_min
          #data_P_RT_NRT <- cbind(data_P_RT_NRT, P_RT_NRT_max, P_RT_NRT_min)
          
          
          dat_w <- data.frame( Monat=c("Jan", "Feb", "Mrz", "Apr", "Mai" ,"Jun" , "Jul", "Aug", "Sep" ,"Okt", "Nov", "Dez"), 
                               data_P_RT_NRT[, c(parameter_w)])
          dat_w$Monat <- factor(dat_w$Monat, levels = c("Jan", "Feb", "Mrz", "Apr", "Mai" ,"Jun" , "Jul", "Aug", "Sep" ,"Okt", "Nov", "Dez"))
          
          dat_w.mlt_w <- melt(dat_w)
          # dat_w.mlt_t$Monat <- factor(dat_w.mlt_t$Monat, levels = month.abb)
          dat_w.mlt_w$value <- round(dat_w.mlt_w$value, 2)
          t <- colnames(dat_w.mlt_w) <- c('Monat','Leg',var_Name_w)
          
          p3 <- ggplot(dat_w.mlt_w , aes( y=Niederschlag, x=Monat))
          p3 <- p3 + geom_bar(position="dodge", stat="identity",fill="#87e0fd") + scale_size_area()+
            xlab(NULL)+
            ylab(paste(var_Name_w, "mm") )+
            ggtitle(paste(station,  " - ", year)) + 
            theme(plot.title=element_text(family="Arial", face="bold", size=10))+
            theme(legend.position="none") +
            geom_text(aes(y=Niederschlag, label = Niederschlag),vjust = 2,size=3)+
            theme(plot.margin = unit(c(0,33,8,8), "mm"))+
            theme(title = element_text(vjust=1))  +
            scale_colour_gradient2("fill") +
            theme(axis.text=element_text(colour="black"))
         #print(p3)
         
  )
}

path <- "http://137.248.191.249:8080/0123456789abcdef"
stations_vip<- c( "HEG03", "HEG19", "HEG20", "HEG24", "HEG29", "HEG31", "HEG48", 
              "SEG03", "SEG09", "SEG32" , "SEG35","SEG43", "SEG50",
              "AEG02", "AEG10", "AEG11", "AEG21", "AEG26", "AEG28", "AEG35") #AEG fehlermeldungen

stations_SEG<- c("SEG01","SEG02","SEG04","SEG05","SEG06", "SEG07", "SEG08","SEG10" ,"SEG11","SEG12","SEG12","SEG13","SEG14","SEG15","SEG16","SEG17","SEG18","SEG19",
"SEG20","SEG21","SEG22","SEG23","SEG24","SEG25","SEG26","SEG27","SEG28","SEG29","SEG30","SEG31","SEG33","SEG34","SEG36","SEG37","SEG38"
,"SEG39","SEG40","SEG41","SEG42","SEG44","SEG45","SEG46","SEG47","SEG48","SEG49")

stations_HEG<- c("HEG01","HEG02","HEG04","HEG05","HEG06", "HEG07", "HEG08","HEG10" ,"HEG11","HEG12","HEG12","HEG13","HEG14","HEG15","HEG16","HEG17","HEG18",
             ,"HEG21","HEG22","HEG23","HEG25","HEG26","HEG27","HEG28","HEG30","HEG33","HEG34","HEG36","HEG37","HEG38"
             ,"HEG39","HEG40","HEG41","HEG42","HEG44","HEG45","HEG46","HEG47","HEG49", "HEG09", "HEG32" , "HEG35","HEG43", "HEG50")

stations_AEG<- c("AEG01","AEG02","AEG04","AEG05","AEG06", "AEG07", "AEG08","AEG10" ,"AEG11","AEG12","AEG12","AEG13","AEG14","AEG15","AEG16","AEG17","AEG18","AEG19",
             "AEG20","AEG21","AEG22","AEG23","AEG24","AEG25","AEG26","AEG27","AEG28","AEG29","AEG30","AEG31","AEG33","AEG34","AEG36","AEG37","AEG38"
             ,"AEG39","AEG40","AEG41","AEG42","AEG44","AEG45","AEG46","AEG47","AEG48","AEG49","AEG03", "AEG09", "AEG32" , "AEG35","AEG43", "AEG50")

station_problem <- c("HEG42")
                     #,"HEG44","HEG45","HEG46","HEG47","HEG49", "HEG43", "HEG50")
year <- c( "2014")
out_path = "/home/dogbert/"

for (y in year) {
  for (s in station_problem) {
    png(paste0(out_path, s, "_", y, "_", "vis.png"),
        width     = 2480,
        height    = 3508,
        units     = "px",
        res       = 300,
        # pointsize = 1
    )
    
    p1 <- getTa_200(path, s, y)
    p2 <- getRh_200(path, s, y)
   # p3 <- getP_RT_NRT(path, s, y)
    multiplot(p1, p2, p3)
    dev.off()
  }
}