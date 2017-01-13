# Codebook.md

## Purpose of this file

It describes the variables, the data and any transformations or work that is performed to clean up the data.

## 0. STARTING DATASET
## Location of Source Data

A full description of the data used in this project can be found at this link:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The source data for this project can be found here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Feature Selection

The complete list of variables of each feature is available in 'features.txt' and the file 'features.info.txt' provides information about most of these variables.

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ.

These signals were elaborated and used to estimate variables of the feature vector for each pattern of the dataset:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

A set of variables, including mean() - Mean value -  and std() - Standard deviation -, were estimated from these signals.

## 1. Merging the data files into one dataset.

The following files have been read firstly into separate files each:

x_train.txt

y_train.txt

subject_train.txt

x_test.txt

y_test.txt

subject_test.txt

features.txt

activity_labels.txt

Then the test and train datasets were merged into a single table with rbind function.

## 2. Filtering the mean and the standard deviation measurements from the table.

The 'grep' function was used to extract all mean and std data from the merged dataset.

## 3. Setting activity names in the data subset.

The data subset was joined with the activityType table to include the descriptive activity names.

## 4. Setting labels on the data subset with descriptive variable names.

The gsub function was used to clean up the variable names having special characters in between.

## 5. Creating a second tidy data set having the average of each variable for each activity and each subject.

Using the aggregate function for the variables a single table containing the averages and means was created (second_set.txt).
