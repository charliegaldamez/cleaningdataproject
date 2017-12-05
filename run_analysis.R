if (!require(dplyr)){
  install.packages("dplyr")
  library(dplyr)
} 

fileLocation <- "../UCI HAR Dataset/"
testLocation <- "../UCI HAR Dataset/test/"
trainingLocation <- "../UCI HAR Dataset/train/"

activityNames <- read.delim(file = paste0(fileLocation, "activity_labels.txt"), sep=" ", header = FALSE, col.names = c("ID", "Activity Name"))
featureNames <- read.delim(file = paste0(fileLocation, "features.txt"), sep=" ", header = FALSE, col.names = c("ID", "Name"))

testSubjects <- read.delim(file = paste0(testLocation, "subject_test.txt"), sep=" ", header = FALSE, col.names = c("Subject"))
testData <- read.delim(file = paste0(testLocation, "X_test.txt"), sep="", header = FALSE, col.names = gsub("\\.|-|[() ]|", "" , tolower(featureNames$Name)))
testLabelsTest <- read.delim(file = paste0(testLocation, "y_test.txt"), sep="", header = FALSE, col.names = c("Activity"))

trainSubjects <- read.delim(file = paste0(trainingLocation, "subject_train.txt"), sep="", header = FALSE, col.names = c("Subject"))
trainData <- read.delim(file = paste0(trainingLocation, "X_train.txt"), sep="", header = FALSE, col.names = gsub("\\.|-|[() ]|", "" , tolower(featureNames$Name)))
trainLabelsTest <-  read.delim(file = paste0(trainingLocation, "y_train.txt"), sep="", header = FALSE, col.names = c("Activity"))

#Point 1
wholeSubject <- rbind(testSubjects, trainSubjects)
wholeData <- rbind(testData, trainData)
wholeLabels <- rbind(testLabelsTest, trainLabelsTest)
wholeDataFrame <- cbind(wholeLabels, wholeSubject, wholeData)

#Point 2
meanFound <- grepl("*mean*", tolower(names(wholeDataFrame)))
stdFound <- grepl("*std*", tolower(names(wholeDataFrame)))

#Point 3 & 4
extractData <- cbind(wholeLabels, wholeSubject, wholeDataFrame[, (meanFound | stdFound)])
extractData <- merge(x = activityNames, y = extractData, by.x = "ID", by.y = "Activity")
extractData$ID <- NULL

#Point 5
averageData <- extractData %>% group_by(Subject, Activity.Name) %>% summarise_all(funs(mean))

write.table(averageData, "resultData.txt", sep="\t", row.names = F)
