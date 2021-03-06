library(shiny)
library(leaflet)
library(maps)
library(ggplot2)
library(dplyr)
library(htmltools)
library(markdown)
library(shinythemes)
library(tidyverse)

Zika_Country_Data <- read_csv("Zika - Country Data.csv")
Zika_State_Data<- read.csv("Zika - US State Data (2).csv")
Zika_Country_Data$Date <- as.Date(Zika_Country_Data$Date, format = "%m/%d/%y")
Zika_Country_Data$logcountry <- log(Zika_Country_Data$Confirmed) 
Zika_Country_Data$logcountry [Zika_Country_Data$logcountry==-Inf] <- 0




function(input, output, session) {

# ############################################################################
# #Country Table 
   output$Outbreak_Over_Time <- renderPlot({

    Zika_Country_Data %>%
      filter(Country_Territory == input$Country) %>%
      ggplot(aes(Date, Confirmed, color=Confirmed_congenital_syndrome)) +
      geom_point() +
      theme(axis.text.x = element_text(angle = 60, hjust = 1))

  })

  output$info <- renderTable({
    xy_str <- function(e) {
      if(is.null(e)) return ("NULL\n")
      paste0("x=" , round(e$x, 1), " y=", round(e$y, 1), "\n")
    }
    xy_range.str <- function(e) {
      if(is.null(e)) return("NULL\n")
      paste0("xmin=", round(e$xmin, 1), "xmax=", round(e$xmax, 1),
             "ymin=", round(e$ymin, 1), "ymax=", round(e$ymax, 1))
    }
    nearPoints(Zika_Country_Data, input$plot_click) %>%
      select(Country_Territory, Confirmed, Confirmed_congenital_syndrome, Imported_Cases, Incidence_Rate)
  })

 ###########################################################################
##Country Map###
  
  country <- rgdal::readOGR("countries.geo.json", "OGRGeoJSON")

   output$Map_Outbreak_Over_Time <- renderLeaflet({

    Zika_Country_Data <- Zika_Country_Data[ Zika_Country_Data$Date == input$Date , ]
    
    country_data <- Zika_Country_Data
    joinedDataCountry<-left_join(country@data, country_data, by= c("name"="Country_Territory"))
    country@data <- joinedDataCountry
    
    
    pal2 <- colorNumeric(
      palette = c("#E3FF33", "#FF3342"),
      domain = country@data$logcountry
                      )
    labels2 <- sprintf(
      "<strong>%s</strong><br/>%g cases",
      country@data$name,
      country@data$Confirmed
                      ) %>% 
      lapply(htmltools::HTML)

    leaflet(data = country ) %>%
    addTiles(options = tileOptions(noWrap = TRUE)) %>%
    addPolygons(fillColor = ~pal2(logcountry),
                weight = 2,
                opacity = 1,
                color = "white",
                # popup = country_popup,
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
      addLegend(pal = pal2,
                values = ~logcountry,
                opacity = 0.7,
                title = input$Date,
                position = "bottomright") %>%
      setView(map, lat = 8.819458, lng = -79.154637, zoom = 1.5)
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
  state_data <- Zika_State_Data
  joinedData<-left_join(states@data, state_data, by= c("NAME"="States"))
  states@data <- joinedData

  pal1 <- colorNumeric(
    palette = c("#FFF68F", "#FF3342"),
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

