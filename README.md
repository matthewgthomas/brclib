# brclib
Personal R package for British Red Cross data science work.

## Installation
To install from this repository:

```r
devtools::install_github("matthewgthomas/brclib")  # make sure you have the devtools library installed first
library(brclib)
```

## Functions

- `%**%`: Multiply numbers only if at least one of them isn't zero
- `add_risk_quantiles`: Add risk quantiles to a dataframe for the given column
- `as_pc`: Convert proportions to %s
- `convert_date`: Convert dates if they're in Excel (numeric) format
- `create_lookup_lsoa_lad_county`: Create lookup table for Lower Layer Super Output Areas to Local Authorities to Counties
- `create_lookup_msoa_lad_county`: Create lookup table for Middle Layer Super Output Areas to Local Authorities to Counties
- `download_wales`: Download data from Stats Wales (https://statswales.gov.wales)
- `get_brc_colours`: Get a list of British Red Cross colour hex codes
- `get_nhs_colours`: Get a list of NHS colour hex codes
- `get_LSOAs`: Get Lower Layer Super Output Areas and devolved nations' equivalents in a single spatial dataframe
- `get_month_num`: Convert month name to the month's number
- `lookup_islands_postcodes`: Lookup coordinates for UK postcodes that aren't in the ONS postcode directory (tends to be Guernsey, Jersey and Isle of Man), scraping them from https://checkmypostcode.uk/ where necessary
- `load_postcodes`: Load BRC's bespoke postcode directory **(note the function to create this file hasn't been implemented in the package yet)**
- `postcode_regex`: Regular expression to match postcodes (allowing lowercase and unlimited spaces)
- `process_CRVs`: Clean and process Community Reserve Volunteers data
- `read_excel_entirely`: Load all worksheets in an Excel file into a single dataframe
- `round_up`: Round up to nearest specified number
- `round_up_nice`: Round up to nearest 'nice' number

## Setting the data directory
The package assumes that all relevant data are stored within sub-folders of a base data directory. To see the default data directory, run:

```r
options("brclib.data_path")
```

To change this directory, run:

```r
options("brclib.data_path" = "<PATH TO DATA FOLDER>")
```

The documentation for each function explains where it expects to find data. You can often set custom data directories in the parameters of individual functions.
