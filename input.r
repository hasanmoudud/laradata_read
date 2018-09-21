fun <- function(){
  x <- readline("Name of the nuclides (e.g. Ra-226):")  
  y <- readline("Threshold for intensity in percentage (e.g. 1):")
  t <- readline("Bin size in MeV (e.g. 0.0001):")
  
  return(c(x, y,t))
  
}
g= fun()   
Co-60
