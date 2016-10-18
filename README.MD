---
title: "Getting and Cleaning Data"
output: github_document
---

## Assignment Summary

Data Source:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Task:

* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement.
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names.
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## System Environment

* Operating System: macOS Sierra 10.12
* IDE: RStudio 0.99.903
* R: R 3.3.1

## Special Notes For Peer Review

* Plyr package are required.
* Variables contains meanfreq() are not included. 

## Code Markdown
* Load Libraries
```
library(plyr)
```
* Download and Unzip Data File
```
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file<-"temp.zip"
download.file(url,file)
unzip(file)
```
* Read activity labels from activity_labels.txt
```
activities<-read.table("UCI HAR Dataset/activity_labels.txt")
activities<-as.character(activities$V2)
```
* Read features list from features.txt
```
features<-read.table("UCI HAR Dataset/features.txt")
features<-as.character(features$V2)
```
* Read test data from X_test.txt, y_test.txt and subject_test.txt
```
testX<-read.table("UCI HAR Dataset/test/X_test.txt")
testY<-read.table("UCI HAR Dataset/test/y_test.txt")
testsubject<-read.table("UCI HAR Dataset/test/subject_test.txt")
```
* Read test data from X_train.txt, y_train.txt and subject_train.txt
```
trainX<-read.table("UCI HAR Dataset/train/X_train.txt")
trainY<-read.table("UCI HAR Dataset/train/y_train.txt")
trainsubject<-read.table("UCI HAR Dataset/train/subject_train.txt")
```
* Rename column names and combine test data
```
colnames(testX)<-features
colnames(testY)<-"activity"
colnames(testsubject)<-"subjectid"
testdata<-cbind(testsubject,testY,testX)
```
* Rename column names and combine train data
```
colnames(trainX)<-features
colnames(trainY)<-"activity"
colnames(trainsubject)<-"subjectid"
traindata<-cbind(trainsubject,trainY,trainX)
```
* Combine test and train data
```
totaldata<-rbind(testdata,traindata)
```
* Subset data with mean() and std()
```
tidydata<-cbind(totaldata[,1:2],totaldata[, grep("mean\\(|std\\(",names(totaldata))])
```
*  Rename variables using descriptive names
```
col<-colnames(tidydata)
col<-tolower(col)  ## Change to lower case
col<-gsub("^t","time",col)  ## Change abbrivation to full name
col<-gsub("^f","fastfouriertransform",col)
col<-gsub("acc","accelerometer",col)
col<-gsub("gyro","gyroscope",col)
col<-gsub("mag","magnitude",col)
col<-gsub("\\-mean\\(\\)", "meanvalue", col) ## Change suffix
col<-gsub("\\-std\\(\\)", "standarddeviation", col)
col<-gsub("\\-x", "inthexdirection", col)
col<-gsub("\\-y", "intheydirection", col)
col<-gsub("\\-z", "inthezdirection", col)
colnames(tidydata)<-col ## Update Column Names
```
* Change acvitity ID to activity names
```
tidydata$activity<-as.factor(tidydata$activity)
activities<-tolower(activities)
activities<-gsub("_","",activities)
levels(tidydata$activity)<-activities
```
* Create new data set for mean values
```
meantidydata<-aggregate(.~subjectid+activity, tidydata, mean)
meantidydata<-meantidydata[order(meantidydata$subjectid, meantidydata$activity),]
```
* Write result 
```
write.table(meantidydata,file="tidydata.txt",row.name=FALSE)
```