##
## Functions to fetch and create geographical boundaries:
## - Lower Layer Super Output Areas and devolved nations' equivalents
##

#' Get Lower Layer Super Output Areas and devolved nations' equivalents
#' - LSOA in England and Wales
#' - Data Zones in Scotland
#' - Super Output Areas in Northern Ireland
#'
#' @param url_eng_wal Boundaries for England and Wales (GeoJSON from ONS Geoportal)
#' @param url_sco Boundaries for Scotland (Shapefile)
#' @param url_ni Boundaries for Northern Ireland (Shapefile)
#'
#' @importFrom magrittr "%>%"
#' @export
#'
get_LSOAs = function(url_eng_wal = "https://opendata.arcgis.com/datasets/007577eeb8e34c62a1844df090a93128_0.geojson",
                     url_sco = "http://sedsh127.sedsh.gov.uk/Atom_data/ScotGov/ZippedShapefiles/SG_DataZoneBdry_2011.zip",
                     url_ni = "https://www.nisra.gov.uk/sites/nisra.gov.uk/files/publications/SOA2011_Esri_Shapefile_0.zip") {

  # load geojson for England/Wales
  lsoa_ew  = sf::read_sf(url_eng_wal)

  # download, unzip and load Scotland shapefiles for Scotland and NI
  lsoa_sco = download_shp(url_sco)
  lsoa_ni =  download_shp(url_ni)

  # sanitise variable names
  lsoa_ew =  lsoa_ew  %>% dplyr::select(Code = LSOA11CD, Name = LSOA11NM)
  lsoa_sco = lsoa_sco %>% dplyr::select(Code = DataZone, Name)
  lsoa_ni  = lsoa_ni  %>% dplyr::select(Code = SOA_CODE, Name = SOA_LABEL)

  # make sure they all have the same CRS (WGS84)
  lsoa_ew  = sf::st_transform(lsoa_ew,  crs = 4326)
  lsoa_sco = sf::st_transform(lsoa_sco, crs = 4326)
  lsoa_ni  = sf::st_transform(lsoa_ni,  crs = 4326)

  # stitch into one shapefile and return
  lsoa = rbind(lsoa_ew, lsoa_sco, lsoa_ni)
  lsoa
}

#' Middle-layer super output areas (and devolved nations' equivalents) shapefiles for
#' [England and Wales](https://geoportal.statistics.gov.uk/datasets/middle-layer-super-output-areas-december-2011-boundaries-ew-bsc)
#' [Scotland](https://www.spatialdata.gov.scot/geonetwork/srv/api/records/389787c0-697d-4824-9ca9-9ce8cb79d6f5)
#'  [Northern Ireland](https://www.nisra.gov.uk/publications/super-output-area-boundaries-gis-format)
get_MSOAs = function() {

}

#' Download and load shapefiles from the web
#' - download .zip into a temp file
#' - unzip into a temp folder
#' - open and return as an `sf` object
#'
#' @param url URL to the .zip file containing shapefiles
#' @export
#'
download_shp = function(url) {
  httr::GET(url, httr::write_disk(tf <- tempfile(fileext = ".zip")))  # download .zip file from `url` to a temp file

  td = tempdir()  # somewhere temporary to stored the unzipped files
  unzipped_files = unzip(tf, exdir = td)  # unzip to the temp folder

  shp = sf::read_sf( unzipped_files[grep(pattern = "*.shp$", unzipped_files)] )  # open the file whose extension is .shp

  # get rid of the temp file/folder and return the spatial object
  unlink(tf); unlink(td)
  shp
}
