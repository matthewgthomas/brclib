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
#' @param url_ni Boundaries for Northern Ireland (GeoJSON)
#'
#' @importFrom magrittr "%>%"
#' @export
#'
get_LSOAs = function(url_eng_wal = "https://opendata.arcgis.com/datasets/007577eeb8e34c62a1844df090a93128_0.geojson",
                     url_sco = "http://sedsh127.sedsh.gov.uk/Atom_data/ScotGov/ZippedShapefiles/SG_DataZoneBdry_2011.zip",
                     url_ni = "https://cc-p-ni.ckan.io/dataset/678697e1-ae71-41f3-abba-0ef5f3f352c2/resource/80392e82-8bee-42de-a1e3-82d1cbaa983f/download/soa2001.json") {

  # load geojsons
  lsoa_ew  = sf::read_sf(url_eng_wal)
  lsoa_ni  = sf::read_sf(url_ni)

  # download, unzip and load Scotland shapefiles
  httr::GET(url_sco, httr::write_disk(tf <- tempfile(fileext = ".zip")))
  td = tempdir()  # somewhere temporary to stored the unzipped files
  unzipped_files = unzip(tf, exdir = td)  # unzip to the temp folder
  lsoa_sco = sf::read_sf( unzipped_files[grep(pattern = "*.shp$", unzipped_files)] )  # open the file whose extension is .shp

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
