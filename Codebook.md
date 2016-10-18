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