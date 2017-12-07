library(shiny)
library(leaflet)
library(markdown)

Zika_Country_Data <- read_csv("Zika - Country Data.csv")
Zika_State_Data<- read.csv("Zika - US State Data (2).csv")
Zika_Country_Data$Date <- as.Date(Zika_Country_Data$Date, format = "%m/%d/%y")

navbarPage( theme = shinythemes::shinytheme("superhero"),
            "Zika Epidemic",

           
  tabPanel("Home",
           includeMarkdown("Zika_Home.md")
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
               mainPanel(plotOutput("Outbreak_Over_Time" , click = "plot_click") , verbatimTextOutput("info"))
                          )
            ),
             
              
      tabPanel("Heatmap Over Time",

              sliderInput(inputId = 'Date', 
                          label= "Select a Date",
                          min(Zika_Country_Data$Date),
                          max(Zika_Country_Data$Date),
                          min(Zika_Country_Data$Date),
                          step = 14, 
                          round = FALSE,
                          format = NULL,
                          locale = NULL, 
                          ticks = TRUE, 
                          animate = TRUE,
                          width = NULL, 
                          sep = ",",
                          pre = NULL, 
                          post = NULL, 
                          timeFormat = ,
                          timezone = , 
                          dragRange = TRUE
                          ),
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
 
             mainPanel(plotOutput("Outbreak_By_State" , click = "plot_click2") , verbatimTextOutput("info2"))

          ),
  
        tabPanel("United States Map of Zika",
           leafletOutput("Outbreak_Heatmap")
          )
           )
  
        )


  
