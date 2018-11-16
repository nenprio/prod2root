#!/usr/bin/tcsh

set path = (  $path /etc /usr/sbin .)
packman calib
packman kid
setup -e emc development
setup -e tls development
setup -e ecl development
setup -e trk development
setup -e trg development
gmake

set ROOTCONFIG = 'root-config '
set ROOTLIBS   = `$ROOTCONFIG --libs`

setenv MYLIBS "$ROOTLIBS -lm -lC -Wl,-bloadmap:map.txt"
rm -rf ../exe/sample.exe

echo "Building ..."
