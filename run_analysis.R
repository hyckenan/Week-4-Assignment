## Load Libraries
library(plyr)
## Download and Unzip Data File
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file<-"temp.zip"
download.file(url,file)
unzip(file)
## Read Activities
activities<-read.table("UCI HAR Dataset/activity_labels.txt")
activities<-as.character(activities$V2)
## Read Features
features<-read.table("UCI HAR Dataset/features.txt")
features<-as.character(features$V2)
## Read Test Data
testX<-read.table("UCI HAR Dataset/test/X_test.txt")
testY<-read.table("UCI HAR Dataset/test/y_test.txt")
## Read Test Subject ID
testsubject<-read.table("UCI HAR Dataset/test/subject_test.txt")
## Read Train Data
trainX<-read.table("UCI HAR Dataset/train/X_train.txt")
trainY<-read.table("UCI HAR Dataset/train/y_train.txt")
## Read Train Subject ID
trainsubject<-read.table("UCI HAR Dataset/train/subject_train.txt")
## Rename Colnames and Combine Test Data
colnames(testX)<-features
colnames(testY)<-"activity"
colnames(testsubject)<-"subjectid"
testdata<-cbind(testsubject,testY,testX)
## Rename Colnames and Combine Train Data
colnames(trainX)<-features
colnames(trainY)<-"activity"
colnames(trainsubject)<-"subjectid"
traindata<-cbind(trainsubject,trainY,trainX)
## Combine Test and Train Data
totaldata<-rbind(testdata,traindata)
## Subset data with mean() and std()
tidydata<-cbind(totaldata[,1:2],totaldata[, grep("mean\\(|std\\(",names(totaldata))])
## Rename Variables using Descriptive Names
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
## Change Acvitity ID to Activity Names
tidydata$activity<-as.factor(tidydata$activity)
activities<-tolower(activities)
activities<-gsub("_","",activities)
levels(tidydata$activity)<-activities
## Create Mean Tidydata
meantidydata<-aggregate(.~subjectid+activity, tidydata, mean)
meantidydata<-meantidydata[order(meantidydata$subjectid, meantidydata$activity),]
## Write Result 
write.table(meantidydata,file="tidydata.txt",row.name=FALSE)