##
## Functions relating to BRC volunteers and staff data
##

#' Clean and process Community Reserve Volunteers data
#'
#' @param vols.dir Path to volunteers data
#' @param vols.file.latest What to call the output file
#'
#' @export
#'
process_CRVs = function(vols.dir = file.path(options("brclib.data_path"), "Volunteers"),
                        vols.file.latest = "CRVs - latest.csv"  # output filename
                        ) {

  # pick the most recent CRV .xlsx file in the Volunteers folder
  # source: https://stackoverflow.com/questions/13762224/how-to-sort-files-list-by-date/13762544
  vols.file.in = file.info(list.files(path = vols.dir, pattern = "*CRV.*xlsx", full.names = T)) %>%
    tibble::rownames_to_column() %>%
    dplyr::mutate(mtime = as.POSIXct(mtime)) %>%
    dplyr::arrange(dplyr::desc(mtime)) %>%
    dplyr::top_n(1, mtime) %>%
    dplyr::select(rowname) %>%
    stringr::str_extract(., "[0-9]+ [A-Za-z\\s]*\\.xlsx")  # keep only the filename

  # extract date from filename to make output filename
  vols.file.out = paste0("CRVs - ", stringr::str_extract(vols.file.in, "[0-9]+"), ".csv")

  # Load CRV data
  vols = readxl::read_excel(file.path(vols.dir, vols.file.in)) %>%
    dplyr::rename(Postcode = postcode) %>%
    dplyr::mutate(Postcode = toupper(Postcode))


  ##
  ## merge in coords for postcodes
  ##
  if (!exists("postcodes")) postcodes = load_postcodes()

  # the ONS data truncates 7-character postcodes to remove spaces (e.g. CM99 1AB --> CM991AB); get rid of all spaces in both datasets to allow merging
  postcodes$Postcode2 = gsub(" ", "", postcodes$Postcode)
  vols$Postcode2 = gsub(" ", "", vols$Postcode)


  ##
  ## look up and save Jersey, Guernsey and Isle of Man postcode coordinates from https://checkmypostcode.uk/
  ##
  # get subset of Channel Islands + IoM postcodes
  channel_new = vols %>%
    select(Postcode2) %>%
    filter(startsWith(Postcode2, "GY") | startsWith(Postcode2, "JE") | startsWith(Postcode2, "IM")) %>%
    distinct()

  # lookup
  channel = lookup_islands_postcodes(channel_new$Postcode2)

  # merge in Channel Island postcodes
  postcodes = postcodes %>%
    dplyr::left_join(channel, by = "Postcode2") %>%
    dplyr::mutate(Longitude = ifelse(Longitude.x == 0, Longitude.y, Longitude.x),
                  Latitude  = ifelse(round(Latitude.x, 0) == 100, Latitude.y, Latitude.x)) %>%
    dplyr::select(-Longitude.x, -Longitude.y, -Latitude.x, -Latitude.y) %>%
    tidyr::replace_na(list(Latitude = 100, Longitude = 0))


  ##
  ## merge all postcodes
  ##
  # merge
  vols = vols %>%
    dplyr::left_join(postcodes, by="Postcode2")

  vols$Postcode2 = NULL  # don't need the truncated column anymore
  vols$Postcode.y = NULL
  vols = dplyr::rename(vols, Postcode = Postcode.x)


  ################################################################
  ## infer probability of gender from name
  ##
  # get year of birth
  # vols$year_of_birth = year(vols$date_of_birth)
  #
  # # get year of joining - round up, but put a ceiling on 2010
  # vols$recruit_rnd = ifelse(vols$`User Registered` < 2010, roundUp(vols$`User Registered`), 2010)
  #
  # # need to rename name column to remove space and remove all non graphical characters
  # # (adapted from https://stackoverflow.com/a/22794831)
  # vols = vols %>%
  #   mutate(vol_name = str_replace_all(`First Name`, "[^[:graph:]]", " "))
  #
  # # calculate gender probabilities
  # tryCatch({
  #   vols_gender = gender_df(vols, name_col="vol_name", year_col=c("year_of_birth", "recruit_rnd"), method="ssa")
  #
  #   # copy genders back into main vols dataframe
  #   vols = vols %>%
  #     left_join(vols_gender, by=c("vol_name" = "name", "year_of_birth" = "year_min", "recruit_rnd" = "year_max"))
  #
  #   # replace NAs with 'Unknown'
  #   vols = vols %>%
  #     mutate(gender = ifelse(is.na(gender), "unknown", gender))
  #
  #   rm(vols_gender)
  # })

  ##
  ## Save
  ##
  vols = vols %>%
    dplyr::select(-`First Name`, -`Last Name`, -`User Email`, -mobile_number, -date_of_birth, -medical_conditions, -emergency_contact_name, -emergency_contact_relationship, -emergency_contact_number)

  dplyr::write_csv(vols, file.path(data.dir, vols.dir, vols.file.out))
  dplyr::write_csv(vols, file.path(data.dir, vols.dir, vols.file.latest))  # save version saying 'latest'

  print("Finished cleaning and processing CRVs")
}
