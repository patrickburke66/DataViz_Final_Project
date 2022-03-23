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
                              choices = levels(factor(wheels$Tire)))
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
  
  wheelselected <- reactive({
    wheels %>% filter(Tire == input$wheelselect)
  })
  
  gliderselected <- reactive({
    glider %>% filter(Glider == input$gliderselect)
  })
  
  totaldf <- reactive({bind_cols(charselected, gliderselected, kartselected, wheelselected,
                       c("WG", "AC", "ON", "OF", "MT", "SL", "SW", 
                         "SA", "SG", "TL", "TW", "TA", "TG"))})
  
  output$stattable <- renderTable({
    
    head(totaldf)
    
  })
}

shinyApp(ui, server)