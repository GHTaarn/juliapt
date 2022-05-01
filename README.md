# Julia From Tar

This code generates .deb files that contain [Julia](https://julialang.org)
which can easily be installed on Debian based Linux distributions like Ubuntu,
Pop OS etc and of course Debian itself!

The .deb file is based on a tarball downloaded from https://julialang.org which
is self contained.

For many people, installing a .deb file is preferable to manual download and
installation because the installation, uninstallation and upgrade process
becomes similar to other software running on the computer.

## Usage

If you want x86_64 architecture and are satisfied with `juliafromtar`s default
version of Julia (usually the latest stable version) then you can just execute:

```
git clone https://github.com/GHTaarn/juliafromtar
cd juliafromtar
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
`juliafromtar-makefile-customization` and edit it, e.g.:

```
git clone https://github.com/GHTaarn/juliafromtar
cd juliafromtar
head -7 Makefile > juliafromtar-makefile-customization
nano juliafromtar-makefile-customization
make
make install
```

You can also generate .deb files for architectures different than you are on,
as long as you do not try to install them locally.

# Feedback

Thank you for your interest in this project. If you have successfully installed
Julia with juliafromtar, it would be much appreciated if you would make a post
about it at https://github.com/GHTaarn/juliafromtar/discussions mentioning which
distribution, architecture and versions of Julia and the distribution you used.

If you have issues related to the packaging, please report them at
https://github.com/GHTaarn/juliafromtar/issues

Please direct issues related to the Julia language itself to either
https://discourse.julialang.org or https://github.com/JuliaLang/julia/issues

## Future work

When there is enough positive feedback to make me confident that the quality of
the .deb files is high enough, then I plan to upload the most popular .deb files
to Github so that they can be downloaded directly.

Further into the future, it would be nice to have a repository so that people
can register it in /etc/apt/sources.list and then just install and upgrade with
`apt` [the way Signal has done](https://signal.org/download/linux/). I'm hoping
that someone will donate some serverspace for this purpose in the future.

