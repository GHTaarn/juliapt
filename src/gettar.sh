#!/bin/sh
# Downloads the Julia tar for Linux from julialang.org and verifies it with
# its GPG signature.
#
# Usage:
#   gettar.bash [Julia version] [architecture]
#
# Default Julia version is the latest stable release,
# default architecture is the output of the arch command

if [ $# -ge 1 ]
then
	JULIA_VERSION=$1
else
	JULIA_VERSION="$(curl -fsSL https://julialang.org/downloads | grep -oP 'Current stable release: v.{0,8}' | sed -n '{s/^.*release: v//; s/[[:space:]].*//p}')"
	echo Assuming Julia version $JULIA_VERSION as it is the latest stable version found on julialang.org
fi
TRUNCATED_JULIA_VERSION=$(echo $JULIA_VERSION | sed -n '{s/[.][0-9]*$//p}')



if [ $# -ge 2 ]
then
	ARCH=$2
else
	ARCH=$(arch)
fi



if [ "$ARCH" = "x86_64" ]
then
	URLSTEM=https://julialang-s3.julialang.org/bin/linux/x64/${TRUNCATED_JULIA_VERSION}
elif [ "$ARCH" = "aarch64" ]
then
	URLSTEM=https://julialang-s3.julialang.org/bin/linux/${ARCH}/${TRUNCATED_JULIA_VERSION}
else
	echo "Architecture $ARCH is not yet implemented"
fi



TARBALL=julia-${JULIA_VERSION}-linux-${ARCH}.tar.gz

#rm ${TARBALL}.asc juliareleases.asc $TARBALL
wget -N ${URLSTEM}/${TARBALL}
wget -N ${URLSTEM}/${TARBALL}.asc
wget -N https://julialang.org/assets/juliareleases.asc

gpg --import juliareleases.asc
if gpg --verify ${TARBALL}.asc ${TARBALL}
then
	echo Successfully downloaded and verified Julia
else
	echo Downloaded Julia tar ball does NOT match the signature!
	# Rename the tarball so that make does not think that it is okay
	mv $TARBALL unverified-${TARBALL}
	exit 1
fi

