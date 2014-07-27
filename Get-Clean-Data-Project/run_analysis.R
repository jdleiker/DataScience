## Getting and Cleaning Data Course project

setwd("~/Workspace/Data Science/getting-and-cleaning-data")

## Part 1 - Merging ... 

testData <- read.table('X_test.txt', sep="", head=F)
testSubjects <- read.table('subject_test.txt', head=F)
testActivities <- read.table('y_test.txt', head=F)

testData <- cbind(testData, testSubjects, testActivities)


trainingData <- read.table('X_train.txt', sep="", head=F)
trainingSubjects <- read.table('subject_train.txt', head=F)
trainingActivities <- read.table('y_train.txt', head=F)

trainingData <- cbind(trainingData, trainingSubjects, trainingActivities)

## Merging both datasets

data <- rbind(testData, trainingData)

## Label columns

columnLabels <- read.table('features.txt', head=F)$V2
colnames(data) <- columnLabels

names(data)[562] <- 'activity'
names(data)[563] <- 'subject'

## Part 2 - Extracting ...  

dataMeansAndDevations <- data[, grepl('mean\\(\\)|std\\(\\)', names(data))]

## Part 3 & 4 - Descriptive names and activities ... 

dataLabelled <- data
activityLabels <- read.table('activity_labels.txt', head=F)$V2

for(i in 1:6){dataLabelled$activity <- gsub(i, activityLabels[i], dataLabelled$activity)}

## Part 5 - Creating "tidy data" ... 


dataSplitted <- split(data, list(data$activity, data$subject))
newDataTable = NULL

## Calculating means ... 

for(i in 1:length(dataSplitted)){
  newDataTable <- rbind(newDataTable, sapply(data.frame(dataSplitted[i]), mean))
}
newDataTable <- data.frame(newDataTable)

## Assigning column names  

colnames(newDataTable) <- columnLabels
names(newDataTable)[562] <- 'subject'
names(newDataTable)[563] <- 'activity'

## Replacing activity codes 

for(i in 1:6){newDataTable$activity <- gsub(i, activityLabels[i], newDataTable$activity)}

newDataTable <- transform(newDataTable, activity=factor(activity))
newDataTable <- transform(newDataTable, subject=factor(subject))

write.csv(newDataTable, file='tidyData.csv')