
setwd("/media/memory01/ei_data_kilimanjaro/processing/plots/ki")


precip <- FALSE

if (precip) {
  level <- "0200"
  prms <- "P_RT_NRT"
  stinv <- read.csv("/media/memory01/ei_data_kilimanjaro/scripts/julendat/src/julendat/scripts/stations_ki/ki_config.cnf",
                    stringsAsFactors = FALSE)
  
  ## check which column is rain in pu2
  prtnrt_1 <- data.frame(PlotID = stinv$PLOTID[stinv$pu2_1_type %in% "rain"],
                         StationID = stinv$LOGGER[stinv$pu2_1_type %in% "rain"],
                         col = "P_RT_NRT_01", stringsAsFactors = FALSE)
  prtnrt_2 <- data.frame(PlotID = stinv$PLOTID[stinv$pu2_2_type %in% "rain"],
                         StationID = stinv$LOGGER[stinv$pu2_2_type %in% "rain"],
                         col = "P_RT_NRT_02", stringsAsFactors = FALSE)
  prtnrt <- data.frame(PlotID = stinv$PLOTID[stinv$LOGGER %in% "000pu1"],
                       StationID = stinv$LOGGER[stinv$LOGGER %in% "000pu1"],
                       col = "P_RT_NRT", stringsAsFactors = FALSE)
  
  prtnrt.map <- rbind(prtnrt_1, prtnrt_2, prtnrt)
  prtnrt.map <- prtnrt.map[!prtnrt.map$PlotID == "flm1", ]
  
  prtnrt.map.ptrn <- data.frame(ptrn = glob2rx(paste("*", prtnrt.map$PlotID, 
                                                     "*", prtnrt.map$StationID, 
                                                     "*", sep = "")),
                                col = prtnrt.map$col,
                                stringsAsFactors = FALSE)
  
  fls.pattern <- glob2rx(paste("*", paste(level, "dat", sep ="."), sep = ""))
  
  fls <- list.files(".", recursive = TRUE, full.names = TRUE,
                    pattern = fls.pattern)
  
  testFls <- function(x) {
    function(y) {
      grep(x, y)
    }
  }
  
  fls.details <- do.call("rbind", lapply(seq(nrow(prtnrt.map.ptrn)), function(i) {
    f <- testFls(prtnrt.map.ptrn$ptrn[i])
    
    if(length(fls[f(fls)]) == 0) {
      df <- NULL
    } else {    
    df <- data.frame(file = fls[f(fls)],
                     col = prtnrt.map.ptrn$col[i],
                     stringsAsFactors = FALSE)
    }
    return(df)
  }))
  
  agg <- unique(substr(fls, 19, 21))

  df <- do.call("rbind", lapply(seq(nrow(fls.details)), function(i) {
    tmp <- read.csv(fls.details$file[i], stringsAsFactors = FALSE)
    tmp <- tmp[, c(1:8, which(names(tmp) == fls.details$col[i]))]
    names(tmp) <- c(names(tmp)[1:8], "P_RT_NRT")
    return(tmp)
  }))
    
  out.nm <- paste(prms, agg, level, sep = "_")
  write.csv(df, paste(out.nm, "txt", sep = "."), row.names = FALSE)
  
} else {
  level <- "0310"
  prms <- c("Ta_200")
  
  fls.pattern <- glob2rx(paste("*", paste(level, "dat", sep ="."), sep = ""))
  
  fls <- list.files(".", recursive = TRUE, full.names = TRUE,
                    pattern = fls.pattern)
  
  agg <- unique(substr(fls, 19, 21))
  
  nms.list <- lapply(seq(fls), function(i) {
    tmp <- read.csv(fls[i], header = TRUE, nrows = 1)
    nms <- names(tmp)
    return(nms)
  })
  
  testPrm <- function(x) {
    function(y) {
      any(x %in% y)
    }
  }
  
  ind.list <- lapply(prms, function(i) {
    f <- testPrm(i)
    unlist(lapply(nms.list, f))
  })
  
  names(ind.list) <- prms
  
  for (j in prms) {
    df <- do.call("rbind", lapply(fls[ind.list[[j]]], function(i) {
      tmp <- read.csv(i, stringsAsFactors = FALSE)
      tmp <- tmp[, c(1:8, which(names(tmp) == j))]
      return(tmp)
    }))
    
    out.nm <- paste(j, agg, level, sep = "_")
    write.csv(df, paste(out.nm, "txt", sep = "."), row.names = FALSE)
  }
}
