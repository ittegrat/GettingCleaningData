# Getting and Cleaning Data Course Project
## Summary
The aim of the R script **[run_analysis.R](../master/run_analysis.R)** provided in this repository is to produce:

1. **harDB**: a data frame in the R global environment containing a selection of the original measures for all the records included in the *[Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)*
1. **harDB_m**: a data frame with the averages of the measures contained in the `harDB` data frame calculated grouping records by subject id and activity type
1. **harDB_m.txt**: a text file in the working directory containing the `harDB_m` data set

Details on the HAR data set and on the process to create the two tidy data sets can be found in the [CodeBook.md](../master/CodeBook.md) file.

For additional details, see also comments in the `run_analysis.R` script.

## Running The Script
The script assumes a standard installation of R (tested on R v3.2.0). No additional packages are required.

The script performs the following actions:

1. If the zip file containing the HAR data set does not exist in the working directory, download it from the URL provided in the details section of the course project.
1. If the data folder containing the original UCI files does not exist in the working directory, extract all the files from the zip archive. An alternative approach could be to extract only the necessary files using a connection.
1. As information is separated into several files, it merges all the pieces to create a full tidy data set.
1. Extracts only the measurements on the mean and standard deviation for each measurement. Here are selected both the *mean()* and *meanFreq()* variables. **Should a narrower or wider definition be required, you have to adjust the regexp to select the correct variable names**.
1. Activity IDs are recoded as factors and labeled accordingly.
1. Use original variable names to label the columns of the full data set.
1. Creates a second data set with the averages of the measures contained in the `harDB` data frame grouped by subject id and activity type.
1. Export the `harDB_m` data frame to the `harDB_m.txt` file.
1. Clear all temporary variables.

All the files gathered in this folder provide a solution for the Coursera [Getting And Cleaning Data](https://class.coursera.org/getdata-015) course project.
