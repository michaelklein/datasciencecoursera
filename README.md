Getting and Cleaning Data Project
=================================

## Steps to produce the tidy data set
* Make sure the required packages are installed.
* Read in all the data.
* Set the names of the columns, using the names that come from features.txt.
* Create a new data set by appending the training data to the test data.  Add a new column, 'test', to indicate for each row where the data came from.
* Add a new column, 'activity', to the data set to indicate which activity the row data corresponds to.  Name the activities based on the names in the activities.txt file.
* Add a new column, 'subject', to the data set to indicate which subject the row data corresponds to.
* Extract the variables that contain mean and standard deviation measurements.  This step looks for variables that contain "-mean()" for means and "-std()" for standard deviations in the variable name.
* Melt the data set by using 'test', 'activity' and 'subject' as the ids of the new data set, and the rest of the columns as measures.  The resulting data set will have five columns: test, activity, subject, variable and value.
* Now dcast() this data set so we have the mean for each measure for each subject/activity combination.
* Write the data set out.
