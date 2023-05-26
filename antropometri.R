library(anthro)
library(readxl)
library(writexl)
lokasi <- "C:/Users/almo/OneDrive - World Health Organization/Documents/surveilans assistant WHO (2021)/surveilans kemenkes/AP-AKI/artikel publikasi GGAPA"
dataa <- "database GGAPA riset"
setwd(lokasi)
malming <- read_xlsx(paste(dataa,".xlsx",sep = ""))
View(malming)

malming$JK <- ifelse(malming$`jenis kelamin (L,P)`==1,"M","F")
hasil <- anthro_zscores(sex = malming$JK,age =malming$`usia (th)`,
                        is_age_in_month = FALSE,weight = malming$BB,
                        lenhei = malming$TB);View(hasil)

akhir <- cbind(malming,hasil$cbmi,hasil$zwei,hasil$zlen)
akhir$kat1 <- ifelse(akhir$`hasil$zwei`<(-3),"gizi buruk",
                     ifelse(akhir$`hasil$zwei`<(-2),"gizi kurang",
                            ifelse(akhir$`hasil$zwei`<2.01,"gizi baik","gizi lebih")))
akhir$kat2 <- ifelse(akhir$`hasil$cbmi`<17.0,"kurus berat",
                     ifelse(akhir$`hasil$cbmi`<18.5,"kurus ringan",
                            ifelse(akhir$`hasil$cbmi`<25.01,"normal",
                                   ifelse(akhir$`hasil$cbmi`<27.01,"gemuk ringan",
                                          "gemuk berat"))))
akhir$katgizi <- ifelse(akhir$`usia (th)`<6,akhir$kat1,
                        akhir$kat2)

write_xlsx(akhir,paste("tambah status gizi.xlsx",sep = ""))
