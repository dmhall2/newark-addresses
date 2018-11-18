# This file loads the Newark CSV files, runs them through USPS address verifier,
# and saves the results to an R data file

# ! UPDATE TO MATCH YOUR LOCATION
base.dir <- file.path("C:", "Users", "Dylan", "Dropbox", "R", "ACNJ", "newark-addresses")

property <- read.csv(file=file.path(base.dir, "Newark residential property - 1.csv"))
lines <- read.csv(file=file.path(base.dir, "All Lead Service Lines.csv"))

# Load the functions from the utility file
# You may need to run the command:
# install.packages('XML')
# the first time
source(file.path(base.dir, "utility.R"))

# Add new columns to store USPS results
property$usps.city <- NA
property$usps.state <- NA
property$usps.address <- NA
property$usps.zip5 <- NA
property$usps.zip4 <- NA

# Loop through each row and run through USPS verifier
for (itr in 1:nrow(property)) {
  
  # Show progress
  if (itr %% 10 == 0) {
    print(itr)
  }
  
  value <- tryCatch({validate_address_usps(street=property$property.location[itr], city="NEWARK", state="NJ")}, error=function(cond){ return (NULL) }, warning=function(cond) { return(NULL)})
  if (is.data.frame(value)) {
    if (nrow(value) > 0) {
      property$usps.city[itr] <- value$City[[1]]
      property$usps.state[itr] <- value$State[[1]]
      property$usps.address[itr] <- value$Address2[[1]]
      property$usps.zip5[itr] <- value$Zip5[[1]]
      property$usps.zip4[itr] <- value$Zip4[[1]]      
    }
  }
}

save(x=property, file=file.path(base.dir, "Property.Rdata"))

lines$usps.city <- NA
lines$usps.state <- NA
lines$usps.address <- NA
lines$usps.zip5 <- NA
lines$usps.zip4 <- NA

for (itr in 1:nrow(lines)) {
  
  if (itr %% 10 == 0) {
    print(itr)
  }
  
  address <- paste(lines$X[itr], lines$X.2[itr], sep=" ")
  value <- tryCatch({validate_address_usps(street=address, city="NEWARK", state="NJ")}, error=function(cond){ return (NULL) }, warning=function(cond) { return(NULL)})
  
  if (is.data.frame(value)) {
    if (nrow(value) > 0) {
      lines$usps.city[itr] <- value$City[[1]]
      lines$usps.state[itr] <- value$State[[1]]
      lines$usps.address[itr] <- value$Address2[[1]]
      lines$usps.zip5[itr] <- value$Zip5[[1]]
      lines$usps.zip4[itr] <- value$Zip4[[1]]      
    }
  }
}

save(x=lines, file=file.path(base.dir, "Lines.Rdata"))