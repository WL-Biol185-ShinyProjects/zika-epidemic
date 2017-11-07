library(shiny)
library(tidyverse)
library(ggplot2)
Zika_Country_Data <- read_csv("~/zika-epidemic/Zika - Country Data.csv")
Zika_State_Data<- read.csv("~/zika-epidemic/Zika - US State Data (2).csv")
Zika_Country_Data$Date <- as.Date(Zika_Country_Data$Date, format = "%m/%d/%Y")
geoJSON_map <- readRDS(file = "geoJSON_map.rds")
geoJSON_map@data <- Zika_Country_Data
pal  <- colorBin("YlOrRd", geoJSON_map@data)


function(input, output, session) {

  
  output$Outbreak_Over_Time <- renderPlot({
    
    Zika_Country_Data %>%
      filter(Country_Territory == input$Country) %>%
      ggplot(aes(Date, Confirmed, color=Confirmed_congenital_syndrome)) +
      geom_point() +
      theme(axis.text.x = element_text(angle = 60, hjust = 1))
  })
  
  
  output$Map_Outbreak_Over_Time <- renderLeaflet({
    
  
    leaflet(data = geoJSON_map) %>%
      addTiles(options = tileOptions(noWrap = TRUE)) %>%
      addPolygons(fillColor = ~pal(Confirmed)) %>%
      
      addLegend(pal = pal, Confirmed = ~density, opacity = 0.7, title = input$Confirmed,
                position = "bottomright")
    
    
  })
  
  
  output$Outbreak_By_State <- renderPlot({
    
    Zika_State_Data %>%
      filter(Region == input$Region) %>%
      ggplot(aes (States, Number_of_Cases)) +
      geom_point() +
      theme(axis.text.x = element_text(angle = 60, hjust = 1))
    
  })
   

  
}
