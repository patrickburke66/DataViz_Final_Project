library(shiny)
library(tidyverse)
library(shinythemes)


ui <- fluidPage(
  
  ## Title
  titlePanel("Mario Kart 8 Statistics"),
  
  ## All the stuff that'll be on the side
  sidebarLayout(
    
    ## Side panel, with the four selections and an action button
    sidebarPanel(selectizeInput(inputId = "charselect",
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
                 h4("Total Statistics"), tableOutput("stattable")
                 ),
  

    mainPanel(
      ## The output of the table to the center of the app.
      tabsetPanel(
        tabPanel("Kart Statistics - Graph", plotOutput("statgraph")),
        tabPanel("World Records", tableOutput("worldrecordtable"))
      )
        #(p("This is an app to test out different combinations for Mario Kart 8 deluxe. In this app, you can select your Character, Kart, Tires, and Glider on the left hand side. Each of our different tabs includes statistics and information about your selection. You can also navigate to the Random Kart selector. All Mario Kart statistics have a minimum of 0.75 and a maximum of 5.75. All of the characters begin with base statistics. Changing the Kart, Tires, or Glider changes can effect each of these statistics positively or negatively. Enjoy!")
         #)
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
  
## Output which shows the current selection.
  output$combotable <- renderTable({
    tibble(new())},
    caption = "Current Selection:", caption.placement = "top")
  
}

## Output idea: select bike vs kart, speed vs acceleration, character size, 
## and the app will provide a character for you



shinyApp(ui, server)