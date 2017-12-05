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


