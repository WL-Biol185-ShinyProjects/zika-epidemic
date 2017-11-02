library(shiny)
library(tidyverse)
library(ggplot2)

Zika_Country_Data <- read_csv("~/zika-epidemic/Zika - Country Data.csv")
Zika_State_Data <- read.csv("StataData.csv")
Zika_Country_Data$Date <- as.Date(Zika_Country_Data$Date, format = "%m/%d/%Y")


function(input, output, session) {

  
  output$Outbreak_Over_Time <- renderPlot({
    
    Zika_Country_Data %>%
      filter(Country_Territory == input$Country) %>%
      ggplot(aes(Date, Confirmed, color=Confirmed_congenital_syndrome)) +
      geom_point() +
      theme(axis.text.x = element_text(angle = 60, hjust = 1))
  })


  output$Outbreak_By_State <- renderPlot({
    
    StataData %>%
      filter(States == input$State) %>%
      ggplot(aes (States, Number_of_Cases)) +
      geom_histogram() +
      theme(axis.text.x = element_text(angle = 60, hjust = 1))
    
  })
  
  output$Outbreak_Heatmap <-renderLeaflet({
    
    states <- rgdal::readOGR("States.JSON", "OGRGeoJSON")
    state_data <- Zika_US_State_Data_2_
    states@data <- state_data
    pal1 <- colorNumeric(
      palette = "YlOrRd",
      domain = states@data$Number_of_Cases)
    
    
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
                  label = "labels",
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
}
