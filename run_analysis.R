## load dplyr library

library(dplyr)

dataset_dir <- "UCI_HAR_Dataset"

## load all feature names

features <- read.table(paste0(dataset_dir, "/features.txt"), header = FALSE, sep=" ",
                       stringsAsFactors = FALSE)

## load training datasets of features and labels

train_features <- read.table(paste0(dataset_dir, "/train/X_train.txt"), header = FALSE)
train_subjects <- read.table(paste0(dataset_dir, "/train/subject_train.txt"), 
                             header = FALSE, col.names = c("subject"))
train_labels <- read.table(paste0(dataset_dir, "/train/y_train.txt"), header = FALSE,
                           col.names = c("activity"))

## bind features and labels for training data

train_df <- cbind(train_features, train_subjects, train_labels)

## load test datasets of features and labels

test_features <- read.table(paste0(dataset_dir, "/test/X_test.txt"), header = FALSE)
test_subjects <- read.table(paste0(dataset_dir, "/test/subject_test.txt"),
                            header = FALSE, col.names = c("subject"))
test_labels <- read.table(paste0(dataset_dir, "/test/y_test.txt"), header = FALSE,
                          col.names = c("activity"))

## bind feautures and labels for test data

test_df <- cbind(test_features, test_subjects, test_labels)

## merge training and test datasets

df <- rbind(train_df, test_df)

## select only mean and std of measurements
index <- c(1:6, 41:46, 81:86, 121:126, 161:166, 201:202, 214:215, 227:228, 
           240:241, 253:254, 266:271, 345:350, 424:429, 503:504, 516:517,
           529:530, 542:543)
df <- select(df, index, subject, activity)

activity_labels <- c("walking","walking upstairs","walking downstairs","sitting",
                     "standing","laying")

## create activity as factor variable with descriptive labels

df <- mutate(df, subject = factor(subject), activity = factor(activity, labels = activity_labels))

## change column names to descriptive names

names(df)[1:length(index)] <- features$V2[index]

## create table with mean of measurements for all activities and all subjects

res <- df %>% group_by(subject, activity) %>% summarise_each(funs(mean))

## save table to file

write.table(res, "result.txt", row.names = FALSE)
