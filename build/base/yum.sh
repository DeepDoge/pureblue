#!/bin/bash

# Define the path you want to add
NEW_REPOS_DIR="/usr/local/yum.repos.d"

# Ensure the directory exists
mkdir -p $NEW_REPOS_DIR

# Check if /etc/yum.conf exists
if [ ! -f /etc/yum.conf ]; then
    # Create /etc/yum.conf and add the reposdir option
    echo "[main]" > /etc/yum.conf
    echo "reposdir=/etc/yum.repos.d:$NEW_REPOS_DIR" >> /etc/yum.conf
    echo "Created /etc/yum.conf with the new reposdir."
else
    # Check if the reposdir option is present
    if ! grep -q '^reposdir=' /etc/yum.conf; then
        # Add the reposdir option
        echo "reposdir=/etc/yum.repos.d:$NEW_REPOS_DIR" >> /etc/yum.conf
        echo "Added reposdir to /etc/yum.conf."
    else
        # Check if the new path is already in reposdir
        if ! grep -q "$NEW_REPOS_DIR" /etc/yum.conf; then
            # Modify the existing reposdir to append the new path, without duplicates
            current_reposdir=$(grep '^reposdir=' /etc/yum.conf)
            new_reposdir="${current_reposdir}:$NEW_REPOS_DIR"
            sed -i "s|$current_reposdir|$new_reposdir|" /etc/yum.conf
            echo "Appended the new path to the existing reposdir in /etc/yum.conf."
        else
            echo "The new path is already in the reposdir in /etc/yum.conf."
        fi
    fi
fi
