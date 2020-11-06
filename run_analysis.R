# locbindad dplyr
library(dplyr)

# read feature names
featureNames <- read.delim("UCI HAR Dataset/features.txt", header = FALSE, sep = " ")

# read activity Mapping
activityMap <- read.delim("UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = " ")
# set names
names(activityMap) <- c("activity_id", "activity_name")

# read test feature data  - step 1 create a 561 long vector of number 16 to help with breaking down the features, step 2 load data 
fwfsize <- rep(c(16), 561)
testFeatures <- read.fwf("UCI HAR Dataset/test/X_test.txt", fwfsize, header=FALSE)
# read test activities
testActivities <- read.delim("UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE)  # only 1 value per observation
# read test subjects
testSubjects <- read.delim("UCI HAR Dataset/test/subject_test.txt",sep = "", header= FALSE) # only 1 value per observation

# read train feature data
trainFeatures <- read.fwf("UCI HAR Dataset/train/X_train.txt", fwfsize, header=FALSE)
# read train activities
trainActivities <- read.delim("UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE)  # only 1 value per observation
# read train subjects
trainSubjects <- read.delim("UCI HAR Dataset/train/subject_train.txt", sep = "", header= FALSE) # only 1 value per observation

# create 1 single data frame for features
features <- rbind(testFeatures, trainFeatures)
# create 1 single data frame for activities
activities <- rbind(testActivities, trainActivities)
# create 1 single data frame for subjects
subjects <- rbind(testSubjects, trainSubjects)

# clean up
rm(testFeatures)
rm(trainFeatures)
rm (testActivities)
rm (trainActivities)
rm (testSubjects)
rm (trainSubjects)

# set feature column names
names(features) <- featureNames[,2]
# set activities column names
names(activities) <- c("activity_id")
# set subject column names
names(subjects) <- c("subject_id")

# Extract Averages and Std
avgStdFeatures <- features[,grepl("mean|std", featureNames[,2], ignore.case = TRUE)]

# Add Activity Marker and Subject ID
subject_activity_data <- cbind(subjects, activities, avgStdFeatures)

# merge readable activity name to main dataset
subject_activity_data <- merge(subject_activity_data, activityMap, by.x = "activity_id", by.y = "activity_id", all = TRUE)

#group data by activity name and subject
final_data <- subject_activity_data %>% group_by(activity_name, subject_id)

# summarize by the groups
summary_final_data <- final_data %>% summarise_at(names(avgStdFeatures), mean, na.rm = TRUE)

# write table out
write.table(summary_final_data, "gcd-assignment-tidydata.txt",  row.names=FALSE)
