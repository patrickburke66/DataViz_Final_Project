library(shiny)
library(tidyverse)

ui <- fluidPage(
  
  ## Title
  titlePanel("Mario Kart 8 Deluxe Character Statistics"),
  
  ## All the stuff that'll be on the side
  sidebarLayout(
    
    ## Side panel, with the four selections and an action button
    sidebarPanel(selectizeInput(inputId = "charselect",
                                label = "Choose a Character",
                                choices = levels(factor(chars$Driver)),
                                selected = "MarioMro"),
                 selectizeInput(inputId = "kartselect",
                                label = "Choose a Kart",
                                choices = levels(factor(karts$Body)),
                                selected = "Standard Kart"),
                 selectizeInput(inputId = "wheelselect",
                              label = "Choose Wheels",
                              choices = levels(factor(wheels$Tire)),
                              selected = "StandardNormal"),
                 selectizeInput(inputId = "gliderselect",
                                label = "Choose a Glider",
                                choices = levels(factor(glider$Glider)),
                                selected = "Super Glider")),
    
    ## The output of the table to the center of the app.
    tabsetPanel(
      tabPanel("Table", tableOutput("stattable")),
      tabPanel("Table2", plotOutput("statgraph"))
    )
  )
)

server <- function(input, output, session) {
  
  selected <- reactive({
    mkfull %>%
      filter(Driver == input$charselect | Glider == input$gliderselect 
             | Tire == input$wheelselect | Body == input$kartselect)})
  
  
  output$stattable <- renderTable({
    
    finalstats <- data.frame(t(colSums(selected()[2:14])))  
    tibble(finalstats)
  })
  
  output$statgraph <- renderPlot({
    ggplot(finalstats) +
      geom_bar()
    
  })
  
}

shinyApp(ui, server)