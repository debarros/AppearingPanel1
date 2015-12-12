library(shiny)
shinyUI(pageWithSidebar(
  headerPanel("Make next panel appear as each one is completed"),
  sidebarPanel(uiOutput("startbox")),
  mainPanel(uiOutput("panels"))
))#end of shinyUI