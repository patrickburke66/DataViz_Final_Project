library(shiny)
library(tidyverse)
library(shinythemes)


ui <- fluidPage(
  
  ## Title
  titlePanel("Mario Kart 8 Statistics"),
  
    mainPanel(
      ## The output of the table to the center of the app.
      tabsetPanel(
        tabPanel("Kart Statistics - Graph", 
                 fluidRow(
                   column(3,
                          selectizeInput(inputId = "charselect",
                                                      label = "Choose a Character",
                                                      choices = levels(factor(charactersNew$Character)),
                                                      selected = "Mario"),
                                       selectizeInput(inputId = "kartselect",
                                                      label = "Choose a Kart",
                                                      choices = levels(factor(bodiesNew$Karts)),
                                                      selected = "Standard Kart"),
                                       selectizeInput(inputId = "wheelselect",
                                                      label = "Choose Wheels",
                                                      choices = levels(factor(tiresNew$Tires)),
                                                      selected = "Standard"),
                                       selectizeInput(inputId = "gliderselect",
                                                      label = "Choose a Glider",
                                                      choices = levels(factor(glidersNew$Gliders)),
                                                      selected = "Super"),
                                       h4("Total Statistics"), tableOutput("stattable")),
                   column(9,
                          plotOutput("statgraph")))),
        tabPanel("Kart Statistics - Heat Map", plotOutput("heatmap"))
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
  finalstats <- reactive({
    data.frame(t(colSums(selected()[2:13])))
  })
  
  display_table <- reactive({ finalstats() %>%
    pivot_longer(cols = c(1:12), names_to = "Stats", values_to = "Rating") 
  })
  
## Output for images.
  output$test <- renderUI({
    images <- c("StandardKartBodyMK8.png",
                "PipeFrameBodyMK8.png")
    tags$img(src= images[input$m])})
  
## Output for stats table.
  output$stattable <- renderTable({
    tibble(display_table())
  },type = "html", bordered = TRUE, striped = TRUE, 
  spacing = "xs", digits = 2)
  
## Output for stats graph.
  output$statgraph <- renderPlot({
      ggplot(display_table(), aes(x = Stats, y = Rating)) +
        geom_col(fill = "darkgoldenrod1", color = "darkgoldenrod3") +
        coord_flip() +
        ylim(0, 5.75)
    })
  
## Output for world records.
  output$worldrecordtable <- renderTable({
    tibble(worldrecords)
  })
  
## Output for heatmap
  output$heatmap <- renderPlot({
    ggplot(display_table(), aes(x = Stats, y = Rating)) +
      geom_tile()
  })
  
## Output for Comparison
  
  

## Output which shows the current selection.
  output$combotable <- renderTable({
    tibble(new())},
    caption = "Current Selection:", caption.placement = "top")
  
}

## Output idea: select bike vs kart, speed vs acceleration, character size, 
## and the app will provide a character for you



shinyApp(ui, server)