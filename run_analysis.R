packages <- c("reshape2")
toInstall <- setdiff(packages, rownames(installed.packages()))
if (length(toInstall > 0)) install.packages(toInstall)
library(reshape2)

features <- read.table("features.txt")
activities <- read.table("activity_labels.txt")

testX <- read.table("test/X_test.txt")
testY <- read.table("test/y_test.txt")
testSubject <- read.table("test/subject_test.txt")

trainX <- read.table("train/X_train.txt")
trainY <- read.table("train/y_train.txt")
trainSubject <- read.table("train/subject_train.txt")

names(testX) <- features$V2
names(trainX) <- features$V2
mergeDF <- rbind(cbind(testX, test = c(TRUE)), cbind(trainX, test = c(FALSE)))
mergeDF$action <- rbind(testY, trainY)$V1
mergeDF$subject <- rbind(testSubject, trainSubject)$V1

columnSet <- grepl("-std\\(", features$V2) | grepl("-mean\\(", features$V2)
columnSet <- append(columnSet, c(TRUE, TRUE, TRUE))
tidyDF <- mergeDF[, columnSet]
tidyDF$action <- factor(tidyDF$action, levels=activities$V1, labels=activities$V2)


measureVars <- names(tidyDF)[1:66]
meltDF <- melt(tidyDF, id=c("test", "action", "subject"), measure.vars=measureVars)
newTidyDF <- dcast(meltDF, action + subject ~ variable, mean)

#write.csv(newTidyDF, file="new_tidy.csv")
