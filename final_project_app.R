library(shiny)
library(tidyverse)
library(shinythemes)


ui <- fluidPage(
  
  ## Title
  titlePanel("Mario Kart 8 Statistics"),
  
    mainPanel(
      ## The output of the table to the center of the app.
      tabsetPanel(
        
        ##FIRST TAB  -  BASIC SELECT AND SHOW STATS
        tabPanel("Kart Statistics - Graph", 
                 fluidRow(
                   ## COLUMN 1, Selector
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
                   ## COLUMN 2 - Graph
                   column(9,
                          plotOutput("statgraph")))),
        ## TAB 2 - Heat Map of Statistics based on selection
        tabPanel("Kart Statistics - Heat Map",
                 fluidRow(
                   column(3,
                          selectizeInput(inputId = "charselect",
                                         label = "Choose an Option to View",
                                         choices = levels(factor(charactersNew$Character)),
                                         selected = "Mario"),
                          plotOutput("heatmap"))
                   )
                 ),
        tabPanel("Random Kart Generator",
                 fluidRow(
                   column(3,                  
                          ## Selecter of Parameters
                          selectizeInput(inputId = "charsizeselect",
                                         label = "Choose a Character Size",
                                         choices = levels(factor(charactersNew$Class)),
                                         selected = "Light"),
                          selectizeInput(inputId = "bikekartselect",
                                         label = "Choose a Vehicle Type",
                                         choices = levels(factor(bodiesNew$Type)),
                                         selected = "Bike"),
                          selectizeInput(inputId = "statselect",
                                         label = "Choose a Stat to Prioritize",
                                         choices = levels(factor(finalstats$Stats)),
                                         selected = "Speed")),
                   column(9,
                          tableOutput("randomtable")))
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
  finalstats <- reactive({
    data.frame(t(colSums(selected()[2:13])))
  })
  
  display_table <- reactive({ finalstats() %>%
    pivot_longer(cols = c(1:12), names_to = "Stats", values_to = "Rating") 
  })
  
  ##Create df for the selected options
  
  randomchar <- reactive({
    charactersNew %>%
    filter(Class == input$charsizeselect)%>%
    select(input$statselect, Character)%>%
    arrange(desc(input$statselect)) %>% 
    slice(1:5)
  })
  randomkart <- reactive({
    bodiesNew %>%
    filter(Type == input$bikekartselect) %>%
    select(input$statselect, Karts)%>%
    arrange(desc(input$statselect)) %>% 
    slice(1:5)
  })

  
## output for random generator
  output$randomtable <- renderTable({
    tibble(randomchar())
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
    ggplot(bodiesNew, aes(x = , y = Karts)) +
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