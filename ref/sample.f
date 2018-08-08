C==============================================================================
C  SAMPLE
C==============================================================================
C
C  Description:
C  ------------
C  Elena Perez del Rio
C  A_C module to select events with more than 1 and less than 11 prompt
C  clusters in barrel
C  And more than 0 and less than 3 tracks with R_pca < 6 and
C  |z_pca| < 12
C  based in etapi0gg.kloe by P. Gauzzi
C  Language:
C  ---------
C  KLOE Fortran
C
C  Author:
C  -------
C
C
C
C==============================================================================
      SUBROUTINE SAMIN
C==============================================================================
C
C  Description:
C  ------------
C
C==============================================================================
C
        IMPLICIT NONE
C========================= Include sample.cin ==========================
      TYPE NeuRadStructure
      SEQUENCE
      INTEGER  NTwPh
      REAL     T0off
      INTEGER  FlgTW(50)
      LOGICAL  Flg5ph
      LOGICAL  FlgBpos
      END TYPE
      TYPE(NeuRadStructure) NRadStru
      COMMON / sampleHBook / NRadStru
C
C==============================================================================
C
      RETURN
      END
C
C==============================================================================
      SUBROUTINE SAMRI
C==============================================================================
C
C  Description:
C  ------------
C
C==============================================================================
C
        IMPLICIT NONE
C
C=========== Include /kloe/soft/onl/calib/v0/inc/anerror.cin ===========
      INTEGER    ANSUCC
      PARAMETER (ANSUCC = X'8198009')
      INTEGER    ANBEGN
      PARAMETER (ANBEGN = X'8198019')
      INTEGER    ANPDUN
      PARAMETER (ANPDUN = X'8198021')
      INTEGER    ANAST
      PARAMETER (ANAST   = X'81980A3')
      INTEGER    ANILPS
      PARAMETER (ANILPS = X'8198122')
      INTEGER    ANILMD
      PARAMETER (ANILMD = X'819812A')
      INTEGER    ANLSTR
      PARAMETER (ANLSTR = X'81980C0')
      INTEGER    ANNINI
      PARAMETER (ANNINI = X'8198102')
      INTEGER    ANOVRF
      PARAMETER (ANOVRF = X'819810A')
      INTEGER    ANNOME
      PARAMETER (ANNOME = X'8198112')
      INTEGER    ANNOLU
      PARAMETER (ANNOLU = X'819811A')
      INTEGER    ANNOEP
      PARAMETER (ANNOEP = X'8198011')
      INTEGER    ANILGP
      PARAMETER (ANILGP = X'8198132')
      INTEGER    ANILPA
      PARAMETER (ANILPA = X'819813A')
      INTEGER    ANILQU
      PARAMETER (ANILQU = X'8198142')
      INTEGER    ANILSY
      PARAMETER (ANILSY = X'819814A')
      INTEGER    ANILLU
      PARAMETER (ANILLU = X'8198152')
      INTEGER    ANILVB
      PARAMETER (ANILVB = X'819815A')
      INTEGER    ANILLI
      PARAMETER (ANILLI = X'8198162')
      INTEGER    ANDUMD
      PARAMETER (ANDUMD = X'819816A')
      INTEGER    ANYBER
      PARAMETER (ANYBER = X'8198172')
      INTEGER    ANYBFE
      PARAMETER (ANYBFE = X'081981B2')
      INTEGER    ANEFOP
      PARAMETER (ANEFOP = X'819817A')
      INTEGER    ANEOF
      PARAMETER (ANEOF = X'8198083')
      INTEGER    ANIFNO
      PARAMETER (ANIFNO = X'819808B')
      INTEGER    ANCLOS
      PARAMETER (ANCLOS = X'8198093')
      INTEGER    ANOFNO
      PARAMETER (ANOFNO = X'819809B')
      INTEGER    ANNOLR
      PARAMETER (ANNOLR = X'8198182')
      INTEGER    ANILST
      PARAMETER (ANILST = X'819818A')
      INTEGER    ANNOEV
      PARAMETER (ANNOEV = X'8198192')
      INTEGER    ANILBL
      PARAMETER (ANILBL = X'819819A')
      INTEGER    ANNEIF
      PARAMETER (ANNEIF = X'81981A2')
      INTEGER    ANNOBK
      PARAMETER (ANNOBK = X'81980C8')
      INTEGER    ANILBK
      PARAMETER (ANILBK = X'81981AA')
C
C External functions
C
      INTEGER    ANPIST
C
C Local declarations
C
      INTEGER    Status
C
C==============================================================================
C
C Put A_C Error Code to SUCCESS at Run_Init
C
        call inittree()
      Status = ANPIST(ANSUCC)
C
      RETURN
      END
C
C==============================================================================
      SUBROUTINE SAMEV
C==============================================================================
C
        IMPLICIT NONE
C
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
C====== Include /kloe/soft/off/offline/inc/development/oferco.cin ======
      INTEGER    OFSUCC                 
      PARAMETER (OFSUCC = 0)
      INTEGER    OFFAIL                 
      PARAMETER (OFFAIL = 1)
      INTEGER    OFFINF                 
      PARAMETER (OFFINF = 2)
      INTEGER    OFERRE                 
      PARAMETER (OFERRE = 3)            
      INTEGER    OFFEOF                 
      PARAMETER (OFFEOF = 4)
C====== Include /kloe/soft/off/offline/inc/development/jobsta.cin ======
        COMMON /JOBSTI/ NRUN, NEV, NRUNA, NEVA, IBEGRN, IENDRN,
     1                  IUDBUG, NEVP, NEVPR, NEVPA, NREC, NRECF
        INTEGER         NRUN, NEV, NRUNA, NEVA, IBEGRN, IENDRN
        INTEGER         IUDBUG, NEVP, NEVPR, NEVPA, NREC, NRECF
        COMMON /JOBLRI/ EXPTYP, PARTNO, RUNTYP, LRECNO, NRCTHS,
     1                  CDFCID, IRTYPA, VERNUM, RELNUM, CRPRID,
     2                  CRYEAR,  CRMON,  CRDAY,
     3                  CRHOUR,  CRMIN,  CRSEC
        INTEGER         EXPTYP, PARTNO, RUNTYP, LRECNO, NRCTHS
        INTEGER         CDFCID, IRTYPA, VERNUM, RELNUM, CRPRID
        INTEGER         CRYEAR,  CRMON,  CRDAY
        INTEGER         CRHOUR,  CRMIN,  CRSEC
        COMMON /JOBEVC/ TRIGNO, TRGSUM(4),
     1                  STEVTI, SDONET, RPTMOD, RESERV, SOPTYP, SBUFNO,
     2                  SREADO(2), SRESIO(2), CREADO(2), TERSUM(2)
        INTEGER         TRIGNO,    TRGSUM
        INTEGER         STEVTI, SDONET, RPTMOD, RESERV, SOPTYP, SBUFNO
        INTEGER         SREADO,    SRESIO,    CREADO,    TERSUM
        COMMON /JOBSTR/ ROOTS, BMAGNT, BMAGFT, BMAGBT
        REAL            ROOTS, BMAGNT, BMAGFT, BMAGBT
C====== Include /kloe/soft/off/offline/inc/development/runtyp.cin ======
        INTEGER    EXKPHY               
        PARAMETER (EXKPHY       = 0)
        INTEGER    EXCOSR               
        PARAMETER (EXCOSR       = 1)
        INTEGER    EXOFSI               
        PARAMETER (EXOFSI       = 2)
        INTEGER    EXTEST               
        PARAMETER (EXTEST       = 3)
        INTEGER    RUKPHY               
        PARAMETER (RUKPHY       = 1)
        INTEGER    RUCOSR               
        PARAMETER (RUCOSR       = 2)
        INTEGER    RUCALI               
        PARAMETER (RUCALI       = 3)
C=========== Include /kloe/soft/onl/calib/v0/inc/anerror.cin ===========
      INTEGER    ANSUCC
      PARAMETER (ANSUCC = X'8198009')
      INTEGER    ANBEGN
      PARAMETER (ANBEGN = X'8198019')
      INTEGER    ANPDUN
      PARAMETER (ANPDUN = X'8198021')
      INTEGER    ANAST
      PARAMETER (ANAST   = X'81980A3')
      INTEGER    ANILPS
      PARAMETER (ANILPS = X'8198122')
      INTEGER    ANILMD
      PARAMETER (ANILMD = X'819812A')
      INTEGER    ANLSTR
      PARAMETER (ANLSTR = X'81980C0')
      INTEGER    ANNINI
      PARAMETER (ANNINI = X'8198102')
      INTEGER    ANOVRF
      PARAMETER (ANOVRF = X'819810A')
      INTEGER    ANNOME
      PARAMETER (ANNOME = X'8198112')
      INTEGER    ANNOLU
      PARAMETER (ANNOLU = X'819811A')
      INTEGER    ANNOEP
      PARAMETER (ANNOEP = X'8198011')
      INTEGER    ANILGP
      PARAMETER (ANILGP = X'8198132')
      INTEGER    ANILPA
      PARAMETER (ANILPA = X'819813A')
      INTEGER    ANILQU
      PARAMETER (ANILQU = X'8198142')
      INTEGER    ANILSY
      PARAMETER (ANILSY = X'819814A')
      INTEGER    ANILLU
      PARAMETER (ANILLU = X'8198152')
      INTEGER    ANILVB
      PARAMETER (ANILVB = X'819815A')
      INTEGER    ANILLI
      PARAMETER (ANILLI = X'8198162')
      INTEGER    ANDUMD
      PARAMETER (ANDUMD = X'819816A')
      INTEGER    ANYBER
      PARAMETER (ANYBER = X'8198172')
      INTEGER    ANYBFE
      PARAMETER (ANYBFE = X'081981B2')
      INTEGER    ANEFOP
      PARAMETER (ANEFOP = X'819817A')
      INTEGER    ANEOF
      PARAMETER (ANEOF = X'8198083')
      INTEGER    ANIFNO
      PARAMETER (ANIFNO = X'819808B')
      INTEGER    ANCLOS
      PARAMETER (ANCLOS = X'8198093')
      INTEGER    ANOFNO
      PARAMETER (ANOFNO = X'819809B')
      INTEGER    ANNOLR
      PARAMETER (ANNOLR = X'8198182')
      INTEGER    ANILST
      PARAMETER (ANILST = X'819818A')
      INTEGER    ANNOEV
      PARAMETER (ANNOEV = X'8198192')
      INTEGER    ANILBL
      PARAMETER (ANILBL = X'819819A')
      INTEGER    ANNEIF
      PARAMETER (ANNEIF = X'81981A2')
      INTEGER    ANNOBK
      PARAMETER (ANNOBK = X'81980C8')
      INTEGER    ANILBK
      PARAMETER (ANILBK = X'81981AA')
C= Include /kloe/soft/off/offline/inc/development/tls/maxstructdim.cin =
      INTEGER     NeleCluMax
      PARAMETER ( NeleCluMax = 2000 )
      INTEGER     MaxNumClu
      PARAMETER ( MaxNumClu = 100 )
      INTEGER    MaxNumVtx
      PARAMETER (MaxNumVtx = 20)
      INTEGER    MaxNumTrkV
      PARAMETER (MaxNumTrkV = 30)
      INTEGER    MaxNumTrk
      PARAMETER (MaxNumTrk = 100)
      INTEGER    MaxNumDHSP
      PARAMETER (MaxNumDHSP = 1000)
      Integer    nMaxDC
      Parameter (nMaxDC=1500)
      INTEGER    NQihiMax
      PARAMETER (NQihiMax=1000)
      INTEGER    NQcalMax
      PARAMETER (NQcalMax= 32 )
      INTEGER    MaxNumFirstHit
      PARAMETER (MaxNumFirstHit = 300 )
      INTEGER    MaxNtrkGen
      PARAMETER (MaxNtrkGen =50)
      INTEGER    MaxNvtxGen
      PARAMETER (MaxNvTxGen =30)
      integer TriggerElements
      parameter (TriggerElements = 300 )
C== Include /kloe/soft/off/offline/inc/development/tls/emcstruct.cin ===
        TYPE EmcCluster
          SEQUENCE
         INTEGER n
         INTEGER nmc
         REAL    E(MaxNumCLu)
         REAL    T(MaxNumCLu)
         REAL    X(MaxNumCLu)
         REAL    Y(MaxNumCLu)
         REAL    Z(MaxNumCLu)
         REAL    XA(MaxNumCLu)
         REAL    YA(MaxNumCLu)
         REAL    ZA(MaxNumCLu)
         REAL    Xrms(MaxNumCLu)
         REAL    Yrms(MaxNumCLu)
         REAL    Zrms(MaxNumCLu)
         REAL    XArms(MaxNumCLu)
         REAL    YArms(MaxNumCLu)
         REAL    ZArms(MaxNumCLu)
         REAL    Trms(MaxNumClu)
         INTEGER Flag(MaxNumCLu)
         INTEGER npart(MaxNumCLu)
         INTEGER part1(MaxNumCLu)
         INTEGER pid1 (MaxNumClu)
         INTEGER part2(MaxNumCLu)
         INTEGER pid2 (MaxNumClu)
         INTEGER part3(MaxNumCLu)
         INTEGER pid3 (MaxNumClu)
      END TYPE
        TYPE (EmcCluster) CLUSTER
C== Include /kloe/soft/off/offline/inc/development/tls/bposcommon.cin ==
      INTEGER NBMAXBPOS
      PARAMETER (NBMAXBPOS = 18)
      REAL VALUEBPOS(NBMAXBPOS)
      INTEGER NBMAXBMOM
      PARAMETER (NBMAXBMOM = 12)
      REAL VALUEBMOM(NBMAXBMOM)
      COMMON /BPOSBMOM/ ValueBpos,ValueBmom
      REAL  VALUEBENE(6)
      COMMON /BENERGY/VALUEBENE
C== Include /kloe/soft/off/offline/inc/development/tls/bposstruct.cin ==
      TYPE  Bposition
        sequence
        REAL px
        REAL py
        REAL pz
        REAL errpx
        REAL errpy
        REAL errpz
        REAL larpx
        REAL elarpx
        REAL larpy
        REAL elarpy
        REAL larpz
        REAL elarpz
        REAL x
        REAL y
        REAL z
        REAL errX
        REAL errY
        REAL errz
        REAL lumx
        REAL elumx
        REAL lumz
        REAL elumz
        REAL Ene
        REAL ErrEne
        REAL Dum1
        REAL ErrDum1
        REAL Dum2
        REAL ErrDum2
      END TYPE
      TYPE (Bposition) BPOS
C== Include /kloe/soft/off/offline/inc/development/tls/tclostruct.cin ==
      INTEGER NTCLOMax
      PARAMETER (NTCLOMax = 40)
      TYPE TrackCluster
        SEQUENCE
         INTEGER nt
         INTEGER verver(NTCLOMax)
         INTEGER trknum(NTCLOMax)
         INTEGER clunum(NTCLOMax)
         REAL    xext(NTCLOMax)
         REAL    yext(NTCLOMax)
         REAL    zext(NTCLOMax)
         REAL    leng(NTCLOMax)
         REAL    chi(NTCLOMax)
         REAL    px(NTCLOmax)
         REAL    py(NTCLOmax)
         REAL    pz(NTCLOmax)
      END TYPE
      TYPE(TrackCluster) TCLO
C=== Include /kloe/soft/off/offline/inc/development/tls/eclsstru.cin ===
      INTEGER MaxNumOverlapStream
      PARAMETER (MaxNumOverlapStream = 8)       
      TYPE ECLSStru
        SEQUENCE
          INTEGER  n
          INTEGER  Trigger
          INTEGER  Filfo
          INTEGER  totword(MaxNumOverlapStream)
          INTEGER  stream(MaxNumOverlapStream)
          INTEGER  tagnum(MaxNumOverlapStream)
          INTEGER  evntyp(MaxNumOverlapStream)
          INTEGER  n2
          INTEGER  Trigger2
          INTEGER  Filfo2
          INTEGER  totword2(MaxNumOverlapStream)
          INTEGER  stream2(MaxNumOverlapStream)
          INTEGER  tagnum2(MaxNumOverlapStream)
          INTEGER  evntyp2(MaxNumOverlapStream)
        END TYPE
      TYPE (ECLSStru) ECLS
C Include /kloe/soft/off/offline/inc/development/tls/getdtfsstruct.cin =
        TYPE AllextendedTracks
        SEQUENCE
         INTEGER ndtfs
         INTEGER trkind(MaxNumTrk)
         INTEGER version(MaxNumTrk)
         REAL    cur(MaxNumtrk)
         REAL    phi(MaxNumTrk)
         REAL    cot(MaxNumTrk)
         REAL    px(MaxNumTrk)
         REAL    py(MaxNumTrk)
         REAL    pz(MaxNumTrk)
         REAL    Pmod(MaxNumTrk)
         REAL    x(MaxNumTrk)
         REAL    y(MaxNumTrk)
         REAL    z(MaxNumTrk)
         REAL    Length(MaxNumTrk)
         REAL    curlast(MaxNumTrk)
         REAL    philast(MaxNumTrk)
         REAL    cotlast(MaxNumTrk)
         REAL    pxlast(MaxNumTrk)
         REAL    pylast(MaxNumTrk)
         REAL    pzlast(MaxNumTrk)
         REAL    Pmodlast(MaxNumTrk)
         REAL    xlast (MaxNumTrk)
         REAL    ylast (MaxNumTrk)
         REAL    zlast (MaxNumTrk)
         REAL    xpca  (MaxNumTrk)
         REAL    ypca  (MaxNumTrk)
         REAL    zpca  (MaxNumTrk)
         REAL    Qtrk  (MaxNumTrk)
         REAL    CotPca(MaxNumTrk)
         REAL    PhiPca(MaxNumTrk)
         INTEGER NumPRhit(MaxNumTrk)
         INTEGER NumFitHit(MaxNumTrk)
         REAL    CHI2FIT(MaxNumTrk)
         REAL    CHI2MS(MaxNumTrk)
         INTEGER NMSkink(MaxNumTrk)
         REAL    Cov(15,MaxNumTrk)      
        END TYPE
        TYPE (AllextendedTracks) DTFS
C========================= Include sample.cin ==========================
      TYPE NeuRadStructure
      SEQUENCE
      INTEGER  NTwPh
      REAL     T0off
      INTEGER  FlgTW(50)
      LOGICAL  Flg5ph
      LOGICAL  FlgBpos
      END TYPE
      TYPE(NeuRadStructure) NRadStru
      COMMON / sampleHBook / NRadStru
C
C External functions
C
      INTEGER    ANGIST, ANGOHS, ANGPAR, anptrg
      INTEGER    GetCluStru, TrkV2Stru, gettclostru, getbpos, getdtfsstr
     &u
      INTEGER    getecls
      REAL       VMOD, VDOTN, VDIST, SQRT
C
C Local declarations
C
      INTEGER    Status, InStat, ntwph, parset, TWCluNumb(50), iloop, is
     &tat
      INTEGER    IClu, recover_splitting,   MinHisId, MaxHisId, iphtw
      INTEGER    trgwrd, iecls
      REAL       t0_gl_nr, RClu, TimWind, Tdif
      REAL       CluVar(5,50), rclu_xy
      REAL       Tcut, VLight
      real       tres_a_bar,tres_a_ec,tres_b_bar,tres_b_ec
      real       CluVarTw(10,50)
      parameter( tres_a_bar=.055 )
      parameter( tres_a_ec=.06 )
      parameter( tres_b_bar=.140 )
      parameter( tres_b_ec=.140 )
      real       Eclu_min, ThetaClu, ThetaClu_min
      parameter( Eclu_min=10. )
      PARAMETER( Vlight = 29.979 )
      parameter( ThetaClu_min = 23.)
      REAL       PI
      INTEGER    IDtfs  
      real       vxy_dtfs
      real       vz_dtfs
      integer    num_good_tracks
      integer bb
      real       newt0find
      LOGICAL    isph, istrk, hisflg,mcflag
      Integer trgwrd1,trgwrd2,numdhit
      common /trgcom/trgwrd1,trgwrd2,numdhit
      common/elena/ bb
C      common /ijk/ ii, jj, kk
C=============================================================================
C
      bb=nrun
C      write(*,*)'FORTRAN',bb
      PI = 4.D0*DATAN(1.D0)
      istat =  getbpos( Bpos )
C Simulation
      IF( exptyp.eq.exofsi )then 
         mcflag = .true.
      else
         mcflag = .false.
      endif
      isph=.FALSE.
      istrk=.FALSE.
      NRadStru%flg5ph=.false.
      NRadStru%flgBpos=.true.   
      nradstru%ntwph = 0
      bpos%x = valuebpos(1)
      bpos%y = valuebpos(2)
      bpos%z = valuebpos(3)
      bpos%erry = valuebpos(5)
      bpos%lumx = valuebpos(7)
      bpos%lumz = valuebpos(9)
      bpos%ene = valuebene(1)
      if(bpos%x.eq.666)then
         NRadStru%flgBpos=.false.               
         goto 999
      endif
C
C IF ANPACK is set to ANYBER (i.e.
      Status = ANGIST(InStat)         
C YBos ERror), skip the event routine
      IF( InStat.EQ.ANYBER ) RETURN   
      CALL NRadStruReset
      CALL VZERO(TWCluNumb,50)
C
C Get clusters and tracks info from TLS functions
C
C Calorimeter clusters info
      Status = GetCluStru(Cluster)     
      status=recover_splitting(cluster)
C If MC check trigger filfo and event classification
      if(mcflag)then
         if(iand(trgwrd1,128).ne.128)goto 999
      end if
C event classification
C Event Classification info
      status = getecls(ecls)           
      if(iand(ecls%filfo,33554432).ne.33554432.and.iand(ecls%filfo2
     $        ,33554432).ne.33554432)goto 999
      do iecls=1,ecls%n
         if((ecls%stream(iecls).eq.3).or.(ecls%stream(iecls).eq.6))
C         if((ecls%stream(iecls).eq.6))
     $         goto 888
      end do
      do iecls=1,ecls%n2
         if((ecls%stream2(iecls).eq.3).or.(ecls%stream2(iecls).eq.6))
C         if((ecls%stream2(iecls).eq.6))
     $         goto 888
      end do
      goto 999
 888  if(nrun.lt.76020)then
        t0_gl_nr=0.
      else
        t0_gl_nr=newt0find()    
      end if
      NRadStru%t0off = t0_gl_nr
C
      num_good_tracks = 0
      status = getdtfsstru(dtfs)
      do IDtfs = 1, dtfs%ndtfs
         if((dtfs%xpca(IDtfs).eq.0).and.(dtfs%ypca(IDtfs).eq.0).and.
     $      (dtfs%zpca(IDtfs).eq.0))then
            goto 999
         endif
C
         vxy_dtfs = sqrt(dtfs%xpca(IDtfs)**2 + dtfs%ypca(IDtfs)**2)
         vz_dtfs = dtfs%zpca(IDtfs)
         if((vxy_dtfs.lt.6).and.(ABS(vz_dtfs).lt.12))then
                num_good_tracks  = num_good_tracks + 1
         endif
      enddo
      if((num_good_tracks.gt.1))then
         istrk=.TRUE.
      else
         goto 999
      endif
C      write(*,*)'DTFS ',dtfs%ndtfs
C
C Get clusters in Time Window
C     Since recover_splitting doesn't change the cluster number, but just sets
C     to zero the variables of the cluster remerged, check that E>0
C
         DO IClu = 1,Cluster%N
            NRadStru%flgtw(iclu)=0
            if(cluster%e(iclu).gt.0.)then
               CluVar(1,IClu) = Cluster%E(IClu)
               CluVar(2,IClu) = Cluster%X(IClu) - bpos%x
               CluVar(3,IClu) = Cluster%Y(IClu) - bpos%y
               CluVar(4,IClu) = Cluster%Z(IClu) - bpos%z
               CluVar(5,IClu) = Cluster%T(IClu) - t0_gl_nr
C
               RClu = SQRT( Cluvar(2,IClu)**2 +
     &              Cluvar(3,IClu)**2 + Cluvar(4,IClu)**2 )
               rclu_xy = SQRT( Cluvar(2,IClu)**2 +
     &              Cluvar(3,IClu)**2 )
               Tdif = CluVar(5,IClu) - RClu/Vlight
               IF( rclu_xy.GT.200. )THEN
                  timwind=sqrt((tres_a_bar*sqrt(1.e3/cluvar(1,iclu)))**2
     $                 +tres_b_bar**2)
               else if( rclu_xy.LT.200. )THEN
                  timwind=sqrt((tres_a_ec*sqrt(1.e3/cluvar(1,iclu)))**2
     $                 +tres_b_ec**2)
               endif
               ThetaClu = (180./PI)*(acos(CluVar(4,IClu)/RClu))
               timwind=min(5.*timwind,2.)
C
C               IF( ABS(Tdif).LT.TimWind )THEN
               IF( (ABS(Tdif).LT.TimWind).and.
     $              (Cluster%E(IClu).gt.Eclu_min).and.
     $              (ThetaClu.gt.ThetaClu_min).and.
     $              (ThetaClu.lt.(180-ThetaClu_min)) )THEN
C
                  Nradstru%Ntwph = Nradstru%Ntwph + 1
                  NRadStru%flgtw(iclu)=1
                  TWCluNumb(NRadStru%NTwPh) = IClu
                  CluVarTw(1,NRadStru%NTwPh) = Cluvar(1,IClu)
                  CluVarTw(2,NRadStru%NTwPh) = Cluvar(2,IClu)
                  CluVarTw(3,NRadStru%NTwPh) = Cluvar(3,IClu)
                  CluVarTw(4,NRadStru%NTwPh) = Cluvar(4,IClu)
                  CluVarTw(5,NRadStru%NTwPh) = Cluvar(5,iclu)
               ENDIF
            endif
         ENDDO
C
         IF( (Nradstru%Ntwph.GT.1).and.(Nradstru%Ntwph.LT.5) )then
            isph = .true.
            NRadStru%flg5ph=.true.
         ENDIF
C=============================================================
        isph = .TRUE.
        istrk =.TRUE.
         if(isph.and.istrk)then
            call fillntu()      
            Status = ANGOHS('PROD2NTU',HisFlg,MinHisId,MaxHisId)
            IF( Status.NE.ANSUCC )THEN
               CALL ERLOGR('SAMEV',ERWARN,0,Status,
     &              'Error getting HBook info for PROD2NTU module')
            ELSE
               IF( HisFlg )THEN
                  ParSet = ANGPAR()
                  IF( ParSet.EQ.1 )THEN
                     CALL HCDir('//PAWC/PROD2NTU',' ')
                     CALL HFNT(1)
                  ENDIF
               ENDIF
            ENDIF
         end if
      status=anptrg(isph)
      status=anptrg(istrk)
 999  continue
C
      RETURN
      END
C
C==============================================================================
      SUBROUTINE SAMRE
C==============================================================================
C
        IMPLICIT NONE
C
C==============================================================================
C
      RETURN
      END
C
C==============================================================================
      SUBROUTINE SAMHB
C==============================================================================
C
        IMPLICIT NONE
C
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
C=========== Include /kloe/soft/onl/calib/v0/inc/anerror.cin ===========
      INTEGER    ANSUCC
      PARAMETER (ANSUCC = X'8198009')
      INTEGER    ANBEGN
      PARAMETER (ANBEGN = X'8198019')
      INTEGER    ANPDUN
      PARAMETER (ANPDUN = X'8198021')
      INTEGER    ANAST
      PARAMETER (ANAST   = X'81980A3')
      INTEGER    ANILPS
      PARAMETER (ANILPS = X'8198122')
      INTEGER    ANILMD
      PARAMETER (ANILMD = X'819812A')
      INTEGER    ANLSTR
      PARAMETER (ANLSTR = X'81980C0')
      INTEGER    ANNINI
      PARAMETER (ANNINI = X'8198102')
      INTEGER    ANOVRF
      PARAMETER (ANOVRF = X'819810A')
      INTEGER    ANNOME
      PARAMETER (ANNOME = X'8198112')
      INTEGER    ANNOLU
      PARAMETER (ANNOLU = X'819811A')
      INTEGER    ANNOEP
      PARAMETER (ANNOEP = X'8198011')
      INTEGER    ANILGP
      PARAMETER (ANILGP = X'8198132')
      INTEGER    ANILPA
      PARAMETER (ANILPA = X'819813A')
      INTEGER    ANILQU
      PARAMETER (ANILQU = X'8198142')
      INTEGER    ANILSY
      PARAMETER (ANILSY = X'819814A')
      INTEGER    ANILLU
      PARAMETER (ANILLU = X'8198152')
      INTEGER    ANILVB
      PARAMETER (ANILVB = X'819815A')
      INTEGER    ANILLI
      PARAMETER (ANILLI = X'8198162')
      INTEGER    ANDUMD
      PARAMETER (ANDUMD = X'819816A')
      INTEGER    ANYBER
      PARAMETER (ANYBER = X'8198172')
      INTEGER    ANYBFE
      PARAMETER (ANYBFE = X'081981B2')
      INTEGER    ANEFOP
      PARAMETER (ANEFOP = X'819817A')
      INTEGER    ANEOF
      PARAMETER (ANEOF = X'8198083')
      INTEGER    ANIFNO
      PARAMETER (ANIFNO = X'819808B')
      INTEGER    ANCLOS
      PARAMETER (ANCLOS = X'8198093')
      INTEGER    ANOFNO
      PARAMETER (ANOFNO = X'819809B')
      INTEGER    ANNOLR
      PARAMETER (ANNOLR = X'8198182')
      INTEGER    ANILST
      PARAMETER (ANILST = X'819818A')
      INTEGER    ANNOEV
      PARAMETER (ANNOEV = X'8198192')
      INTEGER    ANILBL
      PARAMETER (ANILBL = X'819819A')
      INTEGER    ANNEIF
      PARAMETER (ANNEIF = X'81981A2')
      INTEGER    ANNOBK
      PARAMETER (ANNOBK = X'81980C8')
      INTEGER    ANILBK
      PARAMETER (ANILBK = X'81981AA')
C========================= Include sample.cin ==========================
      TYPE NeuRadStructure
      SEQUENCE
      INTEGER  NTwPh
      REAL     T0off
      INTEGER  FlgTW(50)
      LOGICAL  Flg5ph
      LOGICAL  FlgBpos
      END TYPE
      TYPE(NeuRadStructure) NRadStru
      COMMON / sampleHBook / NRadStru
C
C
C External functions
C
      INTEGER    ANGOHS
C
C Local declarations
C
      INTEGER    Status, MinHisId, MaxHisId
      INTEGER    NtuId
      LOGICAL    HisFlg
C
C==============================================================================
C
      Status = ANGOHS('PROD2NTU',HisFlg,MinHisId,MaxHisId)
      IF( Status.NE.ANSUCC )THEN
         CALL ERLOGR('5GAMHB',ERWARN,0,Status,
     &        'Error getting HBook info for prod2ntu module')
      ELSE
         IF( HisFlg )THEN
C
            NtuId = 1
            CALL HCDir('//PAWC/PROD2NTU',' ')
C
C            CALL HBName(NtuId,'5GAM',NRadStru%T0off,'T0off:r')
            CALL HBName(NtuId,'5GAM',NRadStru%flgBpos,'flgBpos:l')
            CALL HBName(NtuId,'5GAM',NRadStru%flg5ph,'flg5ph:l')
C            CALL HBName(NtuId,'5GAM',NRadStru%flgtw,'flgtw(50):i')
         ELSE
            CALL ERLOGR('SAMHB',ERWARN,0,0,
     &           'prod2ntu ntuple not active')
         ENDIF
      ENDIF
C
      RETURN
      END
C
C==============================================================================
      SUBROUTINE SAMTK
C==============================================================================
C
C  Description:
C  ------------
C
C==============================================================================
C
        IMPLICIT NONE
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
C=== Include /kloe/soft/off/s_i/production/aix/library/noarginc.cin ====
      EXTERNAL   N$A
      INTEGER    SIMSAR
      PARAMETER (SIMSAR = 0)            
C========================= Include sample.cin ==========================
      TYPE NeuRadStructure
      SEQUENCE
      INTEGER  NTwPh
      REAL     T0off
      INTEGER  FlgTW(50)
      LOGICAL  Flg5ph
      LOGICAL  FlgBpos
      END TYPE
      TYPE(NeuRadStructure) NRadStru
      COMMON / sampleHBook / NRadStru
C
C External functions
C
      INTEGER   UIDFFI, UIUSGP, UIACME, UIGTYE
C
C Local declarations
C
      INTEGER   Status, MENUF, MENUL, IGROUP
      CHARACTER Verb*40, Prompt*100
C
C==============================================================================
C
      Status=UIDFFI(
     $'$SAMPLE/sample.uid'
     $,IGROUP,MENUF,N$A,N$A,MENUL,N$A )
      Status = UIUSGP(IGROUP,N$A)
C Display menu
 10   Status = UIACME(MENUF,Verb,N$A) 
C
      if(verb.eq.'SHOW')then
         goto 10
      end if
      RETURN
      END
C
C==============================================================================
      SUBROUTINE NRadStruReset
C==============================================================================
C
        IMPLICIT NONE
C
C========================= Include sample.cin ==========================
      TYPE NeuRadStructure
      SEQUENCE
      INTEGER  NTwPh
      REAL     T0off
      INTEGER  FlgTW(50)
      LOGICAL  Flg5ph
      LOGICAL  FlgBpos
      END TYPE
      TYPE(NeuRadStructure) NRadStru
      COMMON / sampleHBook / NRadStru
C
      INTEGER    ILoop
C
C==============================================================================
C
      NRadStru%NTwPh        = 0
      NRadStru%T0off        = 0.
      do iloop=1,50
         NRadStru%flgtw(iloop)=2
      end do
      return
      end
