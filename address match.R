## !! Update this to be where your files are stored
base.dir <- file.path("C:", "Users", "Dylan", "Dropbox", "R", "ACNJ", "newark-addresses")

load(file=file.path(base.dir, "Property.Rdata"))
load(file=file.path(base.dir, "Lines.Rdata"))

# See the columns for each table
colnames(property)
colnames(lines)

# Compile the complete address in a single field
lines$usps.full <- paste0(lines$usps.address, ", ", lines$usps.city, ", ", lines$usps.state, " ", lines$usps.zip5, "-", lines$usps.zip4)
property$usps.full <- paste0(property$usps.address, ", ", property$usps.city, ", ", property$usps.state, " ", property$usps.zip5, "-", property$usps.zip4)

# See the values for a specific column
property$usps.full
lines$usps.full

# See the values for specific rows (1 through 10) and columns usps.address and usps.city
property[1:10, c('usps.address', "usps.city")]

#The total number of rows in the property table 30,789
nrow(property)

# The total number of rows in the lines table 24,628
nrow(lines)

# There are 1,510 duplicates in property file after USPS address verification
nrow(property[duplicated(property$usps.full), ])

# See the duplicates
property[duplicated(property$usps.full), ]

# 173 property records did not succeed with USPS
sum(is.na(property$usps.address))

property$property.location[is.na(property$usps.address)]

# 1,150 line addresses did not succed with USPS
sum(is.na(lines$usps.address))

property$usps.full[is.na(property$usps.address)] <- NA

pl <- merge(property, lines, all.x=TRUE, all.y=FALSE, by="usps.full")
nrow(pl)

# 18,390 (18,563 - 173) did not match
sum(is.na(pl$usps.address.y))

#12,735 records did match
sum(!is.na(pl$usps.address.y))

# See the records that have a property address AND NO line address
pl[(!is.na(pl$usps.full)) && (is.na(pl$usps.address.y)), c('usps.full')]

# Look at the lines that match on MANCHESTER
lines[grepl(x=lines$X.2, pattern="MANCHESTER"), c('X', 'X.1', 'X.2')]

# Needed due to bug when reading the original USPS results
pl$usps.address.x <- paste0(pl$usps.address.x)
pl$usps.address.y <- paste0(pl$usps.address.y)
pl$usps.city.x <- paste0(pl$usps.city.x)
pl$usps.city.y <- paste0(pl$usps.city.y)
pl$usps.state.x <- paste0(pl$usps.state.x)
pl$usps.state.y <- paste0(pl$usps.state.y)
pl$usps.zip4.x <- paste0(pl$usps.zip4.x)
pl$usps.zip4.y <- paste0(pl$usps.zip4.y)
pl$usps.zip5.x <- paste0(pl$usps.zip5.x)
pl$usps.zip5.y <- paste0(pl$usps.zip5.y)
pl$usps.state.y <- paste0(pl$usps.state.y)

# Save the file to a CSV
write.csv(x=pl, file=file.path(base.dir, "join.csv"))