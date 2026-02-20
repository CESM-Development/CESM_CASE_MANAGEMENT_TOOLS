#!/bin/bash
# Recursively rename NetCDF files by pattern substitution.

# Base directory to search
#BASE_DIR="/pscratch/sd/n/nanr/v21.LR.BSMYLE_xOMIP/v21.LR.BSMYLE_xOMIP.2019-11.001/"
#BASE_DIR="/pscratch/sd/n/nanr/v21.LR.BSMYLE_xOMIP/v21.LR.BSMYLE_xOMIP.2021-11.001/"
#BASE_DIR="/pscratch/sd/n/nanr/v21.LR.BSMYLE_xOMIP/v21.LR.BSMYLE_xOMIP.2020-11.001/"
#BASE_DIR="/pscratch/sd/n/nanr/v21.LR.BSMYLE_xOMIP/v21.LR.BSMYLE_xOMIP.2020-05.001/"
#BASE_DIR="/pscratch/sd/n/nanr/v21.LR.BSMYLE_xOMIP/v21.LR.BSMYLE_xOMIP.2019-05.001/"
#BASE_DIR="/pscratch/sd/n/nanr/v21.LR.BSMYLE_xOMIP/v21.LR.BSMYLE_xOMIP.2020-05.001/run.019"
#BASE_DIR="/pscratch/sd/n/nanr/archive/v21.LR.BSMYLE_xOMIP.2021-11.001/"
#BASE_DIR="/pscratch/sd/n/nanr/archive/v21.LR.BSMYLE_xOMIP.2020-11.001/"
BASE_DIR="/pscratch/sd/n/nanr/archive/v21.LR.BSMYLE_xOMIP.2019-11.001/"

# Old and new name patterns
NEW="v21.LR.BSMYLE_xOMIP"
OLD="v21.LR.BSMYLEsmbb"

# Dry run mode (set to false to actually rename)
DRYRUN=true
DRYRUN=false

echo "Searching for .nc files under: $BASE_DIR"
echo "Replacing: $OLD --> $NEW"
echo

# Find all matching files
find "$BASE_DIR" -type f -name "*.nc" | while read -r file; do
    dirname=$(dirname "$file")
    basename=$(basename "$file")
    if [[ "$basename" == *"$OLD"* ]]; then
        newname="${basename//$OLD/$NEW}"
        oldpath="$dirname/$basename"
        newpath="$dirname/$newname"
        if [ "$DRYRUN" = true ]; then
            echo "Would rename:"
            echo "  $oldpath"
            echo "  --> $newpath"
        else
            mv "$oldpath" "$newpath"
            echo "Renamed: $basename --> $newname"
        fi
    fi
done

