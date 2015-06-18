library(dplyr)

setwd("/media/memory01/ei_data_kilimanjaro/processing/plots/ki")

precip <- FALSE

if (precip) {
  level <- "0200"
  prm <- "P_RT_NRT"
} else {
  level <- "0310"
  prm <- "Ta_200"
}

min.n.hrs <- 22
min.n.days <- 20
min.n.months <- 12

pnm <- as.name(prm)

fls.pattern <- glob2rx(paste(prm, "*", 
                             paste(level, "txt", sep = "."), sep = ""))

fls <- list.files(".", pattern = fls.pattern, full.names = TRUE)

dat <- read.csv(fls, stringsAsFactors = FALSE)
dat$Date <- as.Date(substr(dat$Datetime, 1, 10))
dat$month <- substr(dat$Datetime, 6, 7)
dat$yearmon <- substr(dat$Date, 1, 7)

dat.plots <- split(dat, dat$PlotId, drop = TRUE)

if (precip) {
  ### daily sums
  dat.days <- dat %>%
    group_by(PlotId, Date) %>%
    summarise(mean = round(ifelse(length(na.exclude(pnm)) < min.n.hrs, NA, 
                                  sum(pnm, na.rm = TRUE)), 3))
  
  #xyplot(mean ~ Date | PlotId, data = dat.days, type = "l")
  
  names(dat.days) <- c("PlotID", "Date", prm)
  
  out.name <- paste(prm, level, "daily_sums", sep = "_")
  write.csv(dat.days, paste(out.name, "dat", sep = "."), 
            row.names = FALSE)
  
  dat.days$month <- substr(dat.days$Date, 6, 7)
  dat.days$yearmon <- substr(dat.days$Date, 1, 7)
  
  
  
  ### monthly sums
  dat.mnths <- dat %>%
    group_by(PlotId, yearmon) %>%
    summarise(mean = round(ifelse(length(na.exclude(pnm)) < min.n.days, NA, 
                                  sum(pnm, na.rm = TRUE)), 3))
  
  #xyplot(mean ~ as.Date(paste(yearmon, "01", sep = "-")) | PlotID, 
  #       data = dat.mnths, type = "l")
  
  names(dat.mnths) <- c("PlotID", "Yearmon", prm)
  
  out.name <- paste(prm, level, "monthly_sums", sep = "_")
  write.csv(dat.mnths, paste(out.name, "dat", sep = "."), 
            row.names = FALSE)
  
  dat.mnths$month <- substr(dat.mnths$Yearmon, 6, 7)
  
  
  
  ### monthly long term average sums
  dat.mnths.lt <- dat.mnths %>%
    group_by(PlotID, month) %>%
    summarise(mean = round(mean(pnm, na.rm = TRUE), 3))
  
  #xyplot(mean ~ as.numeric(month) | PlotID, data = dat.mnths.lt, type = "l")
  
  names(dat.mnths.lt) <- c("PlotID", "Month", prm)
  
  out.name <- paste(prm, level, "monthly_lt_average_sums", sep = "_")
  write.csv(dat.mnths.lt, paste(out.name, "dat", sep = "."), 
            row.names = FALSE)
  
  
  
  ### MAx mean annual x
  dat.yrs <- dat.mnths.lt %>%
    group_by(PlotID) %>%
    summarise(mean = round(ifelse(length(na.exclude(pnm)) < min.n.months, NA, 
                                  sum(pnm, na.rm = TRUE)), 3))
  
  names(dat.yrs) <- c("PlotID", prm)
  
  out.name <- paste(prm, level, "annual_mean", sep = "_")
  write.csv(dat.yrs, paste(out.name, "dat", sep = "."), 
            row.names = FALSE)
  
} else {
  
  dat.rug <- do.call("rbind", lapply(dat.plots, function(i) {
    if (length(unique(i$StationId)) > 1 & 
          any(unique(i$StationId) == "000rug")) {
      i <- i[i$StationId == "000rug", ]
    } else {
      i <- i
    }
  }))
  
  
  ### daily means
  dat.days <- dat.rug %>%
    group_by(PlotId, StationId, Date) %>%
    summarise(mean = round(ifelse(length(na.exclude(pnm)) < min.n.hrs, NA, 
                                  mean(pnm, na.rm = TRUE)), 3),
              min = round(ifelse(length(na.exclude(pnm)) < min.n.hrs, NA, 
                                 min(pnm, na.rm = TRUE)), 3),
              max = round(ifelse(length(na.exclude(pnm)) < min.n.hrs, NA, 
                                 max(pnm, na.rm = TRUE)), 3))
  
  #xyplot(mean ~ Date | PlotId, data = dat.days, type = "l")
  
  names(dat.days) <- c("PlotId", "StationId", "Date", prm, 
                       paste(prm, "_min", sep = ""),
                       paste(prm, "_max", sep = ""))
  
  out.name <- paste(prm, level, "daily_means", sep = "_")
  write.csv(dat.days, paste(out.name, "dat", sep = "."), 
            row.names = FALSE)
  
  dat.days$month <- substr(dat.days$Date, 6, 7)
  dat.days$yearmon <- substr(dat.days$Date, 1, 7)
  
  
  
  ### monthly long term averages
  dat.mnths.lt <- dat.days %>%
    group_by(PlotId, StationId, month) %>%
    summarise(mean = round(ifelse(length(na.exclude(pnm)) < min.n.days, NA, 
                                  mean(pnm, na.rm = TRUE)), 3),
              min = round(ifelse(length(na.exclude(pnm)) < min.n.days, NA, 
                                  min(pnm, na.rm = TRUE)), 3),
              max = round(ifelse(length(na.exclude(pnm)) < min.n.days, NA, 
                                  max(pnm, na.rm = TRUE)), 3))
  
  #xyplot(mean ~ as.numeric(month) | PlotID, data = dat.mnths.lt, type = "l")
  
  names(dat.mnths.lt) <- c("PlotId", "StationId", "Month", prm, 
                           paste(prm, "_min", sep = ""),
                           paste(prm, "_max", sep = ""))
  
  out.name <- paste(prm, level, "monthly_lt_averages", sep = "_")
  write.csv(dat.mnths.lt, paste(out.name, "dat", sep = "."), 
            row.names = FALSE)
  
  
  
  ### monthly means
  dat.mnths <- dat.days %>%
    group_by(PlotId, StationId, yearmon) %>%
    summarise(mean = round(ifelse(length(na.exclude(pnm)) < min.n.days, NA, 
                                  mean(pnm, na.rm = TRUE)), 3),
              min = round(ifelse(length(na.exclude(pnm)) < min.n.days, NA, 
                                 min(pnm, na.rm = TRUE)), 3),
              max = round(ifelse(length(na.exclude(pnm)) < min.n.days, NA, 
                                 max(pnm, na.rm = TRUE)), 3))
  
  #xyplot(mean ~ as.Date(paste(yearmon, "01", sep = "-")) | PlotID, 
  #       data = dat.mnths, type = "l")
  
  names(dat.mnths) <- c("PlotId", "StationId", "Yearmon", prm,
                        paste(prm, "_min", sep = ""),
                        paste(prm, "_max", sep = ""))
  
  out.name <- paste(prm, level, "monthly_mean", sep = "_")
  write.csv(dat.mnths, paste(out.name, "dat", sep = "."), 
            row.names = FALSE)
  
  
  
  ### MAx mean annual x
  dat.yrs <- dat.mnths.lt %>%
    group_by(PlotId, StationId) %>%
    summarise(mean = round(ifelse(length(na.exclude(pnm)) < min.n.months, NA, 
                                  mean(pnm, na.rm = TRUE)), 3),
              min = round(ifelse(length(na.exclude(pnm)) < min.n.months, NA, 
                                  min(pnm, na.rm = TRUE)), 3),
              max = round(ifelse(length(na.exclude(pnm)) < min.n.months, NA, 
                                  max(pnm, na.rm = TRUE)), 3))
  
  names(dat.yrs) <- c("PlotId", "StationId", prm,
                      paste(prm, "_min", sep = ""),
                      paste(prm, "_max", sep = ""))
  
  out.name <- paste(prm, level, "annual_mean", sep = "_")
  write.csv(dat.yrs, paste(out.name, "dat", sep = "."), 
            row.names = FALSE)
  
}
