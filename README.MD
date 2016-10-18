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

* Plyr and Reshape2 packages are required.
* Variables contains meanfreq() are not included. 

## Code Markdown
* Load Libraries
```
library(plyr)
library(reshape2)
```
* Download and Unzip Data File
```
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file<-"temp.zip"
download.file(url,file)
unzip(file)
```
* Read Data
```
activities<-read.table("UCI HAR Dataset/activity_labels.txt")
activities<-as.character(activities$V2)
features<-read.table("UCI HAR Dataset/features.txt")
features<-as.character(features$V2)
testX<-read.table("UCI HAR Dataset/test/X_test.txt")
testY<-read.table("UCI HAR Dataset/test/y_test.txt")
testsubject<-read.table("UCI HAR Dataset/test/subject_test.txt")
trainX<-read.table("UCI HAR Dataset/train/X_train.txt")
trainY<-read.table("UCI HAR Dataset/train/y_train.txt")
trainsubject<-read.table("UCI HAR Dataset/train/subject_train.txt")
```
* Rename Colnames and Combine Test and Train Data
```
colnames(testX)<-features
colnames(testY)<-"activity"
colnames(testsubject)<-"subjectid"
testdata<-cbind(testsubject,testY,testX)
colnames(trainX)<-features
colnames(trainY)<-"activity"
colnames(trainsubject)<-"subjectid"
traindata<-cbind(trainsubject,trainY,trainX)
totaldata<-rbind(testdata,traindata)
```
* Subset data with mean() and std()
```
tidydata<-cbind(totaldata[,1:2],totaldata[, grep("mean\\(|std\\(",names(totaldata))])
```
*  Rename Variables using Descriptive Names
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
* Change Acvitity ID to Activity Names
```
tidydata$activity<-as.factor(tidydata$activity)
activities<-tolower(activities)
activities<-gsub("_","",activities)
levels(tidydata$activity)<-activities
```
* Create New Tidydata set
```
melttidydata<-melt(tidydata,id.vars=c("subjectid","activity"))
meantidydata<-ddply(melttidydata, .(subjectid, activity), summarise, meanvalue=mean(value))
```
* Write Result 
```
write.table(meantidydata,file="tidydata.txt",row.name=FALSE)
```