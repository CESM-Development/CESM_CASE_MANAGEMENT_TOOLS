#!/usr/bin/env python3
import xarray as xr
import itertools
from datetime import datetime
import os

def process_files(start_year, end_year ):
    """Process CRUNCEP files for a series of years and replace valid values with Trendy data."""

    # Process each year
    for year in range(start_year, end_year + 1):

        # Process each month
        #output_prefix = "clmforc.TRENDY_qianFilled.c2017.0.5d.Prec.YYYY-MM.nc"
        #output_prefix = "clmforc.TRENDY_qianFilled.c2017.0.5d.Solr.YYYY-MM.nc"
        output_prefix = "clmforc.TRENDY_qianFilled.c2017.0.5d.TPQWL.YYYY-MM.nc"
        for month in range(1, 13):  # Months from 1 to 12
            print_file = f"{output_prefix.replace('YYYY', str(year)).replace('MM', f'{month:02d}') }"
            print(f"{print_file}")


def main():
    # Hardcoded paths and prefixes

    # Parameters
    start_year = 1958
    end_year = 2019

    # Call the processing function
    process_files(
        start_year=start_year,
        end_year=end_year,
    )

if __name__ == "__main__":
    main()

