library(shiny)
shinyServer(function(input, output) {  
  
  #This is the data
  d1 = data.frame(
    Student = c("Abe","Bill","Clare","Abe","Bill","Clare"),
    Class = c("ELA","ELA","ELA","Math","Math","Math"),
    Grade = c(71,72,73,74,75,76))
  
  # This pulls a list of unique names from the Student column of the data and creates a checklist
  output$StudentCheckList <- renderUI({
    if(is.null(d1)){return ()
    } else tagList(
      checkboxGroupInput(inputId = "SelectedStudents", 
                         label = "Which students you like to select?", 
                         choices = unique(as.character(d1$Student)))
    )
  })
  
  #This pulls a list of unique names from the Class column of the data and creates a checklist
  output$ClassCheckList <- renderUI({
    if(is.null(d1)){return ()
    } else tagList(
      checkboxGroupInput(inputId = "SelectedClasses", 
                         label = "Which classes would you like to select?", 
                         choices = unique(as.character(d1$Class)))
    )
  })
  
  # This generates the table of data subsetted by the checklist selections
  output$Summary = renderTable({
    if(is.null(d1)){return ()
    } else {
      d3 = d1[which(as.character(d1$Student) %in% input$SelectedStudents),]
      d3 = d3[which(as.character(d3$Class) %in% input$SelectedClasses),]
      return(d3)
    }
  })
  
    # These are the definitions for the individual panels
  p1 = reactive(tabPanel("Pick Students",uiOutput("StudentCheckList")))
  p2 = reactive(tabPanel("Pick Classes",uiOutput("ClassCheckList")))
  p3 = reactive(tabPanel("Summary",tableOutput("Summary")))
  
  # This generates the actual panel layout
  output$Panels = renderUI({
    tagList(
      if(is.null(d1)){return()
      } else if (length(input$SelectedStudents)==0){tabsetPanel(p1())
      } else if (length(input$SelectedClasses)==0){tabsetPanel(p1(),p2())
      } else tabsetPanel(p1(),p2(),p3())
      )
  })
})