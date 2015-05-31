# This is the UI component of my Shiny app that displays a Data Structure Graph
# A Data Structure Graph is a graphical representation of either an ERD (Entity Relationship Diagram) Level 1,
# or a DFD (Data Flow Diagram) Level 2. 
# It could also represent how data flows between multiple organizations.

# Doug Needham
# https://www.linkedin.com/in/dougneedham
# January 2015

library(shiny)

shinyUI(fluidPage(
  titlePanel("Life Graph - What is your Path?"),
  p("A Life Graps a structure to help you visualize your weekly routine. "),
  p("Please feel free to uplad a file to this shiny app. The input requirement is a simple CSV file with three (3) columns"),
  HTML("Column 1 is the <B>Origin</B> where you begin a section of your path? </BR>"),
  HTML("Column 2 is the <B>Objective</B> you are going to on this portion of your path?</BR>"),
  HTML("Column 3 is the <B>Why</B> you are going from one place to another.</BR>"),
  HTML("Column 4 is the <B>Day</B> you underwent the journey.</BR></BR>"),
  HTML("If you have any questions about this application please contact me through my linkedin profile: <a href=\"https://www.linkedin.com/in/dougneedham\" target=\"_blank\">Doug \"The Data Guy\" Needham</a>"),
  br(),
  p("Once you upload this data, you can \"pull a thread\" for an individual Why path, and compare that to the various Day paths."),
  HTML("The columns are required to be labeld <B>Origin,Objective,Why,Day</B>"),
  sidebarLayout(
    sidebarPanel(
      fileInput('file1', 'Choose CSV File',
                accept=c('text/csv', 
                         'text/comma-separated-values,text/plain', 
                         '.csv')),
      tags$hr(),
      checkboxInput('header', 'Header', TRUE),
      radioButtons('sep', 'Separator',
                   c(Comma=',',
                     Semicolon=';',
                     Tab='\t'),
                   ','),
      radioButtons('quote', 'Quote',
                   c(None='',
                     'Double Quote'='"',
                     'Single Quote'="'"),
                   '"'),
    selectInput('thread',"Select Why",choices = NULL),
    selectInput('Day',"Select Day",choices=NULL)
    ),
    mainPanel(
      imageOutput("myPlot", width=800, height=1000),
      imageOutput("ThreadPlot", width=800, height=500),
      imageOutput("DayPlot",width=800,height=500)
    
    )
  )
))
