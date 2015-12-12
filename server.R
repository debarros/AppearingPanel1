library(shiny)
source("tabsetPanel2.R")

#This is the data
d1 = data.frame(
  Student = c("Abe","Bill","Clare","Abe","Bill","Clare"),
  Class = c("ELA","ELA","ELA","Math","Math","Math"),
  Grade = c(71,72,73,74,75,76))

shinyServer(function(input, output) {  
  
  ##### Create the Widgets and Persistent Data Objects #####
  
  #Create a checkbox that determines whether to show the first tab of the tabsetPanel
  output$startbox = renderUI({checkboxInput(inputId = "getstarted",label = "Get started?")})
  
  #This pulls a list of unique names from the Student column of the data and creates a checklist
  output$StudentCheckList <- renderUI({
    if(is.null(d1)){return ()
    } else tagList(checkboxGroupInput(inputId = "SelectedStudents", 
                                      label = "Which students you like to select?", 
                                      choices = unique(as.character(d1$Student)),
                                      selected = selectedstudents()))
  })
  
  #This holds which students were selected so that selections persist when the widget is rebuilt
  selectedstudents = reactive({input$SelectedStudents})
  
  #This pulls a list of unique names from the Class column of the data and creates a checklist
  output$ClassCheckList <- renderUI({
    if(is.null(d1)){return ()
    } else checkboxGroupInput(inputId = "SelectedClasses", 
                              label = "Which classes would you like to select?", 
                              choices = unique(as.character(d1$Class)),
                              selected = selectedclasses())
  })
  
  #This holds which classes were selected so that selections persist when the widget is rebuilt
  selectedclasses = reactive({input$SelectedClasses})
  
  # This generates the table of data subsetted by the checklist selections
  output$Summary = renderTable({
    if(is.null(d1)){return ()
    } else {
      d3 = d1[which(as.character(d1$Student) %in% input$SelectedStudents),]
      d3 = d3[which(as.character(d3$Class) %in% input$SelectedClasses),]
      return(d3)}
  })
  
  
  ##### Create the Panel Structure #####
  
  #Define the individual panels  
  p1 = reactive({if(is.null(input$getstarted)){return(NULL)
  }else if(input$getstarted){tabPanel(title = "Pick Students",uiOutput("StudentCheckList"), value = "first")
  }else return(NULL)})
  
  p2 = reactive({if (length(input$SelectedStudents)==0){return(NULL)
  } else tabPanel(title = "Pick Classes",uiOutput("ClassCheckList"), value = "second")})
  
  p3 = reactive({if (length(input$SelectedClasses)==0){return(NULL)
  } else tabPanel(title = "Summary",tableOutput("Summary"), value = "third")})
  
  #This holds which tab is selected so that the right tab shows up when the widget is rebuilt
  selectedtab = reactive({
    if(is.null(input$panelset)){"first"
    } else input$panelset})
  
  #This holds the entire tabsetPanel
  output$panels = renderUI({tabsetPanel2(p1(),p2(),p3(), id="panelset", selected = selectedtab())})
  
}) #end of shinyServer