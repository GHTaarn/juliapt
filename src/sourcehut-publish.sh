# This script generates a Debian formatted repository and uploads it to
# Sourcehut pages. All .deb files in the current directory are included
# in this repository. The script also requires the sourcehut pages key to be
# in the srht-pages-key.txt file.
# The file srht-url.txt should contain the base url of the repository on
# Sourcehut (e.g. create with "echo taarn.srht.site/juliafromtar > srht-url.txt")

# Note that the total size of all published files must be less than 1Gbyte

reponame=srht-repo

rm -r $reponame/stable
mkdir -p $reponame/stable
mv *.deb $reponame/stable
cd $reponame
dpkg-scanpackages --multiversion stable /dev/null | gzip -9c > stable/Packages.gz
cat ../packaging-files/srht-README.html | sed s/JULIAVERSION/${NEW_VERSION}/g > README.html
tar zcvf ../repo.tar.gz stable README.html
cd ..
curl --oauth2-bearer `cat srht-pages-key.txt` \
    -Fcontent=@repo.tar.gz \
    https://pages.sr.ht/publish/`cat srht-url.txt`

