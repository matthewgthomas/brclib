#' Get a list of British Red Cross colour hex codes
#'
#' These colours are from the Website and SEO guidelines.
#'
#' @export
#'
get_brc_colours = function() {
  list(
    red = "#D0021B",
    red_dark = "#AD1220",
    red_light = "#CC434F",

    black = "#262626",
    grey = "#5C747A",
    grey_light = "#9CAAAE",

    green = "#40A22A",
    green_dark = "#05853A",
    green_light = "#44A46C",

    blue = "#193351",
    blue_light = "#475C74",

    teal = "#2B7586",
    teal_light = "#6A9EAA"
  )
}

#' Get a list of NHS colour hex codes
#' source: https://www.england.nhs.uk/nhsidentity/identity-guidelines/colours/
#'
#' @export
#'
get_nhs_colours = function() {
  list(
    # Level 1: NHS blues
    blue = "#005EB8",
    blue_bright = "#0072CE",
    blue_dark = "#003087",
    blue_light = "#41B6E6",
    blue_aqua = "#00A9CE",

    # Level 2: NHS neutrals
    black = "#231f20",
    grey_dark = "#425563",
    grey_mid = "#768692",
    grey_pale = "#E8EDEE",

    # Level 3: NHS support greens
    green = "#009639",
    green_light = "#78BE20",
    green_dark = "#006747",
    green_aqua = "#00A499",

    # Level 4: NHS highlights
    purple = "#330072",
    pink = "#AE2573",
    pink_dark = "#7C2855",

    red_dark = "#8A1538",
    red_emergency = "#DA291C",

    orange = "#ED8B00",
    yellow = "#FAE100",
    yellow_warm = "#FFB81C",
    yellow_ambulance = "#f1dd38"  # hex code from: https://www.ralcolorchart.com/ral-classic/ral-1016-sulfur-yellow
  )
}
