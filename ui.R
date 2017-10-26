library(shiny)

<<<<<<< HEAD
navbarPage("Navbar!",
  
  tabPanel("Zika Cases in Pan-America",
      sidebarLayout(
      sidebarPanel(
=======
fluidPage(
  
  titlePanel("Zika Cases in Pan-America"),
  
  sidebarLayout(
    #panel with widgets
    sidebarPanel(
>>>>>>> 09b6fd67b555a1fb6015b58f91140599ff37e030
      selectInput( inputId = 'Country',
                   label   = 'Select a Country',
                   choices = unique(Zika_Country_Data$Country_Territory)
                     )
    ),
    
    # Panel plot
    mainPanel(plotOutput("Outbreak_Over_Time"))
<<<<<<< HEAD
    )
  ),
  
  tabPanel("Zika Cases in United States",
 
   mainPanel(plotOutput("Outbreak_By_State"))
   )

)
  
=======
  )
  
)
>>>>>>> 09b6fd67b555a1fb6015b58f91140599ff37e030
