# gettingcleaningdata

Readme.txt
Coursera Getting and Cleaning Data Course Project
-------------------------------------------------

DESCRIPTION OF run_analysis.R SCRIPT FILE:

The file can be broken down in to 9 secitons. Each section is explained below:

Section 1 - Downloads and reads files into the following dataframes: 
   - features
   - actnames
   - X_train
   - y_train
   - sub_train
   - X_test
   - y_test
   - sub_test
   
Section 2 - Prepares X_train and X_test datasets for merge by providing a more understandable participant (subject) column name ("participant") and adding the base feature names from the features.txt file as column headers.

Section 3 - Adds y_train and y_test activity index numbers and the act.index column header to the 2nd column of the X_train and X_test dataframes.

Section 4 - Adds source file name to the first columns of X_train and X_test dataframes. This is an important step and an important field to retain in the base dataframe since it allows analysis based on comparison of the original test groups.

Section 5 - Merges the train (X_train) and the test (X_test) sets to create  one data set called  "bind_big".

Section 6 - Creates a dataframe ("mean.std") showing only mean and standard deviation measurements and includes the following columns:
   - File
   - act.index
   - participant
   - All columns including the strings "mean" and "std"

Section 7 - Step 7 - Merge descriptive Activity Labels from the activity_labels file to the y_train and y_test dataframes using provided index numbers.

Section 8 - Finalizes main "result" dataframe by labelling the data set with descriptive variable and participant (subject) names.

Section 9 - From the data set in Step 8 above called "result", a second, independent tidy data set called "tidyresult" with the average of each variable for each activity and each subject is created. 
The tidy column names have been elucidated using the following conventions, where the non-descriptive prefix has been replaced by the following description:
  - ^t   >> time
  - ^f   >> frequency
  - Acc  >> Accelerator
  - Gyro >> Gyroscope
  - Mag  >> Magnitude

For further details regarding the variables listed in the tidyresult file, see affiliated codebook.

