# Creates submetered plots of the loaded data.
makePlot <- function(dataTable) {
  par(mfrow = c(1, 1))
  with(dataTable, {
    plot(new_time, sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
    lines(new_time, sub_metering_2, col = "red")
    lines(new_time, sub_metering_3, col = "blue")
    legend("topright", col = c("black", "red", "blue"), cex = 0.8, lty = 1,
           legend = c("Sub_metering_1", 
                      "Sub_metering_2",
                      "Sub_metering_3"))
  })
  
  dev.copy(png, file = "plot3.png")
  
  dev.off()
}

# Loads the dataset into a table and returns the table.
loadDataset <- function(csvDataFile) {
  dataTable <- read.table(text = grep("^[1,2]/2/2007", readLines(csvDataFile), value = TRUE), 
                          sep = ";", skip = 0, na.strings = "?", stringsAsFactors = FALSE)
  
  names(dataTable) <- c("date", "time", "active_power", "reactive_power", "voltage",
                        "intensity", "sub_metering_1", "sub_metering_2", 
                        "sub_metering_3")
  
  dataTable$new_time <- as.POSIXct(paste(dataTable$date, dataTable$time), format = "%d/%m/%Y %T")
  dataTable
}

# Opens dataset file named household_power_consumption.txt from archived file and returns
# the opened connection to the fie.
openDataFile <- function() {
  unzip("exdata_data_household_power_consumption.zip")
  
  csvDataFile <- file("household_power_consumption.txt", "r")
  csvDataFile
}

# Downloads dataset from cloudfront.
downloadDataset <- function() {
  datasetUrl <- "http://d396qusza40orc.cloudfront.net/exdata/data/household_power_consumption.zip"
  destFile <- "./exdata_data_household_power_consumption.zip"
  download.file(datasetUrl, destFile)
}


downloadDataset()
csvDataFile <- openDataFile()
dataTable <- loadDataset(csvDataFile)
close(csvDataFile)
makePlot(dataTable)
