# This script generates the necessary repository files
# for the .deb files in $reponame/stable and publishes the repo on
# sourcehut so that this repo can be included in /etc/apt/sources.list

# You should therefore place all .deb files that you wish to publish in
# $reponame/stable before running this script. The script also requires
# the sourcehut pages key to be in the sourcehutpages.txt file.

# Note that the total size of all published files must be less than 1Gbyte

reponame=srht-repo

rm -r $reponame/stable
mkdir -p $reponame/stable
mv *.deb $reponame/stable
cd $reponame
dpkg-scanpackages --multiversion stable /dev/null | gzip -9c > stable/Packages.gz
tar zcvf ../repo.tar.gz stable
cd ..
curl --oauth2-bearer `cat sourcehutpages.txt` \
    -Fcontent=@repo.tar.gz \
    https://pages.sr.ht/publish/taarn.srht.site/juliafromtar

