
# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

  ################## HEATMAP REACTIVE DATA #######################

  reactheatmap=reactive({
    data %>%
      filter(tag %in% input$type )%>%
      filter(County %in% input$typeA )
  })

  ################## DRAWS INITIAL HEATMAP #######################
  output$heatmap=renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    leaflet() %>% addTiles(group = "OSM") %>% addProviderTiles(providers$Esri.WorldImagery, group = "Esri World Imagery")%>% addProviderTiles(providers$Esri.NatGeoWorldMap,group = "NatGeoWorldMap") %>%addProviderTiles(providers$Stamen.TonerLite,group = "TonerLite")%>% addProviderTiles(providers$CartoDB.DarkMatter) %>% addLayersControl(baseGroups  = c("OSM", "Esri World Imagery","NatGeoWorldMap","TonerLite","TonerLitedark"),overlayGroups = c("SESYNC")) %>%
      setView(15.2551,54.5260,zoom=4)

   # setView(41.1533, 20.1683,zoom=11)

  })
  observe({
    proxy=leafletProxy("heatmap", data = reactheatmap) %>%
      removeWebGLHeatmap(layerId='a') %>%
      addWebGLHeatmap(layerId='a',data=reactheatmap(),
                      lng=~Longitude, lat=~Latitude,
                      size=24000)
  })

  ################## MAP REACTIVE DATA #######################

  reactmap=reactive({
    data %>%
      filter(tag %in% input$type1 )%>%
      filter(County %in% input$typeB )

  })

  ################## DRAWS INITIAL REGULAR MAP #######################
   output$map=renderLeaflet({
    leaflet() %>% addTiles(group = "OSM") %>% addProviderTiles(providers$Esri.WorldImagery, group = "Esri World Imagery")%>% addProviderTiles(providers$Esri.NatGeoWorldMap,group = "NatGeoWorldMap") %>%addProviderTiles(providers$Stamen.TonerLite,group = "TonerLite")%>% addProviderTiles(providers$CartoDB.DarkMatter) %>% addLayersControl(baseGroups  = c("OSM", "Esri World Imagery","NatGeoWorldMap","TonerLite","TonerLitedark"),overlayGroups = c("SESYNC"))  %>%
      addProviderTiles(providers$Esri.WorldStreetMap) %>%

      setView( 15.2551,54.5260,zoom=4)
  })
  observe({
    proxy=leafletProxy("map", data=reactmap()) %>%
      clearMarkers() %>%
      clearMarkerClusters() %>%
      addCircleMarkers(clusterOptions=markerClusterOptions(),
                       lng=~Longitude, lat=~Latitude,radius=5, group='Cluster',
                       popup=~paste('<b><font color="Blue">','Policy Information','</font></b><br/>',
                                    'Type:', tag,'<br/>',
                                    'Tag Info:', tags,'<br/>')

 )
  })

  ################## CLUSTER MAP #######################

  reactmap1=reactive({
    data %>%
      filter(tag %in% input$type2 )

  })

  ################## DRAWS INITIAL ClusterMap #######################

  output$clustermap=renderLeaflet({
    leaflet() %>% addTiles(group = "OSM") %>% addProviderTiles(providers$Esri.WorldImagery, group = "Esri World Imagery")%>% addProviderTiles(providers$Esri.NatGeoWorldMap,group = "NatGeoWorldMap") %>%addProviderTiles(providers$Stamen.TonerLite,group = "TonerLite")%>% addProviderTiles(providers$CartoDB.DarkMatter) %>% addLayersControl(baseGroups  = c("OSM", "Esri World Imagery","NatGeoWorldMap","TonerLite","TonerLitedark"),overlayGroups = c("SESYNC"))  %>%
      addProviderTiles(providers$Esri.WorldStreetMap) %>%

      setView( 15.2551,54.5260,zoom=4)
  })
  observe({
    proxy=leafletProxy("map", data=reactmap1()) %>%
      clearMarkers() %>%
      clearMarkerClusters() %>%
      addCircleMarkers(
        lng=~Longitude, lat=~Latitude,radius=5, group='Cluster',
        popup=~paste('<b><font color="Black">','Policy Information','</font></b><br/>',
                     'Type:', tag,'<br/>')

      )
  })

  # Fill in the spot we created for a plot
  output$Plot <- renderPlot({

    # Render a barplot
    barplot(table(data$tag),
            main=input$region,
            ylab="Total Number",
            xlab="Power Type",col=c("red","darkblue","yellow"),legend = rownames(table(data$tag)),beside=TRUE)

  })


  ################## DATA TABLE #######################
  output$table <- DT::renderDataTable({
    datatable(data, rownames=FALSE) %>%
      formatStyle(input$selected,  #this is the only place that requires input from the UI. so
                  #here we are highlighting only the column that the user selected
                  background="skyblue", fontWeight='bold')
    # Highlight selected column using formatStyle
  })

})

