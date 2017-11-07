library(shiny)
library(leaflet)
library(markdown)
geoJSON_map <- readRDS(file = "geoJSON_map.rds")


navbarPage("Zika",

navbarPage("Zika Epidemic",

  
  tabPanel("Home",
           includeMarkdown("Zika_Home.rmd")),
           
           
  tabPanel("Overview",
           includeMarkdown("Zika_Overview.rmd")),
          
  navbarMenu("Zika Cases in Pan-America",
              
      tabPanel("Graph Over Time"),
              sidebarLayout(
                sidebarPanel(
                selectInput( inputId = 'Country',
                   label   = 'Select a Country',
                   choices = unique(Zika_Country_Data$Country_Territory)
                     )),
              mainPanel(plotOutput("Outbreak_Over_Time"))
              ),
              
      tabPanel("Heatmap Over Time",
              sliderInput(inputId = "Date", 
                          label= "Select a Date", 
                          11/17/16, 
                          10/05/17, 
                          11/17/16, 
                          step = NULL, 
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
                          dragRange = TRUE,
      
              leafletOutput("Map_Outbreak_Over_Time")
                          )
    
              ),
  
  
  
  tabPanel("Zika Cases in United States",
           selectInput(inputId = 'Region',
                       label= 'Select a Region',
                       multiple= TRUE,
                       choices = unique(Zika_US_State_Data_2_$Region)
                       ),
 
             mainPanel(plotOutput("Outbreak_By_State"))

   )

)

  ),
  
  tabPanel("United States Map of Zika",
           leafletOutput("Outbreak_Heatmap")
  )
) 
  
