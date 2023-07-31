#!/bin/bash
# Optionally add this file to the crontab with "crontab -e"

URL='https://julialang.org/downloads/'

export NEW_VERSION=`curl -s $URL | grep -Eo 'Current stable release:\s*v[0-9]+\.[0-9]+\.[0-9]+' | cut -d 'v' -f 2 | head -n 1`

echo
date
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

# Test that the upload was successful
# (see src/sourcehut-publish.sh for explanation of srht-url.txt)
rm -f Packages.gz # Using -f to avoid warning for non-existing file
wget -nv `cat srht-url.txt`/stable/Packages.gz
diff Packages.gz srht-repo/stable/Packages.gz

