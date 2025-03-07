#!/bin/bash

find . -type f -name "*.sh" -exec chmod +x {} \;
find . -type f -name "*.desktop" -exec chmod +x {} \;
find . -type f -path "*/bin/*" -exec chmod +x {} \;
