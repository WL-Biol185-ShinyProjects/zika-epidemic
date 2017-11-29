library(shiny)
library(leaflet)
library(maps)
library(ggplot2)
library(dplyr)
library(htmltools)
library(markdown)
library(shinythemes)
library(tidyverse)

Zika_Country_Data <- read_csv("~/zika-epidemic/Zika - Country Data.csv")
Zika_State_Data<- read.csv("~/zika-epidemic/Zika - US State Data (2).csv")
Zika_Country_Data$Date <- as.Date(Zika_Country_Data$Date, format = "%m/%d/%y")

function(input, output, session) {

  output$Outbreak_Over_Time <- renderPlot({
    
    Zika_Country_Data %>%
      filter(Country_Territory == input$Country) %>%
      ggplot(aes(Date, Confirmed, color=Confirmed_congenital_syndrome)) +
      geom_point() +
      theme(axis.text.x = element_text(angle = 60, hjust = 1))
    
  })
  
 ###########################################################################
  country <- rgdal::readOGR("countries.geo.json", "OGRGeoJSON")
   
  output$Map_Outbreak_Over_Time <- renderLeaflet({
    
    Zika_Country_Data <- Zika_Country_Data %>%
      filter_("Date" == input$Date)
    country@data <- 
      country@data %>%
      left_join(Zika_Country_Data, by= c("name"="Country_Territory")) %>%
      na.omit(country@data)
    
    pal1 <- colorNumeric(
      palette = "YlOrRd",
      domain = country@data$Confirmed
                        )

    labels2 <- sprintf(
      "<strong>%s</strong><br/>%g cases",
      country@data$name, 
      country@data$Confirmed
                      ) %>% 
      lapply(htmltools::HTML)
    
    leaflet(data = country ) %>%
      addTiles(options = tileOptions(noWrap = TRUE)) %>%
      addPolygons(fillColor = ~pal(Confirmed),
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
  
  ############################################################################
  
  output$Outbreak_By_State <- renderPlot({
    
    Zika_State_Data %>%
      filter(Region %in% input$Region) %>%
      ggplot(aes (States, Number_of_Cases)) +
      geom_point() +
      theme(axis.text.x = element_text(angle = 60, hjust = 1))
    
  })

  ############################################################################
  ##States Map##
  
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

}
