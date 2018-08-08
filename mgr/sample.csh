#!/bin/csh -f


packman calib 
packman kid
setup -e emc development
setup -e tls development
setup -e ecl development
setup -e trk development
setup -e trg development

setenv YBOS_DEBUGLIB /kloe/soft/off/ybos/production/aix/library

cd ../exe
rm -rf sample.exe
cd ../dict
build_job sample_bj.uic
cd ../ref
mv ../dict/sample_bj.kloe .
offexp sample_bj.kloe
offexp sample.kloe
offexp newt0find.kloe
offexp prod2ntu.kloe
ford -g sample_bj.f
ford -g sample.f
ford -g newt0find.f
ford -g prod2ntu.f

cd ../opt
../mgr/link_ana_private.csh ../exe/sample.exe sample.opt user no

#cd ../ref
#rm -rf *.f
#rm -rf *.o
#rm -rf sample_bj.kloe
#cd ../exe








