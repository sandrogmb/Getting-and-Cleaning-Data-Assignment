#QUESTA VERSIONE NON DA' ESITO HA UN FILE CORRETTO
#PROBABILMENTE PERCHE' FONDE PRIMA TEST E TRAIN DATA E DOPO SOGGETTI E LABELS (?)
#The data were downloaded and a new session of RStudio was opened; 
#the working directory in RStudio was changed to the folder where the data files exist

# 1. Merging the training and the test sets to create one data set.

#Reading all the data files we need:

#Training files
train_data_x <- read.table("./train/X_train.txt") 
train_data_y <- read.table("./train/y_train.txt") 
train_data_subject <- read.table("./train/subject_train.txt") 

# test data files 
test_data_x <- read.table("./test/X_test.txt") 
test_data_y <- read.table("./test/y_test.txt") 
test_data_subject <- read.table("./test/subject_test.txt") 

# features file 
features <- read.table("./features.txt") 

# activity names 
activity_labels <- read.table("./activity_labels.txt") 


# merge test and train datasets   
joined_data <- rbind(train_data_x,test_data_x) 
joined_labels <- rbind(train_data_y,test_data_y) 
joined_subjects <- rbind(train_data_subject,test_data_subject) 


# Set the appropiate column names  
names(joined_data) = features[[2]] 
#oppure names(joined_data)<-features$V2
names(joined_labels) = c("Activityid") 
names(joined_subjects) = c("Subjects") 



# 2. Extracting only the measurements on the mean and standard deviation for each measurement 

#Extract the data for mean and std columns as a vector, and then merge the two vectors to get a single vector.  

#primo errore: non riesco a trovare le colonne che iniziano con M e S
#means_indices <- grep("mean",features[[2]]) 
#std_indices <- grep("std",features[[2]]) 

#la versione corretta è la seguente
means_indices <- grep("[Mm]ean",features[[2]]) 
std_indices <- grep("[Ss]td",features[[2]]) 


merged_indices <- c(means_indices,std_indices)  

# Extract relevant joined data through the indices 
#così il seguente file è corretto
indiced_joined_data <- joined_data[merged_indices] 



# 3. Using descriptive activity names to name the activities in the data set

# first step: substitute the column names of the file activity_labels
names(activity_labels) = c("Activityid","Activityname") 

# second step: merge the two files activity_labels and joined_labels 
activities <- merge(activity_labels,joined_labels,"Activityid") 

# la seguente operazione dimostra che usando così merge ottengo la seguente divisione del file
#> tally(group_by(activities, Activityid, Activityname))
#Source: local data frame [6 x 3]
#Groups: Activityid [?]

#  Activityid       Activityname     n
#       <int>             <fctr> <int>
#1          1            WALKING  1722
#2          2   WALKING_UPSTAIRS  1544
#3          3 WALKING_DOWNSTAIRS  1406
#4          4            SITTING  1777
#5          5           STANDING  1906
#6          6             LAYING  1944

# la precedente è la stessa divisione del file joined_labels che si ottiene con il seguente comando
#> tally(group_by(joined_labels, Activityid))
#quindi il file activities è corretto (corrisponde alla stessa suddivisione per attività ottenuta da file ottenuti con +
#script che danno risultati corretti


# third step: join the column of activities and subjects to the dataset

#indiced_joined_data$activities <- activities[[2]] 
#indiced_joined_data$subjects <- joined_subjects[[1]] 

#dopo i due precedenti passaggi c'è l'errore perché non ottengo più 
#le 180 righe (30 soggetti per 6 classi di attività) con tally 
indiced_joined_data1 <- cbind.data.frame(indiced_joined_data, joined_subjects) 
indiced_joined_data1 <- cbind.data.frame(indiced_joined_data1, activities) 
indiced_joined_data <- indiced_joined_data1[,!names(indiced_joined_data1) %in% c("Activityid")]

#tally(group_by(indiced_joined_data, Subjects, Activityname))


# 4. Appropriately labels the data set with descriptive variable names

#Clean up the column names 
names(indiced_joined_data) <- gsub("\\(\\)","",names(indiced_joined_data)) 
names(indiced_joined_data) <- gsub("-","",names(indiced_joined_data)) 



# 5. Creates a second tidy data set with the average of each variable for each activity and each subject

# Aggregate the dataset 
#nella seguente operazione c'è l'errore principale
#second_set<-aggregate(indiced_joined_data[,1:79],list(activities = indiced_joined_data$activities, subjects=indiced_joined_data$subjects),mean, na.rm=TRUE)


molten <- melt(indiced_joined_data,id.vars = c("Subjects","Activityname"))
out_df <- dcast(molten,subjects + activities ~ ...,mean)


 # write to file 
 write.table(out_df,"second_set.txt",row.name=FALSE) 
