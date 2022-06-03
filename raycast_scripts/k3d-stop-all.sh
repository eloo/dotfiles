#!/bin/bash

# Raycast Script Command Template
#
# Duplicate this file and remove ".template." from the filename to get started.
# See full documentation here: https://github.com/raycast/script-commands
#
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title k3d stop all
# @raycast.mode silent
#
# Optional parameters:
# @raycast.icon ⏹️
# @raycast.packageName k3d
# @raycast.description Stops alls k3d clusters

k3d cluster stop --all
