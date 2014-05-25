# Make sure the required packages are installed
packages <- c("reshape2")
toInstall <- setdiff(packages, rownames(installed.packages()))
if (length(toInstall > 0)) install.packages(toInstall)
library(reshape2)

# Read in all the data
features <- read.table("features.txt")
activities <- read.table("activity_labels.txt")
testX <- read.table("test/X_test.txt")
testY <- read.table("test/y_test.txt")
testSubject <- read.table("test/subject_test.txt")
trainX <- read.table("train/X_train.txt")
trainY <- read.table("train/y_train.txt")
trainSubject <- read.table("train/subject_train.txt")

# Set the names of the columns of the test and training data to match the features that were recorded
names(testX) <- features$V2
names(trainX) <- features$V2

# Append the training data to the test data, adding a column to indicate whether it came from test or training
mergeDF <- rbind(cbind(testX, test = c(TRUE)), cbind(trainX, test = c(FALSE)))

# Add a column to specify the activity the row corresponds to, and give them good labels
mergeDF$activity <- rbind(testY, trainY)$V1
mergeDF$activity <- factor(mergeDF$activity, levels=activities$V1, labels=activities$V2)

# Add a column to specify the subject the row corresponds to
mergeDF$subject <- rbind(testSubject, trainSubject)$V1

# Get the set of columns corresponding to mean and standard deviation
columnSet <- grepl("-std\\(", features$V2) | grepl("-mean\\(", features$V2)

# Extract the mean/standard deviation columns, plus test, activity and subject
columnSet <- append(columnSet, c(TRUE, TRUE, TRUE))
tidyDF <- mergeDF[, columnSet]

# Melt the tidy data frame by the measures -- measures are all the columns but the last three
measureVars <- names(tidyDF)[1:66]
meltDF <- melt(tidyDF, id=c("test", "activity", "subject"), measure.vars=measureVars)

# Create a new data frame with averages for each measure by activity and subject
newTidyDF <- dcast(meltDF, activity + subject ~ variable, mean)

write.csv(newTidyDF, file="new_tidy.csv")
