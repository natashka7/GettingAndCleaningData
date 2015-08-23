# 1. Merge the training and the test sets to create one data set

x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

# Combine data tables
x <- rbind(x_train, X_test)
y <- rbind(y_train, y_test)
s <- rbind(subject_train, subject_test)


# 2. Extract only the measurements on the mean and standard deviation for each measurement

features <- read.table("./UCI HAR Dataset/features.txt")
names(features) <- c('feat_id', 'feat_name')

# Search for matches to argument mean or standard deviation within each element of character vector
index_features <- grep("-mean\\(\\)|-std\\(\\)", features$feat_name) 
x <- x[, index_features] 

# Replace all matches of a string features 
names(x) <- gsub("\\(|\\)", "", (features[index_features, 2]))


# 3. Use descriptive activity names to name the activities in the data set
# and 4. Appropriately label the data set with descriptive activity names

activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
names(activities) <- c('act_id', 'act_name')
y[, 1] = activities[y[, 1], 2]

names(y) <- "Activity"
names(s) <- "Subject"

# Combine data table by columns
tidyDataSet <- cbind(s, y, x)


# 5. Creates a second independent tidy data set with the average of each variable for each activity and each subject

t <- tidyDataSet[, 3:dim(tidyDataSet)[2]] 
tidyDataSet_Avg <- aggregate(t,list(tidyDataSet$Subject, tidyDataSet$Activity), mean)

names(tidyDataSet_Avg)[1] <- "Subject"
names(tidyDataSet_Avg)[2] <- "Activity"

# Create tidyDataSet_Avg .txt file
write.table(tidyDataSet_Avg, file = "tidyDataSet_Avg.txt", row.name = FALSE)