library(shiny)
library(leaflet)
library(markdown)


navbarPage("Zika",
  
  tabPanel("Home",
           includeMarkdown("Zika_Home.rmd")),
           
           
  tabPanel("Overview",
           includeMarkdown("Zika_Overview.rmd")),
  
          
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
                       choices = unique(Zika_US_State_Data_2_$Region)
                       ),
 
   mainPanel(plotOutput("Outbreak_By_State"))

  ),
  
  tabPanel("United States Map of Zika",
           leafletOutput("Outbreak_Heatmap")
  )
) 
  
