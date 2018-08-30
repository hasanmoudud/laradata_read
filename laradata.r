library(readr)
Ra_226D_lara <- read_delim("D:/PhD/Simulation_data/Ra-226D.lara.txt", 
                           ";", escape_double = FALSE, trim_ws = TRUE, 
                           skip = 13)

Ra_226D_lara$`Energy (keV)` <-  as.numeric(Ra_226D_lara$`Energy (keV)`)
Ra_226D_lara = Ra_226D_lara[-nrow(Ra_226D_lara), ]

Ra_226 = subset(Ra_226D_lara, Ra_226D_lara$`Intensity (%)`>.9)

colnames(Ra_226)[c(1,3,5)] <- c('Energy_ev','Intensity_frac', 'Type')

Ra_226 = subset(Ra_226, Ra_226$Type !='a')

output <- matrix(ncol=ncol(Ra_226), nrow=nrow(Ra_226))

for(i in 1:(nrow(Ra_226)*2)){
  output[i,] <- runif(2)
  cat(sprintf("<set name=\"%s\" value=\"%f\" ></set>\n", df$timeStamp, df$Price))
  file.create("sample.txt")
  fileConn <- file("sample.txt")
  writeLines(c(paste(i, j, k, "07"),"1","41.6318 -87.0881   10.0"), fileConn)
  close(fileConn)
  file.show("sample.txt")
  
}

for(i in seq_along(lst)) {
  write.table(lst[[i]], paste(names(lst)[i], ".txt", sep = ""), 
              col.names = FALSE, row.names = FALSE, sep = "\t", quote = FALSE)
}

output

output <- data.frame(output)
class(output)