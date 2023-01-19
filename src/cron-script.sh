#!/bin/bash

URL='https://julialang.org/downloads/'

NEW_VERSION=`curl -s $URL | grep -o 'Current stable release: v[0-9]*\.[0-9]*\.[0-9]*' | cut -d 'v' -f 2 | head -n 1`
echo The latest stable version of Julia was determined to be ${NEW_VERSION}

headerfiles=`ls -rt packaging-files/header*.txt`

if [ ! -f "julia-$NEW_VERSION-linux-x86_64.tar.gz" ]; then
    for headerfile in `ls -rt packaging-files/header*.txt`
    do
        echo "DEBJULIAVERSION=$NEW_VERSION-1" | cat $headerfile - /dev/null > juliapt-makefile-customization
        cat juliapt-makefile-customization
        make clean
        make
    done
    ./src/sourcehut-publish.sh
else
    echo "The repository on Sourcehut Pages was determined to be up to date"
fi

