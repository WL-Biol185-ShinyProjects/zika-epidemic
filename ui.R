library(shiny)
library(leaflet)
library(markdown)

navbarPage("Zika Epidemic",

           
  tabPanel("Home",
           includeHTML("Zika_Home_Final.html")
          ),
           
  tabPanel("Overview",
           includeMarkdown("Zika_Overview.rmd")
           ),

  
            
navbarMenu("Zika Cases in Pan-America",
              
    tabPanel("Graph Over Time",
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
             
              
      tabPanel("Heatmap Over Time",
              leafletOutput("Map_Outbreak_Over_Time")
              )
             ),
  
  navbarMenu("Zika Cases in United States",
             
  tabPanel("Graph of Cases in US",
           selectInput(inputId = 'Region',
                       label= 'Select a Region',
                       multiple= TRUE,
                       choices = unique(Zika_US_State_Data_2_$Region)
                       ),
 
             mainPanel(plotOutput("Outbreak_By_State"))

          ),
  
  tabPanel("United States Map of Zika",
           leafletOutput("Outbreak_Heatmap")
          )
           )
  
        )


  
