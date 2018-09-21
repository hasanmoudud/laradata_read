library(utils)
#'''Read an lara text file and write an spectra file for PENELOPE''''

####..... Input data ....#####
nuclide1 = "Ba-133" # nucliede "symbol-massnumber-m/D(If needed)"
nuclide2 = "Co-60" # nucliede "symbol-massnumber-m/D(If needed)"
nuclide3 = "Eu-152" # nucliede "symbol-massnumber-m/D(If needed)"
nuclide4 = "Eu-154" # nucliede "symbol-massnumber-m/D(If needed)"
threshhold_intensity = 0.49   # Minimum intensity in pwersent % (0.90%)
bin.size <- 0.0001  # Bin size of spectra   0.0001= 100 eV

# Generate file name 
output_file =  sprintf("All_nuclides_%s_spectr_thrsh_%f_inp.txt", nuclide1, threshhold_intensity)

lara_data_read <- function(nuclide,threshhold_intensity){
  # Read lara data file 
  lara_data_file = sprintf("%s.lara.txt", nuclide)
  url_lara = sprintf("http://www.nucleide.org/DDEP_WG/Nuclides/%s", lara_data_file)
  all_content = readLines(url_lara)
  Head_skip = all_content[-c(1:grep("--------",all_content))]
  data_lara <- read.table(textConnection(Head_skip[-length(Head_skip)]), header = TRUE, sep = ";", quote = "")
  
  # Make a subset for a threshhold intensity (eg. > 0.9 )
  data_sub = subset(data_lara, data_lara$Intensity.... > threshhold_intensity)
  
  # Change the column name of requried data
  colnames(data_sub)[c(1,3,5)] <- c('Energy_ev','Intensity_frac', 'Type')
  data_sub_only = data_sub[c(1,3,5)]
  return(data_sub_only)
}

nuclide1_data = lara_data_read(nuclide1,threshhold_intensity)
nuclide2_data = lara_data_read(nuclide2,threshhold_intensity)
nuclide3_data = lara_data_read(nuclide3,threshhold_intensity)
nuclide4_data = lara_data_read(nuclide4,threshhold_intensity)

data_all = merge(x = nuclide1_data, y = nuclide2_data, by = c('Energy_ev','Intensity_frac', 'Type'), all = TRUE)

data_all = merge(x = data_all, y = nuclide3_data, by = c('Energy_ev','Intensity_frac', 'Type'), all = TRUE)

data_all = merge(x = data_all, y = nuclide4_data, by = c('Energy_ev','Intensity_frac', 'Type'), all = TRUE)

# Remove alfa lines 
data_all = subset(data_all, data_all$Type !='a')

# Create and open an text file to write the spectra 
file.create(output_file)
fileConn1 <- file(output_file, "w")

#Write the spectra in text file .... two lines for a bin..... intensity is -1 for last line 
for(i in 1:nrow(data_all)){
  #write(sprintf('myfile.write ("SPECTR   \ %fe6\   \ %f\\n")', (data_all$Energy_ev[i]*0.001), (data_all$Intensity_frac[i]/100)), fileConn1, append=TRUE)
  write(sprintf("SPECTR   \ %fe6\   \ %f", (data_all$Energy_ev[i]*0.001), (data_all$Intensity_frac[i]/100)), fileConn1, append=TRUE)
  if(i != nrow(data_all)){
    #write(sprintf('myfile.write ("SPECTR   \ %fe6\   \ %f\\n")', ((data_all$Energy_ev[i]*0.001)+bin.size), (0)), fileConn1, append=TRUE)
    write(sprintf("SPECTR   \ %fe6\   \ %f", ((data_all$Energy_ev[i]*0.001)+bin.size), (0)), fileConn1, append=TRUE)
  }else{
    #write(sprintf('myfile.write ("SPECTR   \ %fe6\   \ %f\\n")', ((data_all$Energy_ev[i]*0.001)+bin.size), (-1)), fileConn1, append=TRUE)
    write(sprintf("SPECTR   \ %fe6\   \ %f", ((data_all$Energy_ev[i]*0.001)+bin.size), (-1)), fileConn1, append=TRUE)
  }
}
close(fileConn1)
file.show(output_file)
