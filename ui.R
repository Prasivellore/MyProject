library(shiny)
library(shinydashboard)

shinyUI(dashboardPage(skin="green",

                      dashboardHeader(title = "FBD INSURANCE  "),
                      dashboardSidebar(
                        sidebarUserPanel("Dashboard"),
                        sidebarMenu(
                         fileInput(inputId = "filedata", label = "Choose Country",
                                    accept = c(".rds")),
                          menuItem("Heat Map", tabName = "heatmap", icon = icon("fire-extinguisher")),
                          menuItem("Map",tabName = "map",icon = icon("map-pin")),
                         # menuItem("ClusterMap", tabName = "clustermap", icon = icon("hourglass")),
                          menuItem("Plot", tabName = "timeseries", icon = icon("hourglass")),
                          menuItem("Data", tabName = "data", icon = icon("database")))
                      ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css")),

    tabItems(

      tabItem(tabName='clustermap',
              div(class="outer",
                  tags$head(
                    tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}")
                  )),
              leafletOutput("clustermap",width = '100%',height = '100%'),

              absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
                            top = 150, left = "auto", right = 15, bottom = "auto",
                            width = 200, height = "auto",
                            checkboxGroupInput(inputId = "type2", label = h4("Select Product Type"),
                                               choices = choice1, selected = 'pole')
            )),

      tabItem(tabName = "data",
              # datatable
              fluidRow(box(DT::dataTableOutput("table"), width = 12))),
      #changing width to 12 makes it take up whole page

      tabItem(tabName = 'timeseries',
              plotOutput("Plot")
            ),

      tabItem(tabName='heatmap',
              div(class="outer",
              tags$head(
                tags$style(type = "text/css", "#heatmap {height: calc(100vh - 80px) !important;}"
              ))),

                         leafletOutput("heatmap",width = '100%',height = '100%'),


                         absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
                                       top = 150, left = "auto", right = 15, bottom = "auto",
                                       width = 200, height = "auto",

                                       checkboxGroupInput(inputId="type", label=h4("Product Type"),
                                                   choices=choice1, selected='pole'),
                                       checkboxGroupInput(inputId="typeA", label=h4("County"),
                                                          choices=choiceA, selected='pole')
                  )),


      tabItem(tabName='map',
              div(class="outer",
                  tags$head(
                    tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}")
                  )),
                        leafletOutput("map",width = '100%',height = '100%'),

                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
                                      top = 150, left = "auto", right = 15, bottom = "auto",
                                      width = 200, height = "auto",
                                      checkboxGroupInput(inputId = "type1", label = h4("Select Power Type"),
                                                   choices = choice1, selected = 'pole'),
                                      checkboxGroupInput(inputId="typeB", label=h4("County"),
                                                         choices=choiceA, selected='pole')
                                     )


)))))




