# This script generates a Debian formatted repository and uploads it to
# Sourcehut pages. All .deb files in the current directory are included
# in this repository. The script also requires the sourcehut pages key to be
# in the srht-pages-key.txt file.

# Note that the total size of all published files must be less than 1Gbyte

reponame=srht-repo

rm -r $reponame/stable
mkdir -p $reponame/stable
mv *.deb $reponame/stable
cd $reponame
dpkg-scanpackages --multiversion stable /dev/null | gzip -9c > stable/Packages.gz
tar zcvf ../repo.tar.gz stable
cd ..
curl --oauth2-bearer `cat srht-pages-key.txt` \
    -Fcontent=@repo.tar.gz \
    https://pages.sr.ht/publish/taarn.srht.site/juliafromtar

