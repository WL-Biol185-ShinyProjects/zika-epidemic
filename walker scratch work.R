
library(shiny)
library(leaflet)
library(maps)
library(ggplot2)
library(dplyr)
library(htmltools)
library(markdown)
library(shinythemes)


Zika_Country_Data <- read_csv("~/zika-epidemic/Zika - Country Data.csv")
Zika_State_Data<- read.csv("~/zika-epidemic/Zika - US State Data (2).csv")
Zika_Country_Data$Date <- as.Date(Zika_Country_Data$Date, format = "%m/%d/%y")

country <- rgdal::readOGR("countries.geo.json", "OGRGeoJSON")
country_data <- Zika_Country_Data

country <- rgdal::readOGR("countries.geo.json", "OGRGeoJSON")

#output$Map_Outbreak_Over_Time <- renderLeaflet({

# Zika_Country_Data <- Zika_Country_Data %>%
#   filter_("Date" == input$Date)

Zika_Country_Data <- Zika_Country_Data[ Zika_Country_Data$Date == input$Date , ]

country@data <-
  country@data %>%
  left_join(Zika_Country_Data, by= c("name"="Country_Territory")) %>%
  na.omit(country@data)

pal2 <- colorNumeric(
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
  addProviderTiles("OpenStreetMap.BlackAndWhite") %>%
  addPolygons(fillColor = ~pal2(Confirmed), 
              fillOpacity = 0.8, 
              color = "#BDBDC3", 
              weight = 1,
              highlight = highlightOptions(
                weight = 5,
                color = "#666",
                dashArray = "",
                fillOpacity = 0.7,
                bringToFront = TRUE),
              label = labels2,
              labelOptions = labelOptions(
                style = list("font-weight" = "normal", 
                             padding = "3px 8px"),
                textsize = "15px",
                direction = "auto")) %>%
  addLegend(pal = pal2, 
            values = ~Confirmed, 
            opacity = 0.7, 
            title = input$Date,
            position = "bottomright") %>%
  setView(map, lat = 38.0110306, lng = -110.4080342, zoom = 3)


country_data_filter <- country_data %>%
  filter_("Date" == input$Date)
country@data <- 
  country@data %>%
  left_join(country_data_filter, by= c("name"="Country_Territory")) %>%
  na.omit(country@data)

pal2 <- colorNumeric(
  palette = "YlOrRd",
  domain = countries@data$Confirmed)
labels2 <- sprintf(
  "<strong>%s</strong><br/>%g cases",
  countries@data$NAME, 
  countries@data$Confirmed
) %>% 
  lapply(htmltools::HTML)


  leaflet(data = country) %>%
    addProviderTiles("OpenStreetMap.BlackAndWhite") %>%
    addPolygons(fillColor = ~pal1(Confirmed), 
                fillOpacity = 0.8, 
                color = "#BDBDC3", 
                weight = 1,
                highlight = highlightOptions(
                  weight = 5,
                  color = "#666",
                  dashArray = "",
                  fillOpacity = 0.7,
                  bringToFront = TRUE),
                label = labels2,
                labelOptions = labelOptions(
                  style = list("font-weight" = "normal", 
                               padding = "3px 8px"),
                  textsize = "15px",
                  direction = "auto")) %>%
    addLegend(pal = pal1, 
              values = ~Confirmed, 
              opacity = 0.7, 
              title = NULL,
              position = "bottomright") %>%
    setView(lat = 38.0110306, lng = -110.4080342, zoom = 3)




  
  #leaflet
  
  library(leaflet)
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
       states <- rgdal::readOGR("States.JSON", "OGRGeoJSON")
       state_data <- Zika_US_State_Data_2_
       states@data <- state_data

       
                 
 library(leaflet) 
     
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
         states@data$Number_of_Cases,
         states@data$Percentage_of_US_Cases
       ) %>% 
         lapply(htmltools::HTML)
        
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
                         fillOpacity = 0.5,
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
       

         
         ##Temporal Line Plots by Region
         colpal <- c("deepskyblue2", "forestgreen", "gold2", "darkorchid2", "firebrick2") 
         
         
         output$TemporalPlot <- renderPlot({
           ##Filter based on ui.R input
           
          Zika_Country_Data %>%
             filter(Confirmed %>% input$Country) %>%
             group_by(Date)%>%
             count(Date, Country_Territory)
              
             ggplot(aes(Date, n, color= Country_Territory)) +
             geom_line() + 
             scale_color_gradient(values= c("#E3FF33", "#FF3342")) +
            ggtitle("Temporal Zika Trends")+
            labs(x= "Date", y= "Number of Cases")+
            xlim (2016-11-17, 2017-10-05)
             
             
             
           
           rapidProg_disease %>%
             filter(DISEASE == input$select9) %>%
             group_by(XRAY_YEAR) %>%
             count(XRAY_YEAR, REGION) %>%
             
             ##Plot
             ggplot(aes(XRAY_YEAR, n, color = REGION)) +
             geom_line() +
             scale_colour_manual(values = c("Northern Appalachia" = "deepskyblue2"
                                            , "Central Appalachia" = "forestgreen"
                                            , "Southern Appalachia" = "gold2"
                                            , "Mid-West" = "darkorchid2"
                                            , "West" = "firebrick2")) +
             ggtitle("Temporal Disease Trends") +
             labs(x="Year", y="Number of Cases") +
             xlim(1969, 2002)
           
         })
         