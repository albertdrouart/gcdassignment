---
title: "Getting and Cleaning Data - Course Project"
author: "Albert Drouart"
date: "11/5/2020"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Overview

For the final assignment of the Getting and Cleaning Data course I merged together 3 different data sources from the Human Activity Recognition Using Smartphones Dataset ("UCI HAR").   Once merge a generate a final summary dataset that includes the summary statistics for the mean/std values of the features that the study tracked.    The data set is a set of sensor readings from Samsung phones for 30 participants who performed a set of 6 activities.    Please see additional readme and feature explanations here:  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The output can be found in a file named: gcd-assignment-tidydata.txt

The UCI HAR expirement broke the group of 30 subjects into two groups, a test and a train group to satisfy the goals of their study.   

Within those two groups (test, train) the output of the study generate 3 files:
1. A file of sensor readings as an X variable - for example X_test.txt is the file for the test group of participants.
2. A file of Activity Identifiers as an Y variable - for example y_test.txt is the file for the activities during which the senor readings were recorded.
3. A file with the Subject identifiers corresponding with the rows of the sensor reading and activity.

Since the data is broken up like this, and the sensor data is recorded multiple times for each subject for each activity, each subject and each activity is repeated several times over the measurement interval.

In order to create an average of the averages and standard deviations for the subjects for each activity and combine the sensor readings a few steps were taken in R to create the final summary data set and tidy data.

1. First the dplyr package is loaded as it is used in the final few steps to group_by and summarize the data.
2. The feature names (the variables of the original study, representing the sensor readings) are loaded into a vector for use as column names in the final data table.
3. The activity ids and their full english name are loaded allowing us to convert activity ids in the traning set into human readable groups.
4. Then, for both the test population and the train population the features (561 features in all) are loaded into memory using a fixed width file approach - each field is exactly 16 wide, so a vector of 561, 16s is created as an argument into the read.fwf call.
5. Once the features are loaded for both populations, I create merged data frames for the activities, features and subjects - in total 10,299 observations. (I also clear up memory by removing the data frames that were used when originally loading now that everything is in 1 place for each data type)
6. I think apply the feature names loaded in step 2 above to the Feature data frame, allowing me to then use GREP to extract only those variables which are mean or stddev measures and ignoring the rest.
7. I then associate the 86 features extracted with their appropriate subject and activity label - this is simple because those data tables line up exactly with each of the 10,299 observations and extracted features.  This adds two columens to the extracted data.
8. To obtain a human readable activity namee, I then merge the activity data loaded in step 3 to the extracted 86 features of step 7 to add a column.  I know have the inal set of 89 columns/variables.
9. Once joined and merged I used the dplyr package to group_by the activity name and the subject before finalizing the call with summarise_at for the feature columns (86 in total).
10.  The final data set of summary by activity and subject of the 86 features is then saved to disk for review.

## Overview of Files 

 * run_analysis.R is the R code for reading and creating the summary and writing the final output
 * gcd-assignment-tidydata.txt is the final tidy data set with the summary details.
 * codebook_summary_final_data.Rmd provides an overview in detail of the contents of the file, including data types and additional information.
 * UCI HAR Dataset directory contains the source data from the original experiment.
 