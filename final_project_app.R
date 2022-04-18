library(shiny)
library(tidyverse)
library(shinythemes)


ui <- fluidPage(
  
  ## Title
  titlePanel(
    textOutput("Mario Kart 8 Statistics")
    
  ),
  
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
                                selected = "Super Glider"),
                 numericInput('m', 'Select Kart 1 or 2', 1, min = 1, max = 2),),

    mainPanel(
      ## The output of the table to the center of the app.
      tabsetPanel(
        tabPanel("Table", tableOutput("stattable")),
        tabPanel("Table2", plotOutput("statgraph")),
        tabPanel("Table3", tableOutput("worldrecordtable"))
      ),
      wellPanel(
        tableOutput("combotable"),
        uiOutput("test")
      )
    ) 
  )
)


server <- function(input, output, session) {
  
  ## Create a reactive df of the current selection for statistics.
  selected <- reactive({
    mkfullNew %>%
      filter(Character == input$charselect | Gliders == input$gliderselect 
             | Tires == input$wheelselect | Karts == input$kartselect)})
  
  ## Create another df of the current selection to display current cart selection.
  combo <- reactive({
    c(selected()$Character, selected()$Tires, selected()$Gliders, selected()$Karts)})
  
  new <- reactive({
    data.frame(combo()) %>%
      drop_na()})
  
  ## Convert finalstats into summed dataframe.
  finalstats <- data.frame(t(colSums(selected()[2:13]))) 
  
  finalstats <- finalstats %>%
    pivot_longer(cols = c(1:12), names_to = "Stats", values_to = "Rating") 
  
  ## Output for images.
  output$test <- renderUI({
    images <- c("StandardKartBodyMK8.png",
                "PipeFrameBodyMK8.png")
    tags$img(src= images[input$m])})
  
  ## Output for stats table.
  output$stattable <- renderTable({
    tibble(finalstats)
  },type = "html", bordered = TRUE, striped = TRUE, 
  spacing = "xs", digits = 0)
  
  ## Output for stats graph.
  output$statgraph <- renderPlot({
      ggplot(finalstats, aes()) +
        geom_bar()
      
    })
  ## Output for world records.
  output$worldrecordtable <- renderTable({
    tibble(worldrecords)
  })
  
  ## Output which shows the current selection.
  output$combotable <- renderTable({
    tibble(new())},
    caption = "Current Selection:", caption.placement = "top")
  
}

shinyApp(ui, server)