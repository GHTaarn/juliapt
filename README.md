# Juliapt

This code generates .deb files that contain [Julia](https://julialang.org)
which can easily be installed on Debian based Linux distributions like Ubuntu,
Pop OS etc and of course Debian itself!

The .deb file is based on a tarball downloaded from https://julialang.org which
is self contained.

For many people, installing a .deb file is preferable to manual download and
installation because the installation, uninstallation and upgrade process
becomes similar to other software running on the computer.

If you do not wish to generate the .deb file yourself, but rather download
a pre-generated .deb file, then visit https://taarn.srht.site/juliafromtar/README.html

## Features

 - Minimalistic code that is easy to understand and use
 - Based on the official .tar.gz file provided at julialang.org (downloads it automatically)
 - Produces a .deb file that:
   - is easily installed and uninstalled on Debian based systems
   - has a full command line version of any chosen version of Julia
   - creates a Julia launcher in the desktop menu
   - provides correctly installed man pages for Julia

## Requirements

A computer running Linux with Debian package management installed and internet access.
A user with sudo permission.
The packages: make, fakeroot, sed, gzip, gpg, wget, git.
They can be installed with the command:

```
sudo apt install make fakeroot sed gzip gpg wget git
```

## Usage

If you want x86_64 architecture and are satisfied with `juliapt`s default
version of Julia (usually the latest stable version) then you can just execute:

```
git clone https://github.com/GHTaarn/juliapt
cd juliapt
make
make install
```

This will download Julia from julialang.org, create a .deb file from it and
install it. This should be run as a normal user, the last command will prompt
for a sudo password.

The .deb file can of course be installed with the `dpkg` command instead of
`make install`, which is useful if you want to install it on another computer
than the one that you built it on.


### Other architectures and Julia versions

If you want a non default architecture or Julia version, then before running
`make` you will need to create the configuration file
`juliapt-makefile-customization` and edit it, e.g.:

```
git clone https://github.com/GHTaarn/juliapt
cd juliapt
head -7 Makefile > juliapt-makefile-customization
nano juliapt-makefile-customization
make
make install
```

You can also generate .deb files for architectures different from the one that
you are on,
as long as you do not try to install them locally.

## Feedback

Thank you for your interest in this project. If you have successfully installed
Julia with juliapt, it would be much appreciated if you would make a post
about it at https://github.com/GHTaarn/juliapt/discussions mentioning which
Linux distribution, architecture and versions of Julia you used.

If you have issues related to the packaging, please report them at
https://github.com/GHTaarn/juliapt/issues

Please direct issues related to the Julia language itself to either
https://discourse.julialang.org or https://github.com/JuliaLang/julia/issues

