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
                                choices = levels(factor(charactersNew$Character)),
                                selected = "MarioMro"),
                 selectizeInput(inputId = "kartselect",
                                label = "Choose a Kart",
                                choices = levels(factor(bodiesNew$Karts)),
                                selected = "Standard Kart"),
                 selectizeInput(inputId = "wheelselect",
                              label = "Choose Wheels",
                              choices = levels(factor(tiresNew$Tires)),
                              selected = "StandardNormal"),
                 selectizeInput(inputId = "gliderselect",
                                label = "Choose a Glider",
                                choices = levels(factor(glidersNew$Gliders)),
                                selected = "Super Glider")),
    mainPanel(
      ## The output of the table to the center of the app.
      tabsetPanel(
        tabPanel("Table", tableOutput("stattable")),
        tabPanel("Table2", plotOutput("statgraph")),
        tabPanel("Table3", tableOutput("worldrecordtable"))
      )
    )

  )
)

server <- function(input, output, session) {
  
  selected <- reactive({
    mkfullNew %>%
      filter(Character == input$charselect | Gliders == input$gliderselect 
             | Tires == input$wheelselect | Karts == input$kartselect)})
  
  combo <- reactive({
    c(selected()$Character, selected()$Tires, selected()$Gliders, selected()$Karts)})
  
  new <- reactive({
    data.frame(combo()) %>%
    drop_na()})
  
  
  output$stattable <- renderTable({
    finalstats <- data.frame(t(colSums(selected()[2:13])))  
    tibble(finalstats)
  })
  
  output$total <- 
  
  output$statgraph <- renderPlot({
    ggplot(finalstats, aes()) +
      geom_bar()
    
  })
  
  output$worldrecordtable <- renderTable({
    tibble(worldrecords)
  })
  
  output$combotable <- renderTable({
    tibble(new())},
    caption = "Current Selection:", caption.placement = "top")
  
}

shinyApp(ui, server)