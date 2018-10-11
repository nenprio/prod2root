
#!/bin/csh -f


set os=`uname -s`
set versis=`uname -v`
echo "Compiling for $os ..."
#
if (${os} == "OSF1")then
   set path = ( . $path /sbin)
else if (${os} == "AIX")then
   set path = (  $path /etc /usr/sbin .)
   alias EXPAND  "expaix"
   if (${versis} == 7)then
    alias F77     "/opt/IBM/xlf/15.1.3/bin/xlf -O3 -qhsflt -qextname -c"
    alias F90     "/opt/IBM/xlf/15.1.3/bin/xlf -O3 -qhsflt -qextname -c"
   else if(${versis} == 5)then
    alias F77     "xlf -qarch=604 -O3 -qhsflt -qextname -c"
    alias F90     "xlf -qarch=604 -O3 -qhsflt -qextname -c"
   endif
else if (${os} == "SunOS")then
   echo "setting aliases for the ${os} platform"
   alias EXPAND  "expand -env=sunos-option=FORTRAN-comment=SOURCE"
   alias F77     "f77 -c -O3"
   alias F90     "f90 -c -O3"
else if (${os} == "Linux")then
   alias EXPAND  "${EXPAND_PROGRAMS}/expand -env=linux"
   alias F77     "f77 -c -O3  -w -fno-automatic -finit-local-zero -fdollar-ok -fno-backslash -fno-second-underscore"
   alias F90     "f90 -c -O3"
else
   set path = (  $path /etc /usr/sbin .)
endif
#
packman calib 
packman kid
setup -e emc development
setup -e tls development
setup -e ecl development
setup -e trk development
setup -e trg development

#
#source rootsetup
#echo "Compiling for $ARCH ..."
#echo "ROOTLIBS : $ROOTLIBS"
gmake clean
gmake
#
# C++ software linked with AC KLOE Fortran software
cd ../ref
#rm -rf Fort2C.o
#gmake -f Makefile_sample clean
#gmake -f Makefile_sample
#xlC -O  -L/kloe/soft/onl/root/v5.08/AIX/lib -Wl,-u,.G__cpp_setupG__Hist -Wl,-u,.G__cpp_setupG__Graf1 -Wl,-u,.G__cpp_setupG__G3D -Wl,-u,.G__cpp_setupG__GPad -Wl,-u,.G__cpp_setupG__Tree -Wl,-u,.G__cpp_setupG__Rint -Wl,-u,.G__cpp_setupG__PostScript -Wl,-u,.G__cpp_setupG__Matrix -Wl,-u,.G__cpp_setupG__Physics -Wl,-u,.G__cpp_setupG__Gui1 -lCore -lCint -lHist -lGraf -lGraf3d -lGpad -lTree -lRint -lPostscript -lMatrix -lPhysics -lGui  -lEG -lHtml -c Fort2C.cpp
##este si
#xlC -O -L/kloe/soft/onl/root/v5.08/AIX/lib `root-config --cflags --libs` -c Fort2C.cpp
set ROOTCONFIG = 'root-config '
set ROOTLIBS   = `$ROOTCONFIG --libs`
echo "ROOTLIBS : $ROOTLIBS"

# Set SAMPLE path for sample_talk.cin
# setenv SAMPLE /afs/kloe.infn.it/user/b/berducci/prod2root/ref
setenv SAMPLE ../ref

setenv MYLIBS "$ROOTLIBS -lm -lC -Wl,-bloadmap:map.txt"
echo "MYLIBS : $MYLIBS"

cd ../exe
rm -rf sample.exe
echo "Building ..."
#
cd ../dict
build_job sample_bj.uic
mv sample_bj.kloe ../ref
#
# List of the files to be compiled/linked 
#
#set listf77 = (build_raw2itce raw2itce itcemaker)
# to fix B-field problem with IT HV Scan use local dcdbini
set listf77 = (sample_bj sample newt0find prod2ntu)
set listf90 = ()
#
cd ../ref
 if (${os} == "SunOS")then
    setenv A_C_LIBRARY    /kloe/soft/off/a_c/production/sunos/library/f90
    setenv YBOS_LIBRARY   /kloe/soft/off/ybos/production/sunos/library/f90
    setenv UIPACK_LIBRARY /kloe/soft/off/uipack/production/sunos/library/f90
    setenv A_C_SOURCE     /kloe/soft/off/a_c/production/sunos/source/f90
 endif
#
# expand all the files
#
foreach ifun (${listf77}) 
 EXPAND ${ifun}.kloe
end
foreach ifun (${listf90}) 
 EXPAND ${ifun}.kloe
end
echo " "
echo "         finished to expand the .kloe          "
echo " "
#
 if (${os} == "SunOS")then
    setenv A_C_LIBRARY    /kloe/soft/off/a_c/production/sunos/library
    setenv YBOS_LIBRARY   /kloe/soft/off/ybos/production/sunos/library
    setenv UIPACK_LIBRARY /kloe/soft/off/uipack/production/sunos/library
    setenv A_C_SOURCE     /kloe/soft/off/a_c/production/sunos/source
 endif
#
# Compile f90 files
#
if (${os} == "Linux")then
  foreach ifun (${listf90}) 
    echo "compiling ${ifun}.f in linux"
    vf90 ${ifun}.f
    f90clean ${ifun}.f
    mv _V${ifun}.f ${ifun}.f
    F77 ${ifun}.f
  end
else
  foreach ifun (${listf90}) 
    echo "compiling ${ifun}.f on ${os} with f90"
    F90 ${ifun}.f 
    echo " "
    echo "  compiled the ${ifun}.f "
    echo " "
  end
  foreach ifun (${listf77}) 
    echo "compiling ${ifun}.f on ${os} with f77"
    F77 ${ifun}.f 
    echo " "
    echo "    compiled the ${ifun}.f "
    echo " " 
  end
endif
echo "   ------------------------------------------------------   "
echo "   --------------  compiled all  the .f  ----------------   "
echo "   ------------------------------------------------------   "
#
cd ../opt
../mgr/link_ana_private.csh ../exe/sample.exe sample.opt no no 
cd ../exe
ls -alrt sample.exe
#
# remove unuseful files
#
  foreach ifun (${listf77}) 
#      rm -f ${ifun}.f
#      rm -f ${ifun}.o
  end
#
  foreach ifun (${listf90}) 
#      rm -f ${ifun}.f
#      rm -f ${ifun}.o
  end
#


