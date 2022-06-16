#!/bin/bash

# Raycast Script Command Template
#
# Duplicate this file and remove ".template." from the filename to get started.
# See full documentation here: https://github.com/raycast/script-commands
#
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title k3d start
# @raycast.mode compact

# Optional parameters:
# @raycast.argument1 { "type": "text", "placeholder": "cluster name"}
# @raycast.icon ⏯
# @raycast.packageName k3d

k3d cluster start $1
