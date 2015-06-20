# CodeBook
## Summary
By processing the *[UCI HAR Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)*, the script **[run_analysis.R](../master/run_analysis.R)** creates two data sets:

1. **harDB**: a data frame containing a selection of the original measures for all the records in the train and test sets
1. **harDB_m**: a data frame with the averages of the measures contained in the `harDB` data frame calculated grouping records by subject id and activity type

Furthermore, the `harDB_m` data frame is exported as a text file (**harDB_m.txt**) in the working directory.

CONTENTS

1. [UCI HAR Dataset](#UCIHAR)
1. [UCI HAR Tidiness](#tidiness)
1. [Used Data](#used-data)
1. [`harDB` data frame](#harDB)
1. [`harDB_m` data frame](#harDB_m)
1. [Exported data](#export)
1. [R Global Environment postcondition status](#postconditions)


## <a name="UCIHAR">UCI HAR Dataset</a>
The *[Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)* from the UCI Machine Learning Repository, contains data collected through an experiment conducted by the [Smartlab Department](www.smartlab.ws) of the University of Genova. The database is built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.

For further details on the experiment and the original collected measures, see the following files contained in the **UCI HAR Dataset.zip** archive:

1. `README.txt`, containing
    + a general description of the experiment
    + a detailed description of the folder structure
    + the licence terms
1. `features_info.txt`, containing a detailed description of the collected measures (unit measures, collection methods, etc.)

The experiments have been carried out with a group of 30 volunteers where everyone performed six activities: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The [UCI HAR Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata/projectfiles/UCI HAR Dataset.zip) archive used hereafter is the one linked from the course website. Original data provided by the [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI HAR Dataset.zip) should work equally well, but are untested.


## <a name="tidiness">Tidiness of the UCI HAR Data Set</a>
According to [Wickham](http://vita.had.co.nz/papers/tidy-data.html), in a tidy data set:

1. Each variable forms a column.
2. Each observation forms a row.
3. Each type of observational unit forms a table.

In the UCI HAR Data Set information is separated into several files, clearly contradicting the above principles. Indeed, here we have two distinct problems:

1. The full data set is divided in multiple tables (the training and the test sets)
1. A single observational unit is stored in multiple tables (the subject who performed the activity and the activity performed are kept separated from the measures)

To create a tidy data set, we have to reconstruct the single observational units for each of the partial sets and then merge the two sets.


## <a name="used-data">Details on the used data</a>
Information for the training and the test data sets are contained in separate subfolders and each set is divided into three files:

1. `subject_????.txt` contains subject IDs; each row identifies the subject who performed the activity and the range is from 1 to 30. 
1. `y_????.txt` contains activity type IDs; each row identifies the activity type and its range is from 1 to 6.
1. `X_????.txt` contains a n by 561 table of recorded measures

The training and the test data sets contain 7352 and 2947 records respectively.

The mapping between columns and variable names is recorded in the `features.txt` file, while the mapping between the activity type id and the activity label is contained in the `activity_labels.txt` file.

All files are text data, space separated, without headers.

## <a name="harDB">**`harDB`** data frame</a>
To create the `harDB` data frame, the script performs the following actions:

1. For both the training and the test sets, it loads the subject, activity and measures files and `cbind` them. The two data frames are `rbind` to get a comprehensive data frame.
1. Variable names are read from `features.txt`. All *std()*, *mean()* and *meanFreq()* variables are identified using regexps and their respective columns are selected from the full data frame. **Should a narrower or wider definition be required, you have to adjust the regexp to select the correct variable names**. Given the actual regexps, 79 variables are selected.
1. Activity type IDs are recoded as factors and labeled according to the mapping contained in the `activity_labels.txt` file.
1. As the original variable names are consistently assigned (cfr. `features_info.txt`), the information contained in the file `features.txt` can be recycled to appropriately label the data set. This approach has the advantage of keeping a link between our subset and the original UCI data set. The first and second columns are named `SubjectID` and `ActivityType` respectively; from the third column, names are assigned according the relevant regexps. 

The resulting data frame has 81 columns (SubjectID, ActivityType and 79 measurement variables) and 10299 records.


## <a name="harDB_m">**`harDB_m`** data frame</a>
The second data frame containing the averages of the measures in the `harDB` data frame is obtained performing the following actions:

1. The `harDB` data frame is partitioned using the subject ID and activity type as factor variables with the `split` function.
1. The average of each variable is calculated using the `lapply` and `colMeans` functions.
1. The resulting list is aggregated and assigned to the `harDB_m` variable.
1. The data frame is ordered according to `SubjectID` and `ActivityType`

Columns in the `harDB_m` data frame are labeled adding the prefix `avg-` to the original variable names to mantain a logic link with the `harDB` data frame.

The resulting data frame has 81 columns (SubjectID, ActivityType and 79 measurement variables) and 180 records (30 subjects by 6 activities).


## <a name="export">Exported data</a>
The `harDB_m` data frame is exported to the `harDB_m.txt` file using the `write.table` function. All the options are left to default values, but `row.names` that is set to false.


## <a name="postconditions">R Global Environment postcondition status</a>
All the intermediate variables and utility functions are removed from the Global Environment and only the `harDB` and the `harDB_m` data frame are left untouched.
