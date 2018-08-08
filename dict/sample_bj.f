      INTEGER FUNCTION ANSTUP(MODE,INLUN,OUTLUN,DEVICE)
C     =================================================
C
C       Description:-
C       =============
C       This Function is used by Analysis_Control
C       to setup and allocate work space for the
C       standard Utilities used by this program.
C       These standard utilities are:-
C
C       Analysis_Control Configuration
C       UIPack Configuration
C       Database Work Area
C       Primary YBOS Array
C       Primary YHIST Array
C       HBOOK PAWC Common Array
C
C       where only those utilities used in this program
C       are initialised.
C
C       Author:-
C       ========
C       BUILD_JOB Program Version  3.01
C
C       Declarations:-
C       ==============
C
        IMPLICIT NONE
      INTEGER MODE, INLUN,OUTLUN,DEVICE
C
      COMMON/ANCOMM/ANPKI4
      INTEGER       ANPKI4
      DIMENSION     ANPKI4(    131072)
      COMMON/MENUCO/MENUI4
      INTEGER       MENUI4
      DIMENSION     MENUI4(    131072)
      COMMON/KLDBBK/CALII4
      INTEGER       CALII4
      DIMENSION     CALII4(   5000000)
      COMMON/BCS   /YBOSI4
      INTEGER       YBOSI4
      DIMENSION     YBOSI4(    600000)
      COMMON/PAWC  /HBK4I4
      INTEGER       HBK4I4
      DIMENSION     HBK4I4(  20000000)
      INTEGER       ANPKIN, ANSTIN
      INTEGER       UIINIT
C
      INTEGER       ZDBINI
C
C==== Include /kloe/soft/off/rtdb/production/aix/library/hdberr.cin ====
      INTEGER CESUCC,CEFAIL,CEDBOP,CENOOB
      PARAMETER (CESUCC = 0, CEFAIL = 99999, CEDBOP = -2)
      PARAMETER (CENOOB = 33)
      INTEGER       BOS77
C
C
      INTEGER       APRIHEPDB
C
C
C==== Include /kloe/soft/off/a_c/production/aix/library/anerror.cin ====
      INTEGER    ANSUCC
      PARAMETER (ANSUCC = '8198009'X)
      INTEGER    ANBEGN
      PARAMETER (ANBEGN = '8198019'X)
      INTEGER    ANPDUN
      PARAMETER (ANPDUN = '8198021'X)
      INTEGER    ANAST
      PARAMETER (ANAST   = '81980A3'X)
      INTEGER    ANILPS
      PARAMETER (ANILPS = '8198122'X)
      INTEGER    ANILMD
      PARAMETER (ANILMD = '819812A'X)
      INTEGER    ANLSTR
      PARAMETER (ANLSTR = '81980C0'X)
      INTEGER    ANNINI
      PARAMETER (ANNINI = '8198102'X)
      INTEGER    ANOVRF
      PARAMETER (ANOVRF = '819810A'X)
      INTEGER    ANNOME
      PARAMETER (ANNOME = '8198112'X)
      INTEGER    ANNOLU
      PARAMETER (ANNOLU = '819811A'X)
      INTEGER    ANNOEP
      PARAMETER (ANNOEP = '8198011'X)
      INTEGER    ANILGP
      PARAMETER (ANILGP = '8198132'X)
      INTEGER    ANILPA
      PARAMETER (ANILPA = '819813A'X)
      INTEGER    ANILQU
      PARAMETER (ANILQU = '8198142'X)
      INTEGER    ANILSY
      PARAMETER (ANILSY = '819814A'X)
      INTEGER    ANILLU
      PARAMETER (ANILLU = '8198152'X)
      INTEGER    ANILVB
      PARAMETER (ANILVB = '819815A'X)
      INTEGER    ANILLI
      PARAMETER (ANILLI = '8198162'X)
      INTEGER    ANDUMD
      PARAMETER (ANDUMD = '819816A'X)
      INTEGER    ANYBER
      PARAMETER (ANYBER = '8198172'X)
      INTEGER    ANYBFE
      PARAMETER (ANYBFE = '081981B2'X)
      INTEGER    ANEFOP
      PARAMETER (ANEFOP = '819817A'X)
      INTEGER    ANEOF
      PARAMETER (ANEOF = '8198083'X)
      INTEGER    ANIFNO
      PARAMETER (ANIFNO = '819808B'X)
      INTEGER    ANCLOS
      PARAMETER (ANCLOS = '8198093'X)
      INTEGER    ANOFNO
      PARAMETER (ANOFNO = '819809B'X)
      INTEGER    ANNOLR
      PARAMETER (ANNOLR = '8198182'X)
      INTEGER    ANILST
      PARAMETER (ANILST = '819818A'X)
      INTEGER    ANNOEV
      PARAMETER (ANNOEV = '8198192'X)
      INTEGER    ANILBL
      PARAMETER (ANILBL = '819819A'X)
      INTEGER    ANNEIF
      PARAMETER (ANNEIF = '81981A2'X)
      INTEGER    ANNOBK
      PARAMETER (ANNOBK = '81980C8'X)
      INTEGER    ANILBK
      PARAMETER (ANILBK = '81981AA'X)
C== Include /kloe/soft/off/uipack/production/aix/library/uierror.cin ===
      INTEGER    UISUCC
      PARAMETER (UISUCC = '8128009'X)
      INTEGER    UIDFLT
      PARAMETER (UIDFLT = '8128011'X)
      INTEGER    UITRUN
      PARAMETER (UITRUN = '8128019'X)
      INTEGER    UIQUPR
      PARAMETER (UIQUPR = '8128021'X)
      INTEGER    UIQUNE
      PARAMETER (UIQUNE = '8128029'X)
      INTEGER    UIQUVA
      PARAMETER (UIQUVA = '8128031'X)
      INTEGER    UIQUDF
      PARAMETER (UIQUDF = '8128039'X)
      INTEGER    UINOIN
      PARAMETER (UINOIN = '8128083'X)
      INTEGER    UIABRT
      PARAMETER (UIABRT = '812808B'X)
      INTEGER    UICANC
      PARAMETER (UICANC = '8128093'X)
      INTEGER    UIMPTY
      PARAMETER (UIMPTY = '81280C0'X)
      INTEGER    UIQUAB
      PARAMETER (UIQUAB = '81280C8'X)
      INTEGER    UIEOF
      PARAMETER (UIEOF  = '81280D0'X)
      INTEGER    UININI
      PARAMETER (UININI = '8128102'X)
      INTEGER    UIOVRF
      PARAMETER (UIOVRF = '812810A'X)
      INTEGER    UINOGP
      PARAMETER (UINOGP = '8128112'X)
      INTEGER    UINOME
      PARAMETER (UINOME = '812811A'X)
      INTEGER    UINOLU
      PARAMETER (UINOLU = '8128122'X)
      INTEGER    UINOPC
      PARAMETER (UINOPC = '812824A'X)
      INTEGER    UINOVP
      PARAMETER (UINOVP = '81281DA'X)
      INTEGER    UIILBU
      PARAMETER (UIILBU = '812812A'X)
      INTEGER    UIILCO
      PARAMETER (UIILCO = '81281E2'X)
      INTEGER    UIILDV
      PARAMETER (UIILDV = '8128132'X)
      INTEGER    UIILGP
      PARAMETER (UIILGP = '812813A'X)
      INTEGER    UIILLI
      PARAMETER (UIILLI = '812818A'X)
      INTEGER    UIILME
      PARAMETER (UIILME = '8128142'X)
      INTEGER    UIILMD
      PARAMETER (UIILMD = '812814A'X)
      INTEGER    UIILPA
      PARAMETER (UIILPA = '81281EA'X)
      INTEGER    UIILPC
      PARAMETER (UIILPC = '812823A'X)
      INTEGER    UIILQU
      PARAMETER (UIILQU = '8128152'X)
      INTEGER    UIILSZ
      PARAMETER (UIILSZ = '812815A'X)
      INTEGER    UIILSB
      PARAMETER (UIILSB = '812821A'X)
      INTEGER    UIILSY
      PARAMETER (UIILSY = '8128162'X)
      INTEGER    UIILTP
      PARAMETER (UIILTP = '812816A'X)
      INTEGER    UIILUI
      PARAMETER (UIILUI = '8128262'X)
      INTEGER    UIILLU
      PARAMETER (UIILLU = '8128172'X)
      INTEGER    UIILVB
      PARAMETER (UIILVB = '812817A'X)
      INTEGER    UIILVP
      PARAMETER (UIILVP = '8128182'X)
      INTEGER    UIDUGP
      PARAMETER (UIDUGP = '8128192'X)
      INTEGER    UIDUME
      PARAMETER (UIDUME = '812819A'X)
      INTEGER    UIDUPA
      PARAMETER (UIDUPA = '81281F2'X)
      INTEGER    UIDUPC
      PARAMETER (UIDUPC = '8128242'X)
      INTEGER    UIDUQU
      PARAMETER (UIDUQU = '81281A2'X)
      INTEGER    UIDUSB
      PARAMETER (UIDUSB = '8128222'X)
      INTEGER    UIDUVB
      PARAMETER (UIDUVB = '81281AA'X)
      INTEGER    UIDUVP
      PARAMETER (UIDUVP = '81281FA'X)
      INTEGER    UIRCSB
      PARAMETER (UIRCSB = '0812822A'X)
      INTEGER    UIRELU
      PARAMETER (UIRELU = '81281B2'X)
      INTEGER    UISTAK
      PARAMETER (UISTAK = '81281BA'X)
      INTEGER    UICIFI
      PARAMETER (UICIFI = '81281C2'X)
      INTEGER    UIRIFI
      PARAMETER (UIRIFI = '0812820A'X)
      INTEGER    UICOFI
      PARAMETER (UICOFI = '81281CA'X)
      INTEGER    UICOWR
      PARAMETER (UICOWR = '8128212'X)
      INTEGER    UIGLOK
      PARAMETER (UIGLOK = '81281D2'X)
      INTEGER    UISLOK
      PARAMETER (UISLOK = '8128232'X)
      INTEGER    UIVLOK
      PARAMETER (UIVLOK = '8128202'X)
      INTEGER    UIEMST
      PARAMETER (UIEMST = '8128252'X)
      INTEGER    UINTME
      PARAMETER (UINTME = '812825A'X)
C==== Include /kloe/soft/off/ybos/production/aix/library/errcod.cin ====
      INTEGER    YESUCC
      PARAMETER (YESUCC = '08508009'X)
      INTEGER    YEWLOK
      PARAMETER (YEWLOK = '08508083'X)
      INTEGER    YEWRNS
      PARAMETER (YEWRNS = '0850808B'X)
      INTEGER    YEINDX
      PARAMETER (YEINDX = '08508093'X)
      INTEGER    YEEOF
      PARAMETER (YEEOF  = '08508100'X)
      INTEGER    YEPRBD
      PARAMETER (YEPRBD = '08508108'X)
      INTEGER    YERSTF
      PARAMETER (YERSTF = '08508110'X)
      INTEGER    YEOVRF
      PARAMETER (YEOVRF = '08508182'X)
      INTEGER    YEBKNG
      PARAMETER (YEBKNG = '0850818A'X)
      INTEGER    YEBKTS
      PARAMETER (YEBKTS = '08508192'X)
      INTEGER    YEBKOV
      PARAMETER (YEBKOV = '0850819A'X)
      INTEGER    YEBKSP
      PARAMETER (YEBKSP = '085081A2'X)
      INTEGER    YENOBK
      PARAMETER (YENOBK = '085081AA'X)
      INTEGER    YENONR
      PARAMETER (YENONR = '085081B2'X)
      INTEGER    YEMANY
      PARAMETER (YEMANY = '085081BA'X)
      INTEGER    YEDUPB
      PARAMETER (YEDUPB = '085081C2'X)
      INTEGER    YEBSIL
      PARAMETER (YEBSIL = '085081CA'X)
      INTEGER    YEILOP
      PARAMETER (YEILOP = '085081D2'X)
      INTEGER    YEAROF
      PARAMETER (YEAROF = '085081DA'X)
      INTEGER    YETRUN
      PARAMETER (YETRUN = '085081E2'X)
      INTEGER    YECORR
      PARAMETER (YECORR = '085081EA'X)
      INTEGER    YEWRGI
      PARAMETER (YEWRGI = '085081F2'X)
      INTEGER    YELWIU
      PARAMETER (YELWIU = '085081FA'X)
      INTEGER    YEILUN
      PARAMETER (YEILUN = '08508202'X)
      INTEGER    YEIOUS
      PARAMETER (YEIOUS = '0850820A'X)
      INTEGER    YELROF
      PARAMETER (YELROF = '08508212'X)
      INTEGER    YELRLN
      PARAMETER (YELRLN = '0850821A'X)
      INTEGER    YEPRXL
      PARAMETER (YEPRXL = '08508222'X)
      INTEGER    YEBKOS
      PARAMETER (YEBKOS = '0850822A'X)
      INTEGER    YEBKXD
      PARAMETER (YEBKXD = '08508232'X)
      INTEGER    YELRZL
      PARAMETER (YELRZL = '0850823A'X)
      INTEGER    YELRWT
      PARAMETER (YELRWT = '08508242'X)
      INTEGER    YEDKOP
      PARAMETER (YEDKOP = '0850824A'X)
      INTEGER    YEDKWT
      PARAMETER (YEDKWT = '08508252'X)
      INTEGER    YEDKRD
      PARAMETER (YEDKRD = '0850825A'X)
      INTEGER    YEILUS
      PARAMETER (YEILUS = '08508282'X)
      INTEGER    YERSUS
      PARAMETER (YERSUS = '0850828A'X)
      INTEGER    YENRUS
      PARAMETER (YENRUS = '08508292'X)
      INTEGER    YEILLA
      PARAMETER (YEILLA = '08508302'X)
      INTEGER    YEDUPA
      PARAMETER (YEDUPA = '0850830A'X)
      INTEGER    YEBTIL
      PARAMETER (YEBTIL = '08508382'X)
      INTEGER    YEGRIL
      PARAMETER (YEGRIL = '0850838A'X)
      INTEGER    YECHKF
      PARAMETER (YECHKF = '08508392'X)
      INTEGER    YESTOF
      PARAMETER (YESTOF = '0850839A'X)
      INTEGER    YENOTA
      PARAMETER (YENOTA = '085083A2'X)
      INTEGER    YEBNKP
      PARAMETER (YEBNKP = '085083AA'X)
      INTEGER    YEBDCH
      PARAMETER (YEBDCH = '085083C2'X)
      INTEGER    YEBDBK
      PARAMETER (YEBDBK = '085083CA'X)
      INTEGER    YEBDLU
      PARAMETER (YEBDLU = '085083D2'X)
      INTEGER    YEBDBS
      PARAMETER (YEBDBS = '085083DA'X)
C====== Include /kloe/soft/off/offline/inc/development/erlevl.cin ======
        INTEGER    ERMINI
        PARAMETER (ERMINI = 0)
        INTEGER    ERMAXI
        PARAMETER (ERMAXI = 7)
        INTEGER    ERSUCC
        PARAMETER (ERSUCC = 0)
        INTEGER    ERINFO
        PARAMETER (ERINFO = 1)
        INTEGER    ERWARN
        PARAMETER (ERWARN = 2)
        INTEGER    EREROR
        PARAMETER (EREROR = 3)
        INTEGER    ERSEVR
        PARAMETER (ERSEVR = 4)
        INTEGER         ELSUCC
        PARAMETER       (ELSUCC = 10)
        INTEGER         ELINFO
        PARAMETER       (ELINFO = 11)
        INTEGER         ELWARN
        PARAMETER       (ELWARN = 12)
        INTEGER         ELWARN2
        PARAMETER       (ELWARN2 = 13)
        INTEGER         ELEROR
        PARAMETER       (ELEROR = 14)
        INTEGER         ELEROR2
        PARAMETER       (ELEROR2 = 15)
        INTEGER         ELNEXT
        PARAMETER       (ELNEXT = 16)
        INTEGER         ELNEXT2
        PARAMETER       (ELNEXT2 = 17)
        INTEGER         ELSEVR
        PARAMETER       (ELSEVR = 18)
        INTEGER         ELABOR
        PARAMETER       (ELABOR = 19)
      EXTERNAL ANFIN
C
C       Executable Code:-
C       =================
C
      ANSTUP = ANSUCC
C
C
C       Initialise Analysis_Control
C       ===========================
C
      IF (ANSTUP .EQ. ANSUCC) THEN
         ANSTUP = ANPKIN(ANPKI4,    131072,'/ANCOMM/', 128)
         IF (ANSTUP .EQ. YESUCC) ANSTUP = ANSUCC
      ENDIF
C
C       Initialise UIPack
C       =================
C
      IF (ANSTUP .EQ. ANSUCC) THEN
         ANSTUP = UIINIT(MODE,INLUN,OUTLUN,DEVICE,    131072, 256)
         IF (ANSTUP .EQ. UISUCC) ANSTUP = ANSUCC
      ENDIF
C
C       Initialise Primary YBOS Array
C       =============================
C
      IF (ANSTUP .EQ. ANSUCC) THEN
         ANSTUP = BOS77(    600000, 256)
         IF (ANSTUP .EQ. YESUCC) ANSTUP = ANSUCC
      ENDIF
C
C       Initialise HBOOK Histogram Package
C       ==================================
C
      IF (ANSTUP .EQ. ANSUCC) THEN
         CALL HLIMIT(  20000000)
      ENDIF
C
C       Initialise Database ZEBRA Array
C       ===============================
C
      IF (ANSTUP .EQ. ANSUCC) THEN
         ANSTUP = ZDBINI(   5000000,-3)
         IF (ANSTUP .EQ. CESUCC) ANSTUP = ANSUCC
      ENDIF
C
C       Initialise    CALIB Database
C       ============================
C
      IF (ANSTUP .EQ. ANSUCC) THEN
         ANSTUP = APRIHEPDB('CALI')
         IF (ANSTUP .EQ. CESUCC) ANSTUP = ANSUCC
      ENDIF
C
C       Initialise GEOMETRY Database
C       ============================
C
      IF (ANSTUP .EQ. ANSUCC) THEN
         ANSTUP = APRIHEPDB('GEOM')
         IF (ANSTUP .EQ. CESUCC) ANSTUP = ANSUCC
      ENDIF
C
C       Initialise RUN_COND Database
C       ============================
C
      IF (ANSTUP .EQ. ANSUCC) THEN
         ANSTUP = APRIHEPDB('RUNC')
         IF (ANSTUP .EQ. CESUCC) ANSTUP = ANSUCC
      ENDIF
C
C       Initialise      TMS Database
C       ============================
C
      IF (ANSTUP .EQ. ANSUCC) THEN
         ANSTUP = APRIHEPDB('  TP')
         IF (ANSTUP .EQ. CESUCC) ANSTUP = ANSUCC
      ENDIF
C
C       Initialise Analysis_Control Status Bank
C       =======================================
C
      ANSTUP = ANSTIN(INLUN,OUTLUN)
C
C       Return to Caller
C       ================
C
      IF(ANSTUP.NE.ANSUCC)   CALL ANEROR(ANSTUP)
      RETURN
      END
      SUBROUTINE ANLGEO
C     =================
C
C       Description:-
C       =============
C       This Routine is used by Analysis_Control
C       to Load the geometry data base when needed.
C       If offline is not enabled it is dummied.
C       Author:-
C       ========
C       BUILD_JOB Program Version  3.01
C
C       Declarations:-
C       ==============
C
        IMPLICIT NONE
C
C
C       Return to Caller
C       ================
C
        RETURN
        END
      INTEGER FUNCTION ANFIN(DUMMY)
C     =============================
C
C       Description:-
C       =============
C       This Function is used by Analysis_Control
C       to close the standard  databases upon program
C       termination
C       These standard database are:-
C
C       Calibration Database
C       Geometry Database
C       Run Conditions Database
C       TMS Database
C
C       where only those databases used in this program
C       are closed.
C
C       Author:-
C       ========
C       BUILD_JOB Program Version  3.01
C
C       Declarations:-
C       ==============
C
        IMPLICIT NONE
      INTEGER DUMMY
C
C
      INTEGER CHIUDIHEPDB
C
C==== Include /kloe/soft/off/rtdb/production/aix/library/hdberr.cin ====
      INTEGER CESUCC,CEFAIL,CEDBOP,CENOOB
      PARAMETER (CESUCC = 0, CEFAIL = 99999, CEDBOP = -2)
      PARAMETER (CENOOB = 33)
C
      INTEGER ANHCCL
C
C==== Include /kloe/soft/off/a_c/production/aix/library/anerror.cin ====
      INTEGER    ANSUCC
      PARAMETER (ANSUCC = '8198009'X)
      INTEGER    ANBEGN
      PARAMETER (ANBEGN = '8198019'X)
      INTEGER    ANPDUN
      PARAMETER (ANPDUN = '8198021'X)
      INTEGER    ANAST
      PARAMETER (ANAST   = '81980A3'X)
      INTEGER    ANILPS
      PARAMETER (ANILPS = '8198122'X)
      INTEGER    ANILMD
      PARAMETER (ANILMD = '819812A'X)
      INTEGER    ANLSTR
      PARAMETER (ANLSTR = '81980C0'X)
      INTEGER    ANNINI
      PARAMETER (ANNINI = '8198102'X)
      INTEGER    ANOVRF
      PARAMETER (ANOVRF = '819810A'X)
      INTEGER    ANNOME
      PARAMETER (ANNOME = '8198112'X)
      INTEGER    ANNOLU
      PARAMETER (ANNOLU = '819811A'X)
      INTEGER    ANNOEP
      PARAMETER (ANNOEP = '8198011'X)
      INTEGER    ANILGP
      PARAMETER (ANILGP = '8198132'X)
      INTEGER    ANILPA
      PARAMETER (ANILPA = '819813A'X)
      INTEGER    ANILQU
      PARAMETER (ANILQU = '8198142'X)
      INTEGER    ANILSY
      PARAMETER (ANILSY = '819814A'X)
      INTEGER    ANILLU
      PARAMETER (ANILLU = '8198152'X)
      INTEGER    ANILVB
      PARAMETER (ANILVB = '819815A'X)
      INTEGER    ANILLI
      PARAMETER (ANILLI = '8198162'X)
      INTEGER    ANDUMD
      PARAMETER (ANDUMD = '819816A'X)
      INTEGER    ANYBER
      PARAMETER (ANYBER = '8198172'X)
      INTEGER    ANYBFE
      PARAMETER (ANYBFE = '081981B2'X)
      INTEGER    ANEFOP
      PARAMETER (ANEFOP = '819817A'X)
      INTEGER    ANEOF
      PARAMETER (ANEOF = '8198083'X)
      INTEGER    ANIFNO
      PARAMETER (ANIFNO = '819808B'X)
      INTEGER    ANCLOS
      PARAMETER (ANCLOS = '8198093'X)
      INTEGER    ANOFNO
      PARAMETER (ANOFNO = '819809B'X)
      INTEGER    ANNOLR
      PARAMETER (ANNOLR = '8198182'X)
      INTEGER    ANILST
      PARAMETER (ANILST = '819818A'X)
      INTEGER    ANNOEV
      PARAMETER (ANNOEV = '8198192'X)
      INTEGER    ANILBL
      PARAMETER (ANILBL = '819819A'X)
      INTEGER    ANNEIF
      PARAMETER (ANNEIF = '81981A2'X)
      INTEGER    ANNOBK
      PARAMETER (ANNOBK = '81980C8'X)
      INTEGER    ANILBK
      PARAMETER (ANILBK = '81981AA'X)
C
C       Executable Code:-
C       =================
C
      ANFIN = ANSUCC
C
C
C       Close Calibration databases
C       =====================
      IF(ANFIN.EQ.ANSUCC)   THEN
         ANFIN = CHIUDIHEPDB('CALI')
         IF(ANFIN.EQ.CESUCC)   ANFIN=ANSUCC
      ENDIF
C
C       Close Geometry databases
C       =====================
      IF(ANFIN.EQ.ANSUCC)   THEN
         ANFIN = CHIUDIHEPDB('GEOM')
         IF(ANFIN.EQ.CESUCC)   ANFIN=ANSUCC
      ENDIF
C
C       Close Run Conditions databases
C       =====================
      IF(ANFIN.EQ.ANSUCC)   THEN
         ANFIN = CHIUDIHEPDB('RUNC')
         IF(ANFIN.EQ.CESUCC)   ANFIN=ANSUCC
      ENDIF
C
C       Close TMS databases
C       =====================
      IF(ANFIN.EQ.ANSUCC)   THEN
         ANFIN = CHIUDIHEPDB('  TP')
         IF(ANFIN.EQ.CESUCC)   ANFIN=ANSUCC
      ENDIF
C
C       Cleanup (close) HBOOK4 Histogram Files
C       ======================================
C
      IF (ANFIN .EQ. ANSUCC)
     &   ANFIN = ANHCCL(-1)
C
C       Return to Caller
C       ================
C
      IF(ANFIN.NE.ANSUCC)   CALL ANEROR(ANFIN)
      RETURN
      END
C
      SUBROUTINE ANGEN_DEF(TEXT1,TEXT2,TEXT3,INT1,INT2,INT3,DEFTYPE)
C     ==============================================================
C       Description:-
C       =============
C       This Subprogram is called by UIPACK to pass
C       certain definitions to X-Windows subprograms
C
C       Author:-
C       ========
C       BUILD_JOB Program Version  3.01
C
C       Declarations:-
        IMPLICIT NONE
      CHARACTER*(*) TEXT1,TEXT2,TEXT3,DEFTYPE
      INTEGER INT1,INT2,INT3
C
C
C       Executable Code:-
C       =================
C
C
C       Dummy Routine  X-Windows Interface not used
C
      RETURN
      END
C
C
      SUBROUTINE ANGEN_PARS
C     =====================
C       Description:-
C       =============
C       This Subprogram is called by Analysis_Control
C       to start X-Windows Interface
C       Calls ANPARS
C
C       Author:-
C       ========
C       BUILD_JOB Program Version  3.01
C
C       Declarations:-
        IMPLICIT NONE
C
C
C       Executable Code:-
C       =================
C
C
C       Dummy Routine  X-Windows Interface not used
C
      CALL ANPARS
      RETURN
      END
C
      INTEGER FUNCTION ANMDEC(DUMMY)
C     ==============================
C
C       Description:-
C       =============
C       This Subprogram is called by Analysis_Control to
C       declare the Modules in the current Executable
C       Program
C
C       Author:-
C       ========
C       BUILD_JOB Program Version  3.01
C
C       Declarations:-
C       ==============
C
        IMPLICIT NONE
      INTEGER DUMMY
C==== Include /kloe/soft/off/a_c/production/aix/library/anerror.cin ====
      INTEGER    ANSUCC
      PARAMETER (ANSUCC = '8198009'X)
      INTEGER    ANBEGN
      PARAMETER (ANBEGN = '8198019'X)
      INTEGER    ANPDUN
      PARAMETER (ANPDUN = '8198021'X)
      INTEGER    ANAST
      PARAMETER (ANAST   = '81980A3'X)
      INTEGER    ANILPS
      PARAMETER (ANILPS = '8198122'X)
      INTEGER    ANILMD
      PARAMETER (ANILMD = '819812A'X)
      INTEGER    ANLSTR
      PARAMETER (ANLSTR = '81980C0'X)
      INTEGER    ANNINI
      PARAMETER (ANNINI = '8198102'X)
      INTEGER    ANOVRF
      PARAMETER (ANOVRF = '819810A'X)
      INTEGER    ANNOME
      PARAMETER (ANNOME = '8198112'X)
      INTEGER    ANNOLU
      PARAMETER (ANNOLU = '819811A'X)
      INTEGER    ANNOEP
      PARAMETER (ANNOEP = '8198011'X)
      INTEGER    ANILGP
      PARAMETER (ANILGP = '8198132'X)
      INTEGER    ANILPA
      PARAMETER (ANILPA = '819813A'X)
      INTEGER    ANILQU
      PARAMETER (ANILQU = '8198142'X)
      INTEGER    ANILSY
      PARAMETER (ANILSY = '819814A'X)
      INTEGER    ANILLU
      PARAMETER (ANILLU = '8198152'X)
      INTEGER    ANILVB
      PARAMETER (ANILVB = '819815A'X)
      INTEGER    ANILLI
      PARAMETER (ANILLI = '8198162'X)
      INTEGER    ANDUMD
      PARAMETER (ANDUMD = '819816A'X)
      INTEGER    ANYBER
      PARAMETER (ANYBER = '8198172'X)
      INTEGER    ANYBFE
      PARAMETER (ANYBFE = '081981B2'X)
      INTEGER    ANEFOP
      PARAMETER (ANEFOP = '819817A'X)
      INTEGER    ANEOF
      PARAMETER (ANEOF = '8198083'X)
      INTEGER    ANIFNO
      PARAMETER (ANIFNO = '819808B'X)
      INTEGER    ANCLOS
      PARAMETER (ANCLOS = '8198093'X)
      INTEGER    ANOFNO
      PARAMETER (ANOFNO = '819809B'X)
      INTEGER    ANNOLR
      PARAMETER (ANNOLR = '8198182'X)
      INTEGER    ANILST
      PARAMETER (ANILST = '819818A'X)
      INTEGER    ANNOEV
      PARAMETER (ANNOEV = '8198192'X)
      INTEGER    ANILBL
      PARAMETER (ANILBL = '819819A'X)
      INTEGER    ANNEIF
      PARAMETER (ANNEIF = '81981A2'X)
      INTEGER    ANNOBK
      PARAMETER (ANNOBK = '81980C8'X)
      INTEGER    ANILBK
      PARAMETER (ANILBK = '81981AA'X)
C
      INTEGER IM_KID_IN_DEC
      INTEGER prod2ntu_dec
      INTEGER SAMDC
C
C       Executable Code:-
C       =================
C
      ANMDEC = ANSUCC
C
      IF (ANMDEC .EQ. ANSUCC) THEN
         ANMDEC = IM_KID_IN_DEC(DUMMY)
      ENDIF
      IF (ANMDEC .EQ. ANSUCC) THEN
         ANMDEC = prod2ntu_dec(DUMMY)
      ENDIF
      IF (ANMDEC .EQ. ANSUCC) THEN
         ANMDEC = SAMDC(DUMMY)
      ENDIF
C
C       Return to Caller
C       ================
      IF(ANMDEC.NE.ANSUCC)   CALL ANEROR(ANMDEC)
C
      RETURN
      END
      INTEGER FUNCTION prod2ntu_dec(DUMMY)
C     ==============================
C
C       Description:-
C       =============
C       This Function is the Module Declaration
C       Subprogram for Module PROD2NTU. It defines
C       the Module Entrypoints and Characteristics.
C
C       Author:-
C       ========
C       BUILD_JOB Program Version  3.01
C
C       Declarations:-
C       ==============
C
        IMPLICIT NONE
      INTEGER DUMMY
C
C==== Include /kloe/soft/off/a_c/production/aix/library/anerror.cin ====
      INTEGER    ANSUCC
      PARAMETER (ANSUCC = '8198009'X)
      INTEGER    ANBEGN
      PARAMETER (ANBEGN = '8198019'X)
      INTEGER    ANPDUN
      PARAMETER (ANPDUN = '8198021'X)
      INTEGER    ANAST
      PARAMETER (ANAST   = '81980A3'X)
      INTEGER    ANILPS
      PARAMETER (ANILPS = '8198122'X)
      INTEGER    ANILMD
      PARAMETER (ANILMD = '819812A'X)
      INTEGER    ANLSTR
      PARAMETER (ANLSTR = '81980C0'X)
      INTEGER    ANNINI
      PARAMETER (ANNINI = '8198102'X)
      INTEGER    ANOVRF
      PARAMETER (ANOVRF = '819810A'X)
      INTEGER    ANNOME
      PARAMETER (ANNOME = '8198112'X)
      INTEGER    ANNOLU
      PARAMETER (ANNOLU = '819811A'X)
      INTEGER    ANNOEP
      PARAMETER (ANNOEP = '8198011'X)
      INTEGER    ANILGP
      PARAMETER (ANILGP = '8198132'X)
      INTEGER    ANILPA
      PARAMETER (ANILPA = '819813A'X)
      INTEGER    ANILQU
      PARAMETER (ANILQU = '8198142'X)
      INTEGER    ANILSY
      PARAMETER (ANILSY = '819814A'X)
      INTEGER    ANILLU
      PARAMETER (ANILLU = '8198152'X)
      INTEGER    ANILVB
      PARAMETER (ANILVB = '819815A'X)
      INTEGER    ANILLI
      PARAMETER (ANILLI = '8198162'X)
      INTEGER    ANDUMD
      PARAMETER (ANDUMD = '819816A'X)
      INTEGER    ANYBER
      PARAMETER (ANYBER = '8198172'X)
      INTEGER    ANYBFE
      PARAMETER (ANYBFE = '081981B2'X)
      INTEGER    ANEFOP
      PARAMETER (ANEFOP = '819817A'X)
      INTEGER    ANEOF
      PARAMETER (ANEOF = '8198083'X)
      INTEGER    ANIFNO
      PARAMETER (ANIFNO = '819808B'X)
      INTEGER    ANCLOS
      PARAMETER (ANCLOS = '8198093'X)
      INTEGER    ANOFNO
      PARAMETER (ANOFNO = '819809B'X)
      INTEGER    ANNOLR
      PARAMETER (ANNOLR = '8198182'X)
      INTEGER    ANILST
      PARAMETER (ANILST = '819818A'X)
      INTEGER    ANNOEV
      PARAMETER (ANNOEV = '8198192'X)
      INTEGER    ANILBL
      PARAMETER (ANILBL = '819819A'X)
      INTEGER    ANNEIF
      PARAMETER (ANNEIF = '81981A2'X)
      INTEGER    ANNOBK
      PARAMETER (ANNOBK = '81980C8'X)
      INTEGER    ANILBK
      PARAMETER (ANILBK = '81981AA'X)
C==== Include /kloe/soft/off/a_c/production/aix/library/anparam.cin ====
        INTEGER ANMXMD
        PARAMETER (ANMXMD = 255)
        INTEGER ANMXIL
        PARAMETER (ANMXIL = 256)
        INTEGER ANMAGP
        PARAMETER (ANMAGP = 0)
        INTEGER ANMDGP
        PARAMETER (ANMDGP = 1)
        INTEGER ANDEGP
        PARAMETER (ANDEGP = 2)
        INTEGER ANHSGP
        PARAMETER (ANHSGP = 3)
        INTEGER ANOUGP
        PARAMETER (ANOUGP = 4)
        INTEGER ANPAGP
        PARAMETER (ANPAGP = 5)
        INTEGER ANSHGP
        PARAMETER (ANSHGP = 6)
        INTEGER ANTAGP
        PARAMETER (ANTAGP = 7)
        INTEGER ANSTGP
        PARAMETER (ANSTGP = 8)
        INTEGER ANINGP
        PARAMETER (ANINGP = 9)
        INTEGER ANIMGP
        PARAMETER (ANIMGP = 10)
        INTEGER ANOMGP
        PARAMETER (ANOMGP = 11)
        INTEGER ANTMGP
        PARAMETER (ANTMGP = 12)
        INTEGER ANFMGP
        PARAMETER (ANFMGP = 13)
        INTEGER ANEPGP
        PARAMETER (ANEPGP = 14)
        INTEGER ANHEGP
        PARAMETER (ANHEGP = 15)
        INTEGER ANSPGP
        PARAMETER (ANSPGP = 16)
        INTEGER ANMHGP
        PARAMETER (ANMHGP = 17)
        INTEGER ANALGP
        PARAMETER (ANALGP = 18)
        INTEGER ANPSGP
        PARAMETER (ANPSGP = 19)
        INTEGER ANTBGP
        PARAMETER (ANTBGP = 20)
        INTEGER ANCLGP
        PARAMETER (ANCLGP = 21)
        INTEGER    ANFTGP
        PARAMETER (ANFTGP = 22)
        INTEGER    ANBSGP
        PARAMETER (ANBSGP = 23)
        INTEGER    ANRTGP
        PARAMETER (ANRTGP = 24)
        INTEGER ANOPMU
        PARAMETER (ANOPMU = 4)
        INTEGER ANOSMU
        PARAMETER (ANOSMU = 6)
        INTEGER ANIPMU
        PARAMETER (ANIPMU = 7)
        INTEGER ANISMU
        PARAMETER (ANISMU = 8)
        INTEGER    ANRTMU
        PARAMETER (ANRTMU = 24)
        INTEGER    ANMEIN
        PARAMETER (ANMEIN = 0)
        INTEGER    ANMERI
        PARAMETER (ANMERI = 1)
        INTEGER    ANMEEV
        PARAMETER (ANMEEV = 2)
        INTEGER    ANMEOT
        PARAMETER (ANMEOT = 3)
        INTEGER    ANMERF
        PARAMETER (ANMERF = 4)
        INTEGER    ANMEFI
        PARAMETER (ANMEFI = 5)
        INTEGER    ANMETA
        PARAMETER (ANMETA = 6)
        INTEGER    ANMEMI
        PARAMETER (ANMEMI = 7)
        INTEGER    ANMETE
        PARAMETER (ANMETE = 8)
        INTEGER    ANMEBO
        PARAMETER (ANMEBO = 9)
C
      INTEGER ANDMOD,ANDENT,ANDBOO
      INTEGER ANUMOD
      INTEGER ANDFIL
      INTEGER ANDMPA
C
      LOGICAL DONE
C
      EXTERNAL prod2ntu_in
      EXTERNAL prod2ntu_rin
      EXTERNAL prod2ntu_ev
      EXTERNAL prod2ntu_rfi
      EXTERNAL prod2ntu_end
      EXTERNAL prod2ntu_tk
      EXTERNAL prod2ntu_hb
      SAVE DONE
      DATA DONE/.FALSE./
C
C       Executable Code:-
C       =================
C
      prod2ntu_dec = ANSUCC
C
      IF (prod2ntu_dec .EQ. ANSUCC) THEN
         IF(.NOT.DONE)   THEN
            prod2ntu_dec = ANDMOD('PROD2NTU',
     &      'Production to Ntuple ')
            DONE = .TRUE.
         ELSE
            prod2ntu_dec = ANUMOD('PROD2NTU')
         ENDIF
      ENDIF
      IF (prod2ntu_dec .EQ. ANSUCC) THEN
         prod2ntu_dec = ANDFIL(DUMMY)
      ENDIF
      IF (prod2ntu_dec .EQ. ANSUCC) THEN
         prod2ntu_dec = ANDENT(prod2ntu_in,ANMEIN)
      ENDIF
      IF (prod2ntu_dec .EQ. ANSUCC) THEN
         prod2ntu_dec = ANDENT(prod2ntu_rin,ANMERI)
      ENDIF
      IF (prod2ntu_dec .EQ. ANSUCC) THEN
         prod2ntu_dec = ANDENT(prod2ntu_ev,ANMEEV)
      ENDIF
      IF (prod2ntu_dec .EQ. ANSUCC) THEN
         prod2ntu_dec = ANDENT(prod2ntu_rfi,ANMERF)
      ENDIF
      IF (prod2ntu_dec .EQ. ANSUCC) THEN
         prod2ntu_dec = ANDENT(prod2ntu_end,ANMEFI)
      ENDIF
      IF (prod2ntu_dec .EQ. ANSUCC) THEN
         prod2ntu_dec = ANDENT(prod2ntu_tk,ANMETA)
      ENDIF
      IF (prod2ntu_dec .EQ. ANSUCC) THEN
         prod2ntu_dec = ANDBOO(prod2ntu_hb,     0,     0)
      ENDIF
      IF (prod2ntu_dec .EQ. ANSUCC) THEN
         prod2ntu_dec = ANDMPA(  2)
      ENDIF
C
C       Return to Caller
C       ================
C
      RETURN
      END
      INTEGER FUNCTION SAMDC(DUMMY)
C     ==============================
C
C       Description:-
C       =============
C       This Function is the Module Declaration
C       Subprogram for Module SAMPLE. It defines
C       the Module Entrypoints and Characteristics.
C
C       Author:-
C       ========
C       BUILD_JOB Program Version  3.01
C
C       Declarations:-
C       ==============
C
        IMPLICIT NONE
      INTEGER DUMMY
C
C==== Include /kloe/soft/off/a_c/production/aix/library/anerror.cin ====
      INTEGER    ANSUCC
      PARAMETER (ANSUCC = '8198009'X)
      INTEGER    ANBEGN
      PARAMETER (ANBEGN = '8198019'X)
      INTEGER    ANPDUN
      PARAMETER (ANPDUN = '8198021'X)
      INTEGER    ANAST
      PARAMETER (ANAST   = '81980A3'X)
      INTEGER    ANILPS
      PARAMETER (ANILPS = '8198122'X)
      INTEGER    ANILMD
      PARAMETER (ANILMD = '819812A'X)
      INTEGER    ANLSTR
      PARAMETER (ANLSTR = '81980C0'X)
      INTEGER    ANNINI
      PARAMETER (ANNINI = '8198102'X)
      INTEGER    ANOVRF
      PARAMETER (ANOVRF = '819810A'X)
      INTEGER    ANNOME
      PARAMETER (ANNOME = '8198112'X)
      INTEGER    ANNOLU
      PARAMETER (ANNOLU = '819811A'X)
      INTEGER    ANNOEP
      PARAMETER (ANNOEP = '8198011'X)
      INTEGER    ANILGP
      PARAMETER (ANILGP = '8198132'X)
      INTEGER    ANILPA
      PARAMETER (ANILPA = '819813A'X)
      INTEGER    ANILQU
      PARAMETER (ANILQU = '8198142'X)
      INTEGER    ANILSY
      PARAMETER (ANILSY = '819814A'X)
      INTEGER    ANILLU
      PARAMETER (ANILLU = '8198152'X)
      INTEGER    ANILVB
      PARAMETER (ANILVB = '819815A'X)
      INTEGER    ANILLI
      PARAMETER (ANILLI = '8198162'X)
      INTEGER    ANDUMD
      PARAMETER (ANDUMD = '819816A'X)
      INTEGER    ANYBER
      PARAMETER (ANYBER = '8198172'X)
      INTEGER    ANYBFE
      PARAMETER (ANYBFE = '081981B2'X)
      INTEGER    ANEFOP
      PARAMETER (ANEFOP = '819817A'X)
      INTEGER    ANEOF
      PARAMETER (ANEOF = '8198083'X)
      INTEGER    ANIFNO
      PARAMETER (ANIFNO = '819808B'X)
      INTEGER    ANCLOS
      PARAMETER (ANCLOS = '8198093'X)
      INTEGER    ANOFNO
      PARAMETER (ANOFNO = '819809B'X)
      INTEGER    ANNOLR
      PARAMETER (ANNOLR = '8198182'X)
      INTEGER    ANILST
      PARAMETER (ANILST = '819818A'X)
      INTEGER    ANNOEV
      PARAMETER (ANNOEV = '8198192'X)
      INTEGER    ANILBL
      PARAMETER (ANILBL = '819819A'X)
      INTEGER    ANNEIF
      PARAMETER (ANNEIF = '81981A2'X)
      INTEGER    ANNOBK
      PARAMETER (ANNOBK = '81980C8'X)
      INTEGER    ANILBK
      PARAMETER (ANILBK = '81981AA'X)
C==== Include /kloe/soft/off/a_c/production/aix/library/anparam.cin ====
        INTEGER ANMXMD
        PARAMETER (ANMXMD = 255)
        INTEGER ANMXIL
        PARAMETER (ANMXIL = 256)
        INTEGER ANMAGP
        PARAMETER (ANMAGP = 0)
        INTEGER ANMDGP
        PARAMETER (ANMDGP = 1)
        INTEGER ANDEGP
        PARAMETER (ANDEGP = 2)
        INTEGER ANHSGP
        PARAMETER (ANHSGP = 3)
        INTEGER ANOUGP
        PARAMETER (ANOUGP = 4)
        INTEGER ANPAGP
        PARAMETER (ANPAGP = 5)
        INTEGER ANSHGP
        PARAMETER (ANSHGP = 6)
        INTEGER ANTAGP
        PARAMETER (ANTAGP = 7)
        INTEGER ANSTGP
        PARAMETER (ANSTGP = 8)
        INTEGER ANINGP
        PARAMETER (ANINGP = 9)
        INTEGER ANIMGP
        PARAMETER (ANIMGP = 10)
        INTEGER ANOMGP
        PARAMETER (ANOMGP = 11)
        INTEGER ANTMGP
        PARAMETER (ANTMGP = 12)
        INTEGER ANFMGP
        PARAMETER (ANFMGP = 13)
        INTEGER ANEPGP
        PARAMETER (ANEPGP = 14)
        INTEGER ANHEGP
        PARAMETER (ANHEGP = 15)
        INTEGER ANSPGP
        PARAMETER (ANSPGP = 16)
        INTEGER ANMHGP
        PARAMETER (ANMHGP = 17)
        INTEGER ANALGP
        PARAMETER (ANALGP = 18)
        INTEGER ANPSGP
        PARAMETER (ANPSGP = 19)
        INTEGER ANTBGP
        PARAMETER (ANTBGP = 20)
        INTEGER ANCLGP
        PARAMETER (ANCLGP = 21)
        INTEGER    ANFTGP
        PARAMETER (ANFTGP = 22)
        INTEGER    ANBSGP
        PARAMETER (ANBSGP = 23)
        INTEGER    ANRTGP
        PARAMETER (ANRTGP = 24)
        INTEGER ANOPMU
        PARAMETER (ANOPMU = 4)
        INTEGER ANOSMU
        PARAMETER (ANOSMU = 6)
        INTEGER ANIPMU
        PARAMETER (ANIPMU = 7)
        INTEGER ANISMU
        PARAMETER (ANISMU = 8)
        INTEGER    ANRTMU
        PARAMETER (ANRTMU = 24)
        INTEGER    ANMEIN
        PARAMETER (ANMEIN = 0)
        INTEGER    ANMERI
        PARAMETER (ANMERI = 1)
        INTEGER    ANMEEV
        PARAMETER (ANMEEV = 2)
        INTEGER    ANMEOT
        PARAMETER (ANMEOT = 3)
        INTEGER    ANMERF
        PARAMETER (ANMERF = 4)
        INTEGER    ANMEFI
        PARAMETER (ANMEFI = 5)
        INTEGER    ANMETA
        PARAMETER (ANMETA = 6)
        INTEGER    ANMEMI
        PARAMETER (ANMEMI = 7)
        INTEGER    ANMETE
        PARAMETER (ANMETE = 8)
        INTEGER    ANMEBO
        PARAMETER (ANMEBO = 9)
C
      INTEGER ANDMOD,ANDENT,ANDBOO
      INTEGER ANUMOD
      INTEGER ANDFIL
      INTEGER ANDMPA
C
      LOGICAL DONE
C
      EXTERNAL SAMIN
      EXTERNAL SAMRI
      EXTERNAL SAMEV
      EXTERNAL SAMRE
      EXTERNAL SAMTK
      EXTERNAL SAMHB
      SAVE DONE
      DATA DONE/.FALSE./
C
C       Executable Code:-
C       =================
C
      SAMDC = ANSUCC
C
      IF (SAMDC .EQ. ANSUCC) THEN
         IF(.NOT.DONE)   THEN
            SAMDC = ANDMOD('SAMPLE','Selection of events ')
            DONE = .TRUE.
         ELSE
            SAMDC = ANUMOD('SAMPLE')
         ENDIF
      ENDIF
      IF (SAMDC .EQ. ANSUCC) THEN
         SAMDC = ANDFIL(DUMMY)
      ENDIF
      IF (SAMDC .EQ. ANSUCC) THEN
         SAMDC = ANDENT(SAMIN,ANMEIN)
      ENDIF
      IF (SAMDC .EQ. ANSUCC) THEN
         SAMDC = ANDENT(SAMRI,ANMERI)
      ENDIF
      IF (SAMDC .EQ. ANSUCC) THEN
         SAMDC = ANDENT(SAMEV,ANMEEV)
      ENDIF
      IF (SAMDC .EQ. ANSUCC) THEN
         SAMDC = ANDENT(SAMRE,ANMERF)
      ENDIF
      IF (SAMDC .EQ. ANSUCC) THEN
         SAMDC = ANDENT(SAMTK,ANMETA)
      ENDIF
      IF (SAMDC .EQ. ANSUCC) THEN
         SAMDC = ANDBOO(SAMHB,     0,     0)
      ENDIF
      IF (SAMDC .EQ. ANSUCC) THEN
         SAMDC = ANDMPA(  2)
      ENDIF
C
C       Return to Caller
C       ================
C
      RETURN
      END
