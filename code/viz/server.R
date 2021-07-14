#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(pals)

# get functions
source("functions.R")
# get data
data_to_plot <- read.csv("data_to_plot_short.csv", 
                         colClasses = c(data_version = "Date", "date" = "Date"))
# the names of the models
models <- unique(data_to_plot$model)
# colour palette for plotting:
cols <- glasbey(length(models) + 1)[-1]
names(cols) <- models

# Define server logic
shinyServer(function(input, output, session) {

    # observer for pressing the forward button
    observeEvent(input$forward, {
        # if forward button is clicked update the date input (given that new date is not in the future):
        if((input$select_data_version + 1) <= Sys.Date()){
            updateDateInput(session, inputId = "select_data_version", value = input$select_data_version + 1)
        }
    })
    
    # observer for pressing the back button
    observeEvent(input$back, {
        updateDateInput(session, inputId = "select_data_version", value = input$select_data_version - 1)
    })
    
    # define a UI element to select the models (embedded in the UI file)
    # This will contain one checkbox for each model from the data set
    output$select_models <- renderUI(
        checkboxGroupInput("select_models", "Select models:", choices = models, selected = models)
    )
    
    # generate plot:
    output$plot_R <- renderPlot({

        # create empty plot:
        plot(NULL,
             x = as.Date("2021-01-01"), y = -1,
             c(as.Date("2021-01-01"), Sys.Date() + 28), ylim = c(0, 2),
             xlab = "date (as in provided file, may actually refer to longer period)",
             ylab = expression(R[t]))
        
        # add selected models
        for(mod in input$select_models){
            plot_R(data_to_plot, mod, input$select_data_version, interval = input$show_interval,
                   add = TRUE, col = cols[mod])
        }

        # vertical line at current date:
        abline(v = input$select_data_version, lty = "dashed")
        # horizontal line at R_t = 1
        abline(h = 1, lty = "dotted")
        
        # legend:
        legend("topright",
               legend = models,
               col = cols,
               lty = 1, bty = "n")
    })

})
