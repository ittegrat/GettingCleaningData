
# This script performs the following actions:
#  1. If the zip file containing the HAR data set does not exist in the
#     working directory, download it from the URL set in *harURL* (here set
#     as the link provided in the details section of the course project).
#     If *harDir* does not exist in the working directory, extract all the
#     files from the zip archive.
#  2. Merges the training and the test sets to create a full data set.
#  3. Extracts only the measurements on the mean and standard deviation
#     for each measurement. Here are selected both the mean() and meanFreq()
#     variables. Should a narrower or wider definition be required, you have
#     to adjust the regexp to select the correct variable names.
#  4. To assign descriptive activity names to the activity IDs in the data
#     set, IDs are recoded as factors and labeled according to the mapping
#     contained in the activity_labels.txt file.
#  5. As the original variable names are consistently assigned (cfr.
#     features_info.txt), the information contained in the file features.txt
#     can be recycled to appropriately label the data set with descriptive
#     variable names.
#  6. Creates a second data set with the averages of the measures contained
#     in the *harDB* data frame grouped by subject id and activity type.
#  7. Clear all temporary variables
#


# 1. Download and prepare raw data
#-----------------------------------------------------------

# Set global variables
harURL <- "https://d396qusza40orc.cloudfront.net/getdata/projectfiles"
harZip <- "UCI HAR Dataset.zip"
harDir <- "UCI HAR Dataset"

# If necessary, download data file in binary mode
if (!file.exists(harZip))
  download.file(paste0(harURL, "/", harZip), destfile=harZip, mode="wb")

# If necessary, extract data
if (!file.exists(harDir))
  unzip(harZip)


# 2. Merge the training and test sets
#    Relevant files are:
#      */subject_*.txt  subject id
#      */y_*.txt        activity id
#      */X_*.txt        561-feature database
#
#    For more info, see also the README.txt enclosed into
#    the downloaded zip file.
#-----------------------------------------------------------

# Utility function that returns a data frame containing a data set
get.dataset <- function(path,subset) {
  dbPath <- paste0(path, "/", subset)

  # All files are text data, space separated, without headers
  subj <- read.table(paste0(dbPath, "/", "subject_", subset, ".txt"))
  act  <- read.table(paste0(dbPath, "/", "y_", subset, ".txt"))
  dat  <- read.table(paste0(dbPath, "/", "X_", subset, ".txt"))

  data.frame(subj, act, dat)
}

# Load and merge train and test sets
harDB <- rbind(
  get.dataset(harDir, "train"),
  get.dataset(harDir, "test")
)


# Utility function used in step 3 and 4 to extract names
#-----------------------------------------------------------
get.names <- function(fname) {
  # All files are text data, space separated, without headers
  map <- read.table(paste0(harDir, "/", fname), stringsAsFactors=F)
  map <- map[order(map[1]), ]
  map[[2]]
}


# 3. Extracts only the measurements on the mean and standard
#    deviation for each measurement.
#-----------------------------------------------------------

# Read variable names from file
features <- get.names("features.txt")

# Select all std(), mean() and meanFreq() variables using regexps
cols <- sort(
  c(
    grep("mean(Freq)?\\(\\)", features),
    grep("std()", features)
  )
)

# Select only the columns of interest
harDB <- harDB[ ,c(1,2,cols+2)]


# 4. Transform activity IDs into factors according to the
#    mapping contained in the activity_labels.txt file
#-----------------------------------------------------------

# Read activity names from file
activities <- get.names("activity_labels.txt")

# Recode activity IDs as factors
harDB[[2]] <- factor(harDB[[2]], labels=activities)


# 5. Appropriately labels the data set with descriptive
#    variable names recycling the information contained
#    in the file features.txt
#-----------------------------------------------------------

# Assign names to data frame columns
varNames <- c("SubjectID", "ActivityType", features[cols])
names(harDB) <- varNames


#  6. Creates the second data set with the average measures
#     of *harDB* variables grouped by subject and activity
#-----------------------------------------------------------

# Split the harDB data frame using subjects and activities
# as factors
harDB_l <- split(harDB,list(harDB$SubjectID,harDB$ActivityType))

# Calculate the average of each variable grouped by subject
# and activity
harDB_lm <- lapply(
  harDB_l,
  function(z) {
    data.frame(sID=z[1,1], actType=z[1,2], t(colMeans(z[3:ncol(z)])))
  }
)

# Create the second data frame
harDB_m <- do.call(rbind, c(make.row.names=F, harDB_lm))

# Reassign names to data frame columns
names(harDB_m) <- varNames

# Order the data set by subject and activity type
harDB_m <- harDB_m[order(harDB_m$SubjectID,harDB_m$ActivityType), ]

# Export the data set to harDB_m.txt
write.table(harDB_m, file="harDB_m.txt", row.names=F)

#  7. Clean-up all intermediate variables
#-----------------------------------------------------------
rm(harURL,harZip,harDir)
rm(activities,features,cols,varNames)
rm(harDB_l,harDB_lm)
rm(get.dataset,get.names)
