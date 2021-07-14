#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI
shinyUI(fluidPage(

    # App title ----
    titlePanel("Comparison of estimated effective reproductive numbers"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        
        # Sidebar panel for inputs ----
        sidebarPanel(
            
            # Inputs:
            # date selector for data version:
            dateInput(
                inputId = "select_data_version",
                label = "Data version",
                value = as.Date("2021-05-01"),
                min = as.Date("2021-01-01"),
                max = Sys.Date()
            ),
            # buttons to go back and forward:
            actionButton("back", "<"),
            actionButton("forward", ">"),
            # check boxes to select models:
            uiOutput("select_models"),
            # check box to decide if intervals should be shown:
            checkboxInput("show_interval", "Show 95% uncertainty intervals")
        ),
        
        # Main panel for displaying outputs...
        mainPanel(
            
            # Output: Plot
            plotOutput(outputId = "plot_R")
            
        )
    )
))
