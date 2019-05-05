#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


library(shiny)

source("visualization.R")

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Test Your Functioning Fitness Index"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      textInput(inputId = "name", label = "Your Full Name", value = "", width = NULL),
      textInput(inputId = "ID", label = "Your ID", value = "", width = NULL),
      textInput(inputId = "age", label = "Age (60-94)", value = "60", width = NULL,
                placeholder = NULL),
      textInput(inputId = "value", label = "Yards Walked with 6 mins (200-800)", value = "200", width = NULL,
                placeholder = NULL),
      actionButton("updateButton", "Test now"),
      actionButton("clearButton", "Clear all"),
      downloadButton("downloadPlot", "Download Evaluation Chart")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("Plot")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  values <- reactiveValues()
  
  output$Plot <- renderPlot({p})
  
  plotInput <- function(){
    add_new_point(p, age = values$age, val = values$value, name = values$name, ID = as.numeric(input$ID))
  }
  
  observeEvent(input$updateButton, {
    values$age <- as.numeric(input$age)
    values$value  <- as.numeric(input$value)
    values$name <- input$name
    values$ID <- input$ID
    output$Plot <- renderPlot(plotInput())
  })
  
  observeEvent(input$clearButton, {
    output$Plot <- renderPlot({p})
  })
  
  output$downloadPlot <- downloadHandler(
    filename = function() {
      paste("ID_", input$ID,"_Name_", input$name, ".png", sep="")
    },
    content = function(file) {
      ggsave(file, plot = plotInput(), device = "png", width = 279, height = 216, units = "mm")
    },
    contentType = "image/png"
  )
  
}

# Run the application 
shinyApp(ui = ui, server = server)

