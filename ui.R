library(shiny)

navbarPage("Navbar!",
  
  tabPanel("Zika Cases in Pan-America",
      sidebarLayout(
      sidebarPanel(
      selectInput( inputId = 'Country',
                   label   = 'Select a Country',
                   choices = unique(Zika_Country_Data$Country_Territory)
                     )
    ),
    
    # Panel plot
    mainPanel(plotOutput("Outbreak_Over_Time"))
    )
  ),
  
  tabPanel("Zika Cases in United States",
 
   mainPanel(plotOutput("Outbreak_By_State"))
   )

)
  
