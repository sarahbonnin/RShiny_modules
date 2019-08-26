# Module to download plot into file
  # Choose format, name, width and height.
  # default plot name is Sys.Date()_plot.png

# need to install orca command-line utility

plotDownloadUI <- function(id, height = 400) {
  ns <- NS(id)
  fluidPage(
    fluidRow(
      column(3,
             # file format (default png)
             selectInput(ns("fileFormat"), "Format", c("png"="png", "jpeg"="jpeg", "tiff"="tiff", "bmp"="bmp", "svg"="svg", "pdf"="pdf"),
                         selected = "png")
      ),
      column(2,
             # width and height (default for both: 7 inches)
             numericInput(ns("fileWidth"), "File width (inches)", value=7, min=4, max=30),
             numericInput(ns("fileHeight"), "File Height (inches)", value=7, min=4, max=30)
      ),
      column(3,
             # file name (replaces the default "plot" but keeps the time stamp)
             textInput(ns("fileName"), label="Name", value="plot")
      ),
      column(4, 
             # displays in UI the file name according to options
             uiOutput(ns("choice")),
             # button to download file with name and sizes chosen (with ggsave)
             downloadButton(ns("download_plot"), "Save figure to file")
      )
    )
  )
}

plotDownload <- function(input, output, session, plotFun) {
  # retrieve user-chosen input, respectively format, name, width and height
  plotFormat <- reactive({input$fileFormat})
  plotName <- reactive({input$fileName})
  plotWidth <- reactive({input$fileWidth})
  plotHeight <- reactive({input$fileHeight})
  
  output$download_plot <- downloadHandler(
    filename = function() {
      # file name (Sys.Date() is always kept as the first string in the file name)
      paste(Sys.Date(), "_", plotName(), ".", plotFormat(), sep="")
    },
    content = function(file) {
      # save plot
      #ggsave(file, plotFun(), device=plotFormat(), 
      #       units="in", width=plotWidth(), height=plotHeight())
      orca(plotFun(), file="test")
    }
  )
  # display in UI the file nam, combining user-chosen parameters
  output$choice <- renderUI({
    paste("File Name:", paste(Sys.Date(), "_", plotName(), ".", plotFormat(), sep=""))
  })
}

