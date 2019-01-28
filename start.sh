#!/usr/bin/env bash

# If not argument is passed to the script, start the GUI
if [ $# -eq 0 ]; then
    echo "Starting GUI"
    python3 scripts/PcieGui.py
else
    # If the argument 'rssi' is passed to the script, load the rssi configuration
    if [ ${arg} == "rssi" ]; then
        config_file="config/pcie_rssi_config.yml"
    # If the argument 'fsbl' is passed to the script, load the fsbl configuration
    elif [ ${arg} == "fsbl" ]; then
        config_file="config/pcie_fsbl_config.yml"
    # Abort if the argument is invalid
    else
        echo "Invalid default configuration"
        exit
    fi

    # Load the configuration file and exit
    echo "Loading default configuration: ${config_file}"
    python3 scripts/PcieLoadConfig.py --yaml ${config_file}
    echo "Done!"
fi
