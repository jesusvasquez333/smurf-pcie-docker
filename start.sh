#!/usr/bin/env bash

# If not argument is passed to the script, start the GUI
if [ $# -eq 0 ]; then
    echo "Starting GUI"
    python3 scripts/PcieGui.py
else
    # Verify we are getting only 1 argument
    if [ $# -eq 1 ]; then
        # Read the input argument
        arg=$1
        # If the argument 'program' is passed to the script, invoke the programming script
        if [ ${arg} == "program" ]; then
            echo "Staring programing script..."
            python3 ../firmware/submodules/axi-pcie-core/python/updateKcu1500.py --path ../firmware/targets/SmurfKcu1500RssiOffload10GbE/images/
            echo "Done!"
        else
            # If the argument 'rssi' is passed to the script, select the rssi configuration file
            if [ ${arg} == "rssi" ]; then
                config_file="config/pcie_rssi_config.yml"
            # If the argument 'fsbl' is passed to the script, select the fsbl configuration file
            elif [ ${arg} == "fsbl" ]; then
                config_file="config/pcie_fsbl_config.yml"
            # Abort if the argument is invalid
            else
                echo "Invalid argument. Only 'rssi', 'fsbl' or 'program' are supported."
                exit
            fi

            # Load the configuration file and exit
            echo "Loading default configuration: ${config_file}"
            python3 scripts/PcieLoadConfig.py --yaml ${config_file}
            echo "Done!"
        fi

    else
        echo "Invalid number of arguments"
        exit
    fi
fi
