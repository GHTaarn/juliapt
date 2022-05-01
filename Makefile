PROJNAME=juliafromtar
# Output of the arch command
ARCH=x86_64
# Used in .deb packages
DEBARCH=amd64
DEBJULIAVERSION=1.7.2-1

-include juliafromtar-makefile-customization

JULIAVERSION != echo $(DEBJULIAVERSION) | sed -n 's/-.*//p'
JULIADIR=julia-$(JULIAVERSION)
TARFILE=$(JULIADIR)-linux-$(ARCH).tar.gz
TARGET=$(PROJNAME)_$(DEBJULIAVERSION)_$(DEBARCH).deb

$(TARGET): $(JULIADIR)
	-rm -r debian
	mkdir -p debian/DEBIAN/
	mkdir -p debian/usr/bin/
	mkdir -p debian/usr/share/man/man1/
	mkdir -p debian/usr/share/applications/
	mkdir -p debian/usr/share/doc/$(PROJNAME)/
	mkdir -p debian/opt/$(PROJNAME)/
	echo "Package: $(PROJNAME)" > debian/DEBIAN/control
	echo "Version: $(DEBJULIAVERSION)" >> debian/DEBIAN/control
	echo "Architecture: $(DEBARCH)" >> debian/DEBIAN/control
	cat packaging-files/control-part2.txt >> debian/DEBIAN/control
	cp -a $(JULIADIR) debian/opt/$(PROJNAME)
	gzip --best --keep $(JULIADIR)/share/man/man1/*
	mv $(JULIADIR)/share/man/man1/*.gz debian/usr/share/man/man1/
	cp -a $(JULIADIR)/share/applications/* debian/usr/share/applications/
	ln -s /opt/$(PROJNAME)/$(JULIADIR)/bin/julia debian/usr/bin/
	cp -a $(JULIADIR)/share/doc/* debian/usr/share/doc/
	cp packaging-files/copyright $(JULIADIR)/LICENSE.md debian/usr/share/doc/$(PROJNAME)/
	chmod -R g-w debian
	fakeroot dpkg -b debian
	mv debian.deb $(TARGET)

$(JULIADIR): $(TARFILE)
	-rm -r $(JULIADIR)
	tar zxf $(TARFILE)
	touch $(JULIADIR)

$(TARFILE):
	src/gettar.sh $(JULIAVERSION) $(ARCH)

.PHONY: clean thoroughclean test install uninstall installtest

clean:
	-rm -r debian/ $(TARGET) $(JULIADIR)

thoroughclean:
	-rm *.deb *.tar.gz *.asc
	make clean

test: $(TARGET)
	lintian $(TARGET)

# sudo -k requires that user inputs sudo password so that they are aware that sudo is used
install: $(TARGET)
	sudo -k
	sudo dpkg -i $(TARGET)

uninstall:
	sudo -k
	sudo dpkg -r $(PROJNAME)

installtest:
	make test
	make install
	dpkg -l $(PROJNAME)
	apt show $(PROJNAME)
	which julia
	julia --version
	make uninstall
	-dpkg -l $(PROJNAME)
	-apt show $(PROJNAME)
	-which julia
	-julia --version

