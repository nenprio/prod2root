#!/bin/csh -f
#  This is a fourth round simulation of LINK_ANA.COM
#
#  Author:  Liz Sexton
#	    Flavia Donno - Modified to implement for KLOE + port to HP
#	                   (nawk is not implemented for HP-UX)
#
#  Parse or prompt for arguments
#  =============================
set prompt = 0
if ("$1" == "") then
   echo -n "What do you want to call your program (include extension)? "
   set exe_name = $<
   set prompt = 1
else
   set exe_name = $1
endif
if ("$2" == "") then
   echo -n "What is the name of your options file (include extension)? "
   set opt_name = $<
   set prompt = 1
else
   set opt_name = $2
endif
#
# Make sure this is an opt file
# =============================
set ok_opt = `echo $opt_name | awk '{ if (index($0,".opt")!=0) print "ok"}'`
if ("$ok_opt" == 'ok') then
#
# If the file exists parse it and place contents in string
# ========================================================
   if ( -e "$opt_name") then
      set string = `awk -F, '$1 !~ /^#/ {for (i=1;i<=NF;i++) print $i}' $opt_name`
      set string = `eval echo "$string"`
   else
      echo "%LINKANA-F-FILE_NOT_FOUND, File $opt_name is empty or missing."
      exit 1
   endif
else
   echo  "%LINKANA-F-UNREC_EXT, $opt_name must have a .opt extension"
   exit 2
endif
#
#
if ( `uname` == 'HP-UX' ) then
   set for = "fort77 +ppu"
   set forl = "-lU77 -lV3 -lm /lib/pa1.1/libm.a"
   set osrel = `uname -r | awk -F. '{print $2}'`
   if ( "$osrel" == "10" ) then
      set for = "fort77 +ppu +U77"
      set forl = "-lV3 -lc -lm -lM"
   endif
   set ospec = ""
   set O2spec = "-O +O2"
   set Gspec = "-G"
else
   set for = f77
   set forl = "-lU77"
   set ospec = ""
   set O2spec = "-O2"
   set Gspec = "-G"
endif
if ( `uname` == 'OSF1' ) then
   set forl = ""
   set ospec = "-Wl,-taso"
   set O2spec = "-fast -O"
   set Gspec = "-pg"
endif
if ( `uname` == 'AIX' && `uname -v` == 5) then
#    set for = "xlf -qcharlen=32767 -qextname"
   set for = "xlf -qarch=604 -O3 -qhsflt -qextname -static -lm -lc -bloadmap:map.txt"
#   set for = "xlf -qcharlen=32767  "
   set forl = "-L/usr/xlmass/lib/aix51 -lmass"
else if( `uname` == 'AIX' && `uname -v` == 7) then
   set for = "/opt/IBM/xlf/15.1.3/bin/xlf -O3 -qhsflt -qextname -static -lm -lc -bloadmap:map.txt"
   set forl = "-L/usr/xlmass/lib/aix51 -lmass"
endif
#
# now we become AIX/IRIX specific:
if ( `uname` == 'AIX' ) then

   #
   # IRIX or HP-UX or OSF1:
   # ======================
   #
   if ("$3" == "") then
      echo -n "Do you want the debugger?[no,user,all,profile,O2,O3] "
      set answer = $<
      set prompt = 1
   else
      set answer = $3
   endif
   set deb_opt = \
   `echo $answer | awk '{ if (index($0,"a")==1) {print "a"} else if (index($0,"u")==1) {print "u"} else if (index($0,"n")==1) {print "n"} else if (index($0,"p")==1) {print "p"} else if (index($0,"3")==2) {print "3"} else {print "2"}}'`
   set anmain_file = anmain.o
#
   if ("$4" == "") then
      echo -n "Do you want to use TMS? [yes,no] "
      set answer = $<
      set prompt = 1
   else
      set answer = $4
   endif
   set tms_opt = \
   `echo $answer | awk '{ if (index($0,"y")==1) {print "y"} else if (index($0,"n")==1) {print "n"}}'` 
#
#   if ($prompt == 1) then
#      echo -n "Do you want to use CPS? [cps,nocps] "
#      if ($< == "cps") set anmain_file = anmain_cps.o
#   else if ("$4" == "cps") then
#      set anmain_file = anmain_cps.o
#   endif
#   if ($?CPSLIB) then
#      set cpslib = "$CPSLIB -lsun"
#   else
      set cpslib = " "
#   endif
   #
   #  End arg. parsing now try to minimize the enviroment for linking
   #  ===============================================================
   source $A_C_DIR/link_unsetup.csh
   if ($?OFFLINE_OPT) then
   #
   #  User has overwriten the default area for the options offline file
   #  =================================================================
      if ( -e "$OFFLINE_OPT") then
         set opt_name = "$OFFLINE_OPT"
      else
         echo "%LINKANA-F-FILE_NOT_FOUND, File $OFFLINE_OPT is empty or missing."
         exit 1
      endif
   else
      #
      #  Use default
      #  ===========
      set opt_name = $OFFLINE_DIR/offline.opt
   endif
   set geabos_lib = $GEABOS_LIBRARY/geabos.olb
#
   if ("$deb_opt" == 'a') then
      set geabos_lib = $GEABOS_DEBUGLIB/geabos.olb
      set pre = ""
      set ext = 'dlb'
      set fstring = "`awk -f $A_C_DIR/link_ana.awk $opt_name`"
      set off_string = `eval echo "$fstring"`
   else if ("$deb_opt" == 'u') then
      set geabos_lib = $GEABOS_LIBRARY/geabos.olb
      set pre = ""
      set ext = 'olb'
      set fstring = "`awk -f $A_C_DIR/link_ana.awk $opt_name`"
      set off_string = `eval echo "$fstring"`
   else if ("$deb_opt" == 'n') then
      set geabos_lib = $GEABOS_LIBRARY/geabos.olb
      set pre = ""
      set ext = 'olb'
      set fstring = "`awk -f $A_C_DIR/link_ana.awk $opt_name`"
      set off_string = `eval echo "$fstring"`
   else if ("$deb_opt" == 'p') then
      set geabos_lib = $GEABOS_LIBRARY/geabos.olb
      set pre = ""
      set ext = 'glb'
      set fstring = "`awk -f $A_C_DIR/link_ana.awk $opt_name`"
      set off_string = `eval echo "$fstring"`
   else if ("$deb_opt" == '2') then
      set pre = 'O2'
      set ext = 'olb'
      set geabos_lib = $GEABOS_LIBRARY/${pre}geabos.olb
      set fstring = "`awk -f $A_C_DIR/link_ana.awk $opt_name`"
      set off_string = `eval echo "$fstring"`
   else if ("$deb_opt" == '3') then
      set pre = ""
      set ext = 'u'
      set geabos_lib = $GEABOS_LIBRARY/geabos.${ext}
      set fstring = "`awk -f $A_C_DIR/link_ana.awk $opt_name`"
      set off_string = `eval echo "$fstring"`
   endif
   #
   #  Handle cern library name change
   #  ===============================
   if ($?CERN_ROOT) then
      setenv cern_mglib $CERN_ROOT/lib/libmathlib
   else
      echo "%LINKANA-F-NOCERN, Some version of cern is need."
   endif
   #
   #  Setup done Link now
   #  ===================
   if ($?MAPFILE) then
   #
   #  A map file has been specified ==> write one
   #  ===========================================
    if ("$tms_opt" == 'y') then
#
      if ("$deb_opt" == 'a') then
         echo 'Linking "all" code with debug option...'
         echo "$for  -g $ospec -Wl,-m $string"'\'
         echo "$A_C_DEBUGLIB/$anmain_file    "'\'
         echo "$off_string                   "'\'
         echo "$A_C_DEBUGLIB/anpack.olb	     "'\'
         echo "$geabos_lib		     "'\'
         echo "$TMS_DEBUGLIB/tms.olb	     "'\'
         echo "$RTDB_DEBUGLIB/rtdb.olb	     "'\'
         echo "$UIPACK_DEBUGLIB/uipack.olb   "'\'
         echo "$YBOS_DEBUGLIB/ybos.olb       "'\'
         echo "$S_I_DEBUGLIB/s_i.olb         "'\'
         echo "$E_L_DEBUGLIB/e_l.olb         "'\'
         echo "$RBIO_LIB                     "'\'
         echo "${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl "'\'
         echo "-o $exe_name"
#
         $for  -g $ospec -Wl,-m $string         \
             $A_C_DEBUGLIB/$anmain_file         \
             $off_string               		\
             $A_C_DEBUGLIB/anpack.olb		\
             $geabos_lib			\
             $TMS_DEBUGLIB/fmqtms.o	        \
             $TMS_DEBUGLIB/fmutms.o	        \
             $TMS_DEBUGLIB/tms.olb	        \
             $RTDB_DEBUGLIB/rtdb.olb		\
             $UIPACK_DEBUGLIB/uipack.olb	\
             $YBOS_DEBUGLIB/ybos.olb   		\
             $S_I_DEBUGLIB/s_i.olb       	\
             $E_L_DEBUGLIB/e_l.olb       	\
             $RBIO_LIB                 		\
             ${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl \
             -o $exe_name >! "$MAPFILE"
      else if ("$deb_opt" == 'u') then
         echo 'Linking "user" code with debug option...'
         echo "$for  -g $ospec -Wl,-m $string"'\'
         echo "$A_C_LIBRARY/$anmain_fil e    "'\'
         echo "$off_string                   "'\'
         echo "$A_C_LIBRARY/anpack.olb	     "'\'
         echo "$geabos_lib		     "'\'
         echo "$TMS_LIBRARY/tms.olb	     "'\'
         echo "$RTDB_LIBRARY/rtdb.olb	     "'\'
         echo "$UIPACK_LIBRARY/uipack.olb    "'\'
         echo "$YBOS_LIBRARY/ybos.olb.save        "'\'
         echo "$S_I_LIBRARY/s_i.olb          "'\'
         echo "$E_L_LIBRARY/e_l.olb          "'\'
         echo "$RBIO_LIB                     "'\'
         echo "${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl "'\'
         echo "-o $exe_name"
#
         $for -g $ospec -Wl,-m  $string		\
             $A_C_LIBRARY/$anmain_file          \
             $off_string               		\
             $A_C_LIBRARY/anpack.olb		\
             $geabos_lib			\
             $TMS_LIBRARY/fmqtms.o              \
             $TMS_LIBRARY/fmutms.o              \
             $TMS_LIBRARY/tms.olb               \
             $RTDB_LIBRARY/rtdb.olb		\
             $UIPACK_LIBRARY/uipack.olb		\
             $YBOS_LIBRARY/ybos.olb.save   		\
             $S_I_LIBRARY/s_i.olb       	\
             $E_L_LIBRARY/e_l.olb       	\
             $RBIO_LIB                 		\
             ${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl \
             -o $exe_name >! "$MAPFILE"
      else if ("$deb_opt" == 'n') then
         echo 'Linking "no" code with debug option...'
#
         echo "$for $ospec -Wl,-m $string    "'\'
         echo "$A_C_LIBRARY/$anmain_file     "'\'
         echo "$off_string                   "'\'
         echo "$A_C_LIBRARY/anpack.olb	     "'\'
         echo "$geabos_lib		     "'\'
         echo "$TMS_LIBRARY/tms.olb	     "'\'
         echo "$RTDB_LIBRARY/rtdb.olb	     "'\'
         echo "$UIPACK_LIBRARY/uipack.olb    "'\'
         echo "$YBOS_LIBRARY/ybos.olb.save        "'\'
         echo "$S_I_LIBRARY/s_i.olb          "'\'
         echo "$E_L_LIBRARY/e_l.olb          "'\'
         echo "$RBIO_LIB                     "'\'
         echo "${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl "'\'
         echo "-o $exe_name"
#
         $for $ospec -Wl,-m $string		\
             $A_C_LIBRARY/$anmain_file          \
             $off_string               		\
             $A_C_LIBRARY/anpack.olb		\
             $geabos_lib			\
             $TMS_LIBRARY/fmqtms.o              \
             $TMS_LIBRARY/fmutms.o              \
             $TMS_LIBRARY/tms.olb               \
             $RTDB_LIBRARY/rtdb.olb		\
             $UIPACK_LIBRARY/uipack.olb		\
             $YBOS_LIBRARY/ybos.olb.save   		\
             $S_I_LIBRARY/s_i.olb       	\
             $E_L_LIBRARY/e_l.olb       	\
             $RBIO_LIB                 		\
             ${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl \
             -o $exe_name >! "$MAPFILE"
      else if ("$deb_opt" == 'p') then
         echo 'Linking code with profile (gprof) option...'
#
         echo "$for $ospec $Gspec -Wl,-m $string"'\'
         echo "$A_C_LIBRARY/$anmain_file        "'\'
         echo "$off_string                      "'\'
         echo "$A_C_LIBRARY/anpack.olb	        "'\'
         echo "$geabos_lib		        "'\'
         echo "$TMS_LIBRARY/tms.olb	        "'\'
         echo "$RTDB_LIBRARY/rtdb.olb	        "'\'
         echo "$UIPACK_LIBRARY/uipack.olb       "'\'
         echo "$YBOS_LIBRARY/ybos.olb.save           "'\'
         echo "$S_I_LIBRARY/s_i.olb             "'\'
         echo "$E_L_LIBRARY/e_l.olb             "'\'
         echo "$RBIO_LIB                        "'\'
         echo "${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl "'\'
         echo "-o $exe_name"
#
         $for $ospec $Gspec -Wl,-m $string		\
             $A_C_LIBRARY/$anmain_file          \
             $off_string               		\
             $A_C_LIBRARY/anpack.olb		\
             $geabos_lib			\
             $TMS_LIBRARY/fmqtms.o              \
             $TMS_LIBRARY/fmutms.o              \
             $TMS_LIBRARY/tms.olb               \
             $RTDB_LIBRARY/rtdb.olb		\
             $UIPACK_LIBRARY/uipack.olb		\
             $YBOS_LIBRARY/ybos.olb.save   		\
             $S_I_LIBRARY/s_i.olb       	\
             $E_L_LIBRARY/e_l.olb       	\
             $RBIO_LIB                 		\
             ${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl \
             -o $exe_name >! "$MAPFILE"
      else if ("$deb_opt" == '2') then
         echo 'Linking code with O2 option...'
#
         echo "$for $ospec -Wl,-m $O2spec $string"'\'
         echo "$A_C_LIBRARY/$anmain_file         "'\'
         echo "$off_string                       "'\'
         echo "$A_C_LIBRARY/anpack.olb	         "'\'
         echo "$geabos_lib		         "'\'
         echo "$TMS_LIBRARY/tms.olb	         "'\'
         echo "$RTDB_LIBRARY/rtdb.olb	         "'\'
         echo "$UIPACK_LIBRARY/uipack.olb        "'\'
         echo "$YBOS_LIBRARY/ybos.olb.save            "'\'
         echo "$S_I_LIBRARY/s_i.olb              "'\'
         echo "$E_L_LIBRARY/e_l.olb              "'\'
         echo "$RBIO_LIB                         "'\'
         echo "${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl "'\'
         echo "-o $exe_name"
#
         $for $ospec -Wl,-m $O2spec $string     \
             $A_C_LIBRARY/$anmain_file          \
             $off_string               		\
             $A_C_LIBRARY/${pre}anpack.olb	\
             $geabos_lib			\
             $TMS_LIBRARY/fmqtms.o              \
             $TMS_LIBRARY/fmutms.o              \
             $TMS_LIBRARY/tms.olb               \
             $RTDB_LIBRARY/${pre}rtdb.olb	\
             $UIPACK_LIBRARY/${pre}uipack.olb	\
             $YBOS_LIBRARY/${pre}ybos.olb.save   	\
             $S_I_LIBRARY/${pre}s_i.olb       	\
             $E_L_LIBRARY/${pre}e_l.olb       	\
             $RBIO_LIB                 		\
             ${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl \
             -o $exe_name >! "$MAPFILE"
      else if ("$deb_opt" == '3') then
         echo 'Linking code with O3 option...'
         $for $ospec -Wl,-m -O3 $string         \
             $A_C_LIBRARY/$anmain_file          \
             $off_string               		\
             $A_C_LIBRARY/anpack.u		\
             $geabos_lib			\
             $TMS_LIBRARY/fmqtms.o              \
             $TMS_LIBRARY/fmutms.o              \
             $TMS_LIBRARY/tms.olb               \
             $RTDB_LIBRARY/rtdb.u		\
             $UIPACK_LIBRARY/uipack.u		\
             $YBOS_LIBRARY/ybos.u   		\
             $S_I_LIBRARY/s_i.u		       	\
             $E_L_LIBRARY/e_l.u		       	\
             $RBIO_LIB                 		\
             ${cern_mglib}.u $CERN_ROOT/lib/libpacklib.u  $forl \
             -o $exe_name >! "$MAPFILE"
      endif
#
    else if ("$tms_opt" == 'n') then
#
      if ("$deb_opt" == 'a') then
         echo 'Linking "all" code with debug option...'
         echo "$for  -g $ospec -Wl,-m $string"'\'
         echo "$A_C_DEBUGLIB/$anmain_file    "'\'
         echo "$off_string                   "'\'
         echo "$A_C_DEBUGLIB/anpack.olb	     "'\'
         echo "$geabos_lib		     "'\'
         echo "$RTDB_DEBUGLIB/rtdb.olb	     "'\'
         echo "$UIPACK_DEBUGLIB/uipack.olb   "'\'
         echo "$YBOS_DEBUGLIB/ybos.olb       "'\'
         echo "$S_I_DEBUGLIB/s_i.olb         "'\'
         echo "$E_L_DEBUGLIB/e_l.olb         "'\'
         echo "$RBIO_LIB                     "'\'
         echo "${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl "'\'
         echo "-o $exe_name"
#
         $for  -g $ospec -Wl,-m $string         \
             $A_C_DEBUGLIB/$anmain_file         \
             $off_string               		\
             $A_C_DEBUGLIB/anpack.olb		\
             $geabos_lib			\
             $RTDB_DEBUGLIB/rtdb.olb		\
             $UIPACK_DEBUGLIB/uipack.olb	\
             $YBOS_DEBUGLIB/ybos.olb   		\
             $S_I_DEBUGLIB/s_i.olb       	\
             $E_L_DEBUGLIB/e_l.olb       	\
             $RBIO_LIB                 		\
             ${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl \
             -o $exe_name >! "$MAPFILE"
      else if ("$deb_opt" == 'u') then
         echo 'Linking "user" code with debug option...'
         echo "$for  -g $ospec -Wl,-m $string"'\'
         echo "$A_C_LIBRARY/$anmain_fil e    "'\'
         echo "$off_string                   "'\'
         echo "$A_C_LIBRARY/anpack.olb	     "'\'
         echo "$geabos_lib		     "'\'
         echo "$RTDB_LIBRARY/rtdb.olb	     "'\'
         echo "$UIPACK_LIBRARY/uipack.olb    "'\'
         echo "$YBOS_LIBRARY/ybos.olb.save        "'\'
         echo "$S_I_LIBRARY/s_i.olb          "'\'
         echo "$E_L_LIBRARY/e_l.olb          "'\'
         echo "$RBIO_LIB                     "'\'
         echo "${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl "'\'
         echo "-o $exe_name"
#
         $for -g $ospec -Wl,-m  $string		\
             $A_C_LIBRARY/$anmain_file          \
             $off_string               		\
             $A_C_LIBRARY/anpack.olb		\
             $geabos_lib			\
             $RTDB_LIBRARY/rtdb.olb		\
             $UIPACK_LIBRARY/uipack.olb		\
             $YBOS_LIBRARY/ybos.olb.save   		\
             $S_I_LIBRARY/s_i.olb       	\
             $E_L_LIBRARY/e_l.olb       	\
             $RBIO_LIB                 		\
             ${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl \
             -o $exe_name >! "$MAPFILE"
      else if ("$deb_opt" == 'n') then
         echo 'Linking "no" code with debug option...'
#
         echo "$for $ospec -Wl,-m $string    "'\'
         echo "$A_C_LIBRARY/$anmain_file     "'\'
         echo "$off_string                   "'\'
         echo "$A_C_LIBRARY/anpack.olb	     "'\'
         echo "$geabos_lib		     "'\'
         echo "$RTDB_LIBRARY/rtdb.olb	     "'\'
         echo "$UIPACK_LIBRARY/uipack.olb    "'\'
         echo "$YBOS_LIBRARY/ybos.olb.save        "'\'
         echo "$S_I_LIBRARY/s_i.olb          "'\'
         echo "$E_L_LIBRARY/e_l.olb          "'\'
         echo "$RBIO_LIB                     "'\'
         echo "${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl "'\'
         echo "-o $exe_name"
#
         $for $ospec -Wl,-m $string		\
             $A_C_LIBRARY/$anmain_file          \
             $off_string               		\
             $A_C_LIBRARY/anpack.olb		\
             $geabos_lib			\
             $RTDB_LIBRARY/rtdb.olb		\
             $UIPACK_LIBRARY/uipack.olb		\
             $YBOS_LIBRARY/ybos.olb.save   		\
             $S_I_LIBRARY/s_i.olb       	\
             $E_L_LIBRARY/e_l.olb       	\
             $RBIO_LIB                 		\
             ${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl \
             -o $exe_name >! "$MAPFILE"
      else if ("$deb_opt" == 'p') then
         echo 'Linking code with profile (gprof) option...'
#
         echo "$for $ospec $Gspec -Wl,-m $string"'\'
         echo "$A_C_LIBRARY/$anmain_file        "'\'
         echo "$off_string                      "'\'
         echo "$A_C_LIBRARY/anpack.olb	        "'\'
         echo "$geabos_lib		        "'\'
         echo "$RTDB_LIBRARY/rtdb.olb	        "'\'
         echo "$UIPACK_LIBRARY/uipack.olb       "'\'
         echo "$YBOS_LIBRARY/ybos.olb.save           "'\'
         echo "$S_I_LIBRARY/s_i.olb             "'\'
         echo "$E_L_LIBRARY/e_l.olb             "'\'
         echo "$RBIO_LIB                        "'\'
         echo "${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl "'\'
         echo "-o $exe_name"
#
         $for $ospec $Gspec -Wl,-m $string		\
             $A_C_LIBRARY/$anmain_file          \
             $off_string               		\
             $A_C_LIBRARY/anpack.olb		\
             $geabos_lib			\
             $RTDB_LIBRARY/rtdb.olb		\
             $UIPACK_LIBRARY/uipack.olb		\
             $YBOS_LIBRARY/ybos.olb.save   		\
             $S_I_LIBRARY/s_i.olb       	\
             $E_L_LIBRARY/e_l.olb       	\
             $RBIO_LIB                 		\
             ${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl \
             -o $exe_name >! "$MAPFILE"
      else if ("$deb_opt" == '2') then
         echo 'Linking code with O2 option...'
#
         echo "$for $ospec -Wl,-m $O2spec $string"'\'
         echo "$A_C_LIBRARY/$anmain_file         "'\'
         echo "$off_string                       "'\'
         echo "$A_C_LIBRARY/anpack.olb	         "'\'
         echo "$geabos_lib		         "'\'
         echo "$RTDB_LIBRARY/rtdb.olb	         "'\'
         echo "$UIPACK_LIBRARY/uipack.olb        "'\'
         echo "$YBOS_LIBRARY/ybos.olb.save            "'\'
         echo "$S_I_LIBRARY/s_i.olb              "'\'
         echo "$E_L_LIBRARY/e_l.olb              "'\'
         echo "$RBIO_LIB                         "'\'
         echo "${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl "'\'
         echo "-o $exe_name"
#
         $for $ospec -Wl,-m $O2spec $string     \
             $A_C_LIBRARY/$anmain_file          \
             $off_string               		\
             $A_C_LIBRARY/${pre}anpack.olb	\
             $geabos_lib			\
             $RTDB_LIBRARY/${pre}rtdb.olb	\
             $UIPACK_LIBRARY/${pre}uipack.olb	\
             $YBOS_LIBRARY/${pre}ybos.olb.save   	\
             $S_I_LIBRARY/${pre}s_i.olb       	\
             $E_L_LIBRARY/${pre}e_l.olb       	\
             $RBIO_LIB                 		\
             ${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl \
             -o $exe_name >! "$MAPFILE"
      else if ("$deb_opt" == '3') then
         echo 'Linking code with O3 option...'
         $for $ospec -Wl,-m -O3 $string         \
             $A_C_LIBRARY/$anmain_file          \
             $off_string               		\
             $A_C_LIBRARY/anpack.u		\
             $geabos_lib			\
             $RTDB_LIBRARY/rtdb.u		\
             $UIPACK_LIBRARY/uipack.u		\
             $YBOS_LIBRARY/ybos.u   		\
             $S_I_LIBRARY/s_i.u		       	\
             $E_L_LIBRARY/e_l.u		       	\
             $RBIO_LIB                 		\
             ${cern_mglib}.u $CERN_ROOT/lib/libpacklib.u  $forl \
             -o $exe_name >! "$MAPFILE"
      endif    
#
    endif
#
   endif
#
   if (`printenv MAPFILE` == "") then
   #
   #  No map file has been specified
   #  ==============================
   if ("$tms_opt" == 'y') then
#
    if ("$deb_opt" == 'a') then
      echo 'Linking "all" code with debug option...'
#
         echo "$for  -g $ospec $string       "'\'
         echo "$A_C_DEBUGLIB/$anmain_file    "'\'
         echo "$off_string                   "'\'
         echo "$A_C_DEBUGLIB/anpack.olb	     "'\'
         echo "$geabos_lib		     "'\'
         echo "$TMS_DEBUGLIB/tms.olb	     "'\'
         echo "$RTDB_DEBUGLIB/rtdb.olb	     "'\'
         echo "$UIPACK_DEBUGLIB/uipack.olb   "'\'
         echo "$YBOS_DEBUGLIB/ybos.olb       "'\'
         echo "$S_I_DEBUGLIB/s_i.olb         "'\'
         echo "$E_L_DEBUGLIB/e_l.olb         "'\'
         echo "$RBIO_LIB                     "'\'
         echo "${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl "'\'
         echo "-o $exe_name"
#
      $for -g $ospec $string                    \
          $A_C_DEBUGLIB/$anmain_file            \
          $off_string               		\
          $A_C_DEBUGLIB/anpack.olb		\
          $geabos_lib				\
          $TMS_DEBUGLIB/fmqtms.o                 \
          $TMS_DEBUGLIB/fmutms.o                 \
          $TMS_DEBUGLIB/tms.olb                  \
          $RTDB_DEBUGLIB/rtdb.olb		\
          $UIPACK_DEBUGLIB/uipack.olb		\
          $YBOS_DEBUGLIB/ybos.olb   		\
          $S_I_DEBUGLIB/s_i.olb       		\
          $E_L_DEBUGLIB/e_l.olb       		\
          $RBIO_LIB                 		\
          ${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl \
          -o $exe_name
    else if ("$deb_opt" == 'u') then
      echo 'Linking "user" code with debug option...'
#
         echo "$for  -g $ospec $string       "'\'
         echo "$A_C_DEBUGLIB/$anmain_file    "'\'
         echo "$off_string                   "'\'
         echo "$A_C_DEBUGLIB/anpack.olb	     "'\'
         echo "$geabos_lib		     "'\'
         echo "$TMS_LIBRARY/tms.olb	     "'\'
         echo "$RTDB_DEBUGLIB/rtdb.olb	     "'\'
         echo "$UIPACK_DEBUGLIB/uipack.olb   "'\'
         echo "$YBOS_DEBUGLIB/ybos.olb       "'\'
         echo "$S_I_DEBUGLIB/s_i.olb         "'\'
         echo "$E_L_DEBUGLIB/e_l.olb         "'\'
         echo "$RBIO_LIB                     "'\'
         echo "${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl "'\'
         echo "-o $exe_name"
#
      $for -g $ospec $string                    \
          $A_C_LIBRARY/$anmain_file             \
          $off_string               		\
          $A_C_LIBRARY/anpack.olb		\
          $geabos_lib				\
          $TMS_LIBRARY/fmqtms.o                 \
          $TMS_LIBRARY/fmutms.o                 \
          $TMS_LIBRARY/tms.olb                  \
          $RTDB_LIBRARY/rtdb.olb		\
          $UIPACK_LIBRARY/uipack.olb		\
          $YBOS_LIBRARY/ybos.olb.save   		\
          $S_I_LIBRARY/s_i.olb			\
          $E_L_LIBRARY/e_l.olb			\
          $RBIO_LIB				\
          ${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl \
          -o $exe_name
    else if ("$deb_opt" == 'n') then
      echo 'Linking "no" code with debug option...'
#
         echo "$for $ospec $string               "'\'
         echo "$A_C_LIBRARY/$anmain_file         "'\'
         echo "$off_string                       "'\'
         echo "$A_C_LIBRARY/anpack.olb	         "'\'
         echo "$geabos_lib		         "'\'
         echo "$TMS_LIBRARY/tms.olb	         "'\'
         echo "$RTDB_LIBRARY/rtdb.olb	         "'\'
         echo "$UIPACK_LIBRARY/uipack.olb        "'\'
         echo "$YBOS_LIBRARY/ybos.olb.save            "'\'
         echo "$S_I_LIBRARY/s_i.olb              "'\'
         echo "$E_L_LIBRARY/e_l.olb              "'\'
         echo "$RBIO_LIB                         "'\'
         echo "${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl "'\'
         echo "-o $exe_name"
#
      $for $ospec $string                       \
          $A_C_LIBRARY/$anmain_file             \
          $off_string               		\
          $A_C_LIBRARY/anpack.olb		\
          $geabos_lib				\
          $TMS_LIBRARY/fmqtms.o                 \
          $TMS_LIBRARY/fmutms.o                 \
          $TMS_LIBRARY/tms.olb                  \
          $RTDB_LIBRARY/rtdb.olb		\
          $UIPACK_LIBRARY/uipack.olb		\
          $YBOS_LIBRARY/ybos.olb.save   		\
          $S_I_LIBRARY/s_i.olb			\
          $E_L_LIBRARY/e_l.olb			\
          $RBIO_LIB				\
          ${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl \
          -o $exe_name
    else if ("$deb_opt" == 'p') then
      echo 'Linking code with profile (gprof) option...'
#
         echo "$for $ospec $Gspec $string        "'\'
         echo "$A_C_LIBRARY/$anmain_file         "'\'
         echo "$off_string                       "'\'
         echo "$A_C_LIBRARY/anpack.olb	         "'\'
         echo "$geabos_lib		         "'\'
         echo "$TMS_LIBRARY/tms.olb	         "'\'
         echo "$RTDB_LIBRARY/rtdb.olb	         "'\'
         echo "$UIPACK_LIBRARY/uipack.olb        "'\'
         echo "$YBOS_LIBRARY/ybos.olb.save            "'\'
         echo "$S_I_LIBRARY/s_i.olb              "'\'
         echo "$E_L_LIBRARY/e_l.olb              "'\'
         echo "$RBIO_LIB                         "'\'
         echo "${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl "'\'
         echo "-o $exe_name"
#
      $for $ospec $Gspec $string                       \
          $A_C_LIBRARY/$anmain_file             \
          $off_string               		\
          $A_C_LIBRARY/anpack.olb		\
          $geabos_lib				\
          $TMS_LIBRARY/fmqtms.o                 \
          $TMS_LIBRARY/fmutms.o                 \
          $TMS_LIBRARY/tms.olb                  \
          $RTDB_LIBRARY/rtdb.olb		\
          $UIPACK_LIBRARY/uipack.olb		\
          $YBOS_LIBRARY/ybos.olb.save   		\
          $S_I_LIBRARY/s_i.olb			\
          $E_L_LIBRARY/e_l.olb			\
          $RBIO_LIB				\
          ${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl \
          -o $exe_name
    else if ("$deb_opt" == '2') then
      echo 'Linking code with O2 option...'
#
         echo "$for $ospec $O2spec $string       "'\'
         echo "$A_C_LIBRARY/$anmain_file         "'\'
         echo "$off_string                       "'\'
         echo "$A_C_LIBRARY/anpack.olb	         "'\'
         echo "$geabos_lib		         "'\'
         echo "$TMS_LIBRARY/tms.olb	         "'\'
         echo "$RTDB_LIBRARY/rtdb.olb	         "'\'
         echo "$UIPACK_LIBRARY/uipack.olb        "'\'
         echo "$YBOS_LIBRARY/ybos.olb.save            "'\'
         echo "$S_I_LIBRARY/s_i.olb              "'\'
         echo "$E_L_LIBRARY/e_l.olb              "'\'
         echo "$RBIO_LIB                         "'\'
         echo "${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl "'\'
         echo "-o $exe_name"
#
      $for $ospec $O2spec $string               \
          $A_C_LIBRARY/$anmain_file             \
          $off_string               		\
          $A_C_LIBRARY/${pre}anpack.olb		\
          $geabos_lib				\
          $TMS_LIBRARY/fmqtms.o                 \
          $TMS_LIBRARY/fmutms.o                 \
          $TMS_LIBRARY/tms.olb                  \
          $RTDB_LIBRARY/${pre}rtdb.olb		\
          $UIPACK_LIBRARY/${pre}uipack.olb	\
          $YBOS_LIBRARY/${pre}ybos.olb.save   	\
          $S_I_LIBRARY/${pre}s_i.olb       	\
          $E_L_LIBRARY/${pre}e_l.olb       	\
          $RBIO_LIB                 		\
          ${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl \
          -o $exe_name
    else if ("$deb_opt" == '3') then
      echo 'Linking code with O3 option...'
      $for $ospec -O3 $string                   \
          $A_C_LIBRARY/$anmain_file            	\
          $off_string               		\
          $A_C_LIBRARY/anpack.u			\
          $geabos_lib				\
          $TMS_LIBRARY/fmqtms.o                 \
          $TMS_LIBRARY/fmutms.o                 \
          $TMS_LIBRARY/tms.olb                  \
          $RTDB_LIBRARY/rtdb.u			\
          $UIPACK_LIBRARY/uipack.u		\
          $YBOS_LIBRARY/ybos.u   		\
          $S_I_LIBRARY/s_i.u			\
          $E_L_LIBRARY/e_l.u			\
          $RBIO_LIB                 		\
          ${cern_mglib}.u $CERN_ROOT/lib/libpacklib.u   $forl \
          -o $exe_name
    endif
#
   else if ("$tms_opt" == 'n') then
#
    if ("$deb_opt" == 'a') then
      echo 'Linking "all" code with debug option...'
#
         echo "$for  -g $ospec $string       "'\'
         echo "$A_C_DEBUGLIB/$anmain_file    "'\'
         echo "$off_string                   "'\'
         echo "$A_C_DEBUGLIB/anpack.olb	     "'\'
         echo "$geabos_lib		     "'\'
         echo "$RTDB_DEBUGLIB/rtdb.olb	     "'\'
         echo "$UIPACK_DEBUGLIB/uipack.olb   "'\'
         echo "$YBOS_DEBUGLIB/ybos.olb       "'\'
         echo "$S_I_DEBUGLIB/s_i.olb         "'\'
         echo "$E_L_DEBUGLIB/e_l.olb         "'\'
         echo "$RBIO_LIB                     "'\'
         echo "${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl "'\'
         echo "-o $exe_name"
#
      $for -g $ospec $string                    \
          $A_C_DEBUGLIB/$anmain_file            \
          $off_string               		\
          $A_C_DEBUGLIB/anpack.olb		\
          $geabos_lib				\
          $RTDB_DEBUGLIB/rtdb.olb		\
          $UIPACK_DEBUGLIB/uipack.olb		\
          $YBOS_DEBUGLIB/ybos.olb   		\
          $S_I_DEBUGLIB/s_i.olb       		\
          $E_L_DEBUGLIB/e_l.olb       		\
          $RBIO_LIB                 		\
          ${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl \
          -o $exe_name
    else if ("$deb_opt" == 'u') then
      echo 'Linking "user" code with debug option...'
#
         echo "$for  -g $ospec $string       "'\'
         echo "$A_C_DEBUGLIB/$anmain_file    "'\'
         echo "$off_string                   "'\'
         echo "$A_C_DEBUGLIB/anpack.olb	     "'\'
         echo "$geabos_lib		     "'\'
         echo "$RTDB_DEBUGLIB/rtdb.olb	     "'\'
         echo "$UIPACK_DEBUGLIB/uipack.olb   "'\'
         echo "$YBOS_DEBUGLIB/ybos.olb       "'\'
         echo "$S_I_DEBUGLIB/s_i.olb         "'\'
         echo "$E_L_DEBUGLIB/e_l.olb         "'\'
         echo "$RBIO_LIB                     "'\'
         echo "${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl "'\'
         echo "-o $exe_name"
#
      $for -g $ospec $string                    \
          $A_C_LIBRARY/$anmain_file             \
          $off_string               		\
          $A_C_LIBRARY/anpack.olb		\
          $geabos_lib				\
          $RTDB_LIBRARY/rtdb.olb		\
          $UIPACK_LIBRARY/uipack.olb		\
          $YBOS_LIBRARY/ybos.olb.save   		\
          $S_I_LIBRARY/s_i.olb			\
          $E_L_LIBRARY/e_l.olb			\
          $RBIO_LIB				\
          ${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl \
          -o $exe_name
    else if ("$deb_opt" == 'n') then
      echo 'Linking "no" code with debug option...'
#
         echo "$for $ospec $string               "'\'
         echo "$A_C_LIBRARY/$anmain_file         "'\'
         echo "$off_string                       "'\'
         echo "$A_C_LIBRARY/anpack.olb	         "'\'
         echo "$geabos_lib		         "'\'
         echo "$RTDB_LIBRARY/rtdb.olb	         "'\'
         echo "$UIPACK_LIBRARY/uipack.olb        "'\'
         echo "$YBOS_LIBRARY/ybos.olb.save            "'\'
         echo "$S_I_LIBRARY/s_i.olb              "'\'
         echo "$E_L_LIBRARY/e_l.olb              "'\'
         echo "$RBIO_LIB                         "'\'
         echo "${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl "'\'
         echo "-o $exe_name"
#
      $for $ospec $string                       \
          $A_C_LIBRARY/$anmain_file             \
          $off_string               		\
          $A_C_LIBRARY/anpack.olb		\
          $geabos_lib				\
          $RTDB_LIBRARY/rtdb.olb		\
          $UIPACK_LIBRARY/uipack.olb		\
          $YBOS_LIBRARY/ybos.olb.save   		\
          $S_I_LIBRARY/s_i.olb			\
          $E_L_LIBRARY/e_l.olb			\
          $RBIO_LIB				\
          ${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl \
          -o $exe_name
    else if ("$deb_opt" == 'p') then
      echo 'Linking code with profile (gprof) option...'
#
         echo "$for $ospec $Gspec $string        "'\'
         echo "$A_C_LIBRARY/$anmain_file         "'\'
         echo "$off_string                       "'\'
         echo "$A_C_LIBRARY/anpack.olb	         "'\'
         echo "$geabos_lib		         "'\'
         echo "$RTDB_LIBRARY/rtdb.olb	         "'\'
         echo "$UIPACK_LIBRARY/uipack.olb        "'\'
         echo "$YBOS_LIBRARY/ybos.olb.save            "'\'
         echo "$S_I_LIBRARY/s_i.olb              "'\'
         echo "$E_L_LIBRARY/e_l.olb              "'\'
         echo "$RBIO_LIB                         "'\'
         echo "${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl "'\'
         echo "-o $exe_name"
#
      $for $ospec $Gspec $string                       \
          $A_C_LIBRARY/$anmain_file             \
          $off_string               		\
          $A_C_LIBRARY/anpack.olb		\
          $geabos_lib				\
          $RTDB_LIBRARY/rtdb.olb		\
          $UIPACK_LIBRARY/uipack.olb		\
          $YBOS_LIBRARY/ybos.olb.save   		\
          $S_I_LIBRARY/s_i.olb			\
          $E_L_LIBRARY/e_l.olb			\
          $RBIO_LIB				\
          ${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl \
          -o $exe_name
    else if ("$deb_opt" == '2') then
      echo 'Linking code with O2 option...'
#
         echo "$for $ospec $O2spec $string       "'\'
         echo "$A_C_LIBRARY/$anmain_file         "'\'
         echo "$off_string                       "'\'
         echo "$A_C_LIBRARY/anpack.olb	         "'\'
         echo "$geabos_lib		         "'\'
         echo "$RTDB_LIBRARY/rtdb.olb	         "'\'
         echo "$UIPACK_LIBRARY/uipack.olb        "'\'
         echo "$YBOS_LIBRARY/ybos.olb.save            "'\'
         echo "$S_I_LIBRARY/s_i.olb              "'\'
         echo "$E_L_LIBRARY/e_l.olb              "'\'
         echo "$RBIO_LIB                         "'\'
         echo "${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl "'\'
         echo "-o $exe_name"
#
      $for $ospec $O2spec $string               \
          $A_C_LIBRARY/$anmain_file             \
          $off_string               		\
          $A_C_LIBRARY/${pre}anpack.olb		\
          $geabos_lib				\
          $RTDB_LIBRARY/${pre}rtdb.olb		\
          $UIPACK_LIBRARY/${pre}uipack.olb	\
          $YBOS_LIBRARY/${pre}ybos.olb.save   	\
          $S_I_LIBRARY/${pre}s_i.olb       	\
          $E_L_LIBRARY/${pre}e_l.olb       	\
          $RBIO_LIB                 		\
          ${cern_mglib}.a $CERN_ROOT/lib/libpacklib.a  $forl \
          -o $exe_name
    else if ("$deb_opt" == '3') then
      echo 'Linking code with O3 option...'
      $for $ospec -O3 $string                   \
          $A_C_LIBRARY/$anmain_file            	\
          $off_string               		\
          $A_C_LIBRARY/anpack.u			\
          $geabos_lib				\
          $RTDB_LIBRARY/rtdb.u			\
          $UIPACK_LIBRARY/uipack.u		\
          $YBOS_LIBRARY/ybos.u   		\
          $S_I_LIBRARY/s_i.u			\
          $E_L_LIBRARY/e_l.u			\
          $RBIO_LIB                 		\
          ${cern_mglib}.u $CERN_ROOT/lib/libpacklib.u   $forl \
          -o $exe_name
    endif
#
   endif
#
   endif
   #
endif
#
#
# and exit:
chmod a+rx $exe_name
echo 'link_ana has finished'
exit 0
