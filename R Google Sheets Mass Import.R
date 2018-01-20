# Install googlesheets package if it's not already, and library it.
if(!require(googlesheets)){install.packages("googlesheets")} 
library(googlesheets)

# I'll use examples of cities to prove the point of creating multiple workbooks 
# online through R, without ever opening the brower (although, if it's your 
# first time authenicating you will technically be brought to the browser to 
# sign in and verify your google account to add the R package app)
list<- c("San Francisco Bay Area", "Los Angeles", "San Diego", "Monterrey", 
        "Santa Cruz", "Lake Tahoe", "Sacramento", "Davis", "Santa Barbara", 
        "Pasadena", "San Jose")
# Authorize the package to a Google account
gs_auth()

# Use the list to mass produce a title for each workbook. Assume you have some 
# associations with these cities and want to organize some workbooks for them.
cities<- list()
for (city in list) {
    print(city) # To show that I'm iterating
    city= paste(city, "Regional Affiliate", sep = " ")
    cities[city]<- city # Check our list of cities
    rm(city) # To show that I'm removing the iteration before starting the next
}

# Create the workbooks
for(city in cities){
    gs_new(city)
}

# Now if we have data to add to any of these sheets let's import that first, 
# and then by splitting the data by factor or some category of your own choosing
# we can send the data to it's respectful google sheet. This process simplifies 
# that data sharing that typically happens when collaborating with far and 
# widespread locations over business matters.
data<- data.frame()
for (city in cities) {
    data<- rbind(data, data.frame("city" = city, `dist 1`= rnorm(200), 
                            `dist 2` = rnorm(50), `dist 3` = rnorm(100)))
}

# Now we can finally get to importing the data to our workbooks. Importing the 
# data will look different and may require some tricks of its own. But this is 
# sinmply for exampling the google sheets functions :)

import_data<- split(data, data$city)
# Register each workbook in the R environment to obtain the key, and import
day<- Sys.Date()
i= 1
key= 1
while(i <= length(import_data)){
    region<- import_data[i]
    regionName<- names(region)
    while(key <= length(cities)){
        keyName<- names(cities[key])
        if(starts_with(regionName, vars = keyName) == TRUE){
            gs<- gs_title(keyName)
            newSheet<- gs_ws_new(gs, ws_title = as.character(day))
            gs_edit_cells(newSheet, ws = as.character(day), input = region[[1]],
                          col_names = TRUE)
            key= key+1
            i= i+1
            break
        }
    }
}

# You see, we're only allowed to register one workbook at a time, so while we 
# have our list of titles we can go through our data and register our titles, 
# edit them, and move through our entire list all in one go! 
# If you split a data frame by its factor or category label, the object will 
# be a list of data frames and each named by the category label. If were weren't
# working with sorted data, or data that contain irrelevant information to 
# other cities outside of the cities we're specifically pushing data into, then
# we can make that condition within our looping system.
# Your console will be going to work! 
# Go check your Google Sheets just for the satifaction.
# Now our open source Chromium just got easier with R

