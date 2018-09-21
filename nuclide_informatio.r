library(utils)
#'''Read an lara text file and write an spectra file for PENELOPE''''

####..... Input data ....#####
nuclide = "Co-60" # nucliede "symbol-massnumber-m/D(If needed)"
threshhold_intensity = 0 # Minimum intensity in pwersent % (0.90%)
bin.size <- 0.0001  # Bin size of spectra   0.0001= 100 eV

# Generate file name 
lara_data_file = sprintf("%s.lara.txt", nuclide)
output_file =  sprintf("%s_spectr_thrsh_%f_inp.txt", nuclide, threshhold_intensity)

# Read lara data file 
url_lara = sprintf("http://www.lnhb.fr/nuclides/%s", lara_data_file)
all_content = readLines(url_lara)
all_content[3]
Head_skip = all_content[c(1:grep("--------",all_content))]
Head_skip
data_lara <- read.csv2(textConnection(Head_skip[-length(Head_skip)]), header = FALSE, sep = ";", quote = "")

data_lara$V1 = as.character(data_lara$V1)
data_lara$V2 = as.character(data_lara$V2)
data_lara$V3 = as.character(data_lara$V3)
data_lara$V4 = as.character(data_lara$V4)
half_life <-  as.numeric(data_lara[which(data_lara$V1 == "Half-life (s) "), 2])

half_life


