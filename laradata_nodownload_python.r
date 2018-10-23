library(utils)
#'''Read an lara text file and write an spectra file for PENELOPE''''

####..... Input data ....#####
nuclide = "Cs-137" # nucliede "symbol-massnumber-m/D(If needed)"
threshhold_intensity = 0 # Minimum intensity in pwersent % (0.90%)
bin.size <- 0.0001  # Bin size of spectra   0.0001= 100 eV

# Generate file name 
lara_data_file = sprintf("%s.lara.txt", nuclide)
output_file =  sprintf("%s_spectr_thrsh_%f_inp.txt", nuclide, threshhold_intensity)

# Read lara data file 
url_lara = sprintf("http://www.lnhb.fr/nuclides/%s", lara_data_file)
all_content = readLines(url_lara)
Head_skip = all_content[-c(1:grep("--------",all_content))]
data_lara <- read.table(textConnection(Head_skip[-length(Head_skip)]), header = TRUE, sep = ";", quote = "")

# Make a subset for a threshhold intensity (eg. > 0.9 )
data_sub = data_lara[which(data_lara$Intensity.... > threshhold_intensity), ]

# Change the column name of requried data
colnames(data_sub)[c(1,3,5)] <- c('Energy_ev','Intensity_frac', 'Type')
data_sub = data_sub[order(data_sub$Energy_ev), ]
data_sub = data_sub[ which(data_sub$Type != ' a '), ]
# Remove alfa lines 
data_sub = data_sub[ ,c(1,3,5)] 


# Create and open an text file to write the spectra 
file.create(output_file)
fileConn1 <- file(output_file, "w")

#Write the spectra in text file .... two lines for a bin..... intensity is -1 for last line 
for(i in 1:nrow(data_sub)){
  if (i != nrow(data_sub)){
  bin_ck = (data_sub$Energy_ev[i+1]*0.001)-(data_sub$Energy_ev[i]*0.001)
  if (bin_ck < bin.size){
    bin_add = ((data_sub$Energy_ev[i+1]*0.001)-(data_sub$Energy_ev[i]*0.001))/2.0
  }else{
    bin_add = bin.size
  }
  }
  write(sprintf('myfile.write ("SPECTR   \ %fe6\   \ %f\\n")', (data_sub$Energy_ev[i]*0.001), (data_sub$Intensity_frac[i]/100)), fileConn1, append=TRUE)
  if(i != nrow(data_sub)){
    write(sprintf('myfile.write ("SPECTR   \ %fe6\   \ %f\\n")', ((data_sub$Energy_ev[i]*0.001)+bin_add), (0)), fileConn1, append=TRUE)
  }else{
    write(sprintf('myfile.write ("SPECTR   \ %fe6\   \ %f\\n")', ((data_sub$Energy_ev[i]*0.001)+bin_add), (-1)), fileConn1, append=TRUE)
  }
}
close(fileConn1)
file.show(output_file)




