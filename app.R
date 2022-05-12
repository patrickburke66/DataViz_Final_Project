library(shiny)
library(tidyverse)
library(shinythemes)
library(plotly)
library(janitor)
library(rvest)


ui <- fluidPage(theme = shinytheme("united"),
  
  ## Title
  titlePanel("Mario Kart 8 Statistics"),
  
  navlistPanel(widths = c(2,10),
               
             tabPanel("Statistics", 
                      
                      mainPanel(
                        ## The output of the table to the center of the app.
                        tabsetPanel(
                          
                          
                          ## Tab 1  -  BASIC SELECT AND SHOW STATS
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
                                     column(12,
                                            selectizeInput(inputId = "heatmapselect",
                                                           label = "Choose an Option to View",
                                                           choices = levels(factor(options$col1)),
                                                           selected = "Characters"),
                                            plotlyOutput("heatmap", width = "125%")
                                     )
                                   ),
                                   fluidRow(
                                     column(8,
                                            wellPanel(
                                              h3("About"),
                                              p("These heat maps show each individual impact of the different options. These values all are combined together to gather the final statistics for the selection. For the characters, there are groups within each class which have the same statistics. In the visualization I have combined them together to limit the number of repeated combinations shown. For the Classes - Light, Medium, and Heavy - I used the average statistics for each class for this visualization.")
                                            ))
                                   )
                          )
                          ,
                          tabPanel("Kart Comparison",
                                   fluidRow(
                                     column(4,
                                            wellPanel(
                                              selectizeInput(
                                                inputId = "charselect1",
                                                label = "Choose a Character #1",
                                                choices = levels(factor(charactersNew$Character)),
                                                selected = "Mario"),
                                              selectizeInput(inputId = "kartselect1",
                                                             label = "Choose Kart #1",
                                                             choices = levels(factor(bodiesNew$Karts)),
                                                             selected = "Standard Kart"),
                                              selectizeInput(inputId = "wheelselect1",
                                                             label = "Choose Wheels #1",
                                                             choices = levels(factor(tiresNew$Tires)),
                                                             selected = "Standard"),
                                              selectizeInput(inputId = "gliderselect1",
                                                             label = "Choose Glider #1",
                                                             choices = levels(factor(glidersNew$Gliders)),
                                                             selected = "Super")
                                            )),
                                     column(8,
                                            plotOutput("comparisongraph", width = "150%")
                                     ),
                                     fluidRow(
                                       column(4,
                                              wellPanel(
                                                selectizeInput(
                                                  inputId = "charselect2",
                                                  label = "Choose Character #2",
                                                  choices = levels(factor(charactersNew$Character)),
                                                  selected = "Mario"),
                                                selectizeInput(inputId = "kartselect2",
                                                               label = "Choose Kart #2",
                                                               choices = levels(factor(bodiesNew$Karts)),
                                                               selected = "Standard Kart"),
                                                selectizeInput(inputId = "wheelselect2",
                                                               label = "Choose Wheels #2",
                                                               choices = levels(factor(tiresNew$Tires)),
                                                               selected = "Standard"),
                                                selectizeInput(inputId = "gliderselect2",
                                                               label = "Choose Glider #2",
                                                               choices = levels(factor(glidersNew$Gliders)),
                                                               selected = "Super")
                                              )
                                       )
                                     )
                                     
                                   )
                          )
                        )
                      )
             ),
    
    tabPanel("Guide",
             ## Tab 0 - Intro
             tabsetPanel(
             tabPanel("About this App",
                      fluidRow(column(8,
                                      p("This is an app to test out different combinations for Mario Kart 8 deluxe. In this app, you can select your Character, Kart, Tires, and Glider on the left hand side. Each of our different tabs includes statistics and information about your selection. You can also navigate to the Random Kart selector. All Mario Kart statistics have a minimum of -1 and a maximum of 5.75. All of the characters begin with base statistics. Changing the Kart, Tires, or Glider changes can effect each of these statistics positively or negatively. Enjoy!"),
                                      h6("Made by Patrick Burke for St. Lawrence University and Dr. Matt Higham")
                    )
                ) 
            ),
            tabPanel("Character Guide",
                     wellPanel(
                       h3("Characters")
                     ),
                     fluidRow(
                       
                        column(8,
                               tableOutput("characterguide")))),
            tabPanel("Kart Guide",
                     wellPanel(
                       h3("Karts")),
                       fluidRow(
                         
                         column(8,
                            tableOutput("kartguide")))
                     ),
            tabPanel("Tire Guide",
                     wellPanel(
                       h3("Tires")),
                       fluidRow(
                         
                         column(8,
                              tableOutput("tireguide")))
                     ),
            tabPanel("Glider Guide",
                     wellPanel(
                       h3("Gliders")),
                       fluidRow(
                         
                         column(8,
                              tableOutput("gliderguide")))
                     )
             ))

  )
  
)

  

  


    

server <- function(input, output, session) {
  
  bodiesNew <- read_csv("bodies.csv")
  bodiesNew <- bodiesNew %>%
    mutate(Karts = Body) %>%
    subset(select = (-c(2)))
  
  
  tiresNew <- read_csv("tires.csv")
  tiresNew <- tiresNew %>%
    mutate(Tires = Body) %>%
    subset(select = (-c(2)))
  
  glidersNew <- read_csv("gliders.csv")
  glidersNew <- glidersNew %>%
    mutate(Gliders = Body) %>%
    subset(select = (-c(2)))
  
  charactersNew <- read_csv("characters.csv")
  
  colnames(bodiesNew)<- c("Type", "TotalSpeed","WaterSpeed", "AirSpeed",
                          "GroundSpeed", "Acceleration", "Weight", 
                          "TotalHandling",
                          "WaterHandling","AirHandling", "GroundHandling",
                          "Traction","MiniTurbo","Karts")
  
  colnames(charactersNew)<- c("Class", "Character",
                              "TotalSpeed","WaterSpeed", "AirSpeed",
                              "GroundSpeed", "Acceleration", "Weight", 
                              "TotalHandling", "WaterHandling","AirHandling",
                              "GroundHandling",
                              "Traction","MiniTurbo")
  
  colnames(glidersNew)<- c("Type", "TotalSpeed","WaterSpeed", "AirSpeed",
                           "GroundSpeed", "Acceleration", "Weight", 
                           "TotalHandling",
                           "WaterHandling","AirHandling", "GroundHandling",
                           "Traction","MiniTurbo", "Gliders")
  
  colnames(tiresNew)<- c("Type", "TotalSpeed","WaterSpeed", "AirSpeed",
                         "GroundSpeed", "Acceleration", "Weight", 
                         "TotalHandling",
                         "WaterHandling","AirHandling", "GroundHandling",
                         "Traction","MiniTurbo", "Tires")
  
  colnames(mkfullNew)<- c("Type", "TotalSpeed","WaterSpeed", "AirSpeed",
                          "GroundSpeed", "Acceleration", "Weight", 
                          "TotalHandling",
                          "WaterHandling","AirHandling", "GroundHandling",
                          "Traction","MiniTurbo","Karts", "Class",
                          "Character", "Gliders", "Tires")
  
  mkfullNew <- full_join(bodiesNew, charactersNew)
  mkfullNew <-full_join(mkfullNew, glidersNew)
  mkfullNew <- full_join(mkfullNew, tiresNew)
  
  ## Simplifying Lights
  simplifiedchars <- mkfullNew %>%
    filter(!is.na(Character))%>%
    filter(!row_number() %in% c(1, 7, 3, 11, 9, 13, 12, 6))
  
  ## Renaming Lights
  simplifiedchars <- simplifiedchars %>%
    mutate(Character = ifelse(Character == "Baby Luigi", "BabyLuigi/BabyMario/LightMii", Character)) %>%
    mutate(Character = ifelse(Character == "Baby Daisy", "BabyDaisy/BabyPeach", Character)) %>%
    mutate(Character = ifelse(Character == "Koopa Troopa", "Koopa/Lakitu", Character)) %>%
    mutate(Character = ifelse(Character == "Toad", "Toad/ShyGuy/Larry", Character)) %>%
    mutate(Character = ifelse(Character == "Toadette", "Toadette/Wendy", Character)) %>%
    mutate(Character = ifelse(Character == "Baby Rosalina", "BabyRosalina/Lemmy", Character))
  
  simplifiedchars <- simplifiedchars %>%
    filter(!row_number() %in% c(8, 7, 11, 13, 14))
  
  simplifiedchars <- simplifiedchars %>%
    mutate(Character = ifelse(Character == "Yoshi", "Yoshi/Daisy/Peach", Character)) %>%
    mutate(Character = ifelse(Character == "Iggy Koopa", "Iggy/Luigi", Character)) %>%
    mutate(Character = ifelse(Character == "Mario", "Mario/Ludwig/MediumMii", Character))
  
  simplifiedchars <- simplifiedchars %>%
    filter(!row_number() %in% c(10, 13, 17, 19, 14))
  
  simplifiedchars <- simplifiedchars %>%
    mutate(Character = ifelse(Character == "Waluigi", "Waluigi/DK/Roy", Character)) %>%
    mutate(Character = ifelse(Character == "Morton Koopa", "Bowser/Morton/HeavyMii", Character)) %>%
    mutate(Character = ifelse(Character == "Pink Gold Peach", "PinkGoldPeach/MetalMario", Character)) 
  
  col1 <- c("Type", "Tires", "Glider", "Characters", "Karts")
  options <- data.frame(col1)
  
  bodiesNew <- bodiesNew %>%
    relocate(Karts, .before = Type)
  
  charactersNew <- charactersNew %>%
    relocate(Character, .before = Class)
  
  glidersNew <- glidersNew %>%
    relocate(Gliders, .before = Type)
  
  tiresNew <- tiresNew %>%
    select(-Type)
  
  tiresNew <- tiresNew %>%
    relocate(Tires, .before = TotalSpeed)

# SUMMARY STATISTIC DF MAKING
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
  
  ## Convert finalstats into summed data frame.
  finalstats <- reactive({
    data.frame(t(colSums(selected()[2:13])))
  })
  
  display_table <- reactive({ finalstats() %>%
    pivot_longer(cols = c(1:12), names_to = "Stats", values_to = "Rating") 
  })
  

  
  
##############################################################################
  
# RANDOMIZER DF MAKING
  
  
  
  ##Create df for the selected options
  
  ###Sizes
  randomsize <- reactive({mkfullNew %>%
    filter(Class == input$charsizeselect)})
  
  
  topaccelchars <- reactive({randomsize() %>%
    filter(Acceleration >= 3.25)})
  
  topspeedchars <- reactive({randomsize()
    filter(TotalSpeed >= 4.75)})
  
  topweightchars <- reactive({randomsize()
    filter(Weight >= 4.75)})
  
  tophandlingchars <- reactive({randomsize()
    filter(TotalHandling >= 4.75)})
  
  toptractioncharss <- reactive({randomsize()
    filter(Traction >= 4.5)})
  
  topminiturbochars <- reactive({randomsize()
    filter(MiniTurbo >= 3)})
  
  ###Karts
  randomtype <- reactive({mkfullNew %>%
    filter(Type == input$bikekartselect)})
  
  topspeedkarts <- reactive({randomtype() %>%
    filter(TotalSpeed >= .5)})
  
  topaccelkarts <- reactive({randomtype()
    filter(Acceleration >= 1.25)})
  
  topweightkarts  <- reactive({randomtype() %>%
    filter(Weight >= .5)})
  
  tophandlingkarts  <- reactive({randomtype() %>%
    filter(TotalHandling >= .75)})
  
  toptractionkarts  <- reactive({randomtype() %>%
    filter(Traction >= .5)})
  
  topminiturbokarts  <- reactive({randomtype()%>%
    filter(MiniTurbo >= 1)})
  
###########
  # Random df maker
  
  ### Acceleration
  randomaccelchar <- reactive({topaccelchars()[sample(1:nrow(topaccelchars()), 1), ]})
  randomaccelkart <- reactive({topaccelkarts()[sample(1:nrow(topaccelkarts()), 1), ]})
  randomacceltires <- reactive({topacceltires()[sample(1:nrow(topacceltores()), 1), ]})
  randomaccelglider <-glidersNew[sample(1:nrow(glidersNew), 1), ]
  
  randomaccelselection <- reactive({
    mkfullNew %>%
      filter(Character == randomaccelchar()$Character[1] | Gliders == randomaccelglider()$Gliders[1] 
             | Tires == randomacceltires()$Tires[1] | Karts == randomaccelkart()$Karts[1])})
  
  finalaccelrandomselection <- reactive({
    data.frame(t(colSums(randomaccelselection()[2:13])))
  })
  
  display_randomaccel <- reactive({ finalaccelrandomselection() %>%
      pivot_longer(cols = c(1:12), names_to = "Stats", values_to = "Rating") 
  })
  
  ## Speed
  
  randomspeedchar <- reactive({topspeedchars()[sample(1:nrow(topspeedchars()), 1), ] })
  randomspeedkart <- reactive({topspeedkarts()[sample(1:nrow(topspeedkarts()), 1), ]})
  randomspeedtires <- reactive({topspeedtires()[sample(1:nrow(topspeedtires()), 1), ]})
  randomgspeedglider <-glidersNew[sample(1:nrow(glidersNew), 1), ]
  
  randomspeedselection <- reactive({
    mkfullNew %>%
      filter(Character == randomspeedchar()$Character[1] | Gliders == randomspeedglider()$Gliders[1] 
             | Tires == randomspeedtires()$Tires[1] | Karts == randomspeedkart()$Karts[1])
  })
  
  finalspeedrandomselection <- reactive({
    data.frame(t(colSums(randomspeedselection()[2:13])))
  })
  
  display_randomspeed <- reactive({ finalspeedrandomselection() %>%
      pivot_longer(cols = c(1:12), names_to = "Stats", values_to = "Rating") 
  })
  
  ## Weight
  
  randomweightchar <- reactive({topweightchars()[sample(1:nrow(topweightchars()), 1), ]})
  randomweightkart <- reactive({topweightkarts()[sample(1:nrow(topweightkarts()), 1), ]})
  randomweighttires <- reactive({topweighttires()[sample(1:nrow(topweighttires()), 1), ]})
  randomweightglider <-glidersNew[sample(1:nrow(glidersNew), 1), ]
  
  randomweightselection <- reactive({
    mkfullNew %>%
      filter(Character == randomweightchar()$Character[1] | Gliders == randomweightglider()$Gliders[1] 
             | Tires == randomweighttires()$Tires[1] | Karts == randomweightkart()$Karts[1])})
  
  finalweightrandomselection <- reactive({
    data.frame(t(colSums(randomweightselection()[2:13])))
  })
  
  display_randomweight <- reactive({ finalweightrandomselection() %>%
      pivot_longer(cols = c(1:12), names_to = "Stats", values_to = "Rating") 
  })
  
  ## Handling
  
  randomhandlingchar <- reactive({tophandlingchars()[sample(1:nrow(tophandlingchars()), 1), ]})
  randomhandlingkart <- reactive({tophandlingkarts()[sample(1:nrow(tophandlingkarts()), 1), ]})
  randomhandlingtires <- reactive({tophandlingtires()[sample(1:nrow(tophandlingtores()), 1), ]})
  randomhandlingglider <- glidersNew[sample(1:nrow(glidersNew), 1), ]
  
  randomhandlingselection <- reactive({
    mkfullNew %>%
      filter(Character == randomhandlingchar()$Character[1] | Gliders == randomhandlingglider()$Gliders[1] 
             | Tires == randomhandlingtires()$Tires[1] | Karts == randomhandlingkart()$Karts[1])})
  
  finalhandlingrandomselection <- reactive({
    data.frame(t(colSums(randomhandlingselection()[2:13])))
  })
  
  display_randomhandling <- reactive({ finalhandlingrandomselection() %>%
      pivot_longer(cols = c(1:12), names_to = "Stats", values_to = "Rating") 
  })
  
  ## Traction
  randomtractionchar <- reactive({toptractionchars()[sample(1:nrow(toptractionchars()), 1), ]})
  randomtractionkart <- reactive({toptractionkarts()[sample(1:nrow(toptractionkarts()), 1), ]})
  randomtractiontires <- reactive({toptractiontires()[sample(1:nrow(toptractiontores()), 1), ]})
  randomtractionglider <-glidersNew[sample(1:nrow(glidersNew), 1), ]
  
  
  randomtractionselection <- reactive({
    mkfullNew %>%
      filter(Character == randomtractionchar()$Character[1] | Gliders == randomtractionglider()$Gliders[1] 
             | Tires == randomtractiontires()$Tires[1] | Karts == randomtractionkart()$Karts[1])})
  
  finaltractionrandomselection <- reactive({
    data.frame(t(colSums(randomtractionselection()[2:13])))
  })
  
  display_randomtraction <- reactive({ finaltractionrandomselection() %>%
      pivot_longer(cols = c(1:12), names_to = "Stats", values_to = "Rating") 
  })
  ## MiniTurbo
  
  randomminiturbochar <- reactive({topminiturbokarts()[sample(1:nrow(topminiturbokarts()), 1), ]})
  randomminiturbokart <- reactive({topminiturbokarts()[sample(1:nrow(topminiturbokarts()), 1), ]})
  randomminiturbotire <- reactive({topminiturbotires()[sample(1:nrow(topminiturbotres()), 1), ]})
  randomminiturbogliders <- glidersNew[sample(1:nrow(glidersNew), 1), ]
  
  randomminiturboselection <- reactive({
    mkfullNew %>%
      filter(Character == randomminiturbochar()$Character[1] | Gliders == randomminiturboglider()$Gliders[1] 
             | Tires == randomminiturbotires()$Tires[1] | Karts == randomminiturbokart()$Karts[1])})
  
  finalminiturborandomselection <- reactive({
    data.frame(t(colSums(randomminiturboselection()[2:13])))
  })
  
  display_randomminiturbo <- reactive({ finalminiturborandomselection() %>%
      pivot_longer(cols = c(1:12), names_to = "Stats", values_to = "Rating") 
  })


##############################################################################
  
# BACK TO BACK BARPLOT DF MAKING
  
## FIRST SELECTION
  ## Create a reactive df of the current selection for statistics.
  selected1 <- reactive({
    mkfullNew %>%
      filter(Character == input$charselect1 | Gliders == input$gliderselect1 
             | Tires == input$wheelselect1 | Karts == input$kartselect1)})
  
  ## Create another df of the current selection to display current cart selection.
  combo1 <- reactive({
    c(selected1()$Character, selected1()$Tires, selected1()$Gliders, selected1()$Karts)})
  
  new1 <- reactive({
    data.frame(combo1()) %>%
      drop_na()})
  
  ## Convert finalstats into summed dataframe.
  finalstats1 <- reactive({
    data.frame(t(colSums(selected1()[2:13])))
  })
  
  display_table1 <- reactive({ finalstats1() %>%
      pivot_longer(cols = c(1:12), names_to = "Stats", values_to = "Rating") 
  })
  
  display_tablefinal1 <- reactive({display_table1() %>%
      mutate(Selection = "Player1")})
  
## SECOND SELECTION
  ## Create a reactive df of the current selection for statistics.
  selected2 <- reactive({
    mkfullNew %>%
      filter(Character == input$charselect2 | Gliders == input$gliderselect2 
             | Tires == input$wheelselect2 | Karts == input$kartselect2)})
  
  ## Create another df of the current selection to display current cart selection.
  combo2 <- reactive({
    c(selected2()$Character, selected2()$Tires, selected2()$Gliders, selected2()$Karts)})
  
  new2 <- reactive({
    data.frame(combo2()) %>%
      drop_na()})
  
  ## Convert finalstats into summed dataframe.
  finalstats2 <- reactive({
    data.frame(t(colSums(selected2()[2:13])))
  })
  
  display_table2 <- reactive({ finalstats2() %>%
      pivot_longer(cols = c(1:12), names_to = "Stats", values_to = "Rating") 
  })
  
  display_tablefinal2 <- reactive({display_table2() %>%
      mutate(Selection = "Player2")})
  
  displaytable_total <- reactive({
    full_join(display_tablefinal1(), display_tablefinal2())})

##############################################################################
  
  ## HEAT MAPS
  
  charhm <- ggplot(finalstatschars, aes(x = Character, y = Stats)) +
    geom_tile(aes(fill = Rating), color = "white") +
    theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1, size = 10),
          axis.text.y = element_text(size = 13)) +
    geom_text(aes(label = Rating), color = "white", size = 2) +
    scale_fill_gradient(low = "blue", high = "red")
  
  classhm <- ggplot(finalstatssize, aes(x = Class, y = Stats)) +
    geom_tile(aes(fill = Rating), color = "white") +
    theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1, size = 10),
          axis.text.y = element_text(size = 13)) +
    geom_text(aes(label = Rating), color = "white", size = 2) +
    scale_fill_gradient(low = "blue", high = "red")
  
  tirehm <- ggplot(finalstatstire, aes(x = Tires, y = Stats)) +
    geom_tile(aes(fill = Rating), color = "white") +
    theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1, size = 10),
          axis.text.y = element_text(size = 13)) +
    geom_text(aes(label = Rating), color = "white", size = 2) +
    scale_fill_gradient(low = "blue", high = "red")
  
  kartshm <- ggplot(finalstatskarts, aes(x = Karts, y = Stats)) +
    geom_tile(aes(fill = Rating), color = "white") +
    theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1, size = 10),
          axis.text.y = element_text(size = 13)) +
    geom_text(aes(label = Rating), color = "white", size = 2) +
    scale_fill_gradient(low = "blue", high = "red")
  
  gliderhm <- ggplot(finalstatsglider, aes(x = Gliders, y = Stats)) +
    geom_tile(aes(fill = Rating), color = "white") +
    theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1, size = 10),
          axis.text.y = element_text(size = 13)) +
    geom_text(aes(label = Rating), color = "white", size = 2) +
    scale_fill_gradient(low = "blue", high = "red")
  
  

  
##############################################################################
# OUTPUTS
##############################################################################
  
## Output for random generator
  output$randomtable <- renderTable({
    
      if(input$statselect == "Acceleration"){
        tibble(display_randomaccel())
      }
      else if(input$statselect == "TotalSpeed"){
        tibble(display_randomspeed())
        
      }
      else if(input$statselect == "Weight"){
        tibble(display_randomweight())
      }
      else if(input$statselect == "TotalHandling"){
        tibble(display_randomhandling())
      }
      else if(input$statselect == "Traction"){
        tibble(display_randomtraction())
      }
      else {
        tibble(display_randomminiturbo())
      }
      
    
  })
  
## Output for images.
  output$test <- renderImage({
    list(
      src = file.path("www/title1.png"),
      contentType = "image/png",
      width = 500,
      height = 650
    )
  }, deleteFile = FALSE)
  
  
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
        ylim(0, 5.75) +
        theme(axis.text.y = element_text(size = 13),
              axis.text.x = element_text(size = 13))
    })
  
## Output for heatmap
  output$heatmap <- renderPlotly({
    
    if(input$heatmapselect == "Characters"){
      ggplotly(charhm)
    }
    else if(input$heatmapselect == "Type"){
      ggplotly(classhm)
    }
    else if(input$heatmapselect == "Tires"){
      ggplotly(tirehm)
    }
    else if(input$heatmapselect == "Karts"){
      ggplotly(kartshm)
    }
    else{
      ggplotly(gliderhm)
    }

  })

  
## Output for Comparison

  output$comparisongraph <- renderPlot({
    ggplot(displaytable_total(), aes(x = Stats, y = Rating, fill = Selection)) +
      geom_col(position = position_dodge2(reverse = TRUE)) +
      coord_flip()  +
      theme(axis.text.y = element_text(size = 13),
            axis.text.x = element_text(size = 13))
  })

## Output which shows the current selection.
  output$combotable <- renderTable({
    tibble(new())},
    caption = "Current Selection:", caption.placement = "top")
  
## Output for the guides
  
  # CHAR GUIDE
  
  output$characterguide <- renderTable({
    tibble(charactersNew)
  })

  # TIRE GUIDE
  
  output$tireguide <- renderTable({
    tibble(tiresNew)
  })
  
  # GLIDER GUIDE
  
  output$gliderguide <- renderTable({
    tibble(glidersNew)
  })
  
  # KART GUIDE
  
  output$kartguide <- renderTable({
    tibble(bodiesNew)
  })

  
  output$text <- renderText({      
      p("Data from Kaggle: Tarun Sunkareneni,
      App by Patrick Burke - For Dr. Matt Higham and St. Lawrence University")})
}

shinyApp(ui, server)