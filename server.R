library(shiny)
library(tidyverse)
library(ggplot2)

Zika_Country_Data <- read_csv("~/zika-epidemic/Zika - Country Data.csv")
Zika_State_Data <- read.csv("StataData.csv")
Zika_Country_Data$Date <- as.Date(Zika_Country_Data$Date, format = "%m/%d/%Y")


function(input, output, session) {
  
  
  output$Outbreak_Over_Time <- renderPlot({
    
    Zika_Country_Data %>%
      filter(Country_Territory == input$Country) %>%
      ggplot(aes(Date, Confirmed, color=Confirmed_congenital_syndrome)) +
      geom_point() +
      theme(axis.text.x = element_text(angle = 60, hjust = 1))
  })

    

  output$Outbreak_By_State <- renderPlot({
    
    StataData %>%
      filter(States == input$State) %>%
      ggplot(aes (States, Number_of_Cases)) +
      geom_histogram() +
      theme(axis.text.x = element_text(angle = 60, hjust = 1))
    
  })
  

}

