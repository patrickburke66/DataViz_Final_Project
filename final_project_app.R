library(shiny)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(selectizeInput(inputId = "charselect",
                                label = "Choose a Character",
                                choices = levels(factor(chars$Driver))),
                 selectizeInput(inputId = "kartselect",
                                label = "Choose a Kart",
                                choices = levels(factor(karts$Body))),
                 selectizeInput(inputId = "wheelselect",
                              label = "Choose Wheels",
                              choices = levels(factor(wheels$Tire))),
                 selectizeInput(inputId = "gliderselect",
                                label = "Choose a Glider",
                                choices = levels(factor(glider$Glider)))),
    mainPanel(tableOutput("stattable"))
  )
)

server <- function(input, output, session) {
  
  charselected <- reactive({
    chars %>% filter(Driver == input$charselect)
  })
  
  kartselected <- reactive({
    karts %>% filter(Body == input$kartselect)
  })
  
  selected <- reactive({full_join(kartselected, charselected)})
  
  wheelselected <- reactive({
    wheels %>% filter(Tire == input$wheelselect)
  })
  
  selected <- reactive({full_join(selected, wheelselected)})
  
  
  gliderselected <- reactive({
    glider %>% filter(Glider == input$gliderselect)
  })
  
  selected <-reactive({full_join(selected, gliderselected)})
  
  
  output$stattable <- renderTable({
    
    finalstats = colSums(selected[2:14])
    
    finalstats
    
  })
}

shinyApp(ui, server)