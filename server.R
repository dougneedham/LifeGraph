# This is the server component of my Shiny app that displays a LifeGraph

# Doug Needham
# https://www.linkedin.com/in/dougneedham
# June 2015
library(shiny)
library(igraph)
library(stringr)
get_color <- function(index) {
  color_list <- colors()
  color_string <- color_list[index]
  return(color_string)
}
dup_fun <- function (x) { c(x,x) }

shinyServer(function(input, output,session) {
  output$myPlot <- renderPlot({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    Life.Graph_input <- read.csv(inFile$datapath, header=input$header, sep=input$sep, 
                      quote=input$quote)
    Life.Graph <- graph.data.frame(Life.Graph_input,directed=TRUE)
    Life.Graph$Origin <- str_trim(Life.Graph$Origin)
    Life.Graph$Objective <- str_trim(Life.Graph$Objective)
    Life.Graph$Why <- str_trim(Life.Graph$Why)
    Life.Graph$Day <- str_trim(Life.Graph$Day)
    why_list <- as.data.frame(unique(sort(Life.Graph_input$Why)))
    options <- c()
    for (index in why_list[,1]) { options = c(options,c(index,index))}
    updateSelectInput(session, 'thread', choices = options)    

    day_list <- as.data.frame(unique(sort(Life.Graph_input$Day)))
    options <- c()
    for (index in day_list[,1]) { options = c(options,c(index,index))}
    updateSelectInput(session, 'Day', choices = options)    
    
    col_levels <- levels(Life.Graph_input$Origin)
    V(Life.Graph)$size       <- degree(Life.Graph)*2
    V(Life.Graph)$label.cex  <- 1
    V(Life.Graph)$label.dist <- 1
    V(Life.Graph)$color      <- get_color(which(col_levels %in% Life.Graph_input[V(Life.Graph),2]))
    par(mar=rep(0,4))
   
    plot.igraph(Life.Graph,layout=layout.kamada.kawai(Life.Graph))
  })
  output$ThreadPlot <- renderPlot({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    Life.Graph_input <- read.csv(inFile$datapath, header=input$header, sep=input$sep, 
                      quote=input$quote)
    Life.Graph_input$Why <- str_trim(Life.Graph_input$Why)    
    
    point_of_origin = 0
    Life.Graph <- graph.data.frame(Life.Graph_input[Life.Graph_input$Why==input$thread,],directed=TRUE) 
    Life.Graph$Origin <- str_trim(Life.Graph$Origin)
    Life.Graph$Objective <- str_trim(Life.Graph$Objective)
    Life.Graph$Why <- str_trim(Life.Graph$Why)
    Life.Graph$Day <- str_trim(Life.Graph$Day)
    V(Life.Graph)$size       <- degree(Life.Graph)*1.5
    V(Life.Graph)$color      <- "green"
    V(Life.Graph)$label.cex  <- 1
    V(Life.Graph)$label.dist <- 1
    E(Life.Graph)$color      <- "black"
    plot.igraph(Life.Graph,layout=layout.fruchterman.reingold(Life.Graph))
    
  })
  output$DayPlot <- renderPlot({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    Life.Graph_input <- read.csv(inFile$datapath, header=input$header, sep=input$sep, 
                                 quote=input$quote)
    Life.Graph_input$Day <- str_trim(Life.Graph_input$Day)

    point_of_origin = 0
    Life.Graph <- graph.data.frame(Life.Graph_input[Life.Graph_input$Day==input$Day,],directed=TRUE) 
    Life.Graph$Origin <- str_trim(Life.Graph$Origin)
    Life.Graph$Objective <- str_trim(Life.Graph$Objective)
    Life.Graph$Why <- str_trim(Life.Graph$Why)
    Life.Graph$Day <- str_trim(Life.Graph$Day)
    V(Life.Graph)$size       <- degree(Life.Graph)*1.2
    V(Life.Graph)$color      <- "green"
    V(Life.Graph)$label.cex  <- 1
    V(Life.Graph)$label.dist <- 1
    E(Life.Graph)$color      <- "black"
    plot.igraph(Life.Graph,layout=layout.fruchterman.reingold(Life.Graph))
    
  })
})
