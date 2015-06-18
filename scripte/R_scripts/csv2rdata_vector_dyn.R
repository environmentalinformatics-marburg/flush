setwd("/media/dogbert/dev/be/julendat/processing/plots/be/000HEG03/qc25_fah01_0290/")
files <- list.files(".", pattern = glob2rx("*.dat"), full.names=T)

dat.list <- lapply(seq(files), function(i) {
  read.table(files[i], header = T, sep = ",", stringsAsFactors = F)
})

#dat.list[[1]]$Ta_200[is.na(dat.list[[1]]$Ta_200)] <- -999.99

for ( data in dat.list ) {
  data.Tem <- c(data$Datetime, data$Ta_200)
  print(data.Tem)
}

library(ggplot2) # Lade die ggplot2-Bibliothek
kom <- read.table("be_000HEG03_00AEMU_201301010000_201312310000_mez_qc25_fah01_0290.dat", header = T, sep=",", colClasses = "character") # erzeuge Beispieldaten
data.Tem <- c(kom$Datetime, kom$Ta_200)
colnames(data.Tem) <- c("Datum","Tem") # setze Spalten-Namen
test <- ggplot(data.Tem, aes(x=Datum, y=Tem)) # erzeuge ein ggplot-Objekt
test + geom_point() # trage alle x,y-Werte als Punkte ein