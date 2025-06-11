#!/usr/bin/env python3
import xarray as xr
import itertools
from datetime import datetime
import os

def calculate_running_totals(days_in_month):
    """Calculate the running totals for monthly records."""
    records_per_month = [days * 4 for days in days_in_month]
    running_totals = [0] + list(itertools.accumulate(records_per_month))
    return running_totals

def process_files(path1, prefix_file1, path2, prefix_file2, output_prefix, variables, start_year, end_year, script_name):
    """Process CRUNCEP files for a series of years and replace valid values with Trendy data."""
    # Days in each month (non-leap year)
    days_in_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    # Calculate running totals
    running_totals = calculate_running_totals(days_in_month)

    # Process each year
    for year in range(start_year, end_year + 1):
        trendy_path = f"{path1}/{prefix_file1.replace('YYYY', str(year))}"
        print(f"Processing Trendy file: {trendy_path}")

        # Open File1 (Trendy)
        trendy = xr.open_dataset(trendy_path)

        # Process each month
        for month in range(1, 13):  # Months from 1 to 12
            #cruncep_file = f"{path2}/{prefix_file2.replace('YYYY', str(year)).replace('MM', f'{month:02d}') }"
            # use 2016 as template for 2017-2020 because we don't have those years for CRUNCEP
            cruncep_file = f"{path2}/{prefix_file2.replace('MM', f'{month:02d}') }"
            print(f"Processing CRUNCEP file: {cruncep_file}")

            # Open the corresponding File2-YYYY-MM (CRUNCEP)
            cruncep = xr.open_dataset(cruncep_file)

            # Determine the start and end indices for the current month in Trendy
            start_idx = running_totals[month - 1]
            end_idx = running_totals[month]

            # Select the time slice for the current month in Trendy
            trendy_month = trendy.isel(time=slice(start_idx, end_idx))

            # Process each variable
            for var in variables:
                if var in trendy.variables and var in cruncep.variables:
                    # Select the variable data
                    trendy_var = trendy_month[var]
                    cruncep_var = cruncep[var]

                    # Align dimensions if necessary
                    if 'time' in cruncep_var.dims:
                        trendy_var = trendy_var.assign_coords(time=cruncep_var.time)

                    # Replace valid CRUNCEP values with valid Trendy values
                    updated_var = cruncep_var.where(trendy_var.isnull(), trendy_var)

                    # Update the CRUNCEP dataset with the modified variable
                    cruncep[var] = updated_var

            # Add global attributes for history
            today = datetime.now().strftime("%Y%m%d")
            output_file = f"{path1}/{output_prefix.replace('YYYY', str(year)).replace('MM', f'{month:02d}') }"
            cruncep.attrs["history"] = (
                f"File created by nanr@ucar.edu {script_name} on {today}. "
                f"CRUNCEP Input file: {cruncep_file}, TRENDY input file: {trendy_path} "
                "Description: Overwrite the CRUNCEP land values with valid land TRENDY values in order to "
                "force ELM with TRENDY. Missing values in TRENDY are ignored."
                "Missing values over water in Trendy are ignored."
            )

            # Save the updated File2-YYYY-MM back to disk
            cruncep.to_netcdf(output_file)

            print(f"Processed and saved: {output_file}")

def main():
    # Hardcoded paths and prefixes
    path1 = "/pscratch/sd/n/nanr/TRENDY"
    prefix_file1 = "clmforc.TRENDY.c2020.0.5x0.5.Prec.YYYY.nc"
    path2 = "/global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/inputdata/atm/datm7/Precip6Hrly/"
    #prefix_file2 = "clmforc.cruncep.V8.c2017.0.5d.Prec.YYYY-MM.nc"
    prefix_file2 = "clmforc.cruncep.V8.c2017.0.5d.Prec.2016-MM.nc"
    output_prefix = "clmforc.TRENDY_qianFilled.c2017.0.5d.Prec.YYYY-MM.nc"

    # Parameters
    #variables = ["PSRF", "TBOT", "WIND", "QBOT", "FLDS"]
    variables = ["PRECTmms"]
    start_year = 2017
    end_year = 2019

    # Get the script name
    script_name = os.path.basename(__file__)

    # Call the processing function
    process_files(
        path1=path1,
        prefix_file1=prefix_file1,
        path2=path2,
        prefix_file2=prefix_file2,
        output_prefix=output_prefix,
        variables=variables,
        start_year=start_year,
        end_year=end_year,
        script_name=script_name,
    )

if __name__ == "__main__":
    main()

