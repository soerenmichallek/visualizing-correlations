
library(faux)
library(jtools)
library(shiny)
library(shinydashboard)
library(tidyverse)

# Define UI for application that draws a histogram

# Creating sidebar items
sidebar <- dashboardSidebar(
        sidebarMenu(
            menuItem("Correlation Strength", tabName = "correlation"),
            menuItem("Cohen's d", tabName = "cohens_d")
        )
    )

# Creating actual page content
body <- dashboardBody(
    tabItems(
     tabItem(tabName = "correlation",
        fluidRow(
             box(title = "Correlation Strength",
                align = "center",
                plotOutput("cor_plot"), # Show a plot of the generated distribution
                sliderInput("r", # Create a slider which allows the user to select a desired correlation strength (r)
                    "Correlation size (r)",
                    min = -.99,
                    max = .99,
                    value = 0,
                    step = .01)
                ),
        p("This shinyR application allows you to visualize correlations of different strengths."),
        p("You can set the r of the correlation by moving the slider."),
        p("The application will then generate 100 observations each for"),
        p("two standard normal distributed variables x and y and plot a scatterplot showing their relationship.")
            )
        ),
    tabItem(tabName = "cohens_d",
        h2("work in progress")
        )
    ) 
)
            
# Merging individual dashboard ui elements together
ui <- dashboardPage(skin = "yellow",
        dashboardHeader(title = "Visualizing Stats"),
        sidebar,
        body,
        tags$head(tags$style(HTML("* { font-family: Calibri; }")))
        )

# Define server logic for the plot
server <- function(input, output) {

    output$cor_plot <- renderPlot({
        # generate dataframe with two variables which are correlated to the r which the user specifies
        df <- rnorm_multi(100, 2, 0, 1, r = input$r, varnames = c("x", "y")) 
        
        # plot the relationship between the generated variables
        ggplot(df, aes(x, y)) +
            geom_point() +
            theme_apa() +
            xlim(-4, 4) +
            ylim(-4, 4)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
