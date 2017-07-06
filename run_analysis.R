## Coursera Getting and Cleaning Data Course Project
## ------------------------------------------------------

## Section 1 - Creates directory for and downloads and reads files into the following dataframes: 
## - features
## - actnames
## - X_train
## - y_train
## - sub_train
## - X_test
## - y_test
## - sub_test
## Also cleans environments and loads relevant packages

## Create "/getclnprojectfiles" directory for downloaded files
if (!getwd() == "./getclnprojectfiles") {
  dir.create("./getclnprojectfiles")
}
## Clean environment
rm(list = ls(all = TRUE))

## Load required packages
library(data.table)
library(dplyr)


##  Download zip file in a temporary folder and unzip it there
temp <- tempfile()
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
unzip(temp, list = TRUE) 


## Create the variables for this data set
features<-read.table(unzip(temp,"UCI HAR Dataset/features.txt"))
actnames<-read.table(unzip(temp,"UCI HAR Dataset/activity_labels.txt"))
X_train<-read.table(unzip(temp,"UCI HAR Dataset/train/X_train.txt"))
y_train<-read.table(unzip(temp,"UCI HAR Dataset/train/y_train.txt"))
sub_train<-read.table(unzip(temp,"UCI HAR Dataset/train/subject_train.txt"))
sub_test<-read.table(unzip(temp,"UCI HAR Dataset/test/subject_test.txt"))
y_test<-read.table(unzip(temp,"UCI HAR Dataset/test/y_test.txt"))
X_test<-read.table(unzip(temp,"UCI HAR Dataset/test/X_test.txt"))
unlink(temp)
## ------------------------------------------------------

## Section 2 - Prepares X_train and X_test datasets for merge by providing 
## a more understandable participant (subject) column name ("participant")
## and adding the base feature names from the features.txt file as column 
## headers.

##Add participant (subject) column headers
colnames(sub_train) <- "participant"
colnames(sub_test) <- "participant"

##Add feature names to X_train and X_test
colnames(X_train) <- t(features[2])
colnames(X_test) <- t(features[2])

## Add participant (subject) dataframes to X_train and X_test dataframes
X_train1<-cbind(sub_train,X_train)
X_test1<-cbind(sub_test,X_test)

## ------------------------------------------------------

## Section 3 - Adds y_train and y_test activity index numbers and the act.index 
## column header to the 2nd column of the X_train and X_test dataframes


colnames(y_train)<-"act.index"
colnames(y_test)<-"act.index"

X_train_y<-cbind(y_train,X_train1)
X_test_y<-cbind(y_test,X_test1)

##-----------------------------------------------------

## Section 4 - Adds source file name to the first columns of X_train and X_test
## dataframes. This is an important step and an important field to retain in the base dataframe 
## since it allows analysis based on comparison of the original test groups

## Adds source file name to first columns of X_train and X_test
## and sets it to character class
X_train2<-cbind(File="X_train", X_train_y, stringsAsFactors=FALSE)
X_test2<-cbind(File="X_test", X_test_y, stringsAsFactors=FALSE)

##-----------------------------------------------------

## Section 5 - Merges the train (X_train) and the test (X_test) sets to create 
## one data set called "bind_big"
bind_big<-rbind(X_train2,X_test2)

##-----------------------------------------------------

## Section 6 - Creates a dataframe ("mean.std") showing only mean and standard 
## deviation measurements and includes the following columns:
## - File
## - act.index
## - participant
## - All columns including the strings "mean" and "std"

##subset file, actindex and subject name columns
bind_fileact<- bind_big[,c("File","act.index","participant")]

##subset mean columns
bind_mean<- bind_big[,colnames(bind_big)[grep("mean",colnames(bind_big))]]

##subset std columns
bind_std<- bind_big[,colnames(bind_big)[grep("std",colnames(bind_big))]]

##combine columns into mean.std dataframe
mean.std<- cbind(bind_fileact,bind_mean,bind_std)

## ------------------------------------------------------

## Section 7 - Merge descriptive Activity Labels from the activity_labels file 
## to the y_train and y_test dataframes using provided index numbers


## Creates mean.std2 to distinguish it from the original mean.std dataframe as it 
## will be modified in this step, and adds the "activity" column to the 3rd column 
## of the mean.std dataframe
mean.std2<-mean.std
mean.std2$activity<-"activity"
mean.std2<-mean.std2[,c(1:2,83,3:82)]

## Adds descriptive column names to the bind_big dataframe
## based on the act.index column from the original "y_*" files
mean.std2$activity[mean.std2$act.index==1] <- "WALKING"
mean.std2$activity[mean.std2$act.index==2] <- "WALKING UPSTAIRS"
mean.std2$activity[mean.std2$act.index==3] <- "WALKING DOWNSTAIRS"
mean.std2$activity[mean.std2$act.index==4] <- "SITTING"
mean.std2$activity[mean.std2$act.index==5] <- "STANDING"
mean.std2$activity[mean.std2$act.index==6] <- "LAYING"

## ------------------------------------------------------

## Section 8 - Finalizes main "result" dataframe by labelling the data set with
## descriptive variable and participant (subject) names.

## Provision of descriptive sensor data variable names, without 
## presenting longer, more complicated descriptive names. See original
## UCI Read Me for more complete descriptions

result<-mean.std2
names(result) <- gsub("Acc", "Accelerator", names(result))
names(result) <- gsub("Mag", "Magnitude", names(result))
names(result) <- gsub("Gyro", "Gyroscope", names(result))
names(result) <- gsub("^t", "time", names(result))
names(result) <- gsub("^f", "frequency", names(result))

## Provide descriptive participant names
result$participant <- as.character(result$participant)
result$participant <- paste("Participant ", result$participant, sep="")
result$participant <- as.factor(result$participant)

## ------------------------------------------------------

## Section 9 - From the data set in Section 8 above called "result",  
## a second, independent tidy data set with the average of each variable for
## each activity and each subject is created

library(dplyr)
tidy.result<-result[,!(colnames(result) %in% c("File", "act.index"))] %>% 
  group_by(activity,participant) %>% summarise_all(funs(mean))
