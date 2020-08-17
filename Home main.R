library(shiny)
library(leaflet)
library(dplyr)
library(tidyr)
library(RColorBrewer)
library(DT)
library(tidyverse)

require("RPostgreSQL")
# loads the PostgreSQL driver
pw<- {
  "Saibaba"
}
drv <- dbDriver("PostgreSQL")
# creates a connection to the postgres database
# note that "con" will be used later in each connection to the database
con <- dbConnect(drv, dbname = "ire",
                 host = "localhost", port = 5432,
                 user = "postgres", password = pw)

dbBegin(con)
dbListTables(con)


points <- dbGetQuery(con, "SELECT id,tags, ST_AsText(geom) AS geom from public.nodes")


points$tag <- str_extract(points$tags, "tower|pole|portal|switch|insulator|generator|transformer|substation|generator:method|generator:source")

points$kingdom <- str_extract(points$tags, "tower|pole|portal|switch|insulator|generator|transformer|substation|generator:method|generator:source")
#points <- dbGetQuery(con, "SELECT id,tag, ST_AsText(geom) AS geom from public.nodes")


df <- tidyr::separate(data=points,
                      col=geom,
                      into=c("Longitude","Latitude"),
                      sep=" ",
                      remove=FALSE)

df$Longitude <- stringr::str_replace_all(df$Longitude, "[POINT(]", "")
df$Latitude <- stringr::str_replace_all(df$Latitude, "[)]", "")
df$Latitude <- as.numeric(df$Latitude)
df$Longitude <- as.numeric(df$Longitude)


# Save an object to a file
saveRDS(df, file = "Ireland.rds")

