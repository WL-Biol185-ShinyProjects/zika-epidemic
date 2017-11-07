#Pan American Leaflet
library(shiny)
library(tidyverse)
library(ggplot2)


Zika_Country_Data <- read_csv("~/zika-epidemic/Zika - Country Data.csv")
Zika_Country_Data$Date <- as.Date(Zika_Country_Data$Date, format = "%m/%d/%Y")


function(input, output, session) {

geoJSON_map <- readRDS(file = "geoJSON_map.rds")
geoJSON_map@data <- Zika_Country_Data

output$Outbreak_Over_Time<- renderLeaflet({

pal  <- colorBin("YlOrRd", geoJSON_map@data)

leaflet(data = geoJSON_map) %>%
          addTiles(options = tileOptions(noWrap = TRUE)) %>%
          addPolygons(fillColor = ~pal(Confirmed)) %>%

addLegend(pal = pal, Confirmed = ~density, opacity = 0.7, title = input$Confirmed,
          position = "bottomright")


})

}
