library(shiny)
shinyUI(pageWithSidebar(
  headerPanel("Subset data before analyzing"),
  sidebarPanel(),
  mainPanel(uiOutput("Panels"))
))
