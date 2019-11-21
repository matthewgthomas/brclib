#' Create lookup table for Lower Layer Super Output Areas to Local Authorities to Counties
#'
#' @param lookup.path Path to the ONS's lookup tables
#' @param lsoa.lad.name Name of the LSOA to LAD lookup table file (https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=name&tags=LUP_LSOA_CCG_LAD)
#' @param lad.county.name Name of the LAD to County lookup table file (https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=name&tags=LUP_LAD_CTY)
#' @importFrom magrittr "%>%"
#' @export
#'
create_lookup_lsoa_lad_county = function(lookup.path = file.path(options("brclib.data_path"), "Lookups, names and codes"),
                                         lsoa.lad.name = "Lower_Layer_Super_Output_Area_2011_to_Clinical_Commissioning_Group_to_Local_Authority_District_April_2018_Lookup_in_England.csv",
                                         lad.county.name = "Local_Authority_District_to_County_December_2018_Lookup_in_England.csv"
                                         ) {
  # England: LSOA to CCG / LAD
  eng_lsoa_ccg_lad = readr::read_csv(file.path(lookup.path, lsoa.lad.name))

  # England: LAD to County
  eng_lad_county = readr::read_csv(file.path(lookup.path, lad.county.name))

  eng_lsoa_ccg_lad %>%
    dplyr::select(LSOA11CD, LSOA11NM, LAD18CD, LAD18NM) %>%
    dplyr::left_join(eng_lad_county %>%
                       dplyr::select(LAD18CD, CTY18CD, CTY18NM),
                     by = "LAD18CD")
}


#' Create lookup table for Middle Layer Super Output Areas to Local Authorities to Counties
#'
#' @param lookup.path Path to the ONS's lookup tables
#' @param msoa.lad.name Name of the MSOA to LAD lookup table file (https://geoportal.statistics.gov.uk/datasets/middle-layer-super-output-area-2011-to-ward-to-lad-december-2018-lookup-in-england-and-wales)
#' @param lad.county.name Name of the LAD to County lookup table file (https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=name&tags=LUP_LAD_CTY)
#' @importFrom magrittr "%>%"
#' @export
#'
create_lookup_msoa_lad_county = function(lookup.path = file.path(options("brclib.data_path"), "Lookups, names and codes"),
                                         msoa.lad.name = "Middle_Layer_Super_Output_Area_2011_to_Ward_to_LAD_December_2018_Lookup_in_England_and_Wales.csv",
                                         lad.county.name = "Local_Authority_District_to_County_December_2018_Lookup_in_England.csv"
) {
  # England: LSOA to CCG / LAD
  eng_msoa_lad = readr::read_csv(file.path(lookup.path, msoa.lad.name))

  # England: LAD to County
  eng_lad_county = readr::read_csv(file.path(lookup.path, lad.county.name))

  eng_msoa_lad %>%
    dplyr::select(MSOA11CD, MSOA11NM, LAD18CD, LAD18NM) %>%
    dplyr::left_join(eng_lad_county %>%
                       dplyr::select(LAD18CD, CTY18CD, CTY18NM),
                     by = "LAD18CD")
}
