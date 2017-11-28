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


filteredcountry@data <- Zika_Country_Data %>%
  filter_("Date" == input$Date)



sliderInput(inputId = 'Date', 
            label= "Select a Date",
            min(Zika_Country_Data$Date),
            max(Zika_Country_Data$Date),
            min(Zika_Country_Data$Date),
            step = 14, 
            round = FALSE,
            format = NULL,
            locale = NULL, 
            ticks = TRUE, 
            animate = TRUE,
            width = NULL, 
            sep = ",",
            pre = NULL, 
            post = NULL, 
            timeFormat = NULL,
            timezone = NULL, 
            dragRange = TRUE
)




######################################################################

states <- rgdal::readOGR("States.JSON", "OGRGeoJSON")
state_data <- Zika_US_State_Data_2_
joinedData<-left_join(states@data, state_data, by= c("NAME"="States"))
states@data <- joinedData

pal1 <- colorNumeric(
  palette = "YlOrRd",
  domain = states@data$Number_of_Cases)
labels1 <- sprintf(
  "<strong>%s</strong><br/>%g cases",
  states@data$NAME, 
  states@data$Number_of_Cases
) %>% 
  lapply(htmltools::HTML)

output$Outbreak_Heatmap <-renderLeaflet({    
  leaflet(data = states) %>%
    addProviderTiles("OpenStreetMap.BlackAndWhite") %>%
    addPolygons(fillColor = ~pal1(Number_of_Cases), 
                fillOpacity = 0.8, 
                color = "#BDBDC3", 
                weight = 1,
                highlight = highlightOptions(
                  weight = 5,
                  color = "#666",
                  dashArray = "",
                  fillOpacity = 0.7,
                  bringToFront = TRUE),
                label = labels1,
                labelOptions = labelOptions(
                  style = list("font-weight" = "normal", 
                               padding = "3px 8px"),
                  textsize = "15px",
                  direction = "auto")) %>%
    addLegend(pal = pal1, 
              values = ~Number_of_Cases, 
              opacity = 0.7, 
              title = NULL,
              position = "bottomright") %>%
    setView(lat = 38.0110306, lng = -110.4080342, zoom = 3)
  
})

#############################################################

country <- rgdal::readOGR("countries.geo.json", "OGRGeoJSON")
country_data <- read_csv("Zika - Country Data.csv")

output$Map_Outbreak_Over_Time <- renderLeaflet({
  
  
  country_data_filter <- country_data %>%
    filter_("Date" == input$Date)
  country@data <- 
    country@data %>%
    left_join(country_data, by= c("name"="Country_Territory")) %>%
    na.omit(country@data)
  
  
  pal1 <-  colorBin("YlOrRd", country@data)
  
  labels2 <- sprintf(
    "<strong>%s</strong><br/>%g cases",
    country@data$name, 
    country@data$Confirmed
  ) %>% 
    lapply(htmltools::HTML)
  
  leaflet(data = country ) %>%
    addTiles(options = tileOptions(noWrap = TRUE)) %>%
    addPolygons(fillColor = ~pal(Confirmed.x),
                weight = 2,
                opacity = 1,
                color = "white",
                popup = country_popup,
                dashArray = "3",
                fillOpacity = 0.7,
                highlight = highlightOptions(
                  weight = 5,
                  color = "#666",
                  dashArray = "",
                  fillOpacity = 0.7,
                  bringToFront = TRUE),
                label = labels2,
                labelOptions = labelOptions(
                  style = list("font-weight" = "normal", padding = "3px 8px"),
                  textsize = "10px",
                  direction = "auto")) %>%
    addLegend(pal = pal, Date = ~density, opacity = 0.7, title = input$Date,
              position = "bottomright") %>%
    setView(map, lat = 38.0110306, lng = -110.4080342, zoom = 3)
  
})
