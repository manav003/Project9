


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Questionnaire participant responses"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("gender", "Gender", choices = c("Male", "Female", "All"),
                        selected = "All"), 
            checkboxInput("date", "Display only participants who completed the assessment 
                          before August 1, 2017")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("plot"),
           tableOutput("dataset")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    library(shiny)
    library(tidyverse)
    library(ggplot2)

    output$plot <- renderPlot({
        
        tbl <- readRDS("for_shiny.rds")
        
        

        if (input$gender != "All") {
            tbl <- subset(tbl, gender == input$gender)
        }
        
        if (input$date) {
            tbl <- subset(tbl, timeEnd < ymd_hms("2017-08-01 00:00:00"))
        }
        
        ggplot(tbl, aes(x = avg15, y= avg610)) + 
            geom_jitter() +
            labs(x = "Mean scores of Q1 - Q5", y = "Mean scores of Q6 - Q10") +
            geom_smooth(method = "lm", se = FALSE)
    })
    
    output$dataset <- renderTable({
        tbl <- readRDS("for_shiny.rds")
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
