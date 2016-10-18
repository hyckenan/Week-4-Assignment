---
title: "Code Book"
output: github_document
---

## Data Description

* Data Source: 

Human Activity Recognition Using Smartphones Dataset
Version 1.0

* Data description:

The data is adopted from reference 1, in which data was collected on 30 volunteers (subjectid = 1 ~ 30) performing six activities (walking, walking upstairs, walking downstairs, sitting, standing, laying) by a smartphone (Samsung Galaxy S II) on the waist. 

## Process Procedure

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

## Code Table

Code | Measure
------------- | -------------
subjectid | ID of volunteer 
activity | Activity 
time | Time domain data 
fastfouriertransform | Frequency domain data 
body | Body motion component
gravity | Gravity motion component
accelerometer | Accelerometer data
gyroscope | Gyroscope data
jerk | Jerk signals
magnitude | Euclidean norm of signals
meanvalue | Mean values
standarddeviation | Standard Deviation
inthexdirection | Signal in the X direction
intheydirection | Signal in the Y direction
inthezdirection | Signal in the Z direction

## References

1. Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012