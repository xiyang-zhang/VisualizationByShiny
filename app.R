#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


library(shiny)

source("visualization_pipeline.R")

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Test Your Functioning Fitness"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      textInput(inputId = "name", label = "Your Full Name", value = "", width = NULL),
      textInput(inputId = "ID", label = "Your ID", value = "", width = NULL),
      textInput(inputId = "age", label = "Age (60-94)", value = "60", width = NULL,
                placeholder = NULL),
      selectInput(inputId = "genderType", label = "Choose Your Gender", choices = c(genderList), selected = "Female"),
      selectInput(inputId = "testType", label = "Choose Your Test", choices = c(testList), selected = "Chair Stand"),
      sliderInput(inputId = "value", label = "Your Test Value",
                  min = rangeTable$CSF[1], 
                  max = rangeTable$CSF[length(rangeTable$CSF)], 
                  value = diff(range(rangeTable$CSF))/2 + rangeTable$CSF[1]),
      #textInput(inputId = "value", label = "Your Test Value (Only Allowed within range)", value = "", width = NULL, placeholder = NULL),
      actionButton("updateButton", "Test now"),
      actionButton("clearButton", "Clear all"),
      downloadButton("downloadReport", "Download Evaluation Report")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("Plot")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  values <- reactiveValues()
  savedValues <- reactiveValues(CS = NA, 
                                ARM = NA,
                                WALK = NA,
                                STEP = NA,
                                CHAIRSAR = NA,
                                BACK = NA,
                                UAG = NA)
  
  output$Plot <- renderPlot({
    getBasicPlot(genderType = input$genderType, 
                 testType = input$testType)
  })
  
  plotInput <- function(){
    add_new_point(getBasicPlot(genderType = input$genderType, 
                               testType = input$testType), 
                  age = values$age, val = values$value, name = values$name, 
                  ID = as.numeric(input$ID), genderType = input$genderType, 
                  testType = input$testType, size = 6)
  }
  
  observeEvent(input$updateButton, {
    values$age <- as.numeric(input$age)
    values$value  <- as.numeric(input$value)
    values$name <- input$name
    values$ID <- input$ID
    output$Plot <- renderPlot(plotInput())
    savedValues[[as.character(input$testType)]] <- values$value
  })
  
  observeEvent({input$genderType
               input$testType}, {
                 tableName <- paste0(input$testType, input$genderType)
                 ranges <- rangeTable[[tableName]]
                 if (input$testType == "UAG"){
                   updateSliderInput(session, inputId = "value", 
                                     min = ranges[length(ranges)], 
                                     max = ranges[1], 
                                     value = ranges[length(ranges)] + diff(range(ranges))/2)
                 } else {
                   updateSliderInput(session, inputId = "value", 
                                     min = ranges[1], 
                                     max = ranges[length(ranges)], 
                                     value = ranges[1] + diff(range(ranges))/2)
                 }
               })

  
  observeEvent(input$clearButton, {
    output$Plot <- renderPlot({
      getBasicPlot(genderType = input$genderType, 
                   testType = input$testType)
      })
    savedValues[[as.character(input$testType)]] <- NA
  })
  
  output$downloadReport <- downloadHandler(
    filename = function() {
      if (is.null(input$ID) | is.null(input$name)) {
        return("blankPlot.pdf")
      } else {
        return(paste("ID_", input$ID,"_Name_", input$name, ".pdf", sep=""))
      }
    },
    content = function(file) {
      # Copy the report file to a temporary directory before processing it, in
      # case we don't have write permissions to the current working dir (which
      # can happen when deployed).
      tempReport <- file.path(tempdir(), "report.Rmd")
      file.copy("report.Rmd", tempReport, overwrite = TRUE)
      
      # Knit the document, passing in the `params` list, and eval it in a
      # child of the global environment (this isolates the code in the document
      # from the code in this app).
      # Set up parameters to pass to Rmd document
      rmarkdown::render(tempReport, 
                        output_format = "pdf_document",
                        output_file = file,
                        params = list(testValueList = list(CS = savedValues$CS,
                                                           ARM = savedValues$ARM,
                                                           WALK = savedValues$WALK,
                                                           STEP = savedValues$STEP,
                                                           CHAIRSAR = savedValues$CHAIRSAR,
                                                           BACK = savedValues$BACK,
                                                           UAG = savedValues$UAG),
                                      gender = input$genderType,
                                      name = input$name,
                                      age = input$age,
                                      ID = input$ID)
      )
    },
    contentType = "application/pdf"
  )
  
}

# Run the application 
shinyApp(ui = ui, server = server)

