#!/bin/bash
# -----------------------------------------------------------------------------
# Script Name:  admin-delevation.sh
# Description:  Removes the current logged-in user from the macOS admin group.
#               Intended for use as a post-uninstall script in a dummy .pkg
#               deployed via Workspace ONE UEM to revoke temporary admin rights.
#
# Author:       Brian Irish
# Platform:     macOS
# Requirements: Must run in the context of a macOS device with DEP/MDM enrollment
# Usage:        Workspace ONE > Internal App > Post-Uninstall Script
# -----------------------------------------------------------------------------

loggedInUser=`/usr/bin/stat -f%Su /dev/console`

if [ "$loggedInUser" == "root" ] || [ "$loggedInUser" == "_mbsetupuser" ]; then
  exit 0
fi

# Removes user from admin group (post-uninstall)
dseditgroup -o edit -d "$loggedInUser" -t user admin
