library(shiny)

fluidPage(
  
  titlePanel("Zika Cases in Pan-America"),
  
  sidebarLayout(
    #panel with widgets
    sidebarPanel(
      selectInput( inputId = 'Country',
                   label   = 'Select a Country',
                   choices = unique(Zika_Country_Data$Country_Territory)
                     )
    ),
    
    # Panel plot
    mainPanel(plotOutput("Outbreak_Over_Time"))
  )
  
)