#!/bin/bash
# -----------------------------------------------------------------------------
# Script Name:  admin-elevation.sh
# Description:  Adds the current logged-in user to the macOS admin group.
#               Intended for use as a post-install script in a dummy .pkg
#               deployed via Workspace ONE UEM to temporarily grant admin rights.
#
# Author:       Brian Irish
# Platform:     macOS
# Requirements: Must run in the context of a macOS device with DEP/MDM enrollment
# Usage:        Workspace ONE > Internal App > Post-Install Script
# -----------------------------------------------------------------------------

loggedInUser=`/usr/bin/stat -f%Su /dev/console`

if [ "$loggedInUser" == "root" ] || [ "$loggedInUser" == "_mbsetupuser" ]; then
  exit 0
fi

# Adds user to admin group (post-install)
dseditgroup -o edit -a "$loggedInUser" -t user admin
