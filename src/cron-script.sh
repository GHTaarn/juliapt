#!/bin/bash

# Define the URL for the latest stable version of Julia
URL='https://julialang.org/downloads/'

# Get the latest version number from the website
NEW_VERSION=`curl -s $URL | grep -o 'Current stable release: v[0-9]*\.[0-9]*\.[0-9]*' | cut -d 'v' -f 2 | head -n 1`
echo ${NEW_VERSION}

headerfiles=`ls -rt packaging-files/header*.txt`

# Download the new version if it doesn't exist
if [ ! -f "julia-$NEW_VERSION-linux-x86_64.tar.gz" ]; then
    #for headerfile in "${headerfiles[@]}"
    for headerfile in `ls -rt packaging-files/header*.txt`
    do
        echo "$headerfile"
        echo "DEBJULIAVERSION=$NEW_VERSION-1" | cat $headerfile - /dev/null > juliapt-makefile-customization
        cat juliapt-makefile-customization
        make clean
        make
    done
    ./src/sourcehut-publish.sh
else
    echo "Julia is already downloaded: $NEW_VERSION"
fi

