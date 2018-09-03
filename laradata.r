library(readr)
#'''Read an lara text file and write an spectra file for PENELOPE''''

####..... Input data ....#####
nuclide = "Ra-226D" # nucliede "symbol-massnumber-m/D(If needed)"
threshhold_intensity = 0.9   # Minimum intensity in pwersent % (0.90%)
bin.size <- 0.0001  # Bin size of spectra   0.0001= 100 eV

# Generate file name 
lara_data_file = sprintf("%s.lara.txt", nuclide)
output_file =  sprintf("%s_spectr.txt", nuclide)

# download lara data file 
url_lara = sprintf("http://www.nucleide.org/DDEP_WG/Nuclides/%s", lara_data_file)
download.file(url_lara , lara_data_file)

# Read text file 
data_lara <- read_delim(lara_data_file, 
                           ";", escape_double = FALSE, trim_ws = TRUE, 
                           skip = 26)

# Convert Energy from character to numeric 
data_lara$`Energy (keV)` <-  as.numeric(data_lara$`Energy (keV)`)

#Remove last line with NA values 
data_lara = data_lara[-nrow(data_lara), ]

# Make a subset for a threshhold intensity (eg. > 0.9 )
data_sub = subset(data_lara, data_lara$`Intensity (%)`>threshhold_intensity)

# Change the column name of requried data
colnames(data_sub)[c(1,3,5)] <- c('Energy_ev','Intensity_frac', 'Type')

# Remove alfa lines 
data_sub = subset(data_sub, data_sub$Type !='a')

# Create and open an text file to write the spectra 
file.create(output_file)
fileConn1 <- file(output_file, "w")

#Write the spectra in text file .... two lines for a bin..... intensity is -1 for last line 
for(i in 1:nrow(data_sub)){
  write(sprintf('myfile.write ("SPECTR   \ %fe6\   \ %f\\n")', (data_sub$Energy_ev[i]*0.001), (data_sub$Intensity_frac[i]/100)), fileConn1, append=TRUE)
  if(i != nrow(data_sub)){
    write(sprintf('myfile.write ("SPECTR   \ %fe6\   \ %f\\n")', ((data_sub$Energy_ev[i]*0.001)+bin.size), (0)), fileConn1, append=TRUE)
  }else{
    write(sprintf('myfile.write ("SPECTR   \ %fe6\   \ %f\\n")', ((data_sub$Energy_ev[i]*0.001)+bin.size), (-1)), fileConn1, append=TRUE)
  }
}
close(fileConn1)
#file.show("sample1.txt")


