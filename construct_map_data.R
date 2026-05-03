# construct map data
library(ggplot2)
library(sf)
library(duckdb)
library(leaflet)


# load flux aux data ------------------------------------------------------
addtl_tbl_fluxes <- tbl(con, "addtl_data") |>
  collect() |> 
  # get flux information
  dplyr::filter(
    variable %in% c("Eddy covariance flux timeseries", "Sap flux timeseries")
  ) |>
  # Create specify networks for fluxes
  # Sites that have Eddy covariance == TRUE & SFN == TRUE ~ SFN
  # Sites that have Eddy covariance == TRUE & SFN == FALSE ~ Other Flux Network
  # Sites that have both
  # Sites that have Eddy covariance == FALSE & SFN == FALSE
  mutate(flux = case_when(variable == "Eddy covariance flux timeseries" & availability == TRUE ~ "EC",
                          variable == "Sap flux timeseries" & network == "SAPFLUXNET" ~ "SFN",
                          .default = NA_character_)) |> 
  group_by(dataset_name) |>
  summarize(
    intermediate = paste(flux, collapse = ","),
    network = case_when(
      intermediate == "SFN,NA" ~ "PSInet + SAPFLUXNET",
      intermediate == "NA,EC" ~ "PSInet + FLUXNET",
      intermediate == "SFN,EC" ~ "PSInet + both",
      TRUE ~ "PSInet"
    ),
    .groups = "drop"
  ) |> 
  select(-intermediate)

# SITE DATA as GEO
study_site <- tbl(con, "study_site") |>
  collect() |> 
  # join with additional network column 
  left_join(addtl_tbl_fluxes) |> 
  # convert to sf object
  sf::st_as_sf(coords = c("longitude_wgs84", "latitude_wgs84"),
               crs = "EPSG:4326") # WGS84 coordinate reference system

save(study_site, file =here(".secrets/study_site.rda"))

# plot points -------------------------------------------------------------

networkPal <- colorFactor(palette = "viridis", study_site$network)

leaflet(study_site) %>%
  leaflet::addTiles() %>% # Add default OpenStreetMap map tiles
  leaflet::addCircleMarkers(
    popup = ~paste0(
      "<b>Name:</b> ", study, "<br>",
      "<b>Study Type:</b> ", study_type,"<br>", 
      "<b>Network:<b> ", network, "<br>"
    ),
    radius = 5,
    opacity = 0.4,
    color = ~networkPal(network)
  ) |> 
  addLegend(pal = networkPal,
            values = ~network, 
            title = "Network", 
            opacity = 0.65)
