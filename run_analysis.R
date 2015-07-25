## set the working directory appropriately
setwd("c:/R working/UCI HAR Dataset")


## Read all the neceessary files from the course project folder
## Name the files appropriately

test_set<-read.table("c:/R working/UCI HAR Dataset/test/X_test.txt")
test_set_y<-read.table("c:/R working/UCI HAR Dataset/test/Y_test.txt")
test_set_subject<-read.table("c:/R working/UCI HAR Dataset/test/subject_test.txt")

train_set_subject<-read.table("c:/R working/UCI HAR Dataset/train/subject_train.txt")
train_set_y<-read.table("c:/R working/UCI HAR Dataset/train/Y_train.txt")
train_set<-read.table("c:/R working/UCI HAR Dataset/train/X_train.txt")

features<-read.table("c:/R working/UCI HAR Dataset/features.txt")

## Get the names of all the 563 fields from the features file into a new dataframe
features_2<-data.frame(features[,2])

## In the previous data frame the names of the required fields are in rows.
## Transpose the above data frame to get the names of the field into columns
features_3<-data.frame(t(features_2))
names(features_3)<-features[,2]

## Set the names of test and train project datasets correctly from the above dataframe.
names(test_set)<-names(features_3)
names(train_set)<-names(features_3)

## Name the test and train "Y" datasets' column to be "activity" as it represents activity
names(test_set_y)<-"activity"
names(train_set_y)<-"activity"

## Name the test and train "subject" datasets' column to be "subject" as it represents subject
names(test_set_subject)<-"subject"
names(train_set_subject)<-"subject"

## Change the numeric values of the activity field to what they represent in the test dataset
test_set_y$activity[test_set_y$activity == "1"] <- "WALKING"
test_set_y$activity[test_set_y$activity == "2"] <- "WALKING_UPSTAIRS"
test_set_y$activity[test_set_y$activity == "3"] <- "WALKING_DOWNSTAIRS"
test_set_y$activity[test_set_y$activity == "4"] <- "SITTING"
test_set_y$activity[test_set_y$activity == "5"] <- "STANDING"
test_set_y$activity[test_set_y$activity == "6"] <- "LAYING"

## Change the numeric values of the activity field to what they represent in the train dataset
train_set_y$activity[train_set_y$activity == "1"] <- "WALKING"
train_set_y$activity[train_set_y$activity == "2"] <- "WALKING_UPSTAIRS"
train_set_y$activity[train_set_y$activity == "3"] <- "WALKING_DOWNSTAIRS"
train_set_y$activity[train_set_y$activity == "4"] <- "SITTING"
train_set_y$activity[train_set_y$activity == "5"] <- "STANDING"
train_set_y$activity[train_set_y$activity == "6"] <- "LAYING"


## Combine test data sets "X", "Y" and "subject"
## The following operation will complete test data set
test_set_2<-cbind(test_set,test_set_y,test_set_subject)

## Combine train data sets "X", "Y" and "subject"
## The following operation will complete train data set
train_set_2<-cbind(train_set,train_set_y,train_set_subject)

## Merge the test and train datasets to create one dataset
test_and_train<-rbind(test_set_2,train_set_2)

## Make the column names of the merged data set to be unique
unique_names<-make.names(names(test_and_train),unique = TRUE)
names(test_and_train)<-unique_names

## Extract only the columns which are mean and std for all the subjects and activities
test_and_train_2<-select(test_and_train,subject,activity,contains("mean"),contains("std"))

## Melt and dcast the above data frame to create tidy data set
## This following exercise helps in getting mean values for each subject each activity combination
melted<-melt(data=test_and_train_2,id=c("subject","activity"),measure.vars=colnames(test_and_train_2[,3:88]))
Tidy_data<-dcast(melted,subject+activity~variable,mean)

## Write the tidy data into a text file as per the project instructions
write.table(Tidy_data,file="Tidy_data.txt",row.names = FALSE)