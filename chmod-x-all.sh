#!/bin/bash

# Find all .sh files recursively from the current directory and make them executable
find . -type f -name "*.sh" -exec chmod +x {} \;

echo "All .sh files have been made executable."