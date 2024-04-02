#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#
library(shiny)
library(ggplot2)
victims_data <- data.frame(
  Nationality = c("Jews", "Poles", "Roma/Sinti", "Soviet POWs", "Others"),
  Deportees = c(1100000, 145000, 23000, 15000, 25000),
  Deaths = c(1000000, 72500, 21000, 15000, 12500)
)
ui <- fluidPage(
  titlePanel("Holocaust Victims at Auschwitz"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("selected_nationality", "Select Nationality/Category:",
                         choices = victims_data$Nationality,
                         selected = victims_data$Nationality)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Graph", plotOutput("victimsGraph")),
        tabPanel("Table", tableOutput("victimsTable")) # Using tableOutput
      )
    )
  )
)
server <- function(input, output) {
  filtered_data <- reactive({
    victims_data[victims_data$Nationality %in% input$selected_nationality, ]
  })
  output$victimsGraph <- renderPlot({
    ggplot(filtered_data(), aes(x = Nationality, y = Deaths, fill = Nationality)) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      labs(y = "Number of Deaths", x = "Nationality/Category", title = "Number of Holocaust Victims by Nationality/Category")
  })
  output$victimsTable <- renderTable({
    filtered_data()
  })
}
shinyApp(ui = ui, server = server)

