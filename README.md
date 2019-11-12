# brclib
Personal R package for British Red Cross data science work.

## Installation
To install from this repository:

```r
devtools::install_github("matthewgthomas/brclib")  # make sure you have the devtools library installed first
library(brclib)
```

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
