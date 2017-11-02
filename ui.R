library(shiny)
library(leaflet)

navbarPage("Navbar!",
  
  tabPanel("Zika Cases in Pan-America",
      sidebarLayout(
      sidebarPanel(
      selectInput( inputId = 'Country',
                   label   = 'Select a Country',
                   choices = unique(Zika_Country_Data$Country_Territory)
                     )
    ),
    
    mainPanel(plotOutput("Outbreak_Over_Time"))
    )
  ),
  
  tabPanel("Zika Cases in United States",
           selectInput(inputId = 'Region',
                       label= 'Select a Region',
                       choices = unique(StataData)
                       ),
 
   mainPanel(plotOutput("Outbreak_By_State"))

  ),
  
  tabPanel("United States Map of Zika",
           leafletOutput("Outbreak_Heatmap")
  )
) 
  
