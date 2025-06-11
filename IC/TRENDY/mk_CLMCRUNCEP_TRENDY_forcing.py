#!/usr/bin/env python3
import xarray as xr
import itertools
from datetime import datetime
import argparse

def calculate_running_totals(days_in_month):
    """Calculate the running totals for monthly records."""
    records_per_month = [days * 4 for days in days_in_month]
    running_totals = [0] + list(itertools.accumulate(records_per_month))
    return running_totals

def process_file(trendy_path, cruncep_template, output_template, variables, days_in_month):
    """Process monthly CRUNCEP files and replace valid values with Trendy data."""
    # Calculate running totals
    running_totals = calculate_running_totals(days_in_month)

    # Open File1 (Trendy)
    trendy = xr.open_dataset(trendy_path)

    # Get today's date
    today = datetime.now().strftime("%Y%m%d")

    # Process each month
    for month in range(1, 13):  # Months from 1 to 12
        # Open the corresponding File2-MM (CRUNCEP)
        cruncep_file = cruncep_template.format(month=month)
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
        output_file = output_template.format(month=month, date=today)
        cruncep.attrs["history"] = (
            f"File created by replace_cruncep_with_trendy.py on {today}. "
            f"Input file: {cruncep_file}, Output file: {output_file}. "
            "Updated CRUNCEP files by replacing valid values with Trendy data. "
            "Missing values in Trendy are ignored."
        )

        # Save the updated File2-MM back to disk
        cruncep.to_netcdf(output_file)

        print(f"Processed and saved: {output_file}")

def main():
    # Command-line argument parsing
    parser = argparse.ArgumentParser(description="Replace CRUNCEP values with Trendy values.")
    parser.add_argument(
        "--trendy",
        required=True,
        help="Path to the Trendy file (file1.nc)",
    )
    parser.add_argument(
        "--cruncep-template",
        required=True,
        help="Template for CRUNCEP files (e.g., file2-{month:02d}.nc)",
    )
    parser.add_argument(
        "--output-template",
        required=True,
        help="Template for output files (e.g., updated_file2-{month:02d}_{date}.nc)",
    )
    parser.add_argument(
        "--variables",
        nargs="+",
        default=["PSRF", "TBOT", "WIND", "QBOT", "FLDS"],
        help="List of variables to process (default: PSRF, TBOT, WIND, QBOT, FLDS)",
    )
    parser.add_argument(
        "--days-in-month",
        nargs=12,
        type=int,
        default=[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
        help="Number of days in each month (default: non-leap year)",
    )

    args = parser.parse_args()

    # Call the processing function
    process_file(
        trendy_path=args.trendy,
        cruncep_template=args.cruncep_template,
        output_template=args.output_template,
        variables=args.variables,
        days_in_month=args.days_in_month,
    )

if __name__ == "__main__":
    main()

