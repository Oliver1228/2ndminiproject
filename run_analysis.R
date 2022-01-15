# Merges the training and the test sets to create one data set.
if (!file.exists("specdata")){
  dir.create ("specdata")
}

features <- read.table('specdata/features.txt',
                       col.names = c('Index_Feature','Feature'))
activity_labels <- read.table('specdata/activity_labels.txt',
                              col.names = c('Index_Activity','Activity'))

X_train <- read.table('specdata/train/X_train.txt',
                      col.names = features$Feature,check.names = FALSE)
y_train <- read.table('specdata/train/y_train.txt')
subject_train <- read.table('specdata/train/subject_train.txt')

X_test <- read.table('specdata/test/X_test.txt',
                     col.names = features$Feature,check.names = FALSE)
y_test <- read.table('specdata/test/y_test.txt')
subject_test <- read.table('specdata/test/subject_test.txt')

X_train_p = cbind(y_train, subject_train,X_train)
X_test_p = cbind(y_test, subject_test,X_test)

names(X_train_p)[c(1,2)] <- c('Activity','Subject')
names(X_test_p)[c(1,2)] <- c('Activity','Subject')

#write.csv(x=X_train_p,file = 'X_train.csv',sep = ',',row.names = F)
#write.csv(x=X_test_p,file = 'X_test.csv',sep = ',',row.names = F)

X_data <- rbind(X_train,X_test)
y_data <- rbind(y_train,y_test)
subject_data <- rbind(subject_train,subject_test)


# Extracts only the measurements on the mean and standard deviation for each measurement
col_names <- colnames(X_data)
col_mean  <- grep('mean\\(\\)',col_names)
col_std   <- grep('std\\(\\)',col_names)

X_mean_std <- X_data[,c(col_mean,col_std)]


# Uses descriptive activity names to name the activities in the dataset
X_clean <- cbind(y_data,X_mean_std)
colnames(X_clean)[1] <- 'Index_Activity'
X_clean <- cbind(subject_data,X_clean)
colnames(X_clean)[1] <- 'Subject'

X_clean <- merge(activity_labels,X_clean)
X_clean$Index_Activity <- NULL


# Appropriately labels the data set with descriptive variable names
col_names <- colnames(X_clean)

col_names <- sub(x = col_names,pattern = '^t',replacement = 'Time ')
col_names <- sub(x = col_names,pattern = '^f',replacement = 'Frequency ')
col_names <- sub(x = col_names,pattern = '-',replacement = ', ')
col_names <- sub(x = col_names,pattern = 'mean\\(\\)',replacement = ' Mean ')
col_names <- sub(x = col_names,pattern = 'std\\(\\)',replacement = ' Standard Deviation ')
col_names <- sub(x = col_names,pattern = '-X',replacement = 'XAxis')
col_names <- sub(x = col_names,pattern = '-Y',replacement = 'YAxis')
col_names <- sub(x = col_names,pattern = '-Z',replacement = 'ZAxis')
col_names <- sub(x = col_names,pattern = 'Acc',replacement = ' Accelerometer')
col_names <- sub(x = col_names,pattern = 'Gyro',replacement = ' Gyroscope')
col_names <- sub(x = col_names,pattern = 'Mag',replacement = ' Magnitude')

colnames(X_clean) <- col_names


# From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
X_tidy <- aggregate(X_clean[,3:68],by=list(X_clean$Activity,X_clean$Subject),FUN=mean)
colnames(X_tidy)[1] <- 'Activity'
colnames(X_tidy)[2] <- 'Subject'

write.table(X_tidy,file = 'tidy_dataset.txt',row.names = F)
