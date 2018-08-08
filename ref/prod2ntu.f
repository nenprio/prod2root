C---------------------------------------------------------------------
C   ------------  KLOE PRODuction 2(to) NTUple  -----------------------
C-----------------------------------------------------------------------
C PROD2NTU :== trasform all Element/Segment/Fit level to a Ntuple;
C ----------------------------------------------------------------
C Description:
C ============
C Version 1.0
C ------------
C     The usage of CWN is a reasonable "intermediate" stage for DSTs
C     production.
C     In this module I tried "hard" to give a possible translation at a
C     ntuplelevel of the relevant information for MC, calorimeter and
C     track-to-cluster association. Still missing is the translation for
C     tracks-link to MC,First Hits, Neutral vertex and Global Fit.
C     If a "common" effort is done in pursuing this final "goal" this
C     Ntuple can be used at production level both as a monitor and as a
C     preliminar stage into the analysis.
C     I also like to remark that all the Unpacking routines called are
C     nicely existing StandAlone without any intermediate stage of
C     common blocks.This COULD HELP AVOIDING the unbelievable
C     proliferation of Cblocks inthe Offline areas to reduce it only at
C     the useful comunication Common block for PAW.
C
C Precondition Necessary before calling
C -------------------------------------
C None
C
C Author:
C -------
C S.Miscetti
C Jan-1996
C
C Version 2.1
C -----------
C     Well, it looks like the idea is succesfull. Many people have
C     contributed to extend/enlarge/modify the N-tuple. All students
C     seem to like it/use it. I am now proceeding toward the last
C     changes useful for runI:
C     - make it working both on data/mc just relying on LRID info. Do
C        not fill mc information whenever not necessary.
C     - add EventInfo by LRID/EVCL and an extended TRIGGER block.
C     - add a simple talk-to to modify the "wanted" block. No selection
C       available inside the block. Each analysis should keep the "wanted"
C       selection in order to chain n-tuples in an easy way.
C     - move then structures to types to make it available on all
C       machines
C
C     S.Miscetti
C     15-jan-1999
C
C CVS revision History:
C ----------------------
C $Log: prod2ntu.kloe,v $
C Revision 1.16  2015/02/23 13:27:00  kloe
C Added QCALT and CCALT block.
C
C Revision 1.15  2003/05/19 16:58:29  miscetti
C Adding Virmom + Fixing FlagCl  and NeV
C
C Revision 1.14  2003/04/04 15:24:13  kloe
C Add dE/dx
C
C Revision 1.13  2002/11/07 16:20:05  kloe
C
C adding DC dedx block in ntupla
C
C Call gettrigger for MC events
C
C Revision 1.12  2002/10/21 11:36:16  miscetti
C Adding new blocks from charged Kaons grop
C
C Revision 1.11  2002/01/24 13:41:07  miscetti
C missing parenthesys fixed
C
C Revision 1.10  2002/01/24 13:31:40  miscetti
C VerVer + tphased_mc added
C
C Revision 1.9  2001/10/26 10:06:22  miscetti
C PROD2NTU V3 - CSPS CLUO BENE
C
C Revision 1.7  2001/01/26 17:32:54  miscetti
C Fixing triggerelements range in Pizzetta/Tellina
C
C-----------------------------------------------------------------------
C
C-----------------------------------------------------------------------
      SUBROUTINE prod2ntu_In
C-----------------------------------------------------------------------
C Initialization stage:
C Just decide Ntuple # and Ntuple Title
C-----------------------------------------------------------------------
        IMPLICIT NONE
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
C== Include /kloe/soft/off/offline/inc/development/trg/maxtrgchan.cin ==
      integer maxtrgchan
      parameter (maxtrgchan=300)
C== Include /kloe/soft/off/offline/inc/development/tls/evtstruct.cin ===
        TYPE EventInfo
        SEQUENCE
          INTEGER RunNumber
          INTEGER EventNumber
          INTEGER McFlag
          INTEGER EvFlag
          INTEGER Pileup
          INTEGER GenCod
          INTEGER PhiDecay
          INTEGER A1type
          INTEGER A2type
          INTEGER A3type
          INTEGER B1type
          INTEGER B2type
          INTEGER B3type
          INTEGER T3DOWN
          INTEGER T3FLAG
          REAL ECAP(2)
          REAL DCNOISE(4)
        END TYPE
        Integer len_eventinfostru
        Parameter (len_eventinfostru=21)
        TYPE (EventInfo) INFO
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
C== Include /kloe/soft/off/offline/inc/development/tls/celestruct.cin ==
      TYPE  EmcCells
        sequence
         INTEGER n
         INTEGER nmc
         INTEGER ICL(NeleCluMax)
         INTEGER ibcel(NeleCluMax)
         INTEGER DET(NeleCluMax)
         INTEGER WED(NeleCluMax)
         INTEGER PLA(NeleCluMax)
         INTEGER COL(NeleCluMax)
         REAL    E(NeleCluMax)
         REAL    T(NeleCluMax)
         REAL    X(NeleCluMax)
         REAL    Y(NeleCluMax)
         REAL    Z(NeleCluMax)
         REAL    EA(NeleCluMax)
         REAL    TA(NeleCluMax)
         REAL    EB(NeleCluMax)
         REAL    TB(NeleCluMax)
         REAL    Etrue(NeleCluMax)
         REAL    Ttrue(NeleCluMax)
         REAL    Xtrue(NeleCluMax)
         REAL    Ytrue(NeleCluMax)
         REAL    Ztrue(NeleCluMax)
         INTEGER ptyp (neleclumax)
         INTEGER knum (neleclumax)
         INTEGER numpar(neleclumax)
      END TYPE
      TYPE (EmcCells) CELE
C=== Include /kloe/soft/off/offline/inc/development/tls/vtxstru.cin ====
        TYPE Vertex
         SEQUENCE
         INTEGER n
         INTEGER Ntrk(MaxNumvtx)
         REAL    X(MaxNumVtx)
         REAL    Y(MaxNumVtx)
         REAL    Z(MaxNumVtx)
         REAL    COV1(MaxNumVtx)
         REAL    COV2(MaxNumVtx)
         REAL    COV3(MaxNumVtx)
         REAL    COV4(MaxNumVtx)
         REAL    COV5(MaxNumVtx)
         REAL    COV6(MaxNumVtx)
         REAL    CHI2(MaxNumVtx)
         INTEGER QUAL(MaxNumVtx)
         INTEGER FITID(MaxNumVtx)
        END TYPE
        TYPE (Vertex) VTX
        TYPE TracksVertex
         SEQUENCE
         INTEGER n
         INTEGER iv(MaxNumtrkv)
         INTEGER TrkPoi(MaxNumtrkv)
         REAL    cur(MaxNumtrkv)
         REAL    phi(MaxNumtrkv)
         REAL    cot(MaxNumtrkv)
         REAL    px(MaxNumtrkv)
         REAL    py(MaxNumtrkv)
         REAL    pz(MaxNumtrkv)
         REAL    pmod(MaxNumtrkv)
         REAL    Length(MaxNumtrkv)
         REAL    CHI2(MaxNumTrkV)
         INTEGER ipid(MaxNumtrkv)
         REAL cov11(MaxNumTrkV)
         REAL cov12(MaxNumTrkV)
         REAL cov13(MaxNumTrkV)
         REAL cov22(MaxNumTrkV)
         REAL cov23(MaxNumTrkV)
         REAL cov33(MaxNumTrkV)
        END TYPE
        TYPE (TracksVertex) TRKV
C=== Include /kloe/soft/off/offline/inc/development/tls/trkstru.cin ====
        TYPE AllTracks
        SEQUENCE
         INTEGER n
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
         REAL    SigPCA(MaxNumTrk)
         REAL    SigZeta(MaxNumTrk)
         REAL    SigCurv(MaxNumTrk)
         REAL    SigCot(MaxNumTrk)
         REAL    SigPhi(MaxNumTrk)
         INTEGER NMSkink(MaxNumTrk)
        END TYPE
        TYPE (AllTracks) TRK
        TYPE AllTracksMC
        SEQUENCE
         INTEGER n
         INTEGER ncontr(MaxNumTrk)
         INTEGER kine1(MaxNumTrk)
         INTEGER type1(MaxNumTrk)
         INTEGER hits1(MaxNumTrk)
         INTEGER kine2(MaxNumTrk)
         INTEGER type2(MaxNumTrk)
         INTEGER hits2(MaxNumTrk)
         INTEGER kine3(MaxNumTrk)
         INTEGER type3(MaxNumTrk)
         INTEGER hits3(MaxNumTrk)
         REAL xfirst(MaxNumTrk)
         REAL yfirst(MaxNumTrk)
         REAL zfirst(MaxNumTrk)
         REAL pxfirst(MaxNumTrk)
         REAL pyfirst(MaxNumTrk)
         REAL pzfirst(MaxNumTrk)
         REAL xlast(MaxNumTrk)
         REAL ylast(MaxNumTrk)
         REAL zlast(MaxNumTrk)
         REAL pxlast(MaxNumTrk)
         REAL pylast(MaxNumTrk)
         REAL pzlast(MaxNumTrk)
         REAL xmcfirst(MaxNumTrk)
         REAL ymcfirst(MaxNumTrk)
         REAL zmcfirst(MaxNumTrk)
         REAL pxmcfirst(MaxNumTrk)
         REAL pymcfirst(MaxNumTrk)
         REAL pzmcfirst(MaxNumTrk)
         REAL xmclast(MaxNumTrk)
         REAL ymclast(MaxNumTrk)
         REAL zmclast(MaxNumTrk)
         REAL pxmclast(MaxNumTrk)
         REAL pymclast(MaxNumTrk)
         REAL pzmclast(MaxNumTrk)
        END TYPE
        TYPE (AllTracksMC) TRKMC
C= Include /kloe/soft/off/offline/inc/development/tls/dprs_struct.cin ==
      Integer           MAX_DPRS
      Parameter        (MAX_DPRS = 200)
      Type DPRS_TYPE
        Sequence
        Integer
     &      NDPRS,
     &      NVIEW(3)
        Integer
     &      IDPRS(MAX_DPRS),
     &      VERS(MAX_DPRS),
     &      NPOS(MAX_DPRS),
     &      NNEG(MAX_DPRS)
        Real
     &      XPCA(MAX_DPRS),
     &      YPCA(MAX_DPRS),
     &      ZPCA(MAX_DPRS),
     &      XLST(MAX_DPRS),
     &      YLST(MAX_DPRS),
     &      ZLST(MAX_DPRS),
     &      CURP(MAX_DPRS),
     &      PHIP(MAX_DPRS),
     &      COTP(MAX_DPRS),
     &      QUAL(MAX_DPRS)
        Integer
     &      IPFL(MAX_DPRS),
     &      KINE(MAX_DPRS),
     &      NHKINE(MAX_DPRS)
      End Type
      TYPE (DPRS_TYPE)
     &    DPRS
      Character*(*)     DPRS_NTP_STR
      Parameter        (DPRS_NTP_STR =
     &    'nDPRS[0,200]:U,'//
     &    'nView(3):U:8,'//
     &    'iDPRS(nDPRS):U:8,'//
     &    'DPRSver(nDPRS):U:8,'//
     &    'nPos(nDPRS):U:8,'//
     &    'nNeg(nDPRS):U:8,'//
     &    'xPCA(nDPRS):R,'//
     &    'yPCA(nDPRS):R,'//
     &    'zPCA(nDPRS):R,'//
     &    'xLst(nDPRS):R,'//
     &    'yLst(nDPRS):R,'//
     &    'zLst(nDPRS):R,'//
     &    'curP(nDPRS):R,'//
     &    'phiP(nDPRS):R,'//
     &    'cotP(nDPRS):R,'//
     &    'qual(nDPRS):R,'//
     &    'IPFl(nDPRS):U:4,'//
     &    'prKINE(nDPRS):U:8,'//
     &    'prKHIT(nDPRS):U:8')
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
C== Include /kloe/soft/off/offline/inc/development/tls/cfhistruct.cin ==
        TYPE emcfirsthit
        SEQUENCE
        integer n
        integer pid(maxnumfirsthit)
        integer kinum(maxnumfirsthit)
        integer celadr(maxnumfirsthit)
        integer convfl(maxnumfirsthit)
        real    time(maxnumfirsthit)
        real    x(maxnumfirsthit)
        real    y(maxnumfirsthit)
        real    z(maxnumfirsthit)
        real    px(maxnumfirsthit)
        real    py(maxnumfirsthit)
        real    pz(maxnumfirsthit)
        real    tof(maxnumfirsthit)
        real    tlen(maxnumfirsthit)
        END TYPE
        TYPE (emcfirsthit) cfhi
C= Include /kloe/soft/off/offline/inc/development/tls/geanfistruct.cin =
        TYPE GeanfiInformation
         SEQUENCE
         INTEGER Ntrk
         INTEGER kin(maxNtrkGen)
         INTEGER Pid(MaxNtrkGen)
         INTEGER virmom(maxNtrkGen)
         INTEGER Indv(MaxNtrkGen)
         REAL    Px(MaxNtrkGen)
         REAL    Py(MaxNtrkGen)
         REAL    Pz(MaxNtrkGen)
         REAL    Xcv(MaxNtrkGen)
         REAL    ycv(MaxNtrkGen)
         REAL    zcv(MaxNtrkGen)
         REAL    tofcv(MaxNtrkGen)
         REAL    Theta(MaxNtrkGen)
         REAL    Phi(MaxNtrkGen)
         INTEGER ndchmc (MaxNtrkGen)
         INTEGER nlaymc (MaxNtrkGen)
         INTEGER TrkFlag(MaxNtrkGen)
         REAL    Tofmc  (MaxNtrkGen)
         REAL    TrkLen (MaxNtrkGen)
         REAL    xfhmc(MaxNtrkGen)
         REAL    yfhmc(MaxNtrkGen)
         REAL    zfhmc(MaxNtrkGen)
         REAL    pxfhmc(MaxNtrkGen)
         REAL    pyfhmc(MaxNtrkGen)
         REAL    pzfhmc(MaxNtrkGen)
         REAL    xlhmc(MaxNtrkGen)
         REAL    ylhmc(MaxNtrkGen)
         REAL    zlhmc(MaxNtrkGen)
         REAL    pxlhmc(MaxNtrkGen)
         REAL    pylhmc(MaxNtrkGen)
         REAL    pzlhmc(MaxNtrkGen)
         INTEGER NumVtx
         INTEGER Kinmom(MaxNvtxGen)
         INTEGER mother(MaxNvtxGen)
         REAL    Tof(MaxNvtxGen)
         REAL    Xv(MaxNvtxGen)
         REAL    Yv(MaxNvtxGen)
         REAL    Zv(MaxNvtxGen)
         REAL    TrkVtx(MaxNvtxGen)
        END TYPE
        TYPE( GeanfiInformation) MC
C== Include /kloe/soft/off/offline/inc/development/tls/qihistruct.cin ==
        TYPE QcalHits
          SEQUENCE
                integer  N
                integer  PTY (nqihimax)
                integer  ADD (nqihimax)
                integer  KINE(nqihimax)
                real     X   (nqihimax)
                real     Y   (nqihimax)
                real     Z   (nqihimax)
                real     PX  (nqihimax)
                real     PY  (nqihimax)
                real     PZ  (nqihimax)
                real     TOF (nqihimax)
                real     ENE (nqihimax)
                real     TRL (nqihimax)
        END TYPE
        TYPE (QcalHits) QHIT
C== Include /kloe/soft/off/offline/inc/development/tls/qcalstruct.cin ==
        TYPE QcalEle
        SEQUENCE
           integer n
           integer wed(nqcalmax)
           integer det(nqcalmax)
           real    E  (nqcalmax)
           real    T  (nqcalmax)
        END TYPE
        TYPE (QcalEle) QELE
        TYPE QcalRealHit
        SEQUENCE
           integer n
           real ene (nqcalmax)
           real x   (nqcalmax)
           real y   (nqcalmax)
           real z   (nqcalmax)
           real t   (nqcalmax)
        END TYPE
        TYPE (QcalRealHit) QCAL
C=== Include /kloe/soft/off/offline/inc/development/tls/dhspstru.cin ===
        TYPE AllDCDhsp
         SEQUENCE
         INTEGER numDHSP
         INTEGER itrk(MaxNumDHSP)
         INTEGER layer(MaxNumDHSP)      
         INTEGER wire(MaxNumDHSP)
         REAL    time(MaxNumDHSP)
         REAL    drift(MaxNumDHSP)
         REAL    res(MaxNumDHSP)
         REAL    x(MaxNumDHSP)
         REAL    y(MaxNumDHSP)
         REAL    z(MaxNumDHSP)
        END TYPE
        TYPE (AllDCDhsp) DHSPSTRU
C== Include /kloe/soft/off/offline/inc/development/trg/telestruct.cin ==
      TYPE trgELE
      sequence
         integer ntele
         integer sector(maxtrgchan)  
         integer det(maxtrgchan)
         integer serkind(maxtrgchan)
         real Ea(maxtrgchan)    
         real Eb(maxtrgchan)    
         real Ta(maxtrgchan)    
         real Tb(maxtrgchan)    
         integer bitp(maxtrgchan)  
      end type
      type(trgELE) TELE
C= Include /kloe/soft/off/offline/inc/development/trg/pizzastruct.cin ==
      TYPE pizzastruct
      sequence
         integer npizza
         integer sector(maxtrgchan)  
         integer det(maxtrgchan)
         integer serkind(maxtrgchan)
         real Ea(maxtrgchan)    
         real Eb(maxtrgchan)    
         real E_rec(maxtrgchan)
         real Z_mod(maxtrgchan)
      end type
      type(pizzastruct) PIZZA
C= Include /kloe/soft/off/offline/inc/development/tls/preclustruct.cin =
        TYPE EmcPreCluster      
         SEQUENCE
         INTEGER n
         REAL    E(MaxNumCLu)
         REAL    X(MaxNumCLu)
         REAL    Y(MaxNumCLu)
         REAL    Z(MaxNumCLu)
         REAL    T(MaxNumCLu)
         REAL    TA(MaxNumCLu)
         REAL    TB(MaxNumCLu)
         REAL    TrmsA(MaxNumCLu)
         REAL    TrmsB(MaxNumCLu)
         INTEGER Flag (MaxNumCLu)
        END TYPE
        TYPE (EmcPreCluster) PRECLU
C=== Include /kloe/soft/off/offline/inc/development/tls/nvostru.cin ====
      INTEGER MaxNumKNVO
      PARAMETER (MaxNumKNVO = 40)       
      TYPE KNVOStru
      SEQUENCE
      integer n                
      integer iknvo(MaxNumKNVO) 
      real    px(MaxNumKNVO)   
      real    py(MaxNumKNVO)
      real    pz(MaxNumKNVO)
      integer pid(MaxNumKNVO)  
      integer bank(MaxNumKNVO) 
      integer vlinked(MaxNumKNVO) 
      END TYPE
      TYPE (KNVOStru) KNVO
      INTEGER MaxNumVNVO
      PARAMETER (MaxNumVNVO = 40)       
      TYPE VNVOStru
      SEQUENCE
      integer n                 
      integer ivnvo(MaxNumVNVO) 
      real vx(MaxNumVNVO)  
      real vy(MaxNumVNVO)
      real vz(MaxNumVNVO)
      integer kori(MaxNumVNVO) 
      integer idvfs(MaxNumVNVO) 
      integer nknv(MaxNumVNVO) 
      integer fknv(MaxNumVNVO) 
      END TYPE
      TYPE (VNVOStru) VNVO
      INTEGER MaxNumVNVOb
      PARAMETER (MaxNumVNVOb = 40)      
      TYPE VNVBStru
      SEQUENCE
      integer n                 
      integer ibank(MaxNumVNVOb) 
      END TYPE
      TYPE (VNVBStru) VNVB
      INTEGER MaxNumINVO
      PARAMETER (MaxNumINVO = 40)       
      TYPE INVOStru
      SEQUENCE
      integer n                 
      integer iinvo(MaxNumINVO) 
      integer iclps(MaxNumINVO) 
      real xi(MaxNumINVO)     
      real yi(MaxNumINVO)
      real zi(MaxNumINVO)
      real ti(MaxNumINVO)     
      real lk(MaxNumINVO)     
      real sigmalk(MaxNumINVO) 
      END TYPE
      TYPE (INVOStru) INVO
C=== Include /kloe/soft/off/offline/inc/development/tls/eclostru.cin ===
      INTEGER MaxNumCLINF
      PARAMETER (MaxNumCLINF = 100)     
      TYPE ECLOStru
        SEQUENCE
          INTEGER  n
          INTEGER  TotWord(MaxNumCLINF)
          INTEGER  idpart(MaxNumCLINF)
          INTEGER  dtclpo(MaxNumCLINF)
          INTEGER  dvvnpo(MaxNumCLINF)
          INTEGER  stre(MaxNumCLINF)
          INTEGER  algo(MaxNumCLINF)
          INTEGER  n2
          INTEGER  TotWord2(MaxNumCLINF)
          INTEGER  idpart2(MaxNumCLINF)
          INTEGER  dtclpo2(MaxNumCLINF)
          INTEGER  dvvnpo2(MaxNumCLINF)
          INTEGER  stre2(MaxNumCLINF)
          INTEGER  algo2(MaxNumCLINF)
        END TYPE
      TYPE (ECLOStru) CLINF
C=== Include /kloe/soft/off/offline/inc/development/tls/t0struct.cin ===
      TYPE t0struct
        SEQUENCE
          REAL     dc_step0
          REAL     hit_step0
          REAL     clus_step0
          REAL     step1
          REAL     cable
          REAL     tbunch
          REAL     tphased_mc
        END TYPE
      TYPE (t0struct) T0STRU
C== Include /kloe/soft/off/offline/inc/development/tls/cwrkstruct.cin ==
      TYPE  EmcHits
        sequence
         INTEGER n
         INTEGER add  (NeleCluMax)
         INTEGER cele (NeleCluMax)
         INTEGER icl  (NeleCluMax)
         INTEGER Nhit (NeleCluMax)
         INTEGER Kine (NeleCluMax)
         REAL    E(NeleCluMax)
         REAL    T(NeleCluMax)
         REAL    X(NeleCluMax)
         REAL    Y(NeleCluMax)
         REAL    Z(NeleCluMax)
      END TYPE
      TYPE (EmcHits) CWRK
C=== Include /kloe/soft/off/offline/inc/development/tls/tellina.cin ====
      TYPE tele_short
      sequence
         integer n
         integer add(maxtrgchan)  
         real Ea(maxtrgchan)    
         real Eb(maxtrgchan)    
         real Ta(maxtrgchan)    
         real Tb(maxtrgchan)    
         integer bitp(maxtrgchan)  
      end type
      type(tele_short) TELLINA
C=== Include /kloe/soft/off/offline/inc/development/tls/pizzetta.cin ===
      TYPE pizza_short
      sequence
         integer n
         integer add(maxtrgchan)
         real Ea(maxtrgchan)    
         real Eb(maxtrgchan)    
         real E_rec(maxtrgchan)
         real Z_mod(maxtrgchan)
      end type
      type(pizza_short) PIZZETTA
C== Include /kloe/soft/off/offline/inc/development/trg/trgstruct.cin ===
      integer NSLAYER
      parameter(NSLAYER=10)
      TYPE triggerstruct
      sequence
        real    tspent
        real    tdead
        integer type
        integer bphi
        integer ephi
        integer wphi
        integer bbha
        integer ebha
        integer wbha
        integer bcos
        integer ecos
        integer wcos
        integer e1w1_dwn
        integer b1_dwn
        integer t0d_dwn
        integer vetocos
        integer vetobha
        integer bdw
        integer rephasing
        integer tdc1_pht1
        integer dt2_t1
        integer fiducial
        integer t1c
        integer t1d
        integer t2d
        integer tcr
        integer tcaf_tcrd
        integer tcaf_t2d
        integer moka_t2d
        integer moka_t2dsl(NSLAYER)
      end type
      type(triggerstruct) TRG
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
C== Include /kloe/soft/off/offline/inc/development/tls/gdchitstru.cin ==
      TYPE gdchitStru
      SEQUENCE
      INTEGER  nhit
      INTEGER  nhpr
      INTEGER  nhtf
      END TYPE
      TYPE (gdchitStru) ghit
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
C=== Include /kloe/soft/off/offline/inc/development/tls/trkqstru.cin ===
      INTEGER MaxNumTrkQ
      PARAMETER (MaxNumTrkQ = 100)
        TYPE AllTracksQ
        SEQUENCE
        INTEGER  flagqt                 
         REAL    dist                   
         INTEGER n                      
         REAL    Xi(2,MaxNumTrkQ)       
         REAL    Yi(2,MaxNumTrkQ)       
         REAL    Zi(2,MaxNumTrkQ)       
         INTEGER det(2,MaxNumTrkQ)      
         INTEGER wed(2,MaxNumTrkQ)      
         INTEGER Fnearest(2,MaxNumTrkQ) 
         INTEGER Ferror(MaxNumTrkQ)     
         INTEGER Fqhit(2,MaxNumTrkQ)    
         INTEGER FqhitRAW(MaxNumTrkQ)   
         REAL    PHYabs(2,MaxNumTrkQ)   
         REAL    PHYrel(2,MaxNumTrkQ)   
         REAL    theta(MaxNumTrkQ)      
         INTEGER itrk(MaxNumTrkQ)       
      END TYPE
      TYPE (AllTracksQ) TRKQ
C== Include /kloe/soft/off/offline/inc/development/tls/dtcestruct.cin ==
      Type DChits
        Sequence
        Integer nDTCE
        Integer nSmall
        Integer iLayerDTCE(nMaxDC)
        Integer iWireDTCE(nMaxDC)
        Real    tDTCE(nMaxDC)
      End Type
      Type (DChits) DTCE
C== Include /kloe/soft/off/offline/inc/development/tls/dhrestruct.cin ==
      Type DCdrift
        Sequence
        Integer nDHRE
        Integer iLayerDHRE(nMaxDC)
        Integer iWireDHRE(nMaxDC)
        Real    rDHRE(nMaxDC)
        Real    eDHRE(nMaxDC)
        Integer iTrkDHRE(nMaxDC)
      End Type
      Type (DCdrift) DHRE
C= Include /kloe/soft/off/offline/inc/development/tls/sec2clustru.cin ==
      Type Sector
        Sequence
        Integer Nsect
        Integer Nsect_noclu
        Integer Nsect_clu
        Integer NocluAdd(MaxNumClu) 
        Integer nclus               
        Integer NNorm(MaxNumClu)    
        Integer Nover(MaxNumclu)
        Integer Ncosm(MaxNumclu)
        Integer NormAdd(MaxNumClu)  
        Integer OverAdd(MaxNumClu)  
        Integer CosmAdd(MaxNumClu)  
      End Type
      Type (Sector) S2CLU
C== Include /kloe/soft/off/offline/inc/development/tls/cspsstruct.cin ==
      INTEGER NhitCluMax
      PARAMETER (NhitCluMax = 2000 )
      Type EmcSpacePoints
        Sequence
        Integer Ncel
        Integer Nclu
        Integer Iclu(NhitCluMax)
        Integer Icel(NhitCluMax)
        Integer Ibcel(NhitCluMax)
        Integer Flag(NhitCluMax)
        Integer Add (NhitCluMax)
        Integer Nhit(NhitCluMax)
        Real    TA  (NhitCluMax)
        Real    TB  (NhitCluMax)
        Real    Ea  (NhitCluMax)
        Real    Eb  (NhitCluMax)
        Real    T   (NhitCluMax)
        Real    E   (NhitCluMax)
        Real    X   (NhitCluMax)
        Real    Y   (NhitCluMax)
        Real    Z   (NhitCluMax)
      End Type
      Type (EmcSpacePoints) CSPS
      TYPE  EmcMCSpacePoints
        sequence
          Integer Ncel
          Integer Nclu
          Integer IHit(NhitCluMax)
          Integer Nhit(NhitCluMax)
          Integer knum(NhitCluMax)
          Real    X(NhitCluMax)
          Real    Y(NhitCluMax)
          Real    Z(NhitCluMax)
          Real    T(NhitCluMax)
          Real    E(NhitCluMax)
      END TYPE
      TYPE (EmcMCSpacePoints) CSPSMC
C== Include /kloe/soft/off/offline/inc/development/tls/cluostruct.cin ==
      INTEGER NcluoMax
      PARAMETER (NcluoMax = 100 )
      Type EmcCluObjects
        Sequence
        Integer N
        Integer Ncel(NcluoMax)
        Real    Flag(NcluoMax)
        Real    Chi2(NcluoMax)
        Real    Like(NcluoMax)
        Real    E   (NcluoMax)
        Real    X   (NcluoMax)
        Real    Y   (NcluoMax)
        Real    Z   (NcluoMax)
        Real    T   (NcluoMax)
      End Type
      Type (EmcCluObjects) CLUO
C= Include /kloe/soft/off/offline/inc/development/tls/cluomcstruct.cin =
      INTEGER NMCcluoMax
      PARAMETER (NMCcluoMax = 100 )
      Type EmcMCCluObjects
        Sequence
        Integer Npar
        Integer Nclu
        Integer Ncel(NMCcluoMax)
        Integer Iclu(NMCcluoMax)
        Integer Kine(NMCcluoMax)
        REAL    E   (NMCcluoMax)
        REAL    X   (NMCcluoMax)
        REAL    Y   (NMCcluoMax)
        REAL    Z   (NMCcluoMax)
        REAL    T   (NMCcluoMax)
      End Type
      Type (EmcMCCluObjects) CLUOMC
C== Include /kloe/soft/off/offline/inc/development/tls/dedx2stru.cin ===
       INTEGER  MAXNUMEROADC
       PARAMETER(MAXNUMEROADC = 200)
       INTEGER  MAXNUMTRACCE
       PARAMETER(MAXNUMTRACCE = 20)
       Type DEDX2STRUstruct
        SEQUENCE
        integer numdedx
        integer numeroadc(MaxNumTRACCE)
        integer indicededx(MaxNumTRACCE)
        INTEGER whw1(MAXNUMEROADC,MAXNUMTRACCE)
        INTEGER whw2(MAXNUMEROADC,MAXNUMTRACCE)
        INTEGER Lay(MAXNUMEROADC,MAXNUMTRACCE)
        INTEGER Wir1(MAXNUMEROADC,MAXNUMTRACCE)
        INTEGER Wir2(MAXNUMEROADC,MAXNUMTRACCE)
        INTEGER Was1(MAXNUMEROADC,MAXNUMTRACCE)
        INTEGER Was2(MAXNUMEROADC,MAXNUMTRACCE)
        REAL    step(MAXNUMEROADC,MAXNUMTRACCE)
        REAL    effs(MAXNUMEROADC,MAXNUMTRACCE)
        REAL    Tim1(MAXNUMEROADC,MAXNUMTRACCE)
        REAL    Tim2(MAXNUMEROADC,MAXNUMTRACCE)
        REAL    carica(MAXNUMEROADC,MAXNUMTRACCE)
       end Type
       type(dedx2strustruct) DEDX2STRU
C== Include /kloe/soft/off/offline/inc/development/tls/dhitstruct.cin ==
      INTEGER maxnumdhit
      parameter (maxnumdhit = 2500)
      TYPE mcdc_dhit
        SEQUENCE
         integer n
         integer pid(maxnumdhit)
         integer kinum(maxnumdhit)
         integer celadr(maxnumdhit)
         real    x(maxnumdhit)
         real    y(maxnumdhit)
         real    z(maxnumdhit)
         real    px(maxnumdhit)
         real    py(maxnumdhit)
         real    pz(maxnumdhit)
         real    time(maxnumdhit)
         real    dedx(maxnumdhit)
         real    tlen(maxnumdhit)
         real    dtime(maxnumdhit)
         real    dfromw(maxnumdhit)
         integer flag(maxnumdhit)
      END TYPE
      TYPE (mcdc_dhit) dhit
C= Include /kloe/soft/off/offline/inc/development/tls/eleqcaltstru.cin =
      INTEGER     MaxQCALTChan
      PARAMETER ( MaxQCALTChan = 1920 ) 
      INTEGER     MaxQCALTHits
      PARAMETER ( MaxQCALTHits = 5)
      TYPE  QCALTStructure
      SEQUENCE
      INTEGER Nele
      INTEGER Nhit(MaxQCALTChan)
      INTEGER Addr(MaxQCALTChan)
      INTEGER Qdet(MaxQCALTChan)
      INTEGER Qmod(MaxQCALTChan)
      INTEGER Qpla(MaxQCALTChan)
      INTEGER Qtil(MaxQCALTChan)
      REAL    Time(MaxQCALTChan,MaxQCALTHits)
      END TYPE
C$$INCLUDE 'K$ITLS:qcalthitstru.cin'    ! QCALT hit structure
C= Include /kloe/soft/off/offline/inc/development/tls/ele2hitqcalt.cin =
      INTEGER     RunN, EvtN
      INTEGER     NtuId
      INTEGER     MaxNChan
      PARAMETER ( MaxNChan = 1920 )
      INTEGER     MaxNHits
      PARAMETER ( MaxNHits = 5)
      TYPE  QHITStructure
      SEQUENCE
      INTEGER Nele
      INTEGER Nhit(MaxNChan)
      REAL X(MaxNChan)
      REAL Y(MaxNChan)
      REAL Z(MaxNChan)
      REAL Time(MaxNChan,MaxNHits)
      END TYPE
      TYPE (QHITStructure) QCALTHIT
      LOGICAL HitNtuBok
      COMMON /ELE2HITCom/ HitNtuBok,RunN,EvtN
C=== Include /kloe/soft/off/offline/inc/development/tls/ccaltnum.cin ===
        integer    CCALT_A,   CCALT_B                   
        parameter (CCALT_A=5, CCALT_B=6)
        integer    CCALT_CRY    
        parameter (CCALT_CRY=48)
        integer    CCALT_LAYMIN,   CCALT_LAYMAX
        parameter (CCALT_LAYMIN=1, CCALT_LAYMAX=2)
        integer    CCALT_COLMIN,CCALT_COLMAX            
        parameter (CCALT_COLMIN=1, CCALT_COLMAX=24)
        Integer    CCALTCHAN
        Parameter (CCALTCHAN=96)
C== Include /kloe/soft/off/offline/inc/development/tls/ccaltstru.cin ===
        TYPE  CCALTStructure
          SEQUENCE
           INTEGER NEle
           INTEGER Cry(CCALTChan)
           INTEGER Det(CCALTChan)
           INTEGER Col(CCALTChan)
           INTEGER Pla(CCALTChan)
           REAL    T(CCALTChan)
        END TYPE
        TYPE(CCALTStructure) CCALTStru
C== Include /kloe/soft/off/offline/inc/development/tls/letestruct.cin ==
      INTEGER     LETMaxCh
      PARAMETER ( LETMaxCh = 40)
        TYPE  LETEStr
          SEQUENCE
           INTEGER NEle
           INTEGER Calib
           INTEGER Cry(LETMaxCh)
           INTEGER Det(LETMaxCh)
           INTEGER Col(LETMaxCh)
           INTEGER Pla(LETMaxCh)
           REAL    E(LETMaxCh)
           REAL    T(LETMaxCh)
        END TYPE
        TYPE(LETEStr) LETE
C$$INCLUDE 'k$itls:raw2itce.cin'      ! IT element structure
C== Include /kloe/soft/off/offline/inc/development/tls/itcestruct.cin ==
        integer nmax_itce
        parameter (nmax_itce=25000)
        type itcestruct
        sequence
           integer nitce
           integer foil(nmax_itce)
           integer layer(nmax_itce)
           integer strip(nmax_itce)
           integer view(nmax_itce)
           integer inditkine(nmax_itce)
        end type
        type(itcestruct) itce
C=== Include /kloe/soft/off/offline/inc/development/tls/hetenum.cin ====
      Integer   HETECHAN
      Parameter (HETECHAN = 64)   
      Integer   MAXHITHET
      Parameter (MAXHITHET = 30)  
      Integer   TURNNUM
      Parameter (TURNNUM = 4)     
      Integer   MAXHETTDCVAL      
      Parameter (MAXHETTDCVAL = 1920)
C=== Include /kloe/soft/off/offline/inc/development/tls/hetestru.cin ===
      TYPE HETEStructure
        SEQUENCE
          INTEGER NHETDCs                    
          INTEGER HDet(MAXHETTDCVAL)         
          INTEGER HCol(MAXHETTDCVAL)         
          INTEGER nTurnHet(MAXHETTDCVAL)     
          REAL    TimeHet(MAXHETTDCVAL)      
      END TYPE
      TYPE (HETEStructure) HETE
C=== Include /kloe/soft/off/offline/inc/development/tls/prod2ntu.cin ===
        TYPE prod2ntu_Params
          SEQUENCE
                INTEGER NtId
                CHARACTER*80 NtTitle
        END TYPE
      INTEGER prod2ntu_NtId
      PARAMETER (prod2ntu_NtId = 1)
      CHARACTER*(*) prod2ntu_Title
      PARAMETER (prod2ntu_Title = 'prod')
        TYPE NtupleEvent
          SEQUENCE
            TYPE (EventInfo)         INFO
            TYPE (EmcCluster)        CLU
            TYPE (EmcCells)          CELE
            TYPE (Vertex)            VTX        
            TYPE (TracksVertex)      TRKV
            TYPE (AllTracks)         TRK
            TYPE (AllTracksMC)       TRKMC
            TYPE (DPRS_TYPE)         DPRS
            TYPE (TrackCluster)      TCLO
            TYPE (GeanfiInformation) MC
            TYPE (emcfirsthit)       CFHI
            TYPE (QcalHits)          QHIT
            TYPE (QcalEle)           QELE
            TYPE (QcalRealHit)       QCAL
            TYPE (AllDCDhsp)         DHSP
            TYPE (EmcPreCluster)     PRECLU
            TYPE (KNVOStru)          KNVO
            TYPE (VNVOStru)          VNVO
            TYPE (VNVBStru)          VNVB
            TYPE (INVOStru)          INVO
            TYPE (Eclostru)          ECLO
            TYPE (TrgEle)            TELE
            TYPE (pizzastruct)       PIZZA
            TYPE (t0struct)          T0STRU
            TYPE (EmcHits)           CWRK
            TYPE (pizza_short)       PIZZETTA
            TYPE (tele_short)        TELLINA
            TYPE (triggerstruct)     TRG
            TYPE (ECLSStru)          ECLS
            TYPE (gdchitStru)        GHIT
            TYPE (Bposition)         BPOS
            TYPE (AllTracksQ)        TRKQ
            TYPE (DChits)            DTCE
            TYPE (DCdrift)           DHRE
            TYPE (Sector)            S2CLU
            TYPE (EmcSpacePoints)    CSPS
            TYPE (EmcMCSpacePoints)  CSPSMC
            TYPE (EmcCluObjects)     CLUO
            TYPE (EmcMCCluObjects)   CLUOMC
            TYPE (Vertex)            VTXOLD     
            TYPE (TracksVertex)      TRKVOLD
            TYPE (AllTracks)         TRKOLD
            TYPE (AllTracksMC)       TRKMCOLD
            TYPE (TrackCluster)      TCLOLD
            TYPE (DEDX2STRUstruct)   DEDX2STRU
            TYPE (mcdc_dhit)         DHIT
            TYPE (QCALTStructure)    QCALT
            TYPE (CCALTStructure)    CCLE
            TYPE (LETEStr)           LETE
            TYPE(itcestruct)         ITCE
            TYPE(QHITStructure)      QCALTHIT
            TYPE(HETEStructure)      HETE
        END TYPE
        TYPE ( NtupleEvent) Evt
        TYPE (prod2ntu_Params) params
      COMMON /prod2ntu/ Evt,params
C Include /kloe/soft/off/offline/inc/development/tls/prod2ntu_talk.cin =
        logical CLUSFLAG,CELEFLAG,TRIGFLAG
        logical TRKSFLAG,TRKVFLAG,DPRSFLAG
        logical CFHIFLAG,TCLOFLAG
        logical QCALFLAG,GEANFIFLAG
        logical DHSPFLAG,TELEFLAG
        logical PRECLUSFLAG,NVOFLAG
        logical ECLOFLAG,T0FLAG
        logical CWRKFLAG, ENECORFLAG
        logical ECLSFLAG, GDCHITFG
        logical BPOSFLAG
        Logical dtceFlag,dtce0Flag,DCnHitsFlag,dhreFlag
        logical c2trFlag
        Logical BENEFLAG
        Logical CSPSFLAG,CSPSMCFLAG,CLUOFLAG
        logical TRKSOLDFLAG,TRKVOLDFLAG,TCLOLDFLAG
        logical DHITFLAG,DEDXFLAG
        logical QCALTELEFLAG
        logical CCLEFLAG
        logical LETEFLAG
        logical ITCEFLAG
        logical HETEFLAG
        logical QCALTHITFLAG
        common /PRODMENU/CLUSFLAG,CELEFLAG,TRIGFLAG,TRKSFLAG,
     &  TRKVFLAG,DPRSFLAG,CFHIFLAG,QCALFLAG,TCLOFLAG,
     &  GEANFIFLAG,DHSPFLAG,TELEFLAG,PRECLUSFLAG,NVOFLAG,
     &  ECLOFLAG,T0FLAG,CWRKFLAG,ENECORFLAG,ECLSFLAG,GDCHITFG,
     &  BPOSFLAG,dtceFlag,dtce0Flag,DCnHitsFlag,dhreFlag,
     &  C2TRFLAG,BENEFLAG,CSPSFLAG,CSPSMCFLAG,CLUOFLAG,
     &  TRKSOLDFLAG,TRKVOLDFLAG,TCLOLDFLAG,DHITFLAG,DEDXFLAG,
     &  QCALTELEFLAG,CCLEFLAG,LETEFLAG,ITCEFLAG,HETEFLAG,
     &  QCALTHITFLAG
C
      character*4 prod2ntu_version
      character*6 NtuLayout
C
      prod2ntu_version = 'V5.0'
      NtuLayout        = ' LAY01'
C
      Params%NtId = prod2ntu_NtId
      Params%NtTitle = prod2ntu_Title
     &     //prod2ntu_version(1:4)//NtuLayout(1:6)
C
      PRECLUSFLAG= .false.
      CLUSFLAG   = .true.
      CELEFLAG   = .false.
      TRIGFLAG   = .true.
      TRKSFLAG   = .true.
      TRKVFLAG   = .true.
      DHSPFLAG   = .false.
      DPRSFLAG   = .true.
      TCLOFLAG   = .true.
      CFHIFLAG   = .false.
      QCALFLAG   = .true.
      GEANFIFLAG = .false.
      TELEFLAG   = .false.
      NVOFLAG    = .true.
      ECLOFLAG   = .true.
      ECLSFLAG   = .true.
      GDCHITFG   = .true.
      T0FLAG     = .true.
      BPOSFLAG   = .true.
      BENEFLAG   = .false.
      DTCEFLAG   = .false.
      DTCE0FLAG  = .false.
      DCnHitsFlag= .false.
      DHREFLAG   = .false.
C By Default --> Misc/Palutan 24-1-02
      C2TRFlag   = .TRUE.  
      CSPSFlag   = .false.
      CSPSMCFlag = .false.
      CLUOFlag   = .false.
Cvp
      TRKSOLDFLAG   = .false.
      TRKVOLDFLAG   = .false.
      TCLOLDFLAG    = .false.
      DHITFLAG      = .false.
      DEDXFLAG      = .false.
Cvp
C
Cms -- adding 15-1-2000 to separate Hits from Cele and
Cms    reduce space!
Cms    Adding also Energy Flag to use Fixene forever
C
      cwrkflag   = .true.
      enecorflag = .false.
C
      QCALTELEFLAG = .false.
      QCALTHITFLAG = .false.
      CCLEFLAG     = .false.
      LETEFLAG     = .false.
      ITCEFLAG     = .false.
      HETEFLAG     = .false.
C
      RETURN
      END
C
C-----------------------------------------------------------------------
      SUBROUTINE prod2ntu_hb
C-----------------------------------------------------------------------
C Booking Stage:
C Define all the Blocks in the CWN ntuple.
C-----------------------------------------------------------------------
        IMPLICIT NONE
C===== Include /kloe/soft/off/a_c/production/aix/source/ancomm.cin =====
      INTEGER         ANPKSZ
      PARAMETER      (ANPKSZ = 16384)
      INTEGER         ANPKI4
      DIMENSION       ANPKI4(ANPKSZ)
      LOGICAL         ANPKL4
      DIMENSION       ANPKL4(ANPKSZ)
      REAL            ANPKR4
      DIMENSION       ANPKR4(ANPKSZ)
      EQUIVALENCE    (ANPKI4(1),ANPKR4(1))
      EQUIVALENCE    (ANPKR4(1),ANPKL4(1))
      COMMON /ANCOMM/ ANPKI4
C===== Include /kloe/soft/off/a_c/production/aix/source/anpack.cin =====
        INTEGER    MASK1
        PARAMETER (MASK1 =       '1'X)
        INTEGER    MASK2
        PARAMETER (MASK2 =       '3'X)
        INTEGER    MASK3
        PARAMETER (MASK3 =       '7'X)
        INTEGER    MASK4
        PARAMETER (MASK4 =       'F'X)
        INTEGER    MASK5
        PARAMETER (MASK5 =      '1F'X)
        INTEGER    MASK6
        PARAMETER (MASK6 =      '3F'X)
        INTEGER    MASK7
        PARAMETER (MASK7 =      '7F'X)
        INTEGER    MASK8
        PARAMETER (MASK8 =      'FF'X)
        INTEGER    MASK9
        PARAMETER (MASK9 =     '1FF'X)
        INTEGER    MASK10
        PARAMETER (MASK10 =    '3FF'X)
        INTEGER    MASK11
        PARAMETER (MASK11=     '7FF'X)
        INTEGER    MASK12
        PARAMETER (MASK12=     'FFF'X)
        INTEGER    MASK13
        PARAMETER (MASK13=    '1FFF'X)
        INTEGER    MASK14
        PARAMETER (MASK14=    '3FFF'X)
        INTEGER    MASK15
        PARAMETER (MASK15=    '7FFF'X)
        INTEGER    MASK16
        PARAMETER (MASK16=    'FFFF'X)
        INTEGER    MASK17
        PARAMETER (MASK17=   '1FFFF'X)
        INTEGER    MASK18
        PARAMETER (MASK18=   '3FFFF'X)
        INTEGER    MASK19
        PARAMETER (MASK19=   '7FFFF'X)
        INTEGER    MASK20
        PARAMETER (MASK20=   'FFFFF'X)
        INTEGER    MASK21
        PARAMETER (MASK21=  '1FFFFF'X)
        INTEGER    MASK22
        PARAMETER (MASK22=  '3FFFFF'X)
        INTEGER    MASK23
        PARAMETER (MASK23=  '7FFFFF'X)
        INTEGER    MASK24
        PARAMETER (MASK24=  'FFFFFF'X)
        INTEGER    MASK25
        PARAMETER (MASK25= '1FFFFFF'X)
        INTEGER    MASK26
        PARAMETER (MASK26= '3FFFFFF'X)
        INTEGER    MASK27
        PARAMETER (MASK27= '7FFFFFF'X)
        INTEGER    MASK28
        PARAMETER (MASK28= 'FFFFFFF'X)
        INTEGER    MASK29
        PARAMETER (MASK29='1FFFFFFF'X)
        INTEGER    MASK30
        PARAMETER (MASK30='3FFFFFFF'X)
        INTEGER    MASK31
        PARAMETER (MASK31='7FFFFFFF'X)
        INTEGER    MASK32
        PARAMETER (MASK32='FFFFFFFF'X)
        INTEGER    MBIT1
        PARAMETER (MBIT1 =       '1'X)
        INTEGER    MBIT2
        PARAMETER (MBIT2 =       '2'X)
        INTEGER    MBIT3
        PARAMETER (MBIT3 =       '4'X)
        INTEGER    MBIT4
        PARAMETER (MBIT4 =       '8'X)
        INTEGER    MBIT5
        PARAMETER (MBIT5 =      '10'X)
        INTEGER    MBIT6
        PARAMETER (MBIT6 =      '20'X)
        INTEGER    MBIT7
        PARAMETER (MBIT7 =      '40'X)
        INTEGER    MBIT8
        PARAMETER (MBIT8 =      '80'X)
        INTEGER    MBIT9
        PARAMETER (MBIT9 =     '100'X)
        INTEGER    MBIT10
        PARAMETER (MBIT10 =    '200'X)
        INTEGER    MBIT11
        PARAMETER (MBIT11=     '400'X)
        INTEGER    MBIT12
        PARAMETER (MBIT12=     '800'X)
        INTEGER    MBIT13
        PARAMETER (MBIT13=    '1000'X)
        INTEGER    MBIT14
        PARAMETER (MBIT14=    '2000'X)
        INTEGER    MBIT15
        PARAMETER (MBIT15=    '4000'X)
        INTEGER    MBIT16
        PARAMETER (MBIT16=    '8000'X)
        INTEGER    MBIT17
        PARAMETER (MBIT17=   '10000'X)
        INTEGER    MBIT18
        PARAMETER (MBIT18=   '20000'X)
        INTEGER    MBIT19
        PARAMETER (MBIT19=   '40000'X)
        INTEGER    MBIT20
        PARAMETER (MBIT20=   '80000'X)
        INTEGER    MBIT21
        PARAMETER (MBIT21=  '100000'X)
        INTEGER    MBIT22
        PARAMETER (MBIT22=  '200000'X)
        INTEGER    MBIT23
        PARAMETER (MBIT23=  '400000'X)
        INTEGER    MBIT24
        PARAMETER (MBIT24=  '800000'X)
        INTEGER    MBIT25
        PARAMETER (MBIT25= '1000000'X)
        INTEGER    MBIT26
        PARAMETER (MBIT26= '2000000'X)
        INTEGER    MBIT27
        PARAMETER (MBIT27= '4000000'X)
        INTEGER    MBIT28
        PARAMETER (MBIT28= '8000000'X)
        INTEGER    MBIT29
        PARAMETER (MBIT29='10000000'X)
        INTEGER    MBIT30
        PARAMETER (MBIT30='20000000'X)
        INTEGER    MBIT31
        PARAMETER (MBIT31='40000000'X)
        INTEGER    MBIT32
        PARAMETER (MBIT32 = '80000000'X)
      INTEGER    ANNFIL
      PARAMETER (ANNFIL = 4)
      INTEGER    ANNSET
      PARAMETER (ANNSET = 4)
      INTEGER    ANNTRG
      PARAMETER (ANNTRG = 4)
      INTEGER    ANLENG
      PARAMETER (ANLENG = 16)
      INTEGER    ANLSCH
      PARAMETER (ANLSCH = 16)
      INTEGER    ANMXPS
      PARAMETER (ANMXPS = 32)
      INTEGER    ANMXBN
      PARAMETER (ANMXBN = 64)
      INTEGER    ANMXBC
      PARAMETER (ANMXBC = 4*ANMXBN)
      INTEGER    ANMXNR
      PARAMETER (ANMXNR = 64)
      CHARACTER*4 ANSTNA
      PARAMETER  (ANSTNA = 'ANST')
      INTEGER     ANSTID
      PARAMETER  (ANSTID = 1)
      INTEGER    STBGRP
      PARAMETER (STBGRP = 0)
      INTEGER    STBMEN
      PARAMETER (STBMEN = STBGRP+1)
      INTEGER    STOPMD
      PARAMETER (STOPMD = STBMEN+1)
      INTEGER    STNEVT
      PARAMETER (STNEVT = STOPMD+1)
      INTEGER    STRECT
      PARAMETER (STRECT = STNEVT+1)
      INTEGER    STCRUN
      PARAMETER (STCRUN = STRECT+1)
      INTEGER    STEVNU
      PARAMETER (STEVNU = STCRUN+1)
      INTEGER    STLRUN
      PARAMETER (STLRUN = STEVNU+1)
      INTEGER    STLEV
      PARAMETER (STLEV  = STLRUN+1)
      INTEGER    STLBGR
      PARAMETER (STLBGR = STLEV +1)
      INTEGER    STLENR
      PARAMETER (STLENR = STLBGR+1)
      INTEGER    STUDBG
      PARAMETER (STUDBG = STLENR +1)
      INTEGER    STEVP
      PARAMETER (STEVP  = STUDBG+1)
      INTEGER    STEVPR
      PARAMETER (STEVPR = STEVP +1)
      INTEGER    STEVPA
      PARAMETER (STEVPA = STEVPR+1)
      INTEGER    STNGEV
      PARAMETER (STNGEV = STEVPA+1)
      INTEGER    STNREC
      PARAMETER (STNREC = STNGEV+1)
      INTEGER    STNRCF
      PARAMETER (STNRCF = STNREC+1)
      INTEGER    STCMOD
      PARAMETER (STCMOD = STNRCF+1)
      INTEGER    STCPAT
      PARAMETER (STCPAT = STCMOD+1)
      INTEGER    STCELE
      PARAMETER (STCELE = STCPAT+1)
      INTEGER    STCPAR
      PARAMETER (STCPAR = STCELE+1)
      INTEGER    STMXEV
      PARAMETER (STMXEV = STCPAR+1)
      INTEGER    STGDEV
      PARAMETER (STGDEV = STMXEV+1)
      INTEGER    STFSEV
      PARAMETER (STFSEV = STGDEV+1)
      INTEGER    STSKEV
      PARAMETER (STSKEV = STFSEV+1)
      INTEGER    STRPEV
      PARAMETER (STRPEV = STSKEV+1)
      INTEGER    STRPEL
      PARAMETER (STRPEL = STRPEV+1)
      INTEGER    STRPCP
      PARAMETER (STRPCP = STRPEL+1)
      INTEGER    STRPNR
      PARAMETER (STRPNR = STRPCP+1)
      INTEGER    STRPPE
      PARAMETER (STRPPE = STRPNR+1)
      INTEGER    STDELY
      PARAMETER (STDELY = STRPPE+1)
      INTEGER    STTOUT
      PARAMETER (STTOUT = STDELY+1)
      INTEGER    STIOER
      PARAMETER (STIOER = STTOUT+1)
      INTEGER    STOUER
      PARAMETER (STOUER = STIOER+1)
      INTEGER    STCINP
      PARAMETER (STCINP = STOUER+1)
      INTEGER    STCOUP
      PARAMETER (STCOUP = STCINP+1)
      INTEGER    STILUN
      PARAMETER (STILUN = STCOUP+1)
      INTEGER    STOLUN
      PARAMETER (STOLUN = STILUN+1)
      INTEGER    STTCHK
      PARAMETER (STTCHK = STOLUN+1)
      INTEGER    STPKST
      PARAMETER (STPKST = STTCHK+1)
      INTEGER    STSAYS
      PARAMETER (STSAYS = 0)
      INTEGER    STPRBI
      PARAMETER (STPRBI = 1)
      INTEGER    STPROV
      PARAMETER (STPROV = 2)
      INTEGER    STOUBI
      PARAMETER (STOUBI = 3)
      INTEGER    STPROD
      PARAMETER (STPROD = 4)
      INTEGER    STEOJR
      PARAMETER (STEOJR = 5)
      INTEGER    STPDEF
      PARAMETER (STPDEF = 6)
      INTEGER    STDTGC
      PARAMETER (STDTGC = 7)
      INTEGER    STETPI
      PARAMETER (STETPI = 8)
      INTEGER    STEPHB
      PARAMETER (STEPHB = 9)
      INTEGER    STEFIO
      PARAMETER (STEFIO = 10)
      INTEGER    STEEOF
      PARAMETER (STEEOF = 11)
      INTEGER    STEEXP
      PARAMETER (STEEXP = 12)
      INTEGER    BROAD
      PARAMETER (BROAD = STPKST+1)
      INTEGER    STNOEV
      PARAMETER (STNOEV = BROAD+1)
      INTEGER    STOFFV
      PARAMETER (STOFFV = STNOEV+1)
      INTEGER    STLENG
      PARAMETER (STLENG = STOFFV+1)
      CHARACTER*4 ANRUNA
      PARAMETER  (ANRUNA = 'ANRU')
      INTEGER     ANRUID
      PARAMETER  (ANRUID = 1)
      INTEGER    REPNUM
      PARAMETER (REPNUM = 0)
      INTEGER    RELOWB
      PARAMETER (RELOWB = 1)
      INTEGER    REPAIR
      PARAMETER (REPAIR = 2)
      INTEGER    RELOW
      PARAMETER (RELOW  = 0)
      INTEGER    REHIGH
      PARAMETER (REHIGH = RELOW+1)
      CHARACTER*4 ANARNA
      PARAMETER  (ANARNA = 'ANAR')
      INTEGER     ANARID
      PARAMETER  (ANARID = 1)
      INTEGER     ARCLEN
      PARAMETER  (ARCLEN = 0)
      INTEGER     ARBCOM
      PARAMETER  (ARBCOM = ARCLEN+1)
      CHARACTER*4 ANHBNA
      PARAMETER  (ANHBNA = 'ANHB')
      INTEGER     HBSTAT
      PARAMETER  (HBSTAT = 0)
      INTEGER     HBLUN
      PARAMETER  (HBLUN  = HBSTAT+1)
      INTEGER     HBOPOP
      PARAMETER  (HBOPOP = HBLUN+1)
      INTEGER     HBRECL
      PARAMETER  (HBRECL = HBOPOP+1)
      INTEGER     HBNREC
      PARAMETER  (HBNREC = HBRECL+1)
      INTEGER     HBDLEN
      PARAMETER  (HBDLEN = HBNREC+1)
      INTEGER     HBFLEN
      PARAMETER  (HBFLEN = HBDLEN+1)
      INTEGER     HBBGST
      PARAMETER  (HBBGST = HBFLEN+1)
      INTEGER     HBOPEN
      PARAMETER  (HBOPEN = 0)
      INTEGER     HBNWFI
      PARAMETER  (HBNWFI = 0)
      INTEGER     HBRDON
      PARAMETER  (HBRDON = 1)
      INTEGER     HBUPDA
      PARAMETER  (HBUPDA = 2)
      INTEGER     HBSTOR
      PARAMETER  (HBSTOR = 0)
      INTEGER     HBWRIT
      PARAMETER  (HBWRIT = 1)
      CHARACTER*4 ANEVNA
      PARAMETER  (ANEVNA = 'ANEV')
      CHARACTER*4 ANRQNA
      PARAMETER  (ANRQNA = 'ANRQ')
      INTEGER    RQETYP
      PARAMETER (RQETYP = 0)
      INTEGER    RQTRIG
      PARAMETER (RQTRIG = RQETYP+1)
      INTEGER    RQVETO
      PARAMETER (RQVETO = RQTRIG+ANNTRG)
      INTEGER    RQTYPE
      PARAMETER (RQTYPE = RQVETO+ANNTRG)
      INTEGER    RQSCAL
      PARAMETER (RQSCAL = RQTYPE+1)
      INTEGER    RQTOTL
      PARAMETER (RQTOTL = RQSCAL+1)
      INTEGER    RQSEEN
      PARAMETER (RQSEEN = RQTOTL+1)
      INTEGER    RQLENG
      PARAMETER (RQLENG = RQSEEN+1)
      INTEGER    RQVBIT
      PARAMETER (RQVBIT = 0)
      INTEGER    RQABIT
      PARAMETER (RQABIT = 1)
      CHARACTER*4 ANIDNA
      PARAMETER  (ANIDNA = 'ANID')
      INTEGER    IDNBNK
      PARAMETER (IDNBNK = 0)
      INTEGER    IDBANK
      PARAMETER (IDBANK = IDNBNK + 1)
      CHARACTER*4 ANIRNA
      PARAMETER  (ANIRNA = 'ANIR')
      INTEGER    IRNAMO
      PARAMETER (IRNAMO = 0)
      INTEGER    IRNAMN
      PARAMETER (IRNAMN = IRNAMO + 1)
      CHARACTER*4 ANICNA
      PARAMETER  (ANICNA = 'ANIC')
      INTEGER    ICNBNK
      PARAMETER (ICNBNK = 0)
      INTEGER    ICBANK
      PARAMETER (ICBANK = ICNBNK + 1)
      CHARACTER*4 ANMNNA
      PARAMETER  (ANMNNA = 'ANMN')
      INTEGER    MNSCHA
      PARAMETER (MNSCHA = 0)
      INTEGER    MNLCNA
      PARAMETER (MNLCNA = MNSCHA+1)
      INTEGER    MNSPOI
      PARAMETER (MNSPOI = MNLCNA+1)
      INTEGER    MNLPOI
      PARAMETER (MNLPOI = MNSPOI+1)
      INTEGER    MNSNAM
      PARAMETER (MNSNAM = MNLPOI+1)
      CHARACTER*4 ANMANA
      PARAMETER  (ANMANA = 'ANMA')
      INTEGER    MACLAS
      PARAMETER (MACLAS = 0)
      INTEGER    MAPARS
      PARAMETER (MAPARS = MACLAS+1)
      INTEGER    MADFIL
      PARAMETER (MADFIL = MAPARS+ANNSET)
      INTEGER    MAINIT
      PARAMETER (MAINIT = MADFIL+ANNFIL)
      INTEGER    MARINI
      PARAMETER (MARINI = MAINIT+1)
      INTEGER    MAEVNT
      PARAMETER (MAEVNT = MARINI+1)
      INTEGER    MAOTHR
      PARAMETER (MAOTHR = MAEVNT+1)
      INTEGER    MARFIN
      PARAMETER (MARFIN = MAOTHR+1)
      INTEGER    MAFINI
      PARAMETER (MAFINI = MARFIN+1)
      INTEGER    MATALK
      PARAMETER (MATALK = MAFINI+1)
      INTEGER    MAMINU
      PARAMETER (MAMINU= MATALK+1)
      INTEGER    MAHIST
      PARAMETER (MAHIST = MAMINU+1)
      INTEGER    MATERM
      PARAMETER (MATERM = MAHIST+1)
      INTEGER   MAHMIN
      PARAMETER (MAHMIN = MATERM+1)
      INTEGER    MAHMAX
      PARAMETER (MAHMAX = MAHMIN+1)
      INTEGER    MAMXPA
      PARAMETER (MAMXPA = MAHMAX+1)
      INTEGER    MAPAME
      PARAMETER (MAPAME = MAMXPA+1)
      INTEGER    MAHSTA
      PARAMETER (MAHSTA = MAPAME+1)
      INTEGER    MATIME
      PARAMETER (MATIME = MAHSTA + 1)
      INTEGER    MAELPS
      PARAMETER (MAELPS = MATIME + 1)
      INTEGER    MACNTR
      PARAMETER (MACNTR = MAELPS + 1)
      INTEGER    MALENG
      PARAMETER (MALENG = MACNTR+1)
      INTEGER    MADFCL
      PARAMETER (MADFCL = 0)
      INTEGER    MAINCL
      PARAMETER (MAINCL = 1)
      INTEGER    MAOUCL
      PARAMETER (MAOUCL = 2)
      INTEGER    MABSCL
      PARAMETER (MABSCL = 3)
      INTEGER    MAHBSH
      PARAMETER (MAHBSH = 0)
      INTEGER    MAHASH
      PARAMETER (MAHASH = -1)
      INTEGER    MASHPT
      PARAMETER (MASHPT = -2)
      INTEGER    MAMAPT
      PARAMETER (MAMAPT = 3)
      INTEGER    MASHDB
      PARAMETER (MASHDB = -4)
      INTEGER    MAMADB
      PARAMETER (MAMADB = 3)
      INTEGER    MASHFL
      PARAMETER (MASHFL = -6)
      INTEGER    MAMAFL
      PARAMETER (MAMAFL = 1)
      INTEGER    MASHFS
      PARAMETER (MASHFS = -7)
      INTEGER    MAMAFS
      PARAMETER (MAMAFS = 1)
      CHARACTER*4 ANBINA
      PARAMETER  (ANBINA = 'ANBI')
      INTEGER    BINAME
      PARAMETER (BINAME = 0)
      CHARACTER*4 ANBONA
      PARAMETER  (ANBONA = 'ANBO')
      INTEGER    BONAME
      PARAMETER (BONAME = 0)
      CHARACTER*4 ANBDNA
      PARAMETER  (ANBDNA = 'ANBD')
      INTEGER    BDNAME
      PARAMETER (BDNAME = 0)
      CHARACTER*4 ANRNNA
      PARAMETER  (ANRNNA = 'ANRN')
      INTEGER    RNSCHA
      PARAMETER (RNSCHA = 0)
      INTEGER    RNLCNA
      PARAMETER (RNLCNA = RNSCHA+1)
      INTEGER    RNSPOI
      PARAMETER (RNSPOI = RNLCNA+1)
      INTEGER    RNLPOI
      PARAMETER (RNLPOI = RNSPOI+1)
      INTEGER    RNSNAM
      PARAMETER (RNSNAM = RNLPOI+1)
      CHARACTER*4 ANRPNA
      PARAMETER  (ANRPNA = 'ANRP')
      INTEGER    RPUSED
      PARAMETER (RPUSED = 0)
      INTEGER    RPMODU
      PARAMETER (RPMODU = RPUSED+1)
      INTEGER    RPMASK
      PARAMETER (RPMASK = MASK16)
      INTEGER    RPMPAR
      PARAMETER (RPMPAR = MASK14)
      INTEGER    RPSPAR
      PARAMETER (RPSPAR = -16)
      INTEGER    RPBBIT
      PARAMETER (RPBBIT = 30)
      CHARACTER*4 ANPANA
      PARAMETER  (ANPANA = 'ANPA')
      INTEGER    PAUSED
      PARAMETER (PAUSED = 0)
      INTEGER    PASTAT
      PARAMETER (PASTAT = PAUSED+1)
      INTEGER    PAL3RS
      PARAMETER (PAL3RS = PASTAT+1)
      INTEGER    PAELEM
      PARAMETER (PAELEM = PAL3RS+1)
      INTEGER    PAMASK
      PARAMETER (PAMASK = MASK16)
      INTEGER    PAMPAR
      PARAMETER (PAMPAR = MASK13)
      INTEGER    PASPAR
      PARAMETER (PASPAR = -16)
      INTEGER    PAFBIT
      PARAMETER (PAFBIT = 29)
      INTEGER    PABBIT
      PARAMETER (PABBIT = 30)
      INTEGER    PAMBIT
      PARAMETER (PAMBIT = 31)
      INTEGER    PAFAIL
      PARAMETER (PAFAIL = 2 )
      INTEGER    PASUCC
      PARAMETER (PASUCC = 3 )
      CHARACTER*4 PTHBNA
      PARAMETER  (PTHBNA = 'PTHB')
      INTEGER    PBUSED
      PARAMETER (PBUSED = 0)
      INTEGER    PBSTAT
      PARAMETER (PBSTAT = PBUSED+1)
      INTEGER    PBL3RS
      PARAMETER (PBL3RS = PBSTAT+1)
      INTEGER    PBELST
      PARAMETER (PBELST = PBL3RS+1)
      INTEGER    PBELEM
      PARAMETER (PBELEM = 0)
      INTEGER    PBMODN
      PARAMETER (PBMODN = PBELEM+1)
      INTEGER    PBBLEN
      PARAMETER (PBBLEN = PBMODN+(ANLSCH+3)/4)
      CHARACTER*4 ANFBNA
      PARAMETER  (ANFBNA = 'ANFB')
      INTEGER    FBUSED
      PARAMETER (FBUSED = 0)
      INTEGER    FBELEM
      PARAMETER (FBELEM = FBUSED+1)
      CHARACTER*4 ANFRNA
      PARAMETER  (ANFRNA = 'ANFR')
      INTEGER    FRNREQ
      PARAMETER (FRNREQ = 0)
      INTEGER    FRNTST
      PARAMETER (FRNTST = FRNREQ+1)
      INTEGER    FRMNID
      PARAMETER (FRMNID = FRNTST+1)
      INTEGER    FRPARM
      PARAMETER (FRPARM = FRMNID+1)
      INTEGER    FRFREQ
      PARAMETER (FRFREQ = FRPARM+1)
      INTEGER    FRRQTY
      PARAMETER (FRRQTY = 0)
      INTEGER    FRMASK
      PARAMETER (FRMASK = FRRQTY+1)
      INTEGER    FRPRSC
      PARAMETER (FRPRSC = FRMASK+ANNTRG)
      INTEGER    FRMEET
      PARAMETER (FRMEET = FRPRSC+1)
      INTEGER    FRPASS
      PARAMETER (FRPASS = FRMEET+1)
      INTEGER    FRNWPR
      PARAMETER (FRNWPR = FRPASS+1)
      INTEGER    FRSELE
      PARAMETER (FRSELE = 0)
      INTEGER    FRVETO
      PARAMETER (FRVETO = 1)
      INTEGER    FREXEC
      PARAMETER (FREXEC = -1)
      CHARACTER*4 ANOUNA
      PARAMETER  (ANOUNA = 'ANOU')
      INTEGER    OUSTFL
      PARAMETER (OUSTFL = 0)
      INTEGER    OUFITY
      PARAMETER (OUFITY = OUSTFL+1)
      INTEGER    OUNBUF
      PARAMETER (OUNBUF = OUFITY+1)
      INTEGER    OUTBNK
      PARAMETER (OUTBNK = OUNBUF+1)
      INTEGER    OULREC
      PARAMETER (OULREC = OUTBNK+1)
      INTEGER    OUEREC
      PARAMETER (OUEREC = OULREC+1)
      INTEGER    OUBYTE
      PARAMETER (OUBYTE = OUEREC+1)
      INTEGER    OUALOC
      PARAMETER (OUALOC = OUBYTE+1)
      INTEGER    OUMAXB
      PARAMETER (OUMAXB = OUALOC+1)
      INTEGER    OUMAXR
      PARAMETER (OUMAXR = OUMAXB+1)
      INTEGER    OUREPO
      PARAMETER (OUREPO = OUMAXR+1)
      INTEGER    OUWTHR
      PARAMETER (OUWTHR = OUREPO+1)
      INTEGER    OUWFRQ
      PARAMETER (OUWFRQ = OUWTHR+1)
      INTEGER    OUPWRN
      PARAMETER (OUPWRN = OUWFRQ+1)
      INTEGER    OUFACT
      PARAMETER (OUFACT = OUPWRN+1)
      INTEGER    OUPLUN
      PARAMETER (OUPLUN = OUFACT+1)
      INTEGER    OUMENU
      PARAMETER (OUMENU = OUPLUN+1)
      INTEGER    OUBSMO
      PARAMETER (OUBSMO = OUMENU+1)
      INTEGER    OURUNN
      PARAMETER (OURUNN = OUBSMO+1)
      INTEGER    OURUNW
      PARAMETER (OURUNW = OURUNN+1)
      INTEGER    OURUNR
      PARAMETER (OURUNR = OURUNW+1)
      INTEGER    OUBASQ
      PARAMETER (OUBASQ = OURUNR+1)
      INTEGER    OUSEQU
      PARAMETER (OUSEQU = OUBASQ+1)
      INTEGER    OUSEQW
      PARAMETER (OUSEQW = OUSEQU+1)
      INTEGER    OUSEQR
      PARAMETER (OUSEQR = OUSEQW+1)
      INTEGER    OUODAT
      PARAMETER (OUODAT = OUSEQR+1)
      INTEGER    OUOTIM
      PARAMETER (OUOTIM = OUODAT+1)
      INTEGER    OUCDAT
      PARAMETER (OUCDAT = OUOTIM+1)
      INTEGER    OUCTIM
      PARAMETER (OUCTIM = OUCDAT+1)
      INTEGER    OULWEV
      PARAMETER (OULWEV = OUCTIM+1)
      INTEGER    OUHIEV
      PARAMETER (OUHIEV = OULWEV+1)
      INTEGER    OUFSEV
      PARAMETER (OUFSEV = OUHIEV+1)
      INTEGER    OULAEV
      PARAMETER (OULAEV = OUFSEV+1)
      INTEGER    OUTPRT
      PARAMETER (OUTPRT = OULAEV+1)
      INTEGER    OURECL
      PARAMETER (OURECL = OUTPRT+1)
      INTEGER    OURTRY
      PARAMETER (OURTRY = OURECL+1)
      INTEGER    OUFCHA
      PARAMETER (OUFCHA = OURTRY+1)
        INTEGER    OUQNAM
        PARAMETER (OUQNAM = OUFCHA+1)
        INTEGER    OUBKID
        PARAMETER (OUBKID = OUQNAM+1)
        INTEGER    OUSIGN
        PARAMETER (OUSIGN = OUBKID+1)
        INTEGER    OBRD
        PARAMETER (OBRD = OUSIGN+1)
        INTEGER    OTRNMD
        PARAMETER (OTRNMD = OBRD+1)
        INTEGER    MAXOUT
        PARAMETER (MAXOUT = 31)
      INTEGER    OUFNAM
      PARAMETER (OUFNAM = OTRNMD+1)
      INTEGER    OUBOPE
      PARAMETER (OUBOPE = 0)
      INTEGER    OUBENA
      PARAMETER (OUBENA = 1)
      INTEGER    OUBEOF
      PARAMETER (OUBEOF = 2)
      INTEGER    OUBPAT
      PARAMETER (OUBPAT = 3)
      INTEGER    OUBFIL
      PARAMETER (OUBFIL = 4)
      INTEGER    OUBOPA
      PARAMETER (OUBOPA = 5)
      INTEGER    OUBABS
      PARAMETER (OUBABS = 6)
      INTEGER    OUBIBS
      PARAMETER (OUBIBS = 7)
      INTEGER    OUBAFG
      PARAMETER (OUBAFG = 8)
      INTEGER    OUBRUN
      PARAMETER (OUBRUN = 9)
      INTEGER    OUBSEQ
      PARAMETER (OUBSEQ = 10)
      INTEGER    OUBWRN
      PARAMETER (OUBWRN = 11)
      INTEGER    OUBFUL
      PARAMETER (OUBFUL = 12)
      INTEGER    OUBABO
      PARAMETER (OUBABO = 13)
      INTEGER    OUBHOP
      PARAMETER (OUBHOP = 14)
      INTEGER    OUBHEN
      PARAMETER (OUBHEN = 15)
      INTEGER    OUBHOF
      PARAMETER (OUBHOF = 16)
      INTEGER    OUBDEN
      PARAMETER (OUBDEN = 17)
      INTEGER    OUBCAF
      PARAMETER (OUBCAF = 18)
      INTEGER    OUBAYE
      PARAMETER (OUBAYE = 19)
      INTEGER    OUBVOF
      PARAMETER (OUBVOF = 20)
      INTEGER    OUBFRM
      PARAMETER (OUBFRM = 21)
      INTEGER    OUBHAP
      PARAMETER (OUBHAP = 25)
      INTEGER    OUBICT
      PARAMETER (OUBICT = 26)
      INTEGER    OUBCTF
      PARAMETER (OUBCTF = 27)
      INTEGER    OUDICL
      PARAMETER (OUDICL = 0)
      INTEGER    OUTACL
      PARAMETER (OUTACL = 1)
      INTEGER    OUNWCL
      PARAMETER (OUNWCL = 2)
      INTEGER    OUDACL
      PARAMETER (OUDACL = 3)
      INTEGER    OUCPCL
      PARAMETER (OUCPCL = 4)
      INTEGER    OUFCLO
      PARAMETER (OUFCLO = 0)
      INTEGER    OUFANA
      PARAMETER (OUFANA = 1)
      INTEGER    OUFALL
      PARAMETER (OUFALL = 2)
      INTEGER    OURDEC
      PARAMETER (OURDEC = 0)
      INTEGER    OURHEX
      PARAMETER (OURHEX = 1)
      INTEGER    OUROCT
      PARAMETER (OUROCT = 2)
      INTEGER    OURR36
      PARAMETER (OURR36 = 3)
      INTEGER    OURALP
      PARAMETER (OURALP = 4)
      INTEGER    OUFDY
      PARAMETER( OUFDY = '000000FF'X)
      INTEGER    OUFMH
      PARAMETER( OUFMH = '0000FF00'X)
      INTEGER    OUFYR
      PARAMETER( OUFYR = 'FFFF0000'X)
      INTEGER    OUFSC
      PARAMETER( OUFSC = '000000FF'X)
      INTEGER    OUFMN
      PARAMETER( OUFMN = '0000FF00'X)
      INTEGER    OUFHR
      PARAMETER( OUFHR = 'FFFF0000'X)
      CHARACTER*4 ANFNNA
      PARAMETER  (ANFNNA = 'ANFN')
      INTEGER     FNSQNU
      PARAMETER  (FNSQNU = 0)
      INTEGER     FNCHAR
      PARAMETER  (FNCHAR = FNSQNU+1)
      INTEGER     FNFNAM
      PARAMETER  (FNFNAM = FNCHAR+1)
      CHARACTER*4 ANFDNA
      PARAMETER  (ANFDNA = 'ANFD')
      INTEGER     FDFLUN
      PARAMETER  (FDFLUN = 0)
      INTEGER     FDCHAR
      PARAMETER  (FDCHAR = FDFLUN+1)
      INTEGER     FDFSPC
      PARAMETER  (FDFSPC = FDCHAR+1)
      CHARACTER*4 ANMVNA
      PARAMETER  (ANMVNA = 'ANMV')
      INTEGER     MVOLDS
      PARAMETER  (MVOLDS = 0)
      INTEGER     MVNEWS
      PARAMETER  (MVNEWS = MVOLDS+1)
      INTEGER     MVSTRG
      PARAMETER  (MVSTRG = MVNEWS+1)
      CHARACTER*4 ANOANA
      PARAMETER  (ANOANA = 'ANOA')
      INTEGER    OANBNK
      PARAMETER (OANBNK = 0)
      INTEGER    OABANK
      PARAMETER (OABANK = OANBNK+1)
      CHARACTER*4 ANOHNA
      PARAMETER  (ANOHNA = 'ANOH')
      INTEGER     OHFLUN
      PARAMETER  (OHFLUN = 0)
      INTEGER     OHCHAR
      PARAMETER  (OHCHAR = OHFLUN+1)
      INTEGER     OHFSPC
      PARAMETER  (OHFSPC = OHCHAR+1)
      CHARACTER*4 ANOBNA
      PARAMETER  (ANOBNA = 'ANOB')
      INTEGER    OBNBNK
      PARAMETER (OBNBNK = 0)
      INTEGER    OBBANK
      PARAMETER (OBBANK = OBNBNK+1)
      CHARACTER*4 ANODNA
      PARAMETER  (ANODNA = 'ANOD')
      INTEGER    ODNBNK
      PARAMETER (ODNBNK = 0)
      INTEGER    ODBANK
      PARAMETER (ODBANK = ODNBNK+1)
      CHARACTER*4 ANORNA
      PARAMETER  (ANORNA = 'ANOR')
      INTEGER    ORNDRP
      PARAMETER (ORNDRP = 0)
      INTEGER    ORNKPT
      PARAMETER (ORNKPT = ORNDRP+1)
      INTEGER    ORECLS
      PARAMETER (ORECLS = ORNKPT+1)
      CHARACTER*4 ANOPNA
      PARAMETER  (ANOPNA = 'ANOP')
      INTEGER    OPNPAT
      PARAMETER (OPNPAT = 0)
      INTEGER    OPFSPA
      PARAMETER (OPFSPA = OPNPAT+1)
      INTEGER    OPPATH
      PARAMETER (OPPATH = 0)
      INTEGER    OPPSEV
      PARAMETER (OPPSEV = OPPATH+1)
      INTEGER    OPEXCL
      PARAMETER (OPEXCL = OPPSEV+1)
      INTEGER    OPSCAL
      PARAMETER (OPSCAL = OPEXCL+1)
      INTEGER    OPNWPA
      PARAMETER (OPNWPA = OPSCAL+1)
      CHARACTER*4 ANOONA
      PARAMETER  (ANOONA = 'ANOO')
      INTEGER    OONPAT
      PARAMETER (OONPAT = 0)
      INTEGER    OOFSPA
      PARAMETER (OOFSPA = OONPAT+1)
      INTEGER    OOPATH
      PARAMETER (OOPATH = 0)
      INTEGER    OOTOTL
      PARAMETER (OOTOTL = OOPATH+1)
      INTEGER    OOSEEN
      PARAMETER (OOSEEN = OOTOTL+1)
      INTEGER    OOSCAL
      PARAMETER (OOSCAL = OOSEEN+1)
      INTEGER    OONWPA
      PARAMETER (OONWPA = OOSCAL+1)
      CHARACTER*4 ANOFNA
      PARAMETER  (ANOFNA = 'ANOF')
      INTEGER    OFNFIL
      PARAMETER (OFNFIL = 0)
      INTEGER    OFFSFI
      PARAMETER (OfFSFI = OFNFIL+1)
      INTEGER    OFFILT
      PARAMETER (OFFILT = 0)
      INTEGER    OFFIPS
      PARAMETER (OFFIPS = OFFILT+1)
      INTEGER    OFTOTL
      PARAMETER (OFTOTL = OFFIPS+1)
      INTEGER    OFSEEN
      PARAMETER (OFSEEN = OFTOTL+1)
      INTEGER    OFSCAL
      PARAMETER (OFSCAL = OFSEEN+1)
      INTEGER    OFNWFI
      PARAMETER (OFNWFI = OFSCAL+1)
        CHARACTER*4 ANINNA
        PARAMETER  (ANINNA = 'ANIN')
        INTEGER    ANINID
        PARAMETER (ANINID = 1)
        INTEGER    INSTFL
        PARAMETER (INSTFL = 0)
        INTEGER    INBOPE
        PARAMETER (INBOPE = 0)
        INTEGER    INBFST
        PARAMETER (INBFST = 1)
        INTEGER    INBWDC
        PARAMETER (INBWDC = 2)
        INTEGER    INB$OV
        PARAMETER (INB$OV = 3)
        INTEGER    INFILT
        PARAMETER (INFILT = 4)
        INTEGER    INBFAD
        PARAMETER (INBFAD = 5)
        INTEGER    INBAYE
        PARAMETER (INBAYE = 6)
        INTEGER    INBNOR
        PARAMETER (INBNOR = 7)
        INTEGER    INBFTM
        PARAMETER (INBFTM = 8)
        INTEGER    INBALL
        PARAMETER (INBALL = 9)
        INTEGER    INFITY
        PARAMETER (INFITY = INSTFL+1)
        INTEGER    INPLUN
        PARAMETER (INPLUN = INFITY+1)
        INTEGER    INTBNK
        PARAMETER (INTBNK = INPLUN+1)
        INTEGER    INNREC
        PARAMETER (INNREC = INTBNK+1)
        INTEGER    INPROT
        PARAMETER (INPROT = INNREC+1)
        INTEGER    IN2EOF
        PARAMETER (IN2EOF = INPROT+1)
        INTEGER    INITER
        PARAMETER (INITER = IN2EOF+1)
        INTEGER    INNVAL
        PARAMETER (INNVAL = INITER+1)
        INTEGER    IN2CNT
        PARAMETER (IN2CNT = INNVAL+1)
        INTEGER    INFCHA
        PARAMETER (INFCHA = IN2CNT+1)
        INTEGER    INQNAM
        PARAMETER (INQNAM = INFCHA+1)
        INTEGER    INBKID
        PARAMETER (INBKID = INQNAM+1)
        INTEGER    INSIGN
        PARAMETER (INSIGN = INBKID+1)
        INTEGER    ITRNMD
        PARAMETER (ITRNMD = INSIGN+1)
        INTEGER    INFNAM
        PARAMETER (INFNAM = ITRNMD+1)
        INTEGER    INDICL
        PARAMETER (INDICL = 0)
        INTEGER    INTACL
        PARAMETER (INTACL = 1)
        INTEGER    INNWCL
        PARAMETER (INNWCL = 2)
        INTEGER    INCPCL
        PARAMETER (INCPCL = 3)
        INTEGER    INRTAN
        PARAMETER (INRTAN = 0)
        INTEGER    INREWD
        PARAMETER (INREWD = 1)
        INTEGER    INRNXF
        PARAMETER (INRNXF = 2)
        INTEGER    INFIXN
        PARAMETER (INFIXN = 0)
        INTEGER    INPOSS
        PARAMETER (INPOSS = 1)
        INTEGER    INUSER
        PARAMETER (INUSER = 2)
      CHARACTER*4 ANIFNA
      PARAMETER  (ANIFNA = 'ANIF')
      INTEGER     IFCLEN
      PARAMETER  (IFCLEN = 0)
      INTEGER     IFNFLS
      PARAMETER  (IFNFLS = IFCLEN+1)
      INTEGER     IFCFIL
      PARAMETER  (IFCFIL = IFNFLS+1)
      INTEGER     IFBFLS
      PARAMETER  (IFBFLS = IFCFIL+1)
      CHARACTER*4 ANISNA
      PARAMETER  (ANISNA = 'ANIS')
      INTEGER     ISNFLT
      PARAMETER  (ISNFLT = 0)
      INTEGER     ISBFLL
      PARAMETER  (ISBFLL = ISNFLT+1)
      INTEGER     ISPARM
      PARAMETER  (ISPARM = 0)
      INTEGER     ISNCHR
      PARAMETER  (ISNCHR = ISPARM+1)
      INTEGER     ISFILT
      PARAMETER  (ISFILT = ISNCHR+1)
      INTEGER     ISEXCL
      PARAMETER  (ISEXCL = ISFILT+(ANLSCH+3)/4)
      INTEGER     ISNWDS
      PARAMETER  (ISNWDS = ISEXCL+1)
      INTEGER     ISTGBM
      PARAMETER  (ISTGBM = ISNWDS+1)
      INTEGER     ENEXCL
      PARAMETER  (ENEXCL = 1)
      INTEGER     DIEXCL
      PARAMETER  (DIEXCL = 0)
      CHARACTER*4 ANCANA
      PARAMETER  (ANCANA = 'ANCA')
      INTEGER     CASTAT
      PARAMETER  (CASTAT = 0)
      INTEGER     CABANK
      PARAMETER  (CABANK = CASTAT+1)
      INTEGER    CASTMP
      PARAMETER (CASTMP = 0)
      INTEGER    CASACC
      PARAMETER (CASACC = -1)
      INTEGER    CASSUM
      PARAMETER (CASSUM = -2)
      INTEGER    CACHRF
      PARAMETER (CACHRF = -3)
      INTEGER    CAVIEW
      PARAMETER (CAVIEW = -4)
      CHARACTER*4 ANSPNA
      PARAMETER  (ANSPNA = 'ANSP')
      INTEGER    SPNUCH
      PARAMETER (SPNUCH = 0)
      INTEGER    SPTEXT
      PARAMETER (SPTEXT = SPNUCH+1)
      CHARACTER*4 ANHENA
      PARAMETER  (ANHENA = 'ANHE')
      INTEGER    HENUCH
      PARAMETER (HENUCH = 0)
      INTEGER    HETEXT
      PARAMETER (HETEXT = HENUCH+1)
      CHARACTER*4 ANTANA
      PARAMETER  (ANTANA = 'ANTA')
      INTEGER     ANMXLA
      PARAMETER  (ANMXLA = 8)
      INTEGER     ANMXDV
      PARAMETER  (ANMXDV = 32)
      INTEGER    TASTAT
      PARAMETER (TASTAT = 0)
      INTEGER    TAJFN
      PARAMETER (TAJFN  = TASTAT+1)
      INTEGER    TASEQN
      PARAMETER (TASEQN = TAJFN+1)
      INTEGER    TAALLO
      PARAMETER (TAALLO = TASEQN+1)
      INTEGER    TAUSED
      PARAMETER (TAUSED = TAALLO+1)
      INTEGER    TAMTAS
      PARAMETER (TAMTAS = TAUSED+1)
      INTEGER    TAMTDC
      PARAMETER (TAMTDC = TAMTAS+1)
      INTEGER    TAMTEC
      PARAMETER (TAMTEC = TAMTDC+1)
      INTEGER    TAMTWC
      PARAMETER (TAMTWC = TAMTEC+1)
      INTEGER    TAMTRT
      PARAMETER (TAMTRT = TAMTWC+1)
      INTEGER    TAMTTM
      PARAMETER (TAMTTM = TAMTRT+1)
      INTEGER    TACOCH
      PARAMETER (TACOCH = TAMTTM+1)
      INTEGER    TACONA
      PARAMETER (TACONA = TACOCH+1)
      INTEGER    TAFEET
      PARAMETER (TAFEET = TACONA+8)
      INTEGER    TADENS
      PARAMETER (TADENS = TAFEET+1)
      INTEGER    TABSIZ
      PARAMETER (TABSIZ = TADENS+1)
      INTEGER    TASAFE
      PARAMETER (TASAFE = TABSIZ+1)
      INTEGER    TACABY
      PARAMETER (TACABY = TASAFE+1)
      INTEGER    TAOCBY
      PARAMETER (TAOCBY = TACABY+1)
      INTEGER    TAOCLR
      PARAMETER (TAOCLR = TAOCBY+1)
      INTEGER    TAWTHR
      PARAMETER (TAWTHR = TAOCLR+1)
      INTEGER    TAWFRQ
      PARAMETER (TAWFRQ = TAWTHR+1)
      INTEGER    TAPWRN
      PARAMETER (TAPWRN = TAWFRQ+1)
      INTEGER    TAREPO
      PARAMETER (TAREPO = TAPWRN+1)
      INTEGER    TAPREP
      PARAMETER (TAPREP = TAREPO+1)
      INTEGER    TAFACT
      PARAMETER (TAFACT = TAPREP+1)
      INTEGER    TADPID
      PARAMETER (TADPID = TAFACT+1)
      INTEGER    TADVCH
      PARAMETER (TADVCH = TADPID+1)
      INTEGER    TAUSCH
      PARAMETER (TAUSCH = TADVCH+1)
      INTEGER    TALOCH
      PARAMETER (TALOCH = TAUSCH+1)
      INTEGER    TADFCH
      PARAMETER (TADFCH = TALOCH+1)
      INTEGER    TALACH
      PARAMETER (TALACH = TADFCH+1)
      INTEGER    TANOCH
      PARAMETER (TANOCH = TALACH+1)
      INTEGER    TADVNA
      PARAMETER (TADVNA = TANOCH+1)
      INTEGER    TAUSNA
      PARAMETER (TAUSNA = TADVNA+(ANMXDV/4))
      INTEGER    TALONA
      PARAMETER (TALONA = TAUSNA+4)
      INTEGER    TADFNA
      PARAMETER (TADFNA = TALONA+4)
      INTEGER    TALANA
      PARAMETER (TALANA = TADFNA+(ANMXDV/4))
      INTEGER    TANONA
      PARAMETER (TANONA = TALANA+2)
      INTEGER    TALENG
      PARAMETER (TALENG = TANONA+2)
      INTEGER    TASTAL
      PARAMETER (TASTAL = 0)
      INTEGER    TASTAM
      PARAMETER (TASTAM = 1)
      INTEGER    TASTMO
      PARAMETER (TASTMO = 2)
      INTEGER    TASTOP
      PARAMETER (TASTOP = 3)
      INTEGER    TASTIN
      PARAMETER (TASTIN = 4)
      INTEGER    TASTUL
      PARAMETER (TASTUL = 5)
      INTEGER    TASTWR
      PARAMETER (TASTWR = 6)
      INTEGER    TASTCD
      PARAMETER (TASTCD = 7)
      INTEGER    TASTDO
      PARAMETER (TASTDO = 8)
      INTEGER    TASTDR
      PARAMETER (TASTDR = 9)
      INTEGER    TASTAD
      PARAMETER (TASTAD = 10)
      INTEGER    TASTCO
      PARAMETER (TASTCO = 11)
      INTEGER    TASTOM
      PARAMETER (TASTOM = 12)
      INTEGER    TASTNC
      PARAMETER (TASTNC = 13)
      INTEGER    TASTOW
      PARAMETER (TASTOW = 14)
      INTEGER    TASTOR
      PARAMETER (TASTOR = 15)
      INTEGER    TASTMR
      PARAMETER (TASTMR = 16)
      INTEGER    TASTMF
      PARAMETER (TASTMF = 17)
      INTEGER    TASTMS
      PARAMETER (TASTMS = 18)
      INTEGER    TASTCM
      PARAMETER (TASTCM = 19)
      INTEGER    TAFCLO
      PARAMETER (TAFCLO = 0)
      INTEGER    TAFANA
      PARAMETER (TAFANA = 1)
      INTEGER    TAFALL
      PARAMETER (TAFALL = 2)
      INTEGER    TAFCYC
      PARAMETER (TAFCYC = 3)
      INTEGER    TAFACY
      PARAMETER (TAFACY = 4)
      INTEGER    TAMNON
      PARAMETER (TAMNON = 0)
      INTEGER    TAMTER
      PARAMETER (TAMTER = 1)
      INTEGER    TAMOPE
      PARAMETER (TAMOPE = 2)
      INTEGER    TAMCNO
      PARAMETER (TAMCNO = 0)
      INTEGER    TAMCAB
      PARAMETER (TAMCAB = 1)
      INTEGER    TAMCRT
      PARAMETER (TAMCRT = 2)
        INTEGER    ANPSCH
        PARAMETER (ANPSCH = 16)
        INTEGER    ANMOCH
        PARAMETER (ANMOCH = 16)
        INTEGER    ANBNL
        PARAMETER (ANBNL = 4)
        INTEGER    FLPSMN
        PARAMETER (FLPSMN = 0)
        INTEGER    FLPSNP
        PARAMETER (FLPSNP = FLPSMN+(ANMOCH+3)/ANBNL)
        INTEGER    FLPSPN
        PARAMETER (FLPSPN = FLPSNP+1)
        INTEGER    FLPSNM
        PARAMETER (FLPSNM = 0)
        INTEGER    FLPSBK
        PARAMETER (FLPSBK = FLPSNM + (ANPSCH + 3) /ANBNL)
        INTEGER    FLPSMU
        PARAMETER (FLPSMU = FLPSBK + 1)
        INTEGER    FLPSWP
        PARAMETER (FLPSWP = 2 + (ANPSCH+3)/ANBNL)
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
C$$Include 'maxstructdim.inc'
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
C== Include /kloe/soft/off/offline/inc/development/trg/maxtrgchan.cin ==
      integer maxtrgchan
      parameter (maxtrgchan=300)
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
C== Include /kloe/soft/off/offline/inc/development/tls/celestruct.cin ==
      TYPE  EmcCells
        sequence
         INTEGER n
         INTEGER nmc
         INTEGER ICL(NeleCluMax)
         INTEGER ibcel(NeleCluMax)
         INTEGER DET(NeleCluMax)
         INTEGER WED(NeleCluMax)
         INTEGER PLA(NeleCluMax)
         INTEGER COL(NeleCluMax)
         REAL    E(NeleCluMax)
         REAL    T(NeleCluMax)
         REAL    X(NeleCluMax)
         REAL    Y(NeleCluMax)
         REAL    Z(NeleCluMax)
         REAL    EA(NeleCluMax)
         REAL    TA(NeleCluMax)
         REAL    EB(NeleCluMax)
         REAL    TB(NeleCluMax)
         REAL    Etrue(NeleCluMax)
         REAL    Ttrue(NeleCluMax)
         REAL    Xtrue(NeleCluMax)
         REAL    Ytrue(NeleCluMax)
         REAL    Ztrue(NeleCluMax)
         INTEGER ptyp (neleclumax)
         INTEGER knum (neleclumax)
         INTEGER numpar(neleclumax)
      END TYPE
      TYPE (EmcCells) CELE
C== Include /kloe/soft/off/offline/inc/development/tls/evtstruct.cin ===
        TYPE EventInfo
        SEQUENCE
          INTEGER RunNumber
          INTEGER EventNumber
          INTEGER McFlag
          INTEGER EvFlag
          INTEGER Pileup
          INTEGER GenCod
          INTEGER PhiDecay
          INTEGER A1type
          INTEGER A2type
          INTEGER A3type
          INTEGER B1type
          INTEGER B2type
          INTEGER B3type
          INTEGER T3DOWN
          INTEGER T3FLAG
          REAL ECAP(2)
          REAL DCNOISE(4)
        END TYPE
        Integer len_eventinfostru
        Parameter (len_eventinfostru=21)
        TYPE (EventInfo) INFO
C= Include /kloe/soft/off/offline/inc/development/tls/geanfistruct.cin =
        TYPE GeanfiInformation
         SEQUENCE
         INTEGER Ntrk
         INTEGER kin(maxNtrkGen)
         INTEGER Pid(MaxNtrkGen)
         INTEGER virmom(maxNtrkGen)
         INTEGER Indv(MaxNtrkGen)
         REAL    Px(MaxNtrkGen)
         REAL    Py(MaxNtrkGen)
         REAL    Pz(MaxNtrkGen)
         REAL    Xcv(MaxNtrkGen)
         REAL    ycv(MaxNtrkGen)
         REAL    zcv(MaxNtrkGen)
         REAL    tofcv(MaxNtrkGen)
         REAL    Theta(MaxNtrkGen)
         REAL    Phi(MaxNtrkGen)
         INTEGER ndchmc (MaxNtrkGen)
         INTEGER nlaymc (MaxNtrkGen)
         INTEGER TrkFlag(MaxNtrkGen)
         REAL    Tofmc  (MaxNtrkGen)
         REAL    TrkLen (MaxNtrkGen)
         REAL    xfhmc(MaxNtrkGen)
         REAL    yfhmc(MaxNtrkGen)
         REAL    zfhmc(MaxNtrkGen)
         REAL    pxfhmc(MaxNtrkGen)
         REAL    pyfhmc(MaxNtrkGen)
         REAL    pzfhmc(MaxNtrkGen)
         REAL    xlhmc(MaxNtrkGen)
         REAL    ylhmc(MaxNtrkGen)
         REAL    zlhmc(MaxNtrkGen)
         REAL    pxlhmc(MaxNtrkGen)
         REAL    pylhmc(MaxNtrkGen)
         REAL    pzlhmc(MaxNtrkGen)
         INTEGER NumVtx
         INTEGER Kinmom(MaxNvtxGen)
         INTEGER mother(MaxNvtxGen)
         REAL    Tof(MaxNvtxGen)
         REAL    Xv(MaxNvtxGen)
         REAL    Yv(MaxNvtxGen)
         REAL    Zv(MaxNvtxGen)
         REAL    TrkVtx(MaxNvtxGen)
        END TYPE
        TYPE( GeanfiInformation) MC
C=== Include /kloe/soft/off/offline/inc/development/tls/vtxstru.cin ====
        TYPE Vertex
         SEQUENCE
         INTEGER n
         INTEGER Ntrk(MaxNumvtx)
         REAL    X(MaxNumVtx)
         REAL    Y(MaxNumVtx)
         REAL    Z(MaxNumVtx)
         REAL    COV1(MaxNumVtx)
         REAL    COV2(MaxNumVtx)
         REAL    COV3(MaxNumVtx)
         REAL    COV4(MaxNumVtx)
         REAL    COV5(MaxNumVtx)
         REAL    COV6(MaxNumVtx)
         REAL    CHI2(MaxNumVtx)
         INTEGER QUAL(MaxNumVtx)
         INTEGER FITID(MaxNumVtx)
        END TYPE
        TYPE (Vertex) VTX
        TYPE TracksVertex
         SEQUENCE
         INTEGER n
         INTEGER iv(MaxNumtrkv)
         INTEGER TrkPoi(MaxNumtrkv)
         REAL    cur(MaxNumtrkv)
         REAL    phi(MaxNumtrkv)
         REAL    cot(MaxNumtrkv)
         REAL    px(MaxNumtrkv)
         REAL    py(MaxNumtrkv)
         REAL    pz(MaxNumtrkv)
         REAL    pmod(MaxNumtrkv)
         REAL    Length(MaxNumtrkv)
         REAL    CHI2(MaxNumTrkV)
         INTEGER ipid(MaxNumtrkv)
         REAL cov11(MaxNumTrkV)
         REAL cov12(MaxNumTrkV)
         REAL cov13(MaxNumTrkV)
         REAL cov22(MaxNumTrkV)
         REAL cov23(MaxNumTrkV)
         REAL cov33(MaxNumTrkV)
        END TYPE
        TYPE (TracksVertex) TRKV
C=== Include /kloe/soft/off/offline/inc/development/tls/trkstru.cin ====
        TYPE AllTracks
        SEQUENCE
         INTEGER n
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
         REAL    SigPCA(MaxNumTrk)
         REAL    SigZeta(MaxNumTrk)
         REAL    SigCurv(MaxNumTrk)
         REAL    SigCot(MaxNumTrk)
         REAL    SigPhi(MaxNumTrk)
         INTEGER NMSkink(MaxNumTrk)
        END TYPE
        TYPE (AllTracks) TRK
        TYPE AllTracksMC
        SEQUENCE
         INTEGER n
         INTEGER ncontr(MaxNumTrk)
         INTEGER kine1(MaxNumTrk)
         INTEGER type1(MaxNumTrk)
         INTEGER hits1(MaxNumTrk)
         INTEGER kine2(MaxNumTrk)
         INTEGER type2(MaxNumTrk)
         INTEGER hits2(MaxNumTrk)
         INTEGER kine3(MaxNumTrk)
         INTEGER type3(MaxNumTrk)
         INTEGER hits3(MaxNumTrk)
         REAL xfirst(MaxNumTrk)
         REAL yfirst(MaxNumTrk)
         REAL zfirst(MaxNumTrk)
         REAL pxfirst(MaxNumTrk)
         REAL pyfirst(MaxNumTrk)
         REAL pzfirst(MaxNumTrk)
         REAL xlast(MaxNumTrk)
         REAL ylast(MaxNumTrk)
         REAL zlast(MaxNumTrk)
         REAL pxlast(MaxNumTrk)
         REAL pylast(MaxNumTrk)
         REAL pzlast(MaxNumTrk)
         REAL xmcfirst(MaxNumTrk)
         REAL ymcfirst(MaxNumTrk)
         REAL zmcfirst(MaxNumTrk)
         REAL pxmcfirst(MaxNumTrk)
         REAL pymcfirst(MaxNumTrk)
         REAL pzmcfirst(MaxNumTrk)
         REAL xmclast(MaxNumTrk)
         REAL ymclast(MaxNumTrk)
         REAL zmclast(MaxNumTrk)
         REAL pxmclast(MaxNumTrk)
         REAL pymclast(MaxNumTrk)
         REAL pzmclast(MaxNumTrk)
        END TYPE
        TYPE (AllTracksMC) TRKMC
C= Include /kloe/soft/off/offline/inc/development/tls/dprs_struct.cin ==
      Integer           MAX_DPRS
      Parameter        (MAX_DPRS = 200)
      Type DPRS_TYPE
        Sequence
        Integer
     &      NDPRS,
     &      NVIEW(3)
        Integer
     &      IDPRS(MAX_DPRS),
     &      VERS(MAX_DPRS),
     &      NPOS(MAX_DPRS),
     &      NNEG(MAX_DPRS)
        Real
     &      XPCA(MAX_DPRS),
     &      YPCA(MAX_DPRS),
     &      ZPCA(MAX_DPRS),
     &      XLST(MAX_DPRS),
     &      YLST(MAX_DPRS),
     &      ZLST(MAX_DPRS),
     &      CURP(MAX_DPRS),
     &      PHIP(MAX_DPRS),
     &      COTP(MAX_DPRS),
     &      QUAL(MAX_DPRS)
        Integer
     &      IPFL(MAX_DPRS),
     &      KINE(MAX_DPRS),
     &      NHKINE(MAX_DPRS)
      End Type
      TYPE (DPRS_TYPE)
     &    DPRS
      Character*(*)     DPRS_NTP_STR
      Parameter        (DPRS_NTP_STR =
     &    'nDPRS[0,200]:U,'//
     &    'nView(3):U:8,'//
     &    'iDPRS(nDPRS):U:8,'//
     &    'DPRSver(nDPRS):U:8,'//
     &    'nPos(nDPRS):U:8,'//
     &    'nNeg(nDPRS):U:8,'//
     &    'xPCA(nDPRS):R,'//
     &    'yPCA(nDPRS):R,'//
     &    'zPCA(nDPRS):R,'//
     &    'xLst(nDPRS):R,'//
     &    'yLst(nDPRS):R,'//
     &    'zLst(nDPRS):R,'//
     &    'curP(nDPRS):R,'//
     &    'phiP(nDPRS):R,'//
     &    'cotP(nDPRS):R,'//
     &    'qual(nDPRS):R,'//
     &    'IPFl(nDPRS):U:4,'//
     &    'prKINE(nDPRS):U:8,'//
     &    'prKHIT(nDPRS):U:8')
C=== Include /kloe/soft/off/offline/inc/development/tls/dhspstru.cin ===
        TYPE AllDCDhsp
         SEQUENCE
         INTEGER numDHSP
         INTEGER itrk(MaxNumDHSP)
         INTEGER layer(MaxNumDHSP)      
         INTEGER wire(MaxNumDHSP)
         REAL    time(MaxNumDHSP)
         REAL    drift(MaxNumDHSP)
         REAL    res(MaxNumDHSP)
         REAL    x(MaxNumDHSP)
         REAL    y(MaxNumDHSP)
         REAL    z(MaxNumDHSP)
        END TYPE
        TYPE (AllDCDhsp) DHSPSTRU
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
C== Include /kloe/soft/off/offline/inc/development/tls/cfhistruct.cin ==
        TYPE emcfirsthit
        SEQUENCE
        integer n
        integer pid(maxnumfirsthit)
        integer kinum(maxnumfirsthit)
        integer celadr(maxnumfirsthit)
        integer convfl(maxnumfirsthit)
        real    time(maxnumfirsthit)
        real    x(maxnumfirsthit)
        real    y(maxnumfirsthit)
        real    z(maxnumfirsthit)
        real    px(maxnumfirsthit)
        real    py(maxnumfirsthit)
        real    pz(maxnumfirsthit)
        real    tof(maxnumfirsthit)
        real    tlen(maxnumfirsthit)
        END TYPE
        TYPE (emcfirsthit) cfhi
C== Include /kloe/soft/off/offline/inc/development/tls/qihistruct.cin ==
        TYPE QcalHits
          SEQUENCE
                integer  N
                integer  PTY (nqihimax)
                integer  ADD (nqihimax)
                integer  KINE(nqihimax)
                real     X   (nqihimax)
                real     Y   (nqihimax)
                real     Z   (nqihimax)
                real     PX  (nqihimax)
                real     PY  (nqihimax)
                real     PZ  (nqihimax)
                real     TOF (nqihimax)
                real     ENE (nqihimax)
                real     TRL (nqihimax)
        END TYPE
        TYPE (QcalHits) QHIT
C== Include /kloe/soft/off/offline/inc/development/tls/qcalstruct.cin ==
        TYPE QcalEle
        SEQUENCE
           integer n
           integer wed(nqcalmax)
           integer det(nqcalmax)
           real    E  (nqcalmax)
           real    T  (nqcalmax)
        END TYPE
        TYPE (QcalEle) QELE
        TYPE QcalRealHit
        SEQUENCE
           integer n
           real ene (nqcalmax)
           real x   (nqcalmax)
           real y   (nqcalmax)
           real z   (nqcalmax)
           real t   (nqcalmax)
        END TYPE
        TYPE (QcalRealHit) QCAL
C== Include /kloe/soft/off/offline/inc/development/trg/telestruct.cin ==
      TYPE trgELE
      sequence
         integer ntele
         integer sector(maxtrgchan)  
         integer det(maxtrgchan)
         integer serkind(maxtrgchan)
         real Ea(maxtrgchan)    
         real Eb(maxtrgchan)    
         real Ta(maxtrgchan)    
         real Tb(maxtrgchan)    
         integer bitp(maxtrgchan)  
      end type
      type(trgELE) TELE
C= Include /kloe/soft/off/offline/inc/development/trg/pizzastruct.cin ==
      TYPE pizzastruct
      sequence
         integer npizza
         integer sector(maxtrgchan)  
         integer det(maxtrgchan)
         integer serkind(maxtrgchan)
         real Ea(maxtrgchan)    
         real Eb(maxtrgchan)    
         real E_rec(maxtrgchan)
         real Z_mod(maxtrgchan)
      end type
      type(pizzastruct) PIZZA
C= Include /kloe/soft/off/offline/inc/development/tls/preclustruct.cin =
        TYPE EmcPreCluster      
         SEQUENCE
         INTEGER n
         REAL    E(MaxNumCLu)
         REAL    X(MaxNumCLu)
         REAL    Y(MaxNumCLu)
         REAL    Z(MaxNumCLu)
         REAL    T(MaxNumCLu)
         REAL    TA(MaxNumCLu)
         REAL    TB(MaxNumCLu)
         REAL    TrmsA(MaxNumCLu)
         REAL    TrmsB(MaxNumCLu)
         INTEGER Flag (MaxNumCLu)
        END TYPE
        TYPE (EmcPreCluster) PRECLU
C=== Include /kloe/soft/off/offline/inc/development/tls/nvostru.cin ====
      INTEGER MaxNumKNVO
      PARAMETER (MaxNumKNVO = 40)       
      TYPE KNVOStru
      SEQUENCE
      integer n                
      integer iknvo(MaxNumKNVO) 
      real    px(MaxNumKNVO)   
      real    py(MaxNumKNVO)
      real    pz(MaxNumKNVO)
      integer pid(MaxNumKNVO)  
      integer bank(MaxNumKNVO) 
      integer vlinked(MaxNumKNVO) 
      END TYPE
      TYPE (KNVOStru) KNVO
      INTEGER MaxNumVNVO
      PARAMETER (MaxNumVNVO = 40)       
      TYPE VNVOStru
      SEQUENCE
      integer n                 
      integer ivnvo(MaxNumVNVO) 
      real vx(MaxNumVNVO)  
      real vy(MaxNumVNVO)
      real vz(MaxNumVNVO)
      integer kori(MaxNumVNVO) 
      integer idvfs(MaxNumVNVO) 
      integer nknv(MaxNumVNVO) 
      integer fknv(MaxNumVNVO) 
      END TYPE
      TYPE (VNVOStru) VNVO
      INTEGER MaxNumVNVOb
      PARAMETER (MaxNumVNVOb = 40)      
      TYPE VNVBStru
      SEQUENCE
      integer n                 
      integer ibank(MaxNumVNVOb) 
      END TYPE
      TYPE (VNVBStru) VNVB
      INTEGER MaxNumINVO
      PARAMETER (MaxNumINVO = 40)       
      TYPE INVOStru
      SEQUENCE
      integer n                 
      integer iinvo(MaxNumINVO) 
      integer iclps(MaxNumINVO) 
      real xi(MaxNumINVO)     
      real yi(MaxNumINVO)
      real zi(MaxNumINVO)
      real ti(MaxNumINVO)     
      real lk(MaxNumINVO)     
      real sigmalk(MaxNumINVO) 
      END TYPE
      TYPE (INVOStru) INVO
C=== Include /kloe/soft/off/offline/inc/development/tls/eclostru.cin ===
      INTEGER MaxNumCLINF
      PARAMETER (MaxNumCLINF = 100)     
      TYPE ECLOStru
        SEQUENCE
          INTEGER  n
          INTEGER  TotWord(MaxNumCLINF)
          INTEGER  idpart(MaxNumCLINF)
          INTEGER  dtclpo(MaxNumCLINF)
          INTEGER  dvvnpo(MaxNumCLINF)
          INTEGER  stre(MaxNumCLINF)
          INTEGER  algo(MaxNumCLINF)
          INTEGER  n2
          INTEGER  TotWord2(MaxNumCLINF)
          INTEGER  idpart2(MaxNumCLINF)
          INTEGER  dtclpo2(MaxNumCLINF)
          INTEGER  dvvnpo2(MaxNumCLINF)
          INTEGER  stre2(MaxNumCLINF)
          INTEGER  algo2(MaxNumCLINF)
        END TYPE
      TYPE (ECLOStru) CLINF
C=== Include /kloe/soft/off/offline/inc/development/tls/t0struct.cin ===
      TYPE t0struct
        SEQUENCE
          REAL     dc_step0
          REAL     hit_step0
          REAL     clus_step0
          REAL     step1
          REAL     cable
          REAL     tbunch
          REAL     tphased_mc
        END TYPE
      TYPE (t0struct) T0STRU
C== Include /kloe/soft/off/offline/inc/development/tls/cwrkstruct.cin ==
      TYPE  EmcHits
        sequence
         INTEGER n
         INTEGER add  (NeleCluMax)
         INTEGER cele (NeleCluMax)
         INTEGER icl  (NeleCluMax)
         INTEGER Nhit (NeleCluMax)
         INTEGER Kine (NeleCluMax)
         REAL    E(NeleCluMax)
         REAL    T(NeleCluMax)
         REAL    X(NeleCluMax)
         REAL    Y(NeleCluMax)
         REAL    Z(NeleCluMax)
      END TYPE
      TYPE (EmcHits) CWRK
C=== Include /kloe/soft/off/offline/inc/development/tls/tellina.cin ====
      TYPE tele_short
      sequence
         integer n
         integer add(maxtrgchan)  
         real Ea(maxtrgchan)    
         real Eb(maxtrgchan)    
         real Ta(maxtrgchan)    
         real Tb(maxtrgchan)    
         integer bitp(maxtrgchan)  
      end type
      type(tele_short) TELLINA
C=== Include /kloe/soft/off/offline/inc/development/tls/pizzetta.cin ===
      TYPE pizza_short
      sequence
         integer n
         integer add(maxtrgchan)
         real Ea(maxtrgchan)    
         real Eb(maxtrgchan)    
         real E_rec(maxtrgchan)
         real Z_mod(maxtrgchan)
      end type
      type(pizza_short) PIZZETTA
C== Include /kloe/soft/off/offline/inc/development/trg/trgstruct.cin ===
      integer NSLAYER
      parameter(NSLAYER=10)
      TYPE triggerstruct
      sequence
        real    tspent
        real    tdead
        integer type
        integer bphi
        integer ephi
        integer wphi
        integer bbha
        integer ebha
        integer wbha
        integer bcos
        integer ecos
        integer wcos
        integer e1w1_dwn
        integer b1_dwn
        integer t0d_dwn
        integer vetocos
        integer vetobha
        integer bdw
        integer rephasing
        integer tdc1_pht1
        integer dt2_t1
        integer fiducial
        integer t1c
        integer t1d
        integer t2d
        integer tcr
        integer tcaf_tcrd
        integer tcaf_t2d
        integer moka_t2d
        integer moka_t2dsl(NSLAYER)
      end type
      type(triggerstruct) TRG
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
C== Include /kloe/soft/off/offline/inc/development/tls/gdchitstru.cin ==
      TYPE gdchitStru
      SEQUENCE
      INTEGER  nhit
      INTEGER  nhpr
      INTEGER  nhtf
      END TYPE
      TYPE (gdchitStru) ghit
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
C=== Include /kloe/soft/off/offline/inc/development/tls/trkqstru.cin ===
      INTEGER MaxNumTrkQ
      PARAMETER (MaxNumTrkQ = 100)
        TYPE AllTracksQ
        SEQUENCE
        INTEGER  flagqt                 
         REAL    dist                   
         INTEGER n                      
         REAL    Xi(2,MaxNumTrkQ)       
         REAL    Yi(2,MaxNumTrkQ)       
         REAL    Zi(2,MaxNumTrkQ)       
         INTEGER det(2,MaxNumTrkQ)      
         INTEGER wed(2,MaxNumTrkQ)      
         INTEGER Fnearest(2,MaxNumTrkQ) 
         INTEGER Ferror(MaxNumTrkQ)     
         INTEGER Fqhit(2,MaxNumTrkQ)    
         INTEGER FqhitRAW(MaxNumTrkQ)   
         REAL    PHYabs(2,MaxNumTrkQ)   
         REAL    PHYrel(2,MaxNumTrkQ)   
         REAL    theta(MaxNumTrkQ)      
         INTEGER itrk(MaxNumTrkQ)       
      END TYPE
      TYPE (AllTracksQ) TRKQ
C== Include /kloe/soft/off/offline/inc/development/tls/dtcestruct.cin ==
      Type DChits
        Sequence
        Integer nDTCE
        Integer nSmall
        Integer iLayerDTCE(nMaxDC)
        Integer iWireDTCE(nMaxDC)
        Real    tDTCE(nMaxDC)
      End Type
      Type (DChits) DTCE
C== Include /kloe/soft/off/offline/inc/development/tls/dhrestruct.cin ==
      Type DCdrift
        Sequence
        Integer nDHRE
        Integer iLayerDHRE(nMaxDC)
        Integer iWireDHRE(nMaxDC)
        Real    rDHRE(nMaxDC)
        Real    eDHRE(nMaxDC)
        Integer iTrkDHRE(nMaxDC)
      End Type
      Type (DCdrift) DHRE
C= Include /kloe/soft/off/offline/inc/development/tls/sec2clustru.cin ==
      Type Sector
        Sequence
        Integer Nsect
        Integer Nsect_noclu
        Integer Nsect_clu
        Integer NocluAdd(MaxNumClu) 
        Integer nclus               
        Integer NNorm(MaxNumClu)    
        Integer Nover(MaxNumclu)
        Integer Ncosm(MaxNumclu)
        Integer NormAdd(MaxNumClu)  
        Integer OverAdd(MaxNumClu)  
        Integer CosmAdd(MaxNumClu)  
      End Type
      Type (Sector) S2CLU
C== Include /kloe/soft/off/offline/inc/development/tls/cspsstruct.cin ==
      INTEGER NhitCluMax
      PARAMETER (NhitCluMax = 2000 )
      Type EmcSpacePoints
        Sequence
        Integer Ncel
        Integer Nclu
        Integer Iclu(NhitCluMax)
        Integer Icel(NhitCluMax)
        Integer Ibcel(NhitCluMax)
        Integer Flag(NhitCluMax)
        Integer Add (NhitCluMax)
        Integer Nhit(NhitCluMax)
        Real    TA  (NhitCluMax)
        Real    TB  (NhitCluMax)
        Real    Ea  (NhitCluMax)
        Real    Eb  (NhitCluMax)
        Real    T   (NhitCluMax)
        Real    E   (NhitCluMax)
        Real    X   (NhitCluMax)
        Real    Y   (NhitCluMax)
        Real    Z   (NhitCluMax)
      End Type
      Type (EmcSpacePoints) CSPS
      TYPE  EmcMCSpacePoints
        sequence
          Integer Ncel
          Integer Nclu
          Integer IHit(NhitCluMax)
          Integer Nhit(NhitCluMax)
          Integer knum(NhitCluMax)
          Real    X(NhitCluMax)
          Real    Y(NhitCluMax)
          Real    Z(NhitCluMax)
          Real    T(NhitCluMax)
          Real    E(NhitCluMax)
      END TYPE
      TYPE (EmcMCSpacePoints) CSPSMC
C== Include /kloe/soft/off/offline/inc/development/tls/cluostruct.cin ==
      INTEGER NcluoMax
      PARAMETER (NcluoMax = 100 )
      Type EmcCluObjects
        Sequence
        Integer N
        Integer Ncel(NcluoMax)
        Real    Flag(NcluoMax)
        Real    Chi2(NcluoMax)
        Real    Like(NcluoMax)
        Real    E   (NcluoMax)
        Real    X   (NcluoMax)
        Real    Y   (NcluoMax)
        Real    Z   (NcluoMax)
        Real    T   (NcluoMax)
      End Type
      Type (EmcCluObjects) CLUO
C= Include /kloe/soft/off/offline/inc/development/tls/cluomcstruct.cin =
      INTEGER NMCcluoMax
      PARAMETER (NMCcluoMax = 100 )
      Type EmcMCCluObjects
        Sequence
        Integer Npar
        Integer Nclu
        Integer Ncel(NMCcluoMax)
        Integer Iclu(NMCcluoMax)
        Integer Kine(NMCcluoMax)
        REAL    E   (NMCcluoMax)
        REAL    X   (NMCcluoMax)
        REAL    Y   (NMCcluoMax)
        REAL    Z   (NMCcluoMax)
        REAL    T   (NMCcluoMax)
      End Type
      Type (EmcMCCluObjects) CLUOMC
C== Include /kloe/soft/off/offline/inc/development/tls/dhitstruct.cin ==
      INTEGER maxnumdhit
      parameter (maxnumdhit = 2500)
      TYPE mcdc_dhit
        SEQUENCE
         integer n
         integer pid(maxnumdhit)
         integer kinum(maxnumdhit)
         integer celadr(maxnumdhit)
         real    x(maxnumdhit)
         real    y(maxnumdhit)
         real    z(maxnumdhit)
         real    px(maxnumdhit)
         real    py(maxnumdhit)
         real    pz(maxnumdhit)
         real    time(maxnumdhit)
         real    dedx(maxnumdhit)
         real    tlen(maxnumdhit)
         real    dtime(maxnumdhit)
         real    dfromw(maxnumdhit)
         integer flag(maxnumdhit)
      END TYPE
      TYPE (mcdc_dhit) dhit
C== Include /kloe/soft/off/offline/inc/development/tls/dedx2stru.cin ===
       INTEGER  MAXNUMEROADC
       PARAMETER(MAXNUMEROADC = 200)
       INTEGER  MAXNUMTRACCE
       PARAMETER(MAXNUMTRACCE = 20)
       Type DEDX2STRUstruct
        SEQUENCE
        integer numdedx
        integer numeroadc(MaxNumTRACCE)
        integer indicededx(MaxNumTRACCE)
        INTEGER whw1(MAXNUMEROADC,MAXNUMTRACCE)
        INTEGER whw2(MAXNUMEROADC,MAXNUMTRACCE)
        INTEGER Lay(MAXNUMEROADC,MAXNUMTRACCE)
        INTEGER Wir1(MAXNUMEROADC,MAXNUMTRACCE)
        INTEGER Wir2(MAXNUMEROADC,MAXNUMTRACCE)
        INTEGER Was1(MAXNUMEROADC,MAXNUMTRACCE)
        INTEGER Was2(MAXNUMEROADC,MAXNUMTRACCE)
        REAL    step(MAXNUMEROADC,MAXNUMTRACCE)
        REAL    effs(MAXNUMEROADC,MAXNUMTRACCE)
        REAL    Tim1(MAXNUMEROADC,MAXNUMTRACCE)
        REAL    Tim2(MAXNUMEROADC,MAXNUMTRACCE)
        REAL    carica(MAXNUMEROADC,MAXNUMTRACCE)
       end Type
       type(dedx2strustruct) DEDX2STRU
C= Include /kloe/soft/off/offline/inc/development/tls/eleqcaltstru.cin =
      INTEGER     MaxQCALTChan
      PARAMETER ( MaxQCALTChan = 1920 ) 
      INTEGER     MaxQCALTHits
      PARAMETER ( MaxQCALTHits = 5)
      TYPE  QCALTStructure
      SEQUENCE
      INTEGER Nele
      INTEGER Nhit(MaxQCALTChan)
      INTEGER Addr(MaxQCALTChan)
      INTEGER Qdet(MaxQCALTChan)
      INTEGER Qmod(MaxQCALTChan)
      INTEGER Qpla(MaxQCALTChan)
      INTEGER Qtil(MaxQCALTChan)
      REAL    Time(MaxQCALTChan,MaxQCALTHits)
      END TYPE
C$$INCLUDE 'K$ITLS:qcalthitstru.cin'    ! QCALT hit structure
C= Include /kloe/soft/off/offline/inc/development/tls/ele2hitqcalt.cin =
      INTEGER     RunN, EvtN
      INTEGER     NtuId
      INTEGER     MaxNChan
      PARAMETER ( MaxNChan = 1920 )
      INTEGER     MaxNHits
      PARAMETER ( MaxNHits = 5)
      TYPE  QHITStructure
      SEQUENCE
      INTEGER Nele
      INTEGER Nhit(MaxNChan)
      REAL X(MaxNChan)
      REAL Y(MaxNChan)
      REAL Z(MaxNChan)
      REAL Time(MaxNChan,MaxNHits)
      END TYPE
      TYPE (QHITStructure) QCALTHIT
      LOGICAL HitNtuBok
      COMMON /ELE2HITCom/ HitNtuBok,RunN,EvtN
C=== Include /kloe/soft/off/offline/inc/development/tls/ccaltnum.cin ===
        integer    CCALT_A,   CCALT_B                   
        parameter (CCALT_A=5, CCALT_B=6)
        integer    CCALT_CRY    
        parameter (CCALT_CRY=48)
        integer    CCALT_LAYMIN,   CCALT_LAYMAX
        parameter (CCALT_LAYMIN=1, CCALT_LAYMAX=2)
        integer    CCALT_COLMIN,CCALT_COLMAX            
        parameter (CCALT_COLMIN=1, CCALT_COLMAX=24)
        Integer    CCALTCHAN
        Parameter (CCALTCHAN=96)
C== Include /kloe/soft/off/offline/inc/development/tls/ccaltstru.cin ===
        TYPE  CCALTStructure
          SEQUENCE
           INTEGER NEle
           INTEGER Cry(CCALTChan)
           INTEGER Det(CCALTChan)
           INTEGER Col(CCALTChan)
           INTEGER Pla(CCALTChan)
           REAL    T(CCALTChan)
        END TYPE
        TYPE(CCALTStructure) CCALTStru
C== Include /kloe/soft/off/offline/inc/development/tls/letestruct.cin ==
      INTEGER     LETMaxCh
      PARAMETER ( LETMaxCh = 40)
        TYPE  LETEStr
          SEQUENCE
           INTEGER NEle
           INTEGER Calib
           INTEGER Cry(LETMaxCh)
           INTEGER Det(LETMaxCh)
           INTEGER Col(LETMaxCh)
           INTEGER Pla(LETMaxCh)
           REAL    E(LETMaxCh)
           REAL    T(LETMaxCh)
        END TYPE
        TYPE(LETEStr) LETE
C$$INCLUDE 'k$itls:raw2itce.cin'       ! IT element structure
C== Include /kloe/soft/off/offline/inc/development/tls/itcestruct.cin ==
        integer nmax_itce
        parameter (nmax_itce=25000)
        type itcestruct
        sequence
           integer nitce
           integer foil(nmax_itce)
           integer layer(nmax_itce)
           integer strip(nmax_itce)
           integer view(nmax_itce)
           integer inditkine(nmax_itce)
        end type
        type(itcestruct) itce
C=== Include /kloe/soft/off/offline/inc/development/tls/hetenum.cin ====
      Integer   HETECHAN
      Parameter (HETECHAN = 64)   
      Integer   MAXHITHET
      Parameter (MAXHITHET = 30)  
      Integer   TURNNUM
      Parameter (TURNNUM = 4)     
      Integer   MAXHETTDCVAL      
      Parameter (MAXHETTDCVAL = 1920)
C=== Include /kloe/soft/off/offline/inc/development/tls/hetestru.cin ===
      TYPE HETEStructure
        SEQUENCE
          INTEGER NHETDCs                    
          INTEGER HDet(MAXHETTDCVAL)         
          INTEGER HCol(MAXHETTDCVAL)         
          INTEGER nTurnHet(MAXHETTDCVAL)     
          REAL    TimeHet(MAXHETTDCVAL)      
      END TYPE
      TYPE (HETEStructure) HETE
C=== Include /kloe/soft/off/offline/inc/development/tls/raw2dtce.cin ===
      INTEGER     NumberOfChains, NumberOfCrates
      INTEGER     NumberOfSlots, NumberOfChannels
      INTEGER     NumberOfLayers, MxWires
      PARAMETER ( NumberOfChains =  4 )
      PARAMETER ( NumberOfCrates =  6 )
      PARAMETER ( NumberOfSlots  = 16 )
      PARAMETER ( NumberOfChannels = 96 )
      PARAMETER ( NumberOfLayers = 58 )
      PARAMETER ( MxWires = 378)
      INTEGER     NtuId
      PARAMETER ( NtuId = 2 )
      LOGICAL     NtuBok
      LOGICAL TZeroFromDB
      LOGICAL TZeroSub
      LOGICAL COSMICI
      LOGICAL FILICALDI
      LOGICAL FROMFILE
      CHARACTER*100 TZeroFile
      INTEGER FileLen
      LOGICAL FileExist
      Integer DTCEMaxEle,nMaxDCHR
      REAL    HOTSOGLIA
      COMMON/Raw2DTCECommon/ntuBok,tZeroSub
     +,      tZeroFromDB,tZeroFile,cosmici,filicaldi
     +,      fromFile,DTCEMaxEle,hotSoglia,nMaxDCHR
      TYPE TZeroValues
        SEQUENCE
        REAL    TZer
        REAL    SigT
      END TYPE
      TYPE(TZeroValues) TZER(1:NumberOfLayers,1:MxWires)        
      COMMON / TZeroCommon / TZER
      INTEGER RunNum, TrgNum
      INTEGER MxChandc
      PARAMETER( MxChanDC = 12582)
      TYPE DTCEStructure
        SEQUENCE
        INTEGER NEle
        Integer nDCHR
        Integer nSmallDCm
        Integer nSmallDCp
        Integer nBigDCm
        Integer nBigDCp
        INTEGER Lay(MxChanDC)
        INTEGER Wir(MxChanDC)
        REAL    Time(MxChanDC)
        REAL    Charge(MxChanDC)
      END TYPE
      TYPE(DTCEStructure) DTCEStru
      COMMON / DTCEStruHBook / RunNum,TrgNum, DTCEStru
      TYPE HotWires
        SEQUENCE
        INTEGER HOT
      END TYPE
      TYPE(HotWires) HOT(1:NumberOfLayers,1:MxWires)    
      COMMON / HotCommon / HOT
      INTEGER DCCHAIN(10)
      data DCCHAIN / 1,0,2,0,0,0,0,3,0,4/
C=== Include /kloe/soft/off/offline/inc/development/tls/prod2ntu.cin ===
        TYPE prod2ntu_Params
          SEQUENCE
                INTEGER NtId
                CHARACTER*80 NtTitle
        END TYPE
      INTEGER prod2ntu_NtId
      PARAMETER (prod2ntu_NtId = 1)
      CHARACTER*(*) prod2ntu_Title
      PARAMETER (prod2ntu_Title = 'prod')
        TYPE NtupleEvent
          SEQUENCE
            TYPE (EventInfo)         INFO
            TYPE (EmcCluster)        CLU
            TYPE (EmcCells)          CELE
            TYPE (Vertex)            VTX        
            TYPE (TracksVertex)      TRKV
            TYPE (AllTracks)         TRK
            TYPE (AllTracksMC)       TRKMC
            TYPE (DPRS_TYPE)         DPRS
            TYPE (TrackCluster)      TCLO
            TYPE (GeanfiInformation) MC
            TYPE (emcfirsthit)       CFHI
            TYPE (QcalHits)          QHIT
            TYPE (QcalEle)           QELE
            TYPE (QcalRealHit)       QCAL
            TYPE (AllDCDhsp)         DHSP
            TYPE (EmcPreCluster)     PRECLU
            TYPE (KNVOStru)          KNVO
            TYPE (VNVOStru)          VNVO
            TYPE (VNVBStru)          VNVB
            TYPE (INVOStru)          INVO
            TYPE (Eclostru)          ECLO
            TYPE (TrgEle)            TELE
            TYPE (pizzastruct)       PIZZA
            TYPE (t0struct)          T0STRU
            TYPE (EmcHits)           CWRK
            TYPE (pizza_short)       PIZZETTA
            TYPE (tele_short)        TELLINA
            TYPE (triggerstruct)     TRG
            TYPE (ECLSStru)          ECLS
            TYPE (gdchitStru)        GHIT
            TYPE (Bposition)         BPOS
            TYPE (AllTracksQ)        TRKQ
            TYPE (DChits)            DTCE
            TYPE (DCdrift)           DHRE
            TYPE (Sector)            S2CLU
            TYPE (EmcSpacePoints)    CSPS
            TYPE (EmcMCSpacePoints)  CSPSMC
            TYPE (EmcCluObjects)     CLUO
            TYPE (EmcMCCluObjects)   CLUOMC
            TYPE (Vertex)            VTXOLD     
            TYPE (TracksVertex)      TRKVOLD
            TYPE (AllTracks)         TRKOLD
            TYPE (AllTracksMC)       TRKMCOLD
            TYPE (TrackCluster)      TCLOLD
            TYPE (DEDX2STRUstruct)   DEDX2STRU
            TYPE (mcdc_dhit)         DHIT
            TYPE (QCALTStructure)    QCALT
            TYPE (CCALTStructure)    CCLE
            TYPE (LETEStr)           LETE
            TYPE(itcestruct)         ITCE
            TYPE(QHITStructure)      QCALTHIT
            TYPE(HETEStructure)      HETE
        END TYPE
        TYPE ( NtupleEvent) Evt
        TYPE (prod2ntu_Params) params
      COMMON /prod2ntu/ Evt,params
C Include /kloe/soft/off/offline/inc/development/tls/prod2ntu_talk.cin =
        logical CLUSFLAG,CELEFLAG,TRIGFLAG
        logical TRKSFLAG,TRKVFLAG,DPRSFLAG
        logical CFHIFLAG,TCLOFLAG
        logical QCALFLAG,GEANFIFLAG
        logical DHSPFLAG,TELEFLAG
        logical PRECLUSFLAG,NVOFLAG
        logical ECLOFLAG,T0FLAG
        logical CWRKFLAG, ENECORFLAG
        logical ECLSFLAG, GDCHITFG
        logical BPOSFLAG
        Logical dtceFlag,dtce0Flag,DCnHitsFlag,dhreFlag
        logical c2trFlag
        Logical BENEFLAG
        Logical CSPSFLAG,CSPSMCFLAG,CLUOFLAG
        logical TRKSOLDFLAG,TRKVOLDFLAG,TCLOLDFLAG
        logical DHITFLAG,DEDXFLAG
        logical QCALTELEFLAG
        logical CCLEFLAG
        logical LETEFLAG
        logical ITCEFLAG
        logical HETEFLAG
        logical QCALTHITFLAG
        common /PRODMENU/CLUSFLAG,CELEFLAG,TRIGFLAG,TRKSFLAG,
     &  TRKVFLAG,DPRSFLAG,CFHIFLAG,QCALFLAG,TCLOFLAG,
     &  GEANFIFLAG,DHSPFLAG,TELEFLAG,PRECLUSFLAG,NVOFLAG,
     &  ECLOFLAG,T0FLAG,CWRKFLAG,ENECORFLAG,ECLSFLAG,GDCHITFG,
     &  BPOSFLAG,dtceFlag,dtce0Flag,DCnHitsFlag,dhreFlag,
     &  C2TRFLAG,BENEFLAG,CSPSFLAG,CSPSMCFLAG,CLUOFLAG,
     &  TRKSOLDFLAG,TRKVOLDFLAG,TCLOLDFLAG,DHITFLAG,DEDXFLAG,
     &  QCALTELEFLAG,CCLEFLAG,LETEFLAG,ITCEFLAG,HETEFLAG,
     &  QCALTHITFLAG
C
      CHARACTER*(*) SubName
      PARAMETER (SubName = 'prod2ntu_hb')
      INTEGER BLocat,statuscode
      INTEGER Analysis_Get_HBook_Params
C-----------------------------------------------------------------------
      INTEGER NUL
      PARAMETER (NUL = 0)
      INTEGER HBookStream
      PARAMETER (HBookStream = 1)
      CHARACTER*80 ErrMessage
      CHARACTER*32 TopDir
      CHARACTER*80 FileName
      CHARACTER*4 OpenOptions
      CHARACTER*16 Range
      Integer numdhit
      Integer trgwrd1,trgwrd2
      common /trgcom/trgwrd1,trgwrd2,numdhit
C
C -- add ECLS + Event Time ---
C
      INTEGER  StreamNum, AlgoNum
      INTEGER  TimeSec,TimeMusec
      INTEGER  Ndtce
      INTEGER mcflag_tg
      REAL    currpos,currele,luminosity
      Common /EventInfo/StreamNum,AlgoNum,TimeSec,TimeMusec,
     &      ndtce,mcflag_tg,currpos,currele,luminosity
      Logical SkipFlag
C--------------------------
C TEST FOR EXTENTION
C
      LOGICAL PROD2NTU_AUTO
      DATA PROD2NTU_AUTO /.false./
      INTEGER  UIGTLU,LUNIT,istat
      Integer nId
C
C     Variables for A_C/HBOOK interface:
C     ----------------------------------
C
      Integer
     &    STATUS,
     &    HBINDX,
     &    HBDATA,
     &    RZRECL
      nId = Params%NtId
      IF( .not.PROD2NTU_AUTO) THEN
C
C-----------------------------------------------------------------------
C Book n-tuple
C-----------------------------------------------------------------------
      StatusCode = Analysis_Get_HBook_Params(HBookStream,
     &                                       TopDir,FileName,
     &                                       OpenOptions)
C
C------------------------------------------------------------------
C     Attempt to work some A_C magic to get the record length
C       with which the Ntuple file was opened by A_C
C     -------------------------------------------------------
C------------------------------------------------------------------
      STATUS = BLOCAT(ANPKI4, ANHBNA, HBookStream, HBINDX, HBDATA)
      If (STATUS.NE.YESUCC) Then
        Call ERLOGR ('PROD2NTU_HB', EREROR, 0, STATUS,
     &      'Can''t get histogram pararmeters from A_C')
        Return
      End If
      RZRECL = ANPKI4(HBDATA + HBRECL)
C
C--- Very Useful Comment and explanation of Magic from MAtt ------------
C     Use this value to set the buffer size for the PROD2NTU Ntuple:
C       The Ntuple can only use a limited number of buffers due
C       to limited key storage space in ZEBRA. One buffer is created
C       for each column in the Ntuple, and is flushed to disk when
C       enough events have been processed so that it is full.
C       Making the buffers larger than default means that fewer
C       buffers are written for the same number of events. Not doing
C       this results in the classic error message:
C         RZOUT: current RZ file cannot support > 64K records
C       at end-of-run, and no-one seems to know what the true effect
C       of this on Ntuple stability is!
C       The optimal buffer size for speed is a multiple of the
C       record length. The optimal size for space allocation is
C       when the multiple is Nwords/ZEBRA key, currently 4 (?), but
C       using so much space may require a large PAWC. If HBOOK
C       runs out of space for this reason, the result will be
C       a ZFATAL that is absolutley uninfomative. Much worse, PAWC
C       is adjustable in BUILD_JOB, but only a custom-built PAW
C       will be able to open an Ntuple made with a large record
C       length and large PAWC by A_C. A compromise which I have
C       found useful is to assume Nwords/ZEBRA key = 1. Don't ask
C       where the -15 comes from. If you don't hate HBOOK/ZEBRA by now,
C       I can't help you!
C     ---------------------------------------------------------------
C
      Call HBSET ('BSIZE', RZRECL - 15,  STATUS)
      If (STATUS.NE.0) Then
        Call ERLOGR ('PROD2NTU_HB', EREROR, 0, STATUS,
     &      'Error setting buffer size for Ntuple file')
        Return
      End If
C
C
C     Now finally book it
C     -------------------
C
      CALL HCDir('//'//TopDir,' ')
      CALL HBNt(Params%NtId,Params%NtTitle,'D')
      ELSE
        STATUS = UIGTLU(LUNIT)
        call  HROPEN(LunIT,'PROD','PROD2NTU.NTU','N',1024,Istat)
        CALL HMDIR('//PROD/PROD2NTU', 'S')
        CALL HCDIR('//PROD/PROD2NTU', ' ')
        CALL HBNt(Params%NtId,Params%NtTitle,'D')
      ENDIF
C-----------------------------------------------------------------------
C Event info
C-----------------------------------------------------------------------
      CALL HBName(Params%NtId,'Info',Evt%Info%RunNumber,'nrun:i')
      CALL HBName(Params%NtId,'Info',Evt%Info%EventNumber,'nev:i')
      CALL HBNAME(Params%NtId,'DATA',TimeSec,'TimeSec:i')
      CALL HBNAME(Params%NtId,'DATA',TimeMusec,'TimeMusec:i')
      CALL HBName(Params%NtId,'DATA',CurrPos,'Ipos:r')
      CALL HBName(Params%NtId,'DATA',CurrEle,'Iele:r')
      CALL HBName(Params%NtId,'DATA',Luminosity,'Lumi:r')
C-----------------------------------------------------------------------
      CALL HBName(Params%NtId,'Info',Evt%Info%Pileup,'pileup[0,1]:i')
      CALL HBName(Params%NtId,'Info',Evt%Info%GenCod,'gcod[0,100]:i')
      CALL HBName(Params%NtId,'Info',Evt%Info%PhiDecay,'phid[0,100]:i')
      CALL HBName(Params%NtId,'Info',Evt%Info%A1type,'a1typ[0,100]:i')
      CALL HBName(Params%NtId,'Info',Evt%Info%A2type,'a2typ[0,100]:i')
      CALL HBName(Params%NtId,'Info',Evt%Info%A3type,'a3typ[0,100]:i')
      CALL HBName(Params%NtId,'Info',Evt%Info%B1type,'b1typ[0,100]:i')
      CALL HBName(Params%NtId,'Info',Evt%Info%B2type,'b2typ[0,100]:i')
      CALL HBName(Params%NtId,'Info',Evt%Info%B3type,'b3typ[0,100]:i')
C----------------------------------------------------------------------
      CALL HBNAME(Params%NtId,'DATA',mcflag_tg,'mcflag:i')
C
      IF( BPOSFLAG ) THEN
        CALL HBName(Params%NtId,'BPOS',Evt%Bpos%px,'Bpx:r')
        CALL HBName(Params%NtId,'BPOS',Evt%Bpos%py,'Bpy:r')
        CALL HBName(Params%NtId,'BPOS',Evt%Bpos%pz,'Bpz:r')
        CALL HBName(Params%NtId,'BPOS',Evt%Bpos%x,'Bx:r')
        CALL HBName(Params%NtId,'BPOS',Evt%Bpos%y,'By:r')
        CALL HBName(Params%NtId,'BPOS',Evt%Bpos%z,'Bz:r')
        CALL HBName(Params%NtId,'BPOS',Evt%Bpos%errpx,'Bwidpx:r')
        CALL HBName(Params%NtId,'BPOS',Evt%Bpos%errpy,'Bwidpy:r')
        CALL HBName(Params%NtId,'BPOS',Evt%Bpos%errpz,'Bwidpz:r')
        CALL HBName(Params%NtId,'BPOS',Evt%Bpos%errx,'Bsx:r')
        CALL HBName(Params%NtId,'BPOS',Evt%Bpos%erry,'Bsy:r')
        CALL HBName(Params%NtId,'BPOS',Evt%Bpos%errz,'Bsz:r')
        CALL HBName(Params%NtId,'BPOS',Evt%Bpos%lumx,'Blumx:r')
        CALL HBName(Params%Ntid,'BPOS',Evt%Bpos%lumz,'Blumz:r')
      ENDIF     
      IF( BENEFLAG ) THEN       
        CALL HBName(Params%Ntid,'BENE',Evt%Bpos%Ene,'Broots:r')
        CALL HBName(Params%Ntid,'BENE',Evt%Bpos%ErrEne,'BrootsErr:r')
      ENDIF
C
C new global info from TRK/Pattern HITS ..................
C
      IF( GDCHITFG ) THEN
        CALL HBName(Params%NtId,'GDHIT',NDtce,'dtcehit:i')
        CALL HBName(Params%NtId,'GDHIT',Evt%Ghit%nhit,'dhrehit:i')
        CALL HBName(Params%NtId,'GDHIT',Evt%Ghit%nhpr,'dprshit:i')
        CALL HBName(Params%NtId,'GDHIT',Evt%Ghit%nhtf,'dtfshit:i')
      ENDIF
C
C -- ECLS full unpacking
C
      IF( ECLSFLAG ) THEN
        CALL HBName(Params%NtId,'ECLS',Evt%ecls%n,'necls:i::[0,8]')
        CALL HBName(Params%NtId,'ECLS',Evt%ecls%trigger,'ECLtrgw:i')
        CALL HBName(Params%NtId,'ECLS',Evt%ecls%Filfo,'ECLfilfo:i')
        CALL HBName(Params%NtId,'ECLS',Evt%ecls%totword,
     &      'ECLword(necls):i')
        CALL HBname(Params%NtId,'ECLS',Evt%ecls%stream,
     &     'ECLstream(necls):i')
        CALL HBname(Params%NtId,'ECLS',Evt%ecls%tagnum,
     &      'ECLtagnum(necls):i')
        CALL HBname(Params%NtId,'ECLS',Evt%ecls%evntyp,
     &      'ECLevtype(necls):i')
CSM        CALL HBname(Params%NtId,'FILFO',FILFOflag,'FILFOflag:i')
CGS For the ECLS bank num II
        CALL HBName(Params%NtId,'ECLS2',Evt%ecls%n2,'necls2:i::[0,8]')
        CALL HBName(Params%NtId,'ECLS2',Evt%ecls%trigger2,'ECLtrgw2:i')
        CALL HBName(Params%NtId,'ECLS2',Evt%ecls%Filfo2,'ECLfilfo2:i')
        CALL HBName(Params%NtId,'ECLS2',Evt%ecls%totword2,
     &      'ECLword2(necls2):i')
        CALL HBname(Params%NtId,'ECLS2',Evt%ecls%stream2,
     &     'ECLstream2(necls2):i')
        CALL HBname(Params%NtId,'ECLS2',Evt%ecls%tagnum2,
     &      'ECLtagnum2(necls2):i')
        CALL HBname(Params%NtId,'ECLS2',Evt%ecls%evntyp2,
     &      'ECLevtype2(necls2):i')
      ENDIF
C
      if( TRIGFLAG ) THEN
         CALL HBName(Params%NtId,'Trig',trgwrd1,'trgw1:i')
         CALL HBName(Params%NtId,'Trig',trgwrd2,'trgw2:i')
         IF( C2TRFLAG ) THEN
C
C-  C2TRG block -------------------------------------------------
C
            CALL prod2ntu_NtRange(0,MaxNumClu,Range)
            CALL HBNAME(params%ntid,'C2TRG',Evt%S2CLU%nsect,'Nsec')
            CALL HBNAME(params%ntid,'C2TRG',
     &           Evt%S2CLU%Nsect_noclu,'Nsec_noclu')
            CALL HBNAME(params%ntid,'C2TRG',
     &           Evt%S2CLU%Nsect_clu,'Nsec2clu')
            CALL HBNAME(Params%NtId,'C2TRG',Evt%S2CLU%Nclus,
     $           'nclu2s:i::'//Range)
            CALL HBNAME(Params%NtId,'C2TRG',Evt%S2CLU%Nnorm,
     $           'NNorm(nclu2s):i')
            CALL HBNAME(Params%NtId,'C2TRG',Evt%S2CLU%NormAdd,
     $           'NormAdd(nclu2s):i')
            CALL HBNAME(Params%NtId,'C2TRG',Evt%S2CLU%Nover,
     $           'Nover(nclu2s):i')
            CALL HBNAME(Params%NtId,'C2TRG',Evt%S2CLU%OverAdd,
     $           'OverAdd(nclu2s):i')
            CALL HBNAME(Params%NtId,'C2TRG',Evt%S2CLU%Ncosm,
     $           'NCosm(nclu2s):i')
            CALL HBNAME(Params%NtId,'C2TRG',Evt%S2CLU%CosmAdd,
     $           'CosmAdd(nclu2s):i')
C---------------------------------------------------------------------
         ELSE
C
C ----tellina -
C
            CALL prod2ntu_NtRange(0,triggerelements,Range)
            CALL HBName(Params%NtId,'Telli',Evt%Tellina%n
     &           ,'ntel:i::'//Range)
            CALL HBNAME(Params%NtId,'Telli',Evt%Tellina%add,
     &           'add_tel(ntel):i')
            CALL HBNAME(Params%NtId,'Telli',Evt%Tellina%Bitp,
     &           'bitp_tel(ntel)[0,1100]:i')
            CALL HBNAME(Params%NtId,'Telli',Evt%Tellina%Ea,
     &           'Ea_tel(ntel):r')
            CALL HBNAME(Params%NtId,'Telli',Evt%Tellina%Eb,
     &           'Eb_tel(ntel):r')
            CALL HBNAME(Params%NtId,'Telli',Evt%Tellina%Ta,
     &           'Ta_tel(ntel):r')
            CALL HBNAME(Params%NtId,'Telli',Evt%Tellina%Tb,
     &           'Tb_tel(ntel):r')
C--- pizzetta ---
            CALL HBNAME(Params%NtId,'Pizze',Evt%Pizzetta%n,
     $           'npiz:i::'//Range)
            CALL HBNAME(Params%NtId,'Pizze',Evt%Pizzetta%add,
     $           'add_piz(npiz):i')
            CALL HBNAME(Params%NtId,'Pizze',Evt%Pizzetta%Ea,
     $           'Ea_piz(npiz):r')
            CALL HBNAME(Params%NtId,'Pizze',Evt%Pizzetta%Eb,
     $           'Eb_piz(npiz):r')
            CALL HBNAME(Params%NtId,'Pizze',Evt%Pizzetta%E_rec,
     $           'E_piz(npiz):r')
            CALL HBNAME(Params%NtId,'Pizze',Evt%Pizzetta%Z_mod,
     $           'Z_piz(npiz):r')
         ENDIF
C
C--torta from tortastruhb ----------------------------
         call HBNAME(Params%NtId,'TRG',evt%trg%tspent,
     # 'tspent:r,tdead:r,type[0,7]:i,bphi[0,3]:i,'//
     # 'ephi[0,3]:i,wphi[0,3]:i,bbha[0,3]:i,ebha[0,3]:i,wbha[0,3]:i,'//
     # 'bcos[0,3]:i, ecos[0,3]:i, wcos[0,3]:i, e1w1_dwn[0,1]:i, '//
     # 'b1_dwn[0,1]:i,t0d_dwn[0,1]:i,vetocos[0,1]:i,vetobha[0,1]:i,'//
     # 'bdw[0,1]:i,rephasing[0,4096]:i,tdc1_pht1[0,4096]:i,'//
     # 'dt2_t1[0,4096]:i,fiducial[0,4096]:i,t1c[0,4096]:i,'//
     # 't1d[0,4096]:i,t2d[0,4096]:i,tcr[0,4096]:i,'//
     #       'tcaf_tcrd:i,tcaf_t2d:i,moka_t2d:i,moka_t2dsl(10):i')
C
      endif
      IF( TELEFLAG ) THEN
         CALL prod2ntu_NtRange(0,triggerelements,Range)
C
C ............. from Palutan .............................
C     but using Evt.XXXX
C
         CALL HBName(Params%NtId,'TELE',Evt%TELE%ntele
     $        ,'ntele:i::[0,300]')
         CALL HBNAME(Params%NtId,'TELE',Evt%TELE%Det,
     &        'det_trg(ntele)[0,3]:i')
         CALL HBNAME(Params%NtId,'TELE',Evt%TELE%Bitp,
     &        'bitp(ntele)[0,1100]:i')
         CALL HBNAME(Params%NtId,'TELE',Evt%TELE%Sector,
     &        'sector(ntele)[0,50]:i')
         CALL HBNAME(Params%NtId,'TELE',Evt%TELE%Serkind,
     &        'serkind(ntele)[0,3]:i')
         CALL HBNAME(Params%NtId,'TELE',Evt%TELE%Ea,
     &        'Ea_trg(ntele):r')
         CALL HBNAME(Params%NtId,'TELE',Evt%TELE%Eb,
     &        'Eb_trg(ntele):r')
         CALL HBNAME(Params%NtId,'TELE',Evt%TELE%Ta,
     &        'Ta_trg(ntele):r')
         CALL HBNAME(Params%NtId,'TELE',Evt%TELE%Tb,
     &        'Tb_trg(ntele):r')
         CALL HBNAME(Params%NtId,'PIZZA',Evt%PIZZA%npizza,
     $        'npack:i::[0,300]')
         CALL HBNAME(Params%NtId,'PIZZA',Evt%PIZZA%sector,
     $        'paksect(npack)[0,50]:i')
         CALL HBNAME(Params%NtId,'PIZZA',Evt%PIZZA%det,
     $        'pakdet(npack)[1,3]:i')
         CALL HBNAME(Params%NtId,'PIZZA',Evt%PIZZA%serkind,
     $        'pakserk(npack)[0,3]:i')
         CALL HBNAME(Params%NtId,'PIZZA',Evt%PIZZA%Ea,
     $        'Ea_pack(npack):r')
         CALL HBNAME(Params%NtId,'PIZZA',Evt%PIZZA%Eb,
     $        'Eb_pack(npack):r')
         CALL HBNAME(Params%NtId,'PIZZA',Evt%PIZZA%E_rec,
     $        'E_rec(npack):r')
         CALL HBNAME(Params%NtId,'PIZZA',Evt%PIZZA%Z_mod,
     $        'Z_mod(npack):r')
C
      END IF
C-----------------------------------------------------------
C *** T0 Finder
C-----------------------------------------------------------
      IF( T0FLAG ) THEN
CMS per DeSimone
        CALL HBName(Params%NtId,'Info',Evt%T0stru%tphased_mc,
     &        'tphased_mc:r')
        CALL HBName(Params%NtId,'Info',Evt%T0stru%dc_step0,'t0dc0:r')
        CALL HBName(Params%NtId,'Info',Evt%T0stru%hit_step0,'t0hit0:r')
        CALL HBName(Params%NtId,'Info',Evt%T0stru%clus_step0,'t0clu0:r')
        CALL HBname(Params%NtId,'Info',Evt%T0stru%step1,'T0step1:r')
        CALL HBname(Params%NtId,'Info',Evt%T0stru%cable,'DelayCable:r')
        CALL HBname(Params%NtId,'Info',Evt%T0stru%tbunch,'Tbunch:r')
      ENDIF
C-----------------------------------------------------------------------
C EMC Clusters
C-----------------------------------------------------------------------
      If( CLUSFLAG ) then
         CALL prod2ntu_NtRange(0,MaxNumClu,Range)
         CALL HBName(Params%NtId,'Clu',Evt%Clu%n ,'nclu:i::'//Range)
         CALL HBName(Params%NtId,'Clu',Evt%Clu%E ,'EneCl(nclu):r')
         CALL HBName(Params%NtId,'Clu',Evt%Clu%T ,'Tcl(nclu):r')
         CALL HBName(Params%NtId,'Clu',Evt%Clu%X ,'Xcl(nclu):r')
         CALL HBName(Params%NtId,'Clu',Evt%Clu%Y ,'Ycl(nclu):r')
         CALL HBName(Params%NtId,'Clu',Evt%Clu%Z ,'Zcl(nclu):r')
         CALL HBName(Params%NtId,'Clu',Evt%Clu%Xa,'Xacl(nclu):r')
         CALL HBName(Params%NtId,'Clu',Evt%Clu%Ya,'Yacl(nclu):r')
         CALL HBName(Params%NtId,'Clu',Evt%Clu%Za,'Zacl(nclu):r')
         CALL HBName(Params%NtId,'Clu',Evt%Clu%Xrms,'XRmCl(nclu):r')
         CALL HBName(Params%NtId,'Clu',Evt%Clu%Yrms,'YRmsCl(nclu):r')
         CALL HBName(Params%NtId,'Clu',Evt%Clu%Zrms,'ZrmsCl(nclu):r')
         CALL HBName(Params%NtId,'Clu',Evt%Clu%Trms,'TrmsCl(nclu):r')
         CALL HBName(Params%NtId,'Clu',Evt%Clu%Flag,'FlagCl(nclu):i')
         CALL HBName(Params%NtId,'CluMC',Evt%Clu%nmc,
     &        'nclumc:i::'//Range)
         CALL HBName(Params%NtId,'CluMC',Evt%Clu%Npart
     $        ,'Npar(nclumc)[0,10]:i')
         CALL HBName(Params%NtId,'CluMC',Evt%Clu%part1
     $        ,'Pnum1(nclumc)[0,100]:i')
         CALL HBName(Params%NtId,'CluMC',Evt%Clu%pid1
     $        ,'Pid1(nclumc)[0,100]:i')
         CALL HBName(Params%NtId,'CluMC',Evt%Clu%part2
     $        ,'Pnum2(nclumc)[0,100]:i')
         CALL HBName(Params%NtId,'CluMC',Evt%Clu%pid2
     $        ,'Pid2(nclumc)[0,100]:i')
         CALL HBName(Params%NtId,'CluMC',Evt%Clu%part3
     $        ,'Pnum3(nclumc)[0,100]:i')
         CALL HBName(Params%NtId,'CluMC',Evt%Clu%pid3
     $        ,'Pid3(nclumc)[0,100]:i')
      endif
C-----------------------------------------------------------------------
C EMC Pre-Clusters
C-----------------------------------------------------------------------
      If( PRECLUSFLAG ) then
         CALL prod2ntu_NtRange(0,MaxNumClu,Range)
         CALL HBName(Params%NtId,'PClu',Evt%PreClu%n ,
     &        'npclu:i::'//Range)
         CALL HBName(Params%NtId,'PClu',Evt%PreClu%E ,'Epre(npclu):r')
         CALL HBName(Params%NtId,'PClu',Evt%PreClu%T ,'Tpre(npclu):r')
         CALL HBName(Params%NtId,'PClu',Evt%PreClu%X ,'Xpre(npclu):r')
         CALL HBName(Params%NtId,'PClu',Evt%PreClu%Y ,'Ypre(npclu):r')
         CALL HBName(Params%NtId,'PClu',Evt%PreClu%Z ,'Zpre(npclu):r')
         CALL HBName(Params%NtId,'PClu',Evt%PreClu%TA,'TApre(npclu):r')
         CALL HBName(Params%NtId,'PClu',Evt%PreClu%TB,'TBpre(npclu):r')
         CALL HBName(Params%NtId,'PClu',Evt%PreClu%TrmsA,
     &        'TARpre(npclu):r')
         CALL HBName(Params%NtId,'PClu',Evt%PreClu%TrmsB,
     &        'TBRpre(npclu):r')
      endif
C-----------------------------------------------------------------------
C The CWRK
C-----------------------------------------------------------------------
      IF( CWRKFLAG ) then
         CALL prod2ntu_NtRange(0,NeleCluMax,Range)
         CALL HBName(Params%NtId,'CWR',Evt%CWRK%n ,
     &        'nchit:i::'//Range)
         CALL HBName(Params%NtId,'CWR',Evt%CWRK%icl,
     $        'iclu(nchit):i')
         CALL HBName(Params%NtId,'CWR',Evt%CWRK%cele,
     &        'icel(nchit):i')
         CALL HBNAME(Params%Ntid,'CWR',Evt%CWRK%add,
     &        'Cadd(nchit):i')
         CALL HBNAME(Params%Ntid,'CWR',Evt%CWRK%nhit,
     &        'Cmchit(nchit):i')
         CALL HBNAME(Params%Ntid,'CWR',Evt%CWRK%kine,
     &        'Ckine(nchit):i')
         CALL HBName(Params%NtId,'CWR',Evt%CWRK%E,
     &        'Ene(nchit):r')
         CALL HBName(Params%NtId,'CWR',Evt%CWRK%T,
     &        'T(nchit):r')
         CALL HBName(Params%NtId,'CWR',Evt%CWRK%X,
     &        'x(nchit):r')
         CALL HBName(Params%NtId,'CWR',Evt%CWRK%Y,
     &        'y(nchit):r')
         CALL HBName(Params%NtId,'CWR',Evt%CWRK%Z,
     &        'z(nchit):r')
      ENDIF
C-----------------------------------------------------------------------
C The CELE
C-----------------------------------------------------------------------
      If( CELEFLAG) then
         CALL prod2ntu_NtRange(0,NeleCluMax,Range)
         CALL HBName(Params%NtId,'Cel',Evt%Cele%n ,'ncel:i::'//Range)
         CALL HBName(Params%NtId,'Cel',Evt%Cele%icl
     $        ,'icl(ncel):i')
         CALL HBName(Params%NtId,'Cel',Evt%Cele%det
     $        ,'det(ncel)[0,3]:i')
         CALL HBName(Params%NtId,'Cel',Evt%Cele%wed
     $        ,'wed(ncel)[0,32]:i')
         CALL HBName(Params%NtId,'Cel',Evt%Cele%pla
     $        ,'pla(ncel)[0,5]:i')
         CALL HBName(Params%NtId,'Cel',Evt%Cele%col
     $        ,'col(ncel)[0,12]:i')
C     CALL HBName(Params%NtId,'Cel',Evt%Cele%E,'ECel(ncel):r')
C     CALL HBName(Params%NtId,'Cel',Evt%Cele%t,'tCel(ncel):r')
         CALL HBName(Params%NtId,'Cel',Evt%Cele%Ea,'Ea(ncel):r')
         CALL HBName(Params%NtId,'Cel',Evt%Cele%ta,'ta(ncel):r')
         CALL HBName(Params%NtId,'Cel',Evt%Cele%Eb,'eb(ncel):r')
         CALL HBName(Params%NtId,'Cel',Evt%Cele%tb,'tb(ncel):r')
C
         CALL HBNAME(Params%NtId,'Celmc',Evt%Cele%nmc,
     &        'ncelmc:i::'//Range)
         CALL HBName(Params%NtId,'Celmc',Evt%Cele%Etrue
     $        ,'Emc(ncelmc):r')
         CALL HBName(Params%NtId,'Celmc',Evt%Cele%Ttrue
     $        ,'Tmc(ncelmc):r')
         CALL HBName(Params%NtId,'Celmc',Evt%Cele%xtrue
     $        ,'Xmc(ncelmc):r')
         CALL HBName(Params%NtId,'Celmc',Evt%Cele%ytrue
     $        ,'Ymc(ncelmc):r')
         CALL HBName(Params%NtId,'Celmc',Evt%Cele%ztrue
     $        ,'Zmc(ncelmc):r')
         CALL HBName(Params%NtId,'Celmc',Evt%Cele%ptyp
     $        ,'Ptyp(ncelmc)[0,100]:i')
         CALL HBName(Params%NtId,'Celmc',Evt%Cele%knum
     $        ,'Knum(ncelmc)[0,100]:i')
         CALL HBName(Params%NtId,'Celmc',Evt%Cele%numpar
     $        ,'Nhit(ncelmc)[0,10]:i')
      endif
C-----------------------------------------------------------------------
C      The DTCE
C-----------------------------------------------------------------------
      If (dtceFlag) Then
         call prod2ntu_NtRange(0,nMaxDC,range)
         call HBNAME(nId,'DTCE',Evt%DTCE%nDTCE,'nDTCE:I::'//range)
         call HBNAME(nId,'DTCE',Evt%DTCE%nSmall,'nSmall:I::'//range)
         call HBNAME(nId,'DTCE',Evt%DTCE%iLayerDTCE
     +        ,              'iLayerDTCE(nDTCE)[1,58]:I')
         call HBNAME(nId,'DTCE',Evt%DTCE%iWireDTCE
     +        ,              'iWireDTCE(nDTCE)[1,378]:I')
         call HBNAME(nId,'DTCE',Evt%DTCE%tDTCE
     +        ,              'tDTCE(nDTCE):R')
      EndIf
      If (dtce0Flag) Then
         call prod2ntu_NtRange(0,nMaxDC,range)
         call HBNAME(nId,'DTCE0',DTCEStru%NEle,'nDTCE0:I::'//range)
         call HBNAME(nId,'DTCE0',DTCEStru%Lay
     +        ,              'iLayerDTCE0(nDTCE0)[1,58]:I')
         call HBNAME(nId,'DTCE0',DTCEStru%Wir
     +        ,              'iWireDTCE0(nDTCE0)[1,378]:I')
         call HBNAME(nId,'DTCE0',DTCEStru%Time
     +        ,              'tDTCE0(nDTCE0):R')
      EndIf
      If (DCnHitsFlag) Then
         call HBNAME(nId,'DCHITS',DTCEStru%nDCHR,'nDCHR:I')
         call HBNAME(nId,'DCHITS',DTCEStru%nSmallDCm,'nSmallDCm:I')
         call HBNAME(nId,'DCHITS',DTCEStru%nSmallDCp,'nSmallDCp:I')
         call HBNAME(nId,'DCHITS',DTCEStru%nBigDCm,'nBigDCm:I')
         call HBNAME(nId,'DCHITS',DTCEStru%nBigDCp,'nBigDCp:I')
         call HBNAME(nId,'DCHITS',Evt%DTCE%nDTCE,'nCellDC:I')
         call HBNAME(nId,'DCHITS',Evt%DTCE%nSmall,'nSmallDC:I')
      EndIf
C-----------------------------------------------------------------------
C     The DHRE
C-----------------------------------------------------------------------
      If (dhreFlag) Then
         call prod2ntu_NtRange(0,nMaxDC,range)
         call HBNAME(nId,'DHRE',Evt%DHRE%nDHRE,'nDHRE:I::'//range)
         call HBNAME(nId,'DHRE',Evt%DHRE%iLayerDHRE
     +        ,              'iLayerDHRE(nDHRE)[1,58]:I')
         call HBNAME(nId,'DHRE',Evt%DHRE%iWireDHRE
     +        ,              'iWireDHRE(nDHRE)[1,378]:I')
         call HBNAME(nId,'DHRE',Evt%DHRE%iTrkDHRE
     +        ,              'iTrkDHRE(nDHRE):I')
         call HBNAME(nId,'DHRE',Evt%DHRE%rDHRE
     +        ,              'rDHRE(nDHRE):R')
         call HBNAME(nId,'DHRE',Evt%DHRE%eDHRE
     +        ,              'eDHRE(nDHRE):R')
      EndIf
C-----------------------------------------------------------------------
C      The DHSP
C-----------------------------------------------------------------------
      IF( DHSPFLAG ) THEN
         CALL prod2ntu_NtRange(0,MaxNumDHSP,Range)
         CALL HBName(Params%NtId,'Dhsp',Evt%DHSP%numDHSP,
     $        'ndhsp:i::'//Range)
         CALL HBName(Params%NtId,'Dhsp',Evt%DHSP%itrk
     $        ,'trkdh(ndhsp)[0,100]:i')
         CALL HBName(Params%Ntid,'Dhsp',Evt%Dhsp%layer
     $        ,'layer(ndhsp)[0,60]:i')
         CALL HBName(Params%Ntid,'Dhsp',Evt%Dhsp%wire
     $        ,'wire(ndhsp)[0,400]:i')
         CALL HBName(Params%Ntid,'Dhsp',Evt%Dhsp%time,'time(ndhsp):r'
     $        )
         CALL HBName(Params%Ntid,'Dhsp',Evt%Dhsp%drift
     $        ,'dpar(ndhsp):r')
         CALL HBName(Params%Ntid,'Dhsp',Evt%Dhsp%res,'res(ndhsp):r')
         CALL HBName(Params%Ntid,'Dhsp',Evt%Dhsp%x,'xdh(ndhsp):r')
         CALL HBName(Params%Ntid,'Dhsp',Evt%Dhsp%y,'ydh(ndhsp):r')
         CALL HBName(Params%Ntid,'Dhsp',Evt%Dhsp%z,'zdh(ndhsp):r')
      ENDIF
C-----------------------------------------------------------------------
C Tracks after Vertex reconstruction
C-----------------------------------------------------------------------
      IF( TRKVFLAG ) then
         CALL prod2ntu_NtRange(0,MaxNumTrkV,Range)
         CALL HBName(Params%NtId,'TrkV',Evt%Trkv%n,'ntv:i::'//Range)
         CALL HBName(Params%NtId,'TrkV',Evt%Trkv%iv,'iv(ntv)[0,30]:i'
     $        )
         CALL HBName(Params%NtId,'TrkV',Evt%Trkv%trkpoi
     $        ,'trknumv(ntv)[0,999]:i:')
         CALL HBName(Params%Ntid,'TrkV',Evt%Trkv%cur,'CurV(ntv):r')
         CALL HBName(Params%Ntid,'TrkV',Evt%Trkv%phi,'PhiV(ntv):r')
         CALL HBName(Params%Ntid,'TrkV',Evt%Trkv%cot,'CotV(ntv):r')
         CALL HBName(Params%Ntid,'TrkV',Evt%Trkv%px,'pxtv(ntv):r')
         CALL HBName(Params%Ntid,'TrkV',Evt%Trkv%py,'pytv(ntv):r')
         CALL HBName(Params%Ntid,'TrkV',Evt%Trkv%pz,'pztv(ntv):r')
         CALL HBName(Params%Ntid,'TrkV',Evt%Trkv%pmod,'pmodv(ntv):r')
         CALL HBName(Params%Ntid,'TrkV',Evt%Trkv%Length,'lenv(ntv):r'
     $        )
         CALL HBName(Params%Ntid,'TrkV',Evt%Trkv%Chi2,'chiv(ntv):r')
         CALL HBName(Params%Ntid,'TrkV',Evt%Trkv%ipid,'pidtv(ntv):i')
C     GS
         CALL HBName(Params%Ntid,'TrkV',Evt%Trkv%cov11
     $        ,'cov11tv(ntv):r')
         CALL HBName(Params%Ntid,'TrkV',Evt%Trkv%cov12
     $        ,'cov12tv(ntv):r')
         CALL HBName(Params%Ntid,'TrkV',Evt%Trkv%cov13
     $        ,'cov13tv(ntv):r')
         CALL HBName(Params%Ntid,'TrkV',Evt%Trkv%cov22
     $        ,'cov22tv(ntv):r')
         CALL HBName(Params%Ntid,'TrkV',Evt%Trkv%cov23
     $        ,'cov23tv(ntv):r')
         CALL HBName(Params%Ntid,'TrkV',Evt%Trkv%cov33
     $        ,'cov33tv(ntv):r')
C     GS
C-----------------------------------------------------------------------
C     Verticies
C-----------------------------------------------------------------------
         CALL prod2ntu_NtRange(0,MaxNumVtx,Range)
         CALL HBName(Params%NtId,'Vtx',Evt%vtx%n,'nv:i::'//Range)
         CALL HBName(Params%NtId,'Vtx',Evt%Vtx%Ntrk,'vtx(nv)[0,10]:i'
     $        )
         CALL HBName(Params%NtId,'Vtx',Evt%Vtx%X,'xv(nv):r')
         CALL HBName(Params%NtId,'Vtx',Evt%Vtx%Y,'yv(nv):r')
         CALL HBName(Params%NtId,'Vtx',Evt%Vtx%Z,'zv(nv):r')
         CALL HBName(Params%NtId,'Vtx',Evt%Vtx%Chi2,'chivtx(nv):r')
         CALL HBName(Params%NtId,'Vtx',Evt%Vtx%Qual,'qualv(nv):i')
         CALL HBName(Params%NtId,'Vtx',Evt%Vtx%Fitid,'fitidv(nv):i')
         CALL HBName(Params%NtId,'vtx',Evt%Vtx%Cov1,'VTXcov1(nv):r')
         CALL HBName(Params%NtId,'vtx',Evt%Vtx%Cov2,'VTXcov2(nv):r')
         CALL HBName(Params%NtId,'vtx',Evt%Vtx%Cov3,'VTXcov3(nv):r')
         CALL HBName(Params%NtId,'vtx',Evt%Vtx%Cov4,'VTXcov4(nv):r')
         CALL HBName(Params%NtId,'vtx',Evt%Vtx%Cov5,'VTXcov5(nv):r')
         CALL HBName(Params%NtId,'vtx',Evt%Vtx%Cov6,'VTXcov6(nv):r')
      endif
C-----------------------------------------------------------------------
C Trks before Vertex reconstruction
C-----------------------------------------------------------------------
      if( TRKSFLAG )then
         CALL prod2ntu_NtRange(0,MaxNumTrk,Range)
C     CALL HBName(Params%NtId,'Trk',numdhit,'ndhit:i')
         CALL HBName(Params%NtId,'Trk',Evt%Trk%n,'nt:i::'//Range)
         CALL HBName(Params%NtId,'Trk',Evt%Trk%trkind,'trkind(nt):i')
         CALL HBName(Params%NtId,'Trk',Evt%Trk%version,'trkver(nt):i')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%cur,'Cur(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%phi,'Phi(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%cot,'Cot(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%px,'pxt(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%py,'pyt(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%pz,'pzt(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%pmod,'pmod(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%length,'len(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%x,'xfirst(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%y,'yfirst(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%z,'zfirst(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%curlast,'Curla(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%philast,'Phila(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%cotlast,'Cotla(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%pxlast,'pxtla(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%pylast,'pytla(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%pzlast,'pztla(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%pmodlast
     $        ,'pmodla(nt):r')
         CALL HBName(Params%Ntid,'TRK',Evt%Trk%SigPCA,'spca(nt):r')
         CALL HBName(Params%Ntid,'TRK',Evt%Trk%SigZeta,'szeta(nt):r')
         CALL HBName(Params%Ntid,'TRK',Evt%Trk%SigCurv,'scurv(nt):r')
         CALL HBName(Params%Ntid,'TRK',Evt%Trk%SigCot,'scotg(nt):r')
         CALL HBName(Params%Ntid,'TRK',Evt%Trk%SigPhi,'sphi(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%xlast,'xlast(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%ylast,'ylast(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%zlast,'zlast(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%xpca,'xpca2(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%ypca,'ypca2(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%zpca,'zpca2(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%qtrk,'qtrk2(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%cotpca,'cotpca2(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%phipca,'phipca2(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%NumPRhit
     $        ,'nprhit(nt):i')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%NumFitHit
     $        ,'nfithit(nt):i')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%nmskink
     $        ,'nmskink(nt):i')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%chi2fit
     $        ,'chi2fit(nt):r')
         CALL HBName(Params%Ntid,'Trk',Evt%Trk%chi2ms,'chi2ms(nt):r')
      endif
C-----------------------------------------------------------------------
C DTFSMC patterns
C-----------------------------------------------------------------------
      if(TRKSFLAG)then
         CALL prod2ntu_NtRange(0,MaxNumTrk,Range)
         CALL HBName(Params%NtId,'TrkMC',Evt%TrkMC%n,
     $        'ntfmc:i::'//Range)
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%ncontr
     $        ,'ncontr(ntfmc)[0,10]:i')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%kine1
     $        ,'trkine1(ntfmc)[0,100]:i')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%type1
     $        ,'trtype1(ntfmc)[0,100]:i')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%hits1
     $        ,'trhits1(ntfmc)[0,1000]:i')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%kine2
     $        ,'trkine2(ntfmc)[0,100]:i')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%type2
     $        ,'trtype2(ntfmc)[0,100]:i')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%hits2
     $        ,'trhits2(ntfmc)[0,1000]:i')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%kine3
     $        ,'trkine3(ntfmc)[0,100]:i')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%type3
     $        ,'trtype3(ntfmc)[0,100]:i')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%hits3
     $        ,'trhits3(ntfmc)[0,1000]:i')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%xfirst
     $        ,'xfmc(ntfmc):r')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%yfirst
     $        ,'yfmc(ntfmc):r')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%zfirst
     $        ,'zfmc(ntfmc):r')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%pxfirst
     $        ,'pxfmc(ntfmc):r')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%pyfirst
     $        ,'pyfmc(ntfmc):r')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%pzfirst
     $        ,'pzfmc(ntfmc):r')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%xlast
     $        ,'xlmc(ntfmc):r')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%ylast
     $        ,'ylmc(ntfmc):r')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%zlast
     $           ,'zlmc(ntfmc):r')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%pxlast
     $        ,'pxlmc(ntfmc):r')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%pylast
     $        ,'pylmc(ntfmc):r')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%pzlast
     $        ,'pzlmc(ntfmc):r')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%xmcfirst
     $        ,'xfmc2(ntfmc):r')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%ymcfirst
     $        ,'yfmc2(ntfmc):r')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%zmcfirst
     $        ,'zfmc2(ntfmc):r')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%pxmcfirst
     $        ,'pxfmc2(ntfmc):r')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%pymcfirst
     $        ,'pyfmc2(ntfmc):r')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%pzmcfirst
     $        ,'pzfmc2(ntfmc):r')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%xmclast
     $        ,'xlmc2(ntfmc):r')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%ymclast
     $        ,'ylmc2(ntfmc):r')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%zmclast
     $        ,'zlmc2(ntfmc):r')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%pxmclast
     $        ,'pxlmc2(ntfmc):r')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%pymclast
     $        ,'pylmc2(ntfmc):r')
         CALL HBName(Params%Ntid,'TrkMC',Evt%TrkMC%pzmclast
     $        ,'pzlmc2(ntfmc):r')
      EndIF
Cvp
C-----------------------------------------------------------------------
C ( KPM Stream ): Tracks after Vertex reconstruction before Retracking
C-----------------------------------------------------------------------
         IF( TRKVOLDFLAG ) then
            CALL prod2ntu_NtRange(0,MaxNumTrkV,Range)
            CALL HBName(Params%NtId,'TrkVOld',Evt%TrkvOld%n,
     $           'ntvold:i::'//Range)
            CALL HBName(Params%NtId,'TrkVOld',Evt%TrkvOld%iv,
     $           'ivold(ntvold)[0,30]:i')
            CALL HBName(Params%NtId,'Trkvold',Evt%Trkvold%trkpoi,
     $           'trknumvold(ntvold)[0,999]:i:')
            CALL HBName(Params%Ntid,'Trkvold',Evt%Trkvold%cur,
     $           'CurVold(ntvold):r')
            CALL HBName(Params%Ntid,'Trkvold',Evt%Trkvold%phi,
     $           'PhiVold(ntvold):r')
            CALL HBName(Params%Ntid,'Trkvold',Evt%Trkvold%cot,
     $           'CotVold(ntvold):r')
            CALL HBName(Params%Ntid,'Trkvold',Evt%Trkvold%px,
     $           'pxtvold(ntvold):r')
            CALL HBName(Params%Ntid,'Trkvold',Evt%Trkvold%py,
     $           'pytvold(ntvold):r')
            CALL HBName(Params%Ntid,'Trkvold',Evt%Trkvold%pz,
     $           'pztvold(ntvold):r')
            CALL HBName(Params%Ntid,'Trkvold',Evt%Trkvold%pmod,
     $           'pmodvold(ntvold):r')
            CALL HBName(Params%Ntid,'Trkvold',Evt%Trkvold%Length,
     $           'lenvold(ntvold):r')
            CALL HBName(Params%Ntid,'Trkvold',Evt%Trkvold%Chi2,
     $           'chivold(ntvold):r')
            CALL HBName(Params%Ntid,'Trkvold',Evt%Trkvold%ipid,
     $           'pidtvold(ntvold):i')
CGS
            CALL HBName(Params%Ntid,'Trkvold',Evt%Trkvold%cov11
     $           ,'cov11tvold(ntvold):r')
            CALL HBName(Params%Ntid,'Trkvold',Evt%Trkvold%cov12
     $           ,'cov12tvold(ntvold):r')
            CALL HBName(Params%Ntid,'Trkvold',Evt%Trkvold%cov13
     $           ,'cov13tvold(ntvold):r')
            CALL HBName(Params%Ntid,'Trkvold',Evt%Trkvold%cov22
     $           ,'cov22tvold(ntvold):r')
            CALL HBName(Params%Ntid,'Trkvold',Evt%Trkvold%cov23
     $           ,'cov23tvold(ntvold):r')
            CALL HBName(Params%Ntid,'Trkvold',Evt%Trkvold%cov33
     $           ,'cov33tvold(ntvold):r')
CGS
C-----------------------------------------------------------------------
C (KPM Stream) Verticies before retracking
C-----------------------------------------------------------------------
            CALL prod2ntu_NtRange(0,MaxNumVtx,Range)
            CALL HBName(Params%NtId,'Vtxold',Evt%vtxold%n,
     $           'nvold:i::'//Range)
            CALL HBName(Params%NtId,'Vtxold',Evt%Vtxold%Ntrk,
     $           'vtxold(nvold)[0,10]:i')
            CALL HBName(Params%NtId,'Vtxold',Evt%Vtxold%X,
     $           'xvold(nvold):r')
            CALL HBName(Params%NtId,'Vtxold',Evt%Vtxold%Y,
     $           'yvold(nvold):r')
            CALL HBName(Params%NtId,'Vtxold',Evt%Vtxold%Z,
     $           'zvold(nvold):r')
            CALL HBName(Params%NtId,'Vtxold',Evt%Vtxold%Chi2,
     $           'chivtxold(nvold):r')
            CALL HBName(Params%NtId,'Vtxold',Evt%Vtxold%Qual,
     $           'qualvold(nvold):i')
            CALL HBName(Params%NtId,'Vtxold',Evt%Vtxold%Fitid,
     $           'fitidvold(nvold):i')
            CALL HBName(Params%NtId,'vtxold',Evt%Vtxold%Cov1,
     $           'VTXcov1old(nvold):r')
            CALL HBName(Params%NtId,'vtxold',Evt%Vtxold%Cov2,
     $           'VTXcov2old(nvold):r')
            CALL HBName(Params%NtId,'vtxold',Evt%Vtxold%Cov3,
     $           'VTXcov3old(nvold):r')
            CALL HBName(Params%NtId,'vtxold',Evt%Vtxold%Cov4,
     $           'VTXcov4old(nvold):r')
            CALL HBName(Params%NtId,'vtxold',Evt%Vtxold%Cov5,
     $           'VTXcov5old(nvold):r')
            CALL HBName(Params%NtId,'vtxold',Evt%Vtxold%Cov6,
     $           'VTXcov6old(nvold):r')
         endif
C-----------------------------------------------------------------------
C ( KPM Stream ) Trks before Vertex reconstruction before retracking
C-----------------------------------------------------------------------
         if( TRKSOLDFLAG )then
            CALL prod2ntu_NtRange(0,MaxNumTrk,Range)
            CALL HBName(Params%NtId,'Trkold',Evt%Trkold%n,
     $           'ntold:i::'//Range)
            CALL HBName(Params%NtId,'Trkold',Evt%Trkold%trkind,
     $           'trkindold(ntold):i')
            CALL HBName(Params%NtId,'Trkold',Evt%Trkold%version,
     $           'trkverold(ntold):i')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%cur,
     $           'Curold(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%phi,
     $           'Phiold(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%cot,
     $           'Cotold(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%px,
     $           'pxtold(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%py,
     $           'pytold(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%pz,
     $           'pztold(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%pmod,
     $           'pmodold(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%length,
     $           'lenold(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%x,
     $           'xfirstold(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%y,
     $           'yfirstold(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%z,
     $           'zfirstold(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%curlast,
     $           'Curlaold(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%philast,
     $           'Philaold(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%cotlast,
     $           'Cotlaold(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%pxlast,
     $           'pxtlaold(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%pylast,
     $           'pytlaold(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%pzlast,
     $           'pztlaold(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%pmodlast
     $           ,'pmodlaold(ntold):r')
            CALL HBName(Params%Ntid,'TRKOLD',Evt%Trkold%SigPCA,
     $           'spcaold(ntold):r')
            CALL HBName(Params%Ntid,'TRKOLD',Evt%Trkold%SigZeta,
     $           'szetaold(ntold):r')
            CALL HBName(Params%Ntid,'TRKOLD',Evt%Trkold%SigCurv,
     $           'scurvold(ntold):r')
            CALL HBName(Params%Ntid,'TRKOLD',Evt%Trkold%SigCot,
     $           'scotgold(ntold):r')
            CALL HBName(Params%Ntid,'TRKOLD',Evt%Trkold%SigPhi,
     $           'sphiold(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%xlast,
     $           'xlastold(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%ylast,
     $           'ylastold(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%zlast,
     $           'zlastold(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%xpca,
     $           'xpca2old(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%ypca,
     $           'ypca2old(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%zpca,
     $           'zpca2old(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%qtrk,
     $           'qtrk2old(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%cotpca,
     $           'cotpca2old(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%phipca,
     $           'phipca2old(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%NumPRhit
     $           ,'nprhitold(ntold):i')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%NumFitHit
     $           ,'nfithitold(ntold):i')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%nmskink
     $           ,'nmskinkold(ntold):i')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%chi2fit
     $           ,'chi2fitold(ntold):r')
            CALL HBName(Params%Ntid,'Trkold',Evt%Trkold%chi2ms,
     $           'chi2msold(ntold):r')
         endif
C-----------------------------------------------------------------------
C KPM Stream : DTFSMC patterns before retracking
C-----------------------------------------------------------------------
         if(TRKSOLDFLAG)then
            CALL prod2ntu_NtRange(0,MaxNumTrk,Range)
            CALL HBName(Params%NtId,'Trkmcold',Evt%Trkmcold%n,
     $           'ntfmcold:i::'//Range)
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%ncontr
     $           ,'ncontrold(ntfmcold)[0,10]:i')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%kine1
     $           ,'trkine1old(ntfmcold)[0,100]:i')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%type1
     $           ,'trtype1old(ntfmcold)[0,100]:i')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%hits1
     $           ,'trhits1old(ntfmcold)[0,1000]:i')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%kine2
     $           ,'trkine2old(ntfmcold)[0,100]:i')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%type2
     $           ,'trtype2old(ntfmcold)[0,100]:i')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%hits2
     $           ,'trhits2old(ntfmcold)[0,1000]:i')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%kine3
     $           ,'trkine3old(ntfmcold)[0,100]:i')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%type3
     $           ,'trtype3old(ntfmcold)[0,100]:i')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%hits3
     $           ,'trhits3old(ntfmcold)[0,1000]:i')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%xfirst
     $           ,'xfmcold(ntfmcold):r')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%yfirst
     $           ,'yfmcold(ntfmcold):r')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%zfirst
     $           ,'zfmcold(ntfmcold):r')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%pxfirst
     $           ,'pxfmcold(ntfmcold):r')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%pyfirst
     $           ,'pyfmcold(ntfmcold):r')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%pzfirst
     $           ,'pzfmcold(ntfmcold):r')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%xlast
     $           ,'xlmcold(ntfmcold):r')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%ylast
     $           ,'ylmcold(ntfmcold):r')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%zlast
     $           ,'zlmcold(ntfmcold):r')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%pxlast
     $           ,'pxlmcold(ntfmcold):r')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%pylast
     $           ,'pylmcold(ntfmcold):r')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%pzlast
     $           ,'pzlmcold(ntfmcold):r')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%xmcfirst
     $           ,'xfmc2old(ntfmcold):r')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%ymcfirst
     $           ,'yfmc2old(ntfmcold):r')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%zmcfirst
     $           ,'zfmc2old(ntfmcold):r')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%pxmcfirst
     $           ,'pxfmc2old(ntfmcold):r')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%pymcfirst
     $           ,'pyfmc2old(ntfmcold):r')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%pzmcfirst
     $           ,'pzfmc2old(ntfmcold):r')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%xmclast
     $           ,'xlmc2old(ntfmcold):r')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%ymclast
     $           ,'ylmc2old(ntfmcold):r')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%zmclast
     $           ,'zlmc2old(ntfmcold):r')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%pxmclast
     $           ,'pxlmc2old(ntfmcold):r')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%pymclast
     $           ,'pylmc2old(ntfmcold):r')
            CALL HBName(Params%Ntid,'Trkmcold',Evt%Trkmcold%pzmclast
     $           ,'pzlmc2old(ntfmcold):r')
         EndIF
C-----------------------------------------------------------------------
C MC hits ( DHIT bank )
C-----------------------------------------------------------------------
         if (DHITFLAG) then
            CALL prod2ntu_NtRange(0,maxnumdhit,Range)
            CALL HBName(Params%NtId,'DHIT',Evt%DHIT%n,'ndhit:i::'//Range
     $           )
            CALL HBName(Params%NtId,'DHIT',Evt%DHIT%pid,'dhpid(ndhit):i'
     $           )
            CALL HBName(Params%NtId,'DHIT',Evt%DHIT%kinum
     $           ,'dhkin(ndhit):i')
            CALL HBName(Params%NtId,'DHIT',Evt%DHIT%celadr,
     %           'dhadd(ndhit):i')
            CALL HBName(Params%NtId,'DHIT',Evt%DHIT%x,'dhx(ndhit):r')
            CALL HBName(Params%NtId,'DHIT',Evt%DHIT%y,'dhy(ndhit):r')
            CALL HBName(Params%NtId,'DHIT',Evt%DHIT%z,'dhz(ndhit):r')
            CALL HBName(Params%NtId,'DHIT',Evt%DHIT%px,'dhpx(ndhit):r')
            CALL HBName(Params%NtId,'DHIT',Evt%DHIT%py,'dhpy(ndhit):r')
            CALL HBName(Params%NtId,'DHIT',Evt%DHIT%pz,'dhpz(ndhit):r')
            CALL HBName(Params%NtId,'DHIT',Evt%DHIT%time,'dht(ndhit):r')
            CALL HBName(Params%NtId,'DHIT',Evt%DHIT%dedx
     $           ,'dhdedx(ndhit):r')
            CALL HBName(Params%NtId,'DHIT',Evt%DHIT%tlen
     $           ,'dhtlen(ndhit):r')
            CALL HBName(Params%NtId,'DHIT',Evt%DHIT%dtime,
     %           'dhdtime(ndhit):r')
            CALL HBName(Params%NtId,'DHIT',Evt%DHIT%dfromw,
     %           'dhdfromw(ndhit):r')
            CALL HBName(Params%NtId,'DHIT',Evt%DHIT%flag
     $           ,'dhflag(ndhit):i')
         endif
Cvp
C-----------------------------------------------------------------------
C DEDX in Drift Chamber ( DEDX bank )
C-----------------------------------------------------------------------
         if (DEDXFLAG) then
            CALL HBName(Params%NtId,'DEDX',Evt%DEDX2STRU%numdedx,
     $           'ndedx[0,20]:i')
            CALL HBName(Params%NtId,'DEDX',Evt%DEDX2STRU%numeroadc,
     $           'nadc(ndedx):i')
            CALL HBName(Params%NtId,'DEDX',Evt%DEDX2STRU%indicededx,
     $           'idedx(ndedx):i')
            CALL HBName(Params%NtId,'DEDX',Evt%DEDX2STRU%lay,
     $           'adclayer(100,ndedx):i')
            CALL HBName(Params%NtId,'DEDX',Evt%DEDX2STRU%wir1,
     $           'adcwi1(100,ndedx):i')
            CALL HBName(Params%NtId,'DEDX',Evt%DEDX2STRU%wir2,
     $           'adcwi2(100,ndedx):i')
            CALL HBName(Params%NtId,'DEDX',Evt%DEDX2STRU%step,
     $           'adclen(100,ndedx):r')
            CALL HBName(Params%NtId,'DEDX',Evt%DEDX2STRU%effs,
     $           'adcleff(100,ndedx):r')
            CALL HBName(Params%NtId,'DEDX',Evt%DEDX2STRU%tim1,
     $           'adctim1(100,ndedx):r')
            CALL HBName(Params%NtId,'DEDX',Evt%DEDX2STRU%tim2,
     $           'adctim2(100,ndedx):r')
            CALL HBName(Params%NtId,'DEDX',Evt%DEDX2STRU%carica,
     $           'adccharge(100,ndedx):r')
         endif
Cvp
C-----------------------------------------------------------------------
C DPRS patterns
C-----------------------------------------------------------------------
         If (DPRSFLAG) Then
           Call HBNAME
     &         (Params%NtId, 'DPRS', Evt%DPRS%NDPRS, DPRS_NTP_STR)
         End If
C-----------------------------------------------------------------------
C GEANFI MC Information
C-----------------------------------------------------------------------
         if( GEANFIFLAG )then
            CALL prod2ntu_NtRange(0,MaxNtrkGen,Range)
            CALL HBName(Params%NtId,'MC',Evt%MC%ntrk,'ntmc:i::'//Range)
            CALL HBName(Params%NtId,'MC',Evt%MC%kin
     $           ,'kine(ntmc)[0,100]:i')
            CALL HBName(Params%NtId,'MC',Evt%MC%pid
     $           ,'pidmc(ntmc)[0,100]:i')
            CALL HBName(Params%NtId,'MC',Evt%MC%virmom
     $           ,'virmom(ntmc)[0,100]:i')
            CALL HBName(Params%NtId,'MC',Evt%MC%px,'pxmc(ntmc):r')
            CALL HBName(Params%NtId,'MC',Evt%MC%py,'pymc(ntmc):r')
            CALL HBName(Params%NtId,'MC',Evt%MC%pz,'pzmc(ntmc):r')
            CALL HBName(Params%NtId,'MC',Evt%MC%xcv,'xcv(ntmc):r')
            CALL HBName(Params%NtId,'MC',Evt%MC%ycv,'ycv(ntmc):r')
            CALL HBName(Params%NtId,'MC',Evt%MC%zcv,'zcv(ntmc):r')
            CALL HBName(Params%NtId,'MC',Evt%MC%tofcv,'tofcv(ntmc):r')
            CALL HBName(Params%NtId,'MC',Evt%MC%theta,'themc(ntmc):r')
            CALL HBName(Params%NtId,'MC',Evt%MC%phi,'phimc(ntmc):r')
            CALL HBName(Params%NtId,'MC',Evt%MC%Indv,
     &                             'vtxmc(ntmc)[0,100]:i')
            CALL HBName(Params%NtId,'MC',Evt%MC%ndchmc
     $           ,'ndchmc(ntmc):i')
            CALL HBName(Params%NtId,'MC',Evt%MC%xfhmc,'xfhmc(ntmc):r')
            CALL HBName(Params%NtId,'MC',Evt%MC%yfhmc,'yfhmc(ntmc):r')
            CALL HBName(Params%NtId,'MC',Evt%MC%zfhmc,'zfhmc(ntmc):r')
            CALL HBName(Params%NtId,'MC',Evt%MC%pxfhmc,'pxfhmc(ntmc):r')
            CALL HBName(Params%NtId,'MC',Evt%MC%pyfhmc,'pyfhmc(ntmc):r')
            CALL HBName(Params%NtId,'MC',Evt%MC%pzfhmc,'pzfhmc(ntmc):r')
            CALL HBName(Params%NtId,'MC',Evt%MC%xlhmc,'xlhmc(ntmc):r')
            CALL HBName(Params%NtId,'MC',Evt%MC%ylhmc,'ylhmc(ntmc):r')
            CALL HBName(Params%NtId,'MC',Evt%MC%zlhmc,'zlhmc(ntmc):r')
            CALL HBName(Params%NtId,'MC',Evt%MC%pxlhmc,'pxlhmc(ntmc):r')
            CALL HBName(Params%NtId,'MC',Evt%MC%pylhmc,'pylhmc(ntmc):r')
            CALL HBName(Params%NtId,'MC',Evt%MC%pzlhmc,'pzlhmc(ntmc):r')
            CALL prod2ntu_NtRange(0,MaxNvtxGen,Range)
            CALL HBName(Params%NtId,'MC',Evt%MC%numvtx,'nvtxmc:i::'/
     $           /Range)
            CALL HBName(Params%NtId,'MC',Evt%MC%kinmom
     $           ,'kinmom(nvtxmc)[0,100]:i')
            CALL HBName(Params%NtId,'MC',Evt%MC%mother
     $           ,'mother(nvtxmc)[0,100]:i')
            CALL HBName(Params%NtId,'MC',Evt%MC%xv,'xvmc(nvtxmc):r')
            CALL HBName(Params%NtId,'MC',Evt%MC%yv,'yvmc(nvtxmc):r')
            CALL HBName(Params%NtId,'MC',Evt%MC%zv,'zvmc(nvtxmc):r')
            CALL HBname(Params%NtId,'MC',Evt%MC%tof,'tofvmc(nvtxmc):r')
            CALL HBName(Params%NtId,'MC',Evt%MC%trkvtx,'ntvtx(nvtxmc):r'
     $           )
         endif
C-----------------------------------------------------------------------
C Tracks vs cluster merging ... (BANK TCLO)
C-----------------------------------------------------------------------
         if( TCLOFLAG ) then
            CALL prod2ntu_NtRange(0,NTCLOmax,Range)
            CALL HBName(Params%NtId,'TCLO',Evt%Tclo%nt,'ntcl:i::'//Range
     $           )
            CALL HBName(Params%Ntid,'TCLO',Evt%Tclo%trknum
     $           ,'Asstr(ntcl)[0,999]:i')
            CALL HBName(Params%Ntid,'TCLO',Evt%Tclo%clunum
     $           ,'Asscl(ntcl)[0,100]:i')
            CALL HBName(Params%Ntid,'TCLO',Evt%Tclo%verver,
     &           'verver(ntcl):i')
            CALL HBName(Params%Ntid,'TCLO',Evt%Tclo%xext,'xext(ntcl):r')
            CALL HBName(Params%Ntid,'TCLO',Evt%Tclo%yext,'yext(ntcl):r')
            CALL HBName(Params%Ntid,'TCLO',Evt%Tclo%zext,'zext(ntcl):r')
            CALL HBName(Params%Ntid,'TCLO',Evt%Tclo%leng
     $           ,'Assleng(ntcl):r')
            CALL HBName(Params%Ntid,'TCLO',Evt%Tclo%chi,'AssChi(ntcl):r'
     $           )
            CALL HBName(Params%Ntid,'TCLO',Evt%Tclo%px,'extPx(ntcl):r')
            CALL HBName(Params%Ntid,'TCLO',Evt%Tclo%py,'extPy(ntcl):r')
            CALL HBName(Params%Ntid,'TCLO',Evt%Tclo%pz,'extPz(ntcl):r')
         endif
C-----------------------------------------------------------------------
C Tracks vs cluster merging before retracking ... (BANK TCL1)
C-----------------------------------------------------------------------
         if( TCLOLDFLAG ) then
            CALL prod2ntu_NtRange(0,NTCLOmax,Range)
            CALL HBName(Params%NtId,'TCLOLD',Evt%Tclold%nt,
     $           'ntclold:i::'//Range)
            CALL HBName(Params%Ntid,'TCLOLD',Evt%Tclold%trknum
     $           ,'Asstrold(ntclold)[0,999]:i')
            CALL HBName(Params%Ntid,'TCLOLD',Evt%Tclold%clunum
     $           ,'Assclold(ntclold)[0,100]:i')
            CALL HBName(Params%Ntid,'TCLOLD',Evt%Tclold%verver,
     &           'ververold(ntclold):i')
            CALL HBName(Params%Ntid,'TCLOLD',Evt%Tclold%xext,
     $           'xextold(ntclold):r')
            CALL HBName(Params%Ntid,'TCLOLD',Evt%Tclold%yext,
     $           'yextold(ntclold):r')
            CALL HBName(Params%Ntid,'TCLOLD',Evt%Tclold%zext,
     $           'zextold(ntclold):r')
            CALL HBName(Params%Ntid,'TCLOLD',Evt%Tclold%leng,
     $           'Asslengold(ntclold):r')
            CALL HBName(Params%Ntid,'TCLOLD',Evt%Tclold%chi,
     $           'AssChiold(ntclold):r')
            CALL HBName(Params%Ntid,'TCLOLD',Evt%Tclold%px,
     $           'extPxold(ntclold):r')
            CALL HBName(Params%Ntid,'TCLOLD',Evt%Tclold%py,
     $           'extPyold(ntclold):r')
            CALL HBName(Params%Ntid,'TCLOLD',Evt%Tclold%pz,
     $           'extPzold(ntclold):r')
         endif
C-----------------------------------------------------------------------
C CFHI !
C-----------------------------------------------------------------------
         if( CFHIFLAG ) then
            CALL prod2ntu_NtRange(0,maxnumfirsthit,Range)
            CALL HBName(Params%NtId,'CFHI',Evt%CFHI%n,'nfhi:i::'//Range)
            CALL HBName(Params%Ntid,'CFHI',Evt%CFHI%pid
     $           ,'pidfhi(nfhi)[0,100]:i')
            CALL HBName(Params%Ntid,'CFHI',Evt%CFHI%kinum
     $           ,'kinfhi(nfhi)[0,100]:i')
            CALL HBName(Params%Ntid,'CFHI',Evt%CFHI%celadr
     $           ,'celfhi(nfhi)[0,4880]:i')
            CALL HBName(Params%Ntid,'CFHI',Evt%CFHI%convfl
     $           ,'flgfhi(nfhi)[0,1]:i')
            CALL HBName(Params%Ntid,'CFHI',Evt%CFHI%x,'xfhi(nfhi):r')
            CALL HBName(Params%Ntid,'CFHI',Evt%CFHI%y,'yfhi(nfhi):r')
            CALL HBName(Params%Ntid,'CFHI',Evt%CFHI%z,'zfhi(nfhi):r')
            CALL HBName(Params%Ntid,'CFHI',Evt%CFHI%px,'pxfhi(nfhi):r')
            CALL HBName(Params%Ntid,'CFHI',Evt%CFHI%py,'pyfhi(nfhi):r')
            CALL HBName(Params%Ntid,'CFHI',Evt%CFHI%pz,'pzfhi(nfhi):r')
            CALL HBName(Params%Ntid,'CFHI',Evt%CFHI%tof,'toffhi(nfhi):r'
     $           )
            CALL HBName(Params%Ntid,'CFHI',Evt%CFHI%tlen
     $           ,'tlenfhi(nfhi):r')
         endif
C-----------------------------------------------------------------------
C QIHI - Quadrupole Instrumentation HIts
C-----------------------------------------------------------------------
         if( QCALFLAG ) then
            IF( GEANFIFLAG )THEN
C for the moment
              SkipFlag = .true. 
              IF( SkipFLag ) THEN
               CALL prod2ntu_NtRange(0,NQIHIMAX,Range)
C               write(*,*)'QIHI-Range:',Range
               CALL HBName(Params%NtId,'QIHI',Evt%QHIT%n,
     &              'nqihi:i::'//Range)
               CALL HBName(Params%Ntid,'QIHI',Evt%QHIT%pty
     $              ,'pidqihi(nqihi):i')
               CALL HBName(Params%Ntid,'QIHI',Evt%QHIT%add
     $              ,'addqihi(nqihi):i')
               CALL HBName(Params%Ntid,'QIHI',Evt%QHIT%kine
     $              ,'kinqihi(nqihi):i')
               CALL HBName(Params%Ntid,'QIHI',Evt%QHIT%x
     $              ,'xqihi(nqihi):r')
               CALL HBName(Params%Ntid,'QIHI',Evt%QHIT%Y
     $              ,'yqihi(nqihi):r')
               CALL HBName(Params%Ntid,'QIHI',Evt%QHIT%z
     $              ,'zqihi(nqihi):r')
               CALL HBName(Params%Ntid,'QIHI',Evt%QHIT%px
     $              ,'pxqihi(nqihi):r')
               CALL HBName(Params%Ntid,'QIHI',Evt%QHIT%px
     $              ,'pyqihi(nqihi):r')
               CALL HBName(Params%Ntid,'QIHI',Evt%QHIT%pz
     $              ,'pzqihi(nqihi):r')
               CALL HBName(Params%Ntid,'QIHI',Evt%QHIT%tof
     $              ,'tofqihi(nqihi):r')
               CALL HBName(Params%Ntid,'QIHI',Evt%QHIT%ene
     $              ,'eneqihi(nqihi):r')
               CALL HBName(Params%Ntid,'QIHI',Evt%QHIT%trl
     $              ,'tlenqihi(nqihi):r')
             ENDIF
            ENDIF
C
            IF( TRKSFLAG ) THEN
              CALL prod2ntu_NtRange(0,MaxNumTrkQ,Range)
              CALL HBName(Params%Ntid,'TRKQ',Evt%TRKQ%n,
     +             'ntrkq:i::'//Range)
              CALL HBName(Params%Ntid,'TRKQ',Evt%TRKQ%flagqt
     +             ,'flagqt:i')
              CALL HBName(Params%Ntid,'TRKQ',Evt%TRKQ%det
     +             ,'detqt(2,ntrkq):i')
              CALL HBName(Params%Ntid,'TRKQ',Evt%TRKQ%wed
     +             ,'wedqt(2,ntrkq):i')
              CALL HBName(Params%Ntid,'TRKQ',Evt%TRKQ%xi,
     +             'xqt(2,ntrkq):r')
              CALL HBName(Params%Ntid,'TRKQ',Evt%TRKQ%yi,
     +             'yqt(2,ntrkq):r')
              CALL HBName(Params%Ntid,'TRKQ',Evt%TRKQ%zi,
     +             'zqt(2,ntrkq):r')
              CALL HBName(Params%Ntid,'TRKQ',Evt%TRKQ%itrk
     +             ,'itrqt(ntrkq):i')
            ENDIF
C
            CALL prod2ntu_NtRange(0,NQCALMAX,Range)
C            write(*,*)' QELE-Range:',Range
            CALL HBName(Params%Ntid,'QELE',Evt%QELE%n,
     &           'nqele:i::'//Range)
            CALL HBName(Params%Ntid,'QELE',Evt%QELE%wed,'qwed(nqele):i'
     &           )
            CALL HBName(Params%Ntid,'QELE',Evt%QELE%det,'qdet(nqele):i')
            CALL HBName(Params%Ntid,'QELE',Evt%QELE%e,  'qene(nqele):r')
            CALL HBName(Params%Ntid,'QELE',Evt%QELE%t,  'qtim(nqele):r')
            CALL prod2ntu_NtRange(0,NQCALMAX,Range)
            CALL HBName(Params%Ntid,'QCAL',Evt%Qcal%n,
     &           'nqcal:i::'//Range)
            CALL HBName(Params%Ntid,'QCAL',Evt%Qcal%x, 'xqcal(nqcal):r')
            CALL HBName(Params%Ntid,'QCAL',Evt%Qcal%y, 'yqcal(nqcal):r')
            CALL HBName(Params%Ntid,'QCAL',Evt%Qcal%z, 'zqcal(nqcal):r')
            CALL HBName(Params%Ntid,'QCAL',Evt%Qcal%ene,'eqcal(nqcal):r'
     $           )
            CALL HBName(Params%Ntid,'QCAL',Evt%Qcal%t, 'tqcal(nqcal):r')
         endif
C-----------------------------------------------------------------------
Cgc     KNVO
C-----------------------------------------------------------------------
         IF( NVOFLAG ) then
            CALL prod2ntu_NtRange(0,MaxNumKNVO,Range)
            CALL HBName(Params%NtId,'KNVO',Evt%KNVO%n,'nknvo:i::'//Range
     $           )
            CALL HBName(Params%NtId,'KNVO',Evt%KNVO%iknvo
     $           ,'iknvo(nknvo):i')
            CALL HBName(Params%NtId,'KNVO',Evt%KNVO%px
     $           ,'pxknvo(nknvo):r')
            CALL HBName(Params%NtId,'KNVO',Evt%KNVO%py
     $           ,'pyknvo(nknvo):r')
            CALL HBName(Params%NtId,'KNVO',Evt%KNVO%pz
     $           ,'pzknvo(nknvo):r')
            CALL HBName(Params%NtId,'KNVO',Evt%KNVO%pid
     $           ,'pidknvo(nknvo):i')
            CALL HBName(Params%NtId,'KNVO',Evt%KNVO%bank
     $           ,'bankknvo(nknvo):i')
            CALL HBName(Params%NtId,'KNVO',Evt%KNVO%vlinked
     $           ,'nvnvknvo(nknvo):i')
         endif
C-----------------------------------------------------------------------
Cgc     VNVO
C-----------------------------------------------------------------------
         IF( NVOFLAG ) then
            CALL prod2ntu_NtRange(0,MaxNumVNVO,Range)
            CALL HBName(Params%NtId,'VNVO',Evt%VNVO%n,'nvnvo:i::'//Range
     &)
            CALL HBName(Params%NtId,'VNVO',Evt%VNVO%ivnvo
     $           ,'ivnvo(nvnvo):i')
            CALL HBName(Params%NtId,'VNVO',Evt%VNVO%vx,'vxvnvo(nvnvo):r'
     $           )
            CALL HBName(Params%NtId,'VNVO',Evt%VNVO%vy,'vyvnvo(nvnvo):r'
     $           )
            CALL HBName(Params%NtId,'VNVO',Evt%VNVO%vz,'vzvnvo(nvnvo):r'
     $           )
            CALL HBName(Params%NtId,'VNVO',Evt%VNVO%kori
     $           ,'korivnvo(nvnvo):i')
            CALL HBName(Params%NtId,'VNVO',Evt%VNVO%idvfs
     $           ,'dvfsvnvo(nvnvo):i')
            CALL HBName(Params%NtId,'VNVO',Evt%VNVO%nknv
     $           ,'nbnkvnvo(nvnvo):i')
            CALL HBName(Params%NtId,'VNVO',Evt%VNVO%fknv
     $           ,'fbnkvnvo(nvnvo):i')
         endif
C-----------------------------------------------------------------------
Csdf     VNVB
C-----------------------------------------------------------------------
         IF( NVOFLAG ) then
            CALL prod2ntu_NtRange(0,MaxNumVNVOb,Range)
            CALL HBName(Params%NtId,'VNVB',Evt%VNVB%n,'nbnksvnvo:i::'
     _           //Range)
            CALL HBName(Params%NtId,'VNVB',Evt%VNVB%ibank
     $           ,'ibank(nbnksvnvo):i')
         endif
C-----------------------------------------------------------------------
Cgc     INVO
C-----------------------------------------------------------------------
         IF( NVOFLAG ) then
            CALL prod2ntu_NtRange(0,MaxNumINVO,Range)
            CALL HBName(Params%NtId,'INVO',Evt%INVO%n,'ninvo:i::'//Range
     $           )
            CALL HBName(Params%NtId,'INVO',Evt%INVO%iclps
     $           ,'iclps(ninvo):i')
            CALL HBName(Params%NtId,'INVO',Evt%INVO%xi,'xinvo(ninvo):r')
            CALL HBName(Params%NtId,'INVO',Evt%INVO%yi,'yinvo(ninvo):r')
            CALL HBName(Params%NtId,'INVO',Evt%INVO%zi,'zinvo(ninvo):r')
            CALL HBName(Params%NtId,'INVO',Evt%INVO%ti,'tinvo(ninvo):r')
            CALL HBName(Params%NtId,'INVO',Evt%INVO%lk,'lk(ninvo):r')
            CALL HBName(Params%NtId,'INVO',Evt%INVO%sigmalk
     $           ,'sigmalk(ninvo):r')
         endif
C-----------------------------------------------------------------------
C     ECLO  - informatins from ECLO bank
C-----------------------------------------------------------------------
         IF( ECLOFLAG ) then
            CALL prod2ntu_NtRange(0,MaxNumCLINF,Range)
            CALL HBName(Params%NtId,'ECLO',Evt%eclo%n,
     +           'ncli:i::'//Range)
            CALL HBName(Params%NtId,'ECLO',Evt%eclo%totword,
     +           'ECLOword(ncli):i')
            CALL HBName(Params%NtId,'ECLO',Evt%eclo%idpart,
     +           'idpart(ncli):i')
            CALL HBName(Params%NtId,'ECLO',Evt%eclo%dtclpo,
     +           'dtclpo(ncli):i')
            CALL HBName(Params%NtId,'ECLO',Evt%eclo%dvvnpo,
     +           'dvvnpo(ncli):i')
            CALL HBName(Params%NtId,'ECLO',Evt%eclo%stre,
     +           'stre(ncli):i')
            CALL HBName(Params%NtId,'ECLO',Evt%eclo%algo,
     +           'algo(ncli):i')
CGS ECLO BANK 2
            CALL HBName(Params%NtId,'ECLO2',Evt%eclo%n2,
     +           'ncli2:i::'//Range)
            CALL HBName(Params%NtId,'ECLO2',Evt%eclo%totword2,
     +           'ECLOword2(ncli2):i')
            CALL HBName(Params%NtId,'ECLO2',Evt%eclo%idpart2,
     +           'idpart2(ncli2):i')
            CALL HBName(Params%NtId,'ECLO2',Evt%eclo%dtclpo2,
     +           'dtclpo2(ncli2):i')
            CALL HBName(Params%NtId,'ECLO2',Evt%eclo%dvvnpo2,
     +           'dvvnpo2(ncli2):i')
            CALL HBName(Params%NtId,'ECLO2',Evt%eclo%stre2,
     +           'stre2(ncli2):i')
            CALL HBName(Params%NtId,'ECLO2',Evt%eclo%algo2,
     +           'algo2(ncli2):i')
         endif
         IF( CSPSFLAG ) THEN
            CALL prod2ntu_NtRange(0,NHitCluMax,Range)
            CALL HBName(Params%NtId,'CSPS',Evt%CSPS%Ncel,
     +           'ncs:i::'//Range)
            CALL HBName(Params%NtId,'CSPS',Evt%Csps%Iclu,
     +           'CSclu(ncs):i')
            CALL HBName(Params%NtId,'CSPS',Evt%Csps%Icel,
     &           'CScel(ncs):i')
            CALL HBName(Params%NtId,'CSPS',Evt%Csps%Flag,
     &           'CSfla(ncs):i')
            CALL HBName(Params%NtId,'CSPS',Evt%Csps%Add,
     &           'CSadd(ncs):i')
            CALL HBName(Params%NtId,'CSPS',Evt%Csps%Nhit,
     &           'CSnhi(ncs):i')
C
            CALL HBName(Params%NtId,'CSPS',Evt%Csps%Ta,
     &           'CSta(ncs):r')
            CALL HBName(Params%NtId,'CSPS',Evt%Csps%Tb,
     &           'CStb(ncs):r')
            CALL HBName(Params%NtId,'CSPS',Evt%Csps%Ea,
     &           'CSEa(ncs):r')
            CALL HBName(Params%NtId,'CSPS',Evt%Csps%Eb,
     &           'CSEb(ncs):r')
            CALL HBName(Params%NtId,'CSPS',Evt%Csps%T,
     &           'CSt(ncs):r')
            CALL HBName(Params%NtId,'CSPS',Evt%Csps%E,
     &           'CSE(ncs):r')
            CALL HBName(Params%NtId,'CSPS',Evt%Csps%X,
     &           'CSx(ncs):r')
            CALL HBName(Params%NtId,'CSPS',Evt%Csps%Y,
     &           'CSy(ncs):r')
            CALL HBName(Params%NtId,'CSPS',Evt%Csps%Z,
     &           'CSz(ncs):r')
         ENDIF
C
         IF( CSPSMCFLAG ) THEN
            CALL prod2ntu_NtRange(0,NHitCluMax,Range)
            CALL HBName(Params%NtId,'CSPSMC',Evt%CSPSMC%Ncel,
     +           'ncsmc:i::'//Range)
C            write(6,*)'CSPSMC Range',Range
            CALL HBName(Params%NtId,'CSPSMC',Evt%CSPSMC%Knum,
     +           'CSMCkine(ncsmc):i')
            CALL HBName(Params%NtId,'CSPSMC',Evt%CSPSMC%Ihit,
     &           'CSMCpoi(ncsmc):i')
            CALL HBName(Params%NtId,'CSPSMC',Evt%CSPSMC%Nhit,
     &           'CSMCnhit(ncsmc):i')
            CALL HBName(Params%NtId,'CSPSMC',Evt%CSPSMC%X,
     &           'CSMCx(ncsmc):r')
            CALL HBName(Params%NtId,'CSPSMC',Evt%CSPSMC%Y,
     &           'CSMCy(ncsmc):r')
            CALL HBName(Params%NtId,'CSPSMC',Evt%CSPSMC%Z,
     &           'CSMCz(ncsmc):r')
            CALL HBName(Params%NtId,'CSPSMC',Evt%CSPSMC%T,
     &           'CSMCt(ncsmc):r')
            CALL HBName(Params%NtId,'CSPSMC',Evt%CSPSMC%E,
     &           'CSMCe(ncsmc):r')
C
         ENDIF
         IF( CLUOFLAG ) THEN
            Call prod2ntu_NtRange(0,NCluoMax,Range)
            CALL HBName(Params%NtId,'CLUO',Evt%CLUO%N,
     +           'NCLUO:i::'//Range)
            CALL HBName(Params%NtId,'CLUO',Evt%CLUO%Ncel,
     +           'CluCel(ncluo):i')
            CALL HBName(Params%NtId,'CLUO',Evt%CLUO%Flag,
     +           'CluFl(ncluo):r')
C----------------------------------------------------------
C            CALL HBName(Params%NtId,'CLUO',Evt%CLUO%Ncel,
C     +           'CluChi(ncluo):i')
C            CALL HBName(Params%NtId,'CLUO',Evt%CLUO%Ncel,
C     +           'CluFl(ncluo):i')
C--------------------------------------------------------------
            CALL HBName(Params%NtId,'CLUO',Evt%CLUO%E,
     &           'CluE(Ncluo):r')
            CALL HBName(Params%NtId,'CLUO',Evt%CLUO%X,
     &           'CluX(Ncluo):r')
            CALL HBName(Params%NtId,'CLUO',Evt%CLUO%Y,
     &           'CluY(Ncluo):r')
            CALL HBName(Params%NtId,'CLUO',Evt%CLUO%Z,
     &           'CluZ(Ncluo):r')
            CALL HBName(Params%NtId,'CLUO',Evt%CLUO%T,
     &           'CluT(Ncluo):r')
C
            Call prod2ntu_NtRange(0,NCluoMax,Range)
            CALL HBName(Params%NtId,'CLUOMC',Evt%CLUOMC%Npar,
     +           'nMCpar:i::'//Range)
            CALL HBName(Params%NtId,'CLUOMC',Evt%CLUOMC%Ncel,
     +           'CluMCCel(nmcpar):i')
            CALL HBName(Params%NtId,'CLUOMC',Evt%CLUOMC%Iclu,
     +           'CluMCIcl(nmcpar):i')
            CALL HBName(Params%NtId,'CLUOMC',Evt%CLUOMC%Kine,
     +           'CluMCkin(nmcpar):i')
C
            CALL HBName(Params%NtId,'CLUOMC',Evt%CLUOMC%E,
     &           'CluMCE(nmcpar):r')
            CALL HBName(Params%NtId,'CLUOMC',Evt%CLUOMC%X,
     &           'CluMCX(nmcpar):r')
            CALL HBName(Params%NtId,'CLUOMC',Evt%CLUOMC%Y,
     &           'CluMCY(nmcpar):r')
            CALL HBName(Params%NtId,'CLUOMC',Evt%CLUOMC%Z,
     &           'CluMCZ(nmcpar):r')
            CALL HBName(Params%NtId,'CLUOMC',Evt%CLUOMC%T,
     &           'CluMCT(nmcpar):r')
         ENDIF
C ----------------------------------------------------------------------
C QCAL-T
C ----------------------------------------------------------------------
         IF ( QCALTELEFLAG ) THEN
            CALL HBNAME(Params%NtId,'QTELE',Evt%QCALT%NEle
     &           ,'nqcalt:i::[0,1920]')
            CALL HBNAME(Params%NtId,'QTELE',Evt%QCALT%Nhit
     &           ,'qlte_hit(nqcalt)[0,5]:i')
            CALL HBNAME(Params%NtId,'QTELE',Evt%QCALT%Qdet
     &           ,'qlte_det(nqcalt)[0,2]:i')
            CALL HBNAME(Params%NtId,'QTELE',Evt%QCALT%Qmod
     &           ,'qlte_mod(nqcalt)[0,11]:i')
            CALL HBNAME(Params%NtId,'QTELE',Evt%QCALT%Qpla
     &           ,'qlte_pla(nqcalt)[0,4]:i')
            CALL HBNAME(Params%NtId,'QTELE',Evt%QCALT%Qtil
     &           ,'qlte_til(nqcalt)[0,15]:i')
            CALL HBNAME(Params%NtId,'QTELE',Evt%QCALT%Time
     &           ,'qlte_tim1(nqcalt):r,qlte_tim2(nqcalt):r,'//
     &           'qlte_tim3(nqcalt):r,'//
     &           'qlte_tim4(nqcalt):r,qlte_tim5(nqcalt):r')
         ENDIF
C-----------------------------------------------------------------------
C ----------------------------------------------------------------------
C QCAL-T HIT
C ----------------------------------------------------------------------
         IF (QCALTHITFLAG) THEN
            CALL HBNAME(Params%NtId,'QCTH',Evt%QCALTHIT%Nele
     &           ,'nqcthele:i::[0,1920]')
            CALL HBNAME(Params%NtId,'QCTH',Evt%QCALTHIT%Nhit
     &           ,'nhit(nqcthele)[1,5]:i')
            CALL HBNAME(Params%NtId,'QCTH',Evt%QCALTHIT%X
     &           ,'X(nqcthele):r')
            CALL HBNAME(Params%NtId,'QCTH',Evt%QCALTHIT%Y
     &           ,'Y(nqcthele):r')
            CALL HBNAME(Params%NtId,'QCTH',Evt%QCALTHIT%Z
     &           ,'Z(nqcthele):r')
            CALL HBNAME(Params%NtId,'QCTH',Evt%QCALTHIT%Time
     &           ,'tim1(nqcthele):r,'//
     &           'tim2(nqcthele):r, tim3(nqcthele):r,'//
     &           'tim4(nqcthele):r, tim5(nqcthele):r')
         ENDIF
C-----------------------------------------------------------------------
C ----------------------------------------------------------------------
C CCAL-T
C ----------------------------------------------------------------------
         IF (CCLEFLAG) THEN
            CALL HBNAME(Params%NtId,'CCLE',Evt%CCLE%NEle
     &           ,'nccle:i::[0,96]')
            CALL HBNAME(Params%NtId,'CCLE',Evt%CCLE%Cry
     &           ,'ccle_cry(nccle)[0,96]:i')
            CALL HBNAME(Params%NtId,'CCLE',Evt%CCLE%Det
     &           ,'ccle_det(nccle):i')
            CALL HBNAME(Params%NtId,'CCLE',Evt%CCLE%Col
     &           ,'ccle_col(nccle)[0,24]:i')
            CALL HBNAME(Params%NtId,'CCLE',Evt%CCLE%Pla
     &           ,'ccle_pla(nccle)[0,2]:i')
            CALL HBNAME(Params%NtId,'CCLE',Evt%CCLE%T
     &           ,'ccle_time(nccle):r')
         ENDIF
C ----------------------------------------------------------------------
C LET
C ----------------------------------------------------------------------
         IF(LETEFLAG)THEN
C            CALL HBNAME(Params%NtId,'LETE',Evt%LETE%Iele
C     &           ,'Iele:r')
C            CALL HBNAME(Params%NtId,'LETE',Evt%LETE%Ipos
C     &           ,'Ipos:r')
C            CALL HBNAME(Params%NtId,'LETE',Evt%LETE%Lumi
C     &           ,'Lumi:r')
            CALL HBNAME(Params%NtId,'LETE',Evt%LETE%Calib
     &           ,'letecalib:i')
            CALL prod2ntu_NtRange(0,NeleCluMax,Range)
            CALL HBNAME(Params%NtId,'LETE',Evt%LETE%NEle
     &           ,'nlete:i::[0,40]')
            CALL HBNAME(Params%NtId,'LETE',Evt%LETE%Cry
     &           ,'lete_cry(nlete)[0,40]:i')
C     LET = old QCAL
            CALL HBNAME(Params%NtId,'LETE',Evt%LETE%Det
     &           , 'lete_det(nlete):i')
            CALL HBNAME(Params%NtId,'LETE',Evt%LETE%Col
     &           , 'lete_col(nlete)[0,4]:i')
            CALL HBNAME(Params%NtId,'LETE',Evt%LETE%Pla
     &           , 'lete_pla(nlete)[0,5]:i')
            CALL HBNAME(Params%NtId,'LETE',Evt%LETE%E
     &           ,  'lete_e(nlete):r')
            CALL HBNAME(Params%NtId,'LETE',Evt%LETE%T
     &           ,  'lete_time(nlete):r')
         ENDIF
C-----------------------------------------------------------------------
C IT
         IF(ITCEFLAG)THEN
C             CALL HBNAME(Params%NtId,'Info',NumRun,'nrun:i')
C             CALL HBNAME(Params%NtId,'Info',NumTrg,'ntrig:i')
             CALL HBNAME(Params%NtId,'ITCE',Evt%itce%nitce
     &           ,'nitce:i::[0,4032]')
         CALL HBNAME(Params%NtId,'ITCE',Evt%itce%foil
     &            ,'foil(nitce):i')
             CALL HBNAME(Params%NtId,'ITCE',Evt%itce%layer
     &            ,'layer(nitce):i')
             CALL HBNAME(Params%NtId,'ITCE',Evt%itce%strip
     &            ,'strip(nitce):i')
             CALL HBNAME(Params%NtId,'ITCE',Evt%itce%view
     &            ,'view(nitce):i')
             CALL HBNAME(Params%NtId,'ITCE',Evt%itce%inditkine
     &       ,'inditkine(nitce):i')
          ENDIF
C-----------------------------------------------------------------------
C HET
        IF(HETEFLAG)THEN
             CALL HBNAME(Params%NtId,'HETE',Evt%hete%nhetdcs
     &           ,'nhetdcs:i::[0,1920]')
         CALL HBNAME(Params%NtId,'HETE',Evt%hete%hdet
     &            ,'hdet(nhetdcs):i::[1,2]')
             CALL HBNAME(Params%NtId,'HETE',Evt%hete%hcol
     &            ,'hcol(nhetdcs):i::[1,32]')
             CALL HBNAME(Params%NtId,'HETE',Evt%hete%nturnhet
     &       ,'nturnhet(nhetdcs):i::[1,4]')
      CALL HBNAME(Params%NtId,'HETE',Evt%hete%timehet
     &            ,'timehet(nhetdcs):r')
          ENDIF
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
C That's all, folks!
C-----------------------------------------------------------------------
      RETURN
      END
C
C-----------------------------------------------------------------------
      SUBROUTINE prod2ntu_NtRange(Min,Max,String)
C-----------------------------------------------------------------------
        IMPLICIT NONE
C-----------------------------------------------------------------------
      INTEGER Min
      INTEGER Max
      CHARACTER*(*) String
C-----------------------------------------------------------------------
      WRITE(String,'(A,I4,A,I4,A)') '[',Min,',',Max,']'
      RETURN
      END
C
C-----------------------------------------------------------------------
      SUBROUTINE prod2ntu_ev
C-----------------------------------------------------------------------
C Retrieving information from element/segment level and transfer it on
C the EVT common block for PAW.
C-----------------------------------------------------------------------
        IMPLICIT NONE
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
C======= Include /kloe/soft/off/offline/inc/development/bcs.cin ========
        INTEGER          IW
        REAL             RW(200)
        DOUBLE PRECISION DW(100)
        CHARACTER*4      AW(200)
        INTEGER*2        IW2(400)
        EQUIVALENCE (IW,IW2,RW,DW)
        EQUIVALENCE (IW,AW)
        COMMON /BCS/ IW(200)
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
C====== Include /kloe/soft/off/offline/inc/development/bpoybs.cin ======
      INTEGER RUNGID
      PARAMETER (RUNGID = 0)
      INTEGER RUNVER
      PARAMETER (RUNVER = 1)
      INTEGER RUNRND
      PARAMETER (RUNRND = 3)
      INTEGER RUNEVS
      PARAMETER (RUNEVS = 5)
      INTEGER PARNUM
      PARAMETER (PARNUM = 0)
      INTEGER PARNAM
      PARAMETER (PARNAM = 1)
      INTEGER PARTRT
      PARAMETER (PARTRT = 6)
      INTEGER PARMAS
      PARAMETER (PARMAS = 7)
      INTEGER PARCHR
      PARAMETER (PARCHR = 8)
      INTEGER PARLTI
      PARAMETER (PARLTI = 9)
      INTEGER PARBRT
      PARAMETER (PARBRT = 10)
      INTEGER PARDMO
      PARAMETER (PARDMO = 16)
      INTEGER PAUSER
      PARAMETER (PAUSER = 22)
      INTEGER MATNUM
      PARAMETER (MATNUM = 0)
      INTEGER MATNAM
      PARAMETER (MATNAM = 1)
      INTEGER MATATN
      PARAMETER (MATATN = 6)
      INTEGER MATMAS
      PARAMETER (MATMAS = 7)
      INTEGER MATDEN
      PARAMETER (MATDEN = 8)
      INTEGER MATRLE
      PARAMETER (MATRLE = 9)
      INTEGER MATABL
      PARAMETER (MATABL = 10)
      INTEGER MAUSER
      PARAMETER (MAUSER = 11)
      INTEGER TMENUM
      PARAMETER (TMENUM = 0)
      INTEGER TMENAM
      PARAMETER (TMENAM = 1)
      INTEGER TMEMAT
      PARAMETER (TMEMAT = 6)
      INTEGER TMESTF
      PARAMETER (TMESTF = 7)
      INTEGER TMEMFI
      PARAMETER (TMEMFI = 8)
      INTEGER TMEMFM
      PARAMETER (TMEMFM = 9)
      INTEGER TMEMAA
      PARAMETER (TMEMAA = 10)
      INTEGER TMEMAS
      PARAMETER (TMEMAS = 11)
      INTEGER TMEMAE
      PARAMETER (TMEMAE = 12)
      INTEGER TMEEPS
      PARAMETER (TMEEPS = 13)
      INTEGER TMEMIS
      PARAMETER (TMEMIS = 14)
      INTEGER TMUSER
      PARAMETER (TMUSER = 15)
      INTEGER HEARUN
      PARAMETER (HEARUN = 0)
      INTEGER HEAEVT
      PARAMETER (HEAEVT = 1)
      INTEGER HEARND
      PARAMETER (HEARND = 2)
      INTEGER HEAQMI
      PARAMETER (HEAQMI = 4)
      INTEGER HEAKIN
      PARAMETER (HEAKIN = 5)
      INTEGER HEAVER
      PARAMETER (HEAVER = 6)
      INTEGER HEAUSE
      PARAMETER (HEAUSE = 7)
      INTEGER KINPPX
      PARAMETER (KINPPX = 0)
      INTEGER KINPPY
      PARAMETER (KINPPY = 1)
      INTEGER KINPPZ
      PARAMETER (KINPPZ = 2)
      INTEGER KINPEN
      PARAMETER (KINPEN = 3)
      INTEGER KINPTY
      PARAMETER (KINPTY = 4)
      INTEGER KINVXO
      PARAMETER (KINVXO = 5)
      INTEGER KINNVX
      PARAMETER (KINNVX = 6)
      INTEGER KINVLS
      PARAMETER (KINVLS = 7)
      INTEGER VERXCO
      PARAMETER (VERXCO = 0)
      INTEGER VERYCO
      PARAMETER (VERYCO = 1)
      INTEGER VERZCO
      PARAMETER (VERZCO = 2)
      INTEGER VERTOF
      PARAMETER (VERTOF = 3)
      INTEGER VERTNO
      PARAMETER (VERTNO = 4)
      INTEGER VERTAR
      PARAMETER (VERTAR = 5)
      INTEGER VERNTR
      PARAMETER (VERNTR = 6)
      INTEGER VERTLS
      PARAMETER (VERTLS = 7)
      INTEGER DHIHDS
      PARAMETER (DHIHDS = 0)
      INTEGER DHIVRN
      PARAMETER (DHIVRN = 1)
      INTEGER DHINRO
      PARAMETER (DHINRO = 2)
      INTEGER DHINCO
      PARAMETER (DHINCO = 3)
      INTEGER DHIPTY
      PARAMETER (DHIPTY = 0)
      INTEGER DHITRA
      PARAMETER (DHITRA = 1)
      INTEGER DHIADR
      PARAMETER (DHIADR = 2)
      INTEGER DHIXCO
      PARAMETER (DHIXCO = 3)
      INTEGER DHIYCO
      PARAMETER (DHIYCO = 4)
      INTEGER DHIZCO
      PARAMETER (DHIZCO = 5)
      INTEGER DHIPPX
      PARAMETER (DHIPPX = 6)
      INTEGER DHIPPY
      PARAMETER (DHIPPY = 7)
      INTEGER DHIPPZ
      PARAMETER (DHIPPZ = 8)
      INTEGER DHITOF
      PARAMETER (DHITOF = 9)
      INTEGER DHIELO
      PARAMETER (DHIELO =10)
      INTEGER DHILEN
      PARAMETER (DHILEN =11)
      INTEGER DHITIM
      PARAMETER (DHITIM =12)
      INTEGER DHIDIS
      PARAMETER (DHIDIS =13)
      INTEGER DHIFLA
      PARAMETER (DHIFLA =14)
      INTEGER CHIHDS
      PARAMETER (CHIHDS = 0)
      INTEGER CHIVRN
      PARAMETER (CHIVRN = 1)
      INTEGER CHINRO
      PARAMETER (CHINRO = 2)
      INTEGER CHINCO
      PARAMETER (CHINCO = 3)
      INTEGER CHIPTY
      PARAMETER (CHIPTY = 0)
      INTEGER CHITRA
      PARAMETER (CHITRA = 1)
      INTEGER CHIADR
      PARAMETER (CHIADR = 2)
      INTEGER CHIXCO
      PARAMETER (CHIXCO = 3)
      INTEGER CHIYCO
      PARAMETER (CHIYCO = 4)
      INTEGER CHIZCO
      PARAMETER (CHIZCO = 5)
      INTEGER CHITOF
      PARAMETER (CHITOF = 6)
      INTEGER CHIELO
      PARAMETER (CHIELO = 7)
      INTEGER CHILEN
      PARAMETER (CHILEN = 8)
      INTEGER CFHHDS
      PARAMETER (CFHHDS = 0)
      INTEGER CFHVRN
      PARAMETER (CFHVRN = 1)
      INTEGER CFHNRO
      PARAMETER (CFHNRO = 2)
      INTEGER CFHNCO
      PARAMETER (CFHNCO = 3)
      INTEGER CFHPTY
      PARAMETER (CFHPTY = 0)
      INTEGER CFHTRA
      PARAMETER (CFHTRA = 1)
      INTEGER CFHADR
      PARAMETER (CFHADR = 2)
      INTEGER CFHXCO
      PARAMETER (CFHXCO = 3)
      INTEGER CFHYCO
      PARAMETER (CFHYCO = 4)
      INTEGER CFHZCO
      PARAMETER (CFHZCO = 5)
      INTEGER CFHPPX
      PARAMETER (CFHPPX = 6)
      INTEGER CFHPPY
      PARAMETER (CFHPPY = 7)
      INTEGER CFHPPZ
      PARAMETER (CFHPPZ = 8)
      INTEGER CFHTOF
      PARAMETER (CFHTOF = 9)
      INTEGER CFHLEN
      PARAMETER (CFHLEN = 10)
      INTEGER AHIHDS
      PARAMETER (AHIHDS = 0)
      INTEGER AHIVRN
      PARAMETER (AHIVRN = 1)
      INTEGER AHINRO
      PARAMETER (AHINRO = 2)
      INTEGER AHINCO
      PARAMETER (AHINCO = 3)
      INTEGER AHIPTY
      PARAMETER (AHIPTY = 0)
      INTEGER AHITRA
      PARAMETER (AHITRA = 1)
      INTEGER AHIADR
      PARAMETER (AHIADR = 2)
      INTEGER AHIXCO
      PARAMETER (AHIXCO = 3)
      INTEGER AHIYCO
      PARAMETER (AHIYCO = 4)
      INTEGER AHIZCO
      PARAMETER (AHIZCO = 5)
      INTEGER AHIPPX
      PARAMETER (AHIPPX = 6)
      INTEGER AHIPPY
      PARAMETER (AHIPPY = 7)
      INTEGER AHIPPZ
      PARAMETER (AHIPPZ = 8)
      INTEGER AHITOF
      PARAMETER (AHITOF = 9)
      INTEGER AHIELO
      PARAMETER (AHIELO =10)
      INTEGER AHILEN
      PARAMETER (AHILEN =11)
      INTEGER QIHHDS
      PARAMETER (QIHHDS = 0)
      INTEGER QIHVRN
      PARAMETER (QIHVRN = 1)
      INTEGER QIHNRO
      PARAMETER (QIHNRO = 2)
      INTEGER QIHNCO
      PARAMETER (QIHNCO = 3)
      INTEGER QIHPTY
      PARAMETER (QIHPTY = 0)
      INTEGER QIHTRA
      PARAMETER (QIHTRA = 1)
      INTEGER QIHADR
      PARAMETER (QIHADR = 2)
      INTEGER QIHXCO
      PARAMETER (QIHXCO = 3)
      INTEGER QIHYCO
      PARAMETER (QIHYCO = 4)
      INTEGER QIHZCO
      PARAMETER (QIHZCO = 5)
      INTEGER QIHPPX
      PARAMETER (QIHPPX = 6)
      INTEGER QIHPPY
      PARAMETER (QIHPPY = 7)
      INTEGER QIHPPZ
      PARAMETER (QIHPPZ = 8)
      INTEGER QIHTOF
      PARAMETER (QIHTOF = 9)
      INTEGER QIHELO
      PARAMETER (QIHELO =10)
      INTEGER QIHLEN
      PARAMETER (QIHLEN =11)
      INTEGER QHIHDS
      PARAMETER (QHIHDS = 0)
      INTEGER QHIVRN
      PARAMETER (QHIVRN = 1)
      INTEGER QHINRO
      PARAMETER (QHINRO = 2)
      INTEGER QHINCO
      PARAMETER (QHINCO = 3)
      INTEGER QHIPTY
      PARAMETER (QHIPTY = 0)
      INTEGER QHITRA
      PARAMETER (QHITRA = 1)
      INTEGER QHIADR
      PARAMETER (QHIADR = 2)
      INTEGER QHIXCO
      PARAMETER (QHIXCO = 3)
      INTEGER QHIYCO
      PARAMETER (QHIYCO = 4)
      INTEGER QHIZCO
      PARAMETER (QHIZCO = 5)
      INTEGER QHIPPX
      PARAMETER (QHIPPX = 6)
      INTEGER QHIPPY
      PARAMETER (QHIPPY = 7)
      INTEGER QHIPPZ
      PARAMETER (QHIPPZ = 8)
      INTEGER QHITOF
      PARAMETER (QHITOF = 9)
      INTEGER QHIELO
      PARAMETER (QHIELO =10)
      INTEGER QHILEN
      PARAMETER (QHILEN =11)
      INTEGER DTCHDS
      PARAMETER (DTCHDS = 0)
      INTEGER DTCVRN
      PARAMETER (DTCVRN = 1)
      INTEGER DTCNRO
      PARAMETER (DTCNRO = 2)
      INTEGER DTCNCO
      PARAMETER (DTCNCO = 3)
      INTEGER DTCCOL
      PARAMETER (DTCCOL = 4)
      INTEGER DTCADR
      PARAMETER (DTCADR = 0)
      INTEGER DTCTIM
      PARAMETER (DTCTIM = 1)
      INTEGER DTCCHA
      PARAMETER (DTCCHA = 2)
      INTEGER DTKHDS
      PARAMETER (DTKHDS = 0)
      INTEGER DTKVRN
      PARAMETER (DTKVRN = 1)
      INTEGER DTKNRO
      PARAMETER (DTKNRO = 2)
      INTEGER DTKNTR
      PARAMETER (DTKNTR = 0)
      INTEGER DTKADR
      PARAMETER (DTKADR = 1)
      INTEGER DTHHDS
      PARAMETER (DTHHDS = 0)
      INTEGER DTHVRN
      PARAMETER (DTHVRN = 1)
      INTEGER DTHNRO
      PARAMETER (DTHNRO = 2)
      INTEGER DTHNHI
      PARAMETER (DTHNHI = 0)
      INTEGER DHNHDS
      PARAMETER (DHNHDS = 0)
      INTEGER DHNVRN
      PARAMETER (DHNVRN = 1)
      INTEGER DHNNRO
      PARAMETER (DHNNRO = 2)
      INTEGER DHNNHI
      PARAMETER (DHNNHI = 0)
      INTEGER CELHDS
      PARAMETER (CELHDS = 0)
      INTEGER CELVRN
      PARAMETER (CELVRN = 1)
      INTEGER CELCAL
      PARAMETER (CELCAL = 2)
      INTEGER CELNRO
      PARAMETER (CELNRO = 3)
      INTEGER CELNCO
      PARAMETER (CELNCO = 4)
      INTEGER CELADR
      PARAMETER (CELADR = 0)
      INTEGER CELEA
      PARAMETER (CELEA = 1)
      INTEGER CELEB
      PARAMETER (CELEB = 2)
      INTEGER CELTA
      PARAMETER (CELTA = 3)
      INTEGER CELTB
      PARAMETER (CELTB = 4)
      INTEGER CEKHDS
      PARAMETER (CEKHDS = 0)
      INTEGER CEKVRN
      PARAMETER (CEKVRN = 1)
      INTEGER CEKNRO
      PARAMETER (CEKNRO = 2)
      INTEGER CEKNTR
      PARAMETER (CEKNTR = 0)
      INTEGER CEKADR
      PARAMETER (CEKADR = 1)
      INTEGER CHNHDS
      PARAMETER (CHNHDS = 0)
      INTEGER CHNVRN
      PARAMETER (CHNVRN = 1)
      INTEGER CHNNRO
      PARAMETER (CHNNRO = 2)
      INTEGER CHNNHI
      PARAMETER (CHNNHI = 0)
      INTEGER DTDHDS
      PARAMETER (DTDHDS = 0)
      INTEGER DTDVRN
      PARAMETER (DTDVRN = 1)
      INTEGER DTDNRO
      PARAMETER (DTDNRO = 2)
      INTEGER DTDNCO
      PARAMETER (DTDNCO = 3)
      INTEGER DTDZES
      PARAMETER (DTDZES = 4)
      INTEGER DTDADR
      PARAMETER (DTDADR = 0)
      INTEGER DADHDS
      PARAMETER (DADHDS = 0)
      INTEGER DADVRN
      PARAMETER (DADVRN = 1)
      INTEGER DADNRO
      PARAMETER (DADNRO = 2)
      INTEGER DADNCO
      PARAMETER (DADNCO = 3)
      INTEGER DADPES
      PARAMETER (DADPES = 4)
      INTEGER DADADR
      PARAMETER (DADADR = 0)
      INTEGER CTDHDS
      PARAMETER (CTDHDS = 0)
      INTEGER CTDVRN
      PARAMETER (CTDVRN = 1)
      INTEGER CTDNRO
      PARAMETER (CTDNRO = 2)
      INTEGER CTDNCO
      PARAMETER (CTDNCO = 3)
      INTEGER CTDADR
      PARAMETER (CTDADR = 0)
      INTEGER CADHDS
      PARAMETER (CADHDS = 0)
      INTEGER CADVRN
      PARAMETER (CADVRN = 1)
      INTEGER CADNRO
      PARAMETER (CADNRO = 2)
      INTEGER CADNCO
      PARAMETER (CADNCO = 3)
      INTEGER CADADR
      PARAMETER (CADADR = 0)
C$$Include 'maxstructdim.inc'
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
C== Include /kloe/soft/off/offline/inc/development/trg/maxtrgchan.cin ==
      integer maxtrgchan
      parameter (maxtrgchan=300)
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
C== Include /kloe/soft/off/offline/inc/development/tls/evtstruct.cin ===
        TYPE EventInfo
        SEQUENCE
          INTEGER RunNumber
          INTEGER EventNumber
          INTEGER McFlag
          INTEGER EvFlag
          INTEGER Pileup
          INTEGER GenCod
          INTEGER PhiDecay
          INTEGER A1type
          INTEGER A2type
          INTEGER A3type
          INTEGER B1type
          INTEGER B2type
          INTEGER B3type
          INTEGER T3DOWN
          INTEGER T3FLAG
          REAL ECAP(2)
          REAL DCNOISE(4)
        END TYPE
        Integer len_eventinfostru
        Parameter (len_eventinfostru=21)
        TYPE (EventInfo) INFO
C= Include /kloe/soft/off/offline/inc/development/tls/geanfistruct.cin =
        TYPE GeanfiInformation
         SEQUENCE
         INTEGER Ntrk
         INTEGER kin(maxNtrkGen)
         INTEGER Pid(MaxNtrkGen)
         INTEGER virmom(maxNtrkGen)
         INTEGER Indv(MaxNtrkGen)
         REAL    Px(MaxNtrkGen)
         REAL    Py(MaxNtrkGen)
         REAL    Pz(MaxNtrkGen)
         REAL    Xcv(MaxNtrkGen)
         REAL    ycv(MaxNtrkGen)
         REAL    zcv(MaxNtrkGen)
         REAL    tofcv(MaxNtrkGen)
         REAL    Theta(MaxNtrkGen)
         REAL    Phi(MaxNtrkGen)
         INTEGER ndchmc (MaxNtrkGen)
         INTEGER nlaymc (MaxNtrkGen)
         INTEGER TrkFlag(MaxNtrkGen)
         REAL    Tofmc  (MaxNtrkGen)
         REAL    TrkLen (MaxNtrkGen)
         REAL    xfhmc(MaxNtrkGen)
         REAL    yfhmc(MaxNtrkGen)
         REAL    zfhmc(MaxNtrkGen)
         REAL    pxfhmc(MaxNtrkGen)
         REAL    pyfhmc(MaxNtrkGen)
         REAL    pzfhmc(MaxNtrkGen)
         REAL    xlhmc(MaxNtrkGen)
         REAL    ylhmc(MaxNtrkGen)
         REAL    zlhmc(MaxNtrkGen)
         REAL    pxlhmc(MaxNtrkGen)
         REAL    pylhmc(MaxNtrkGen)
         REAL    pzlhmc(MaxNtrkGen)
         INTEGER NumVtx
         INTEGER Kinmom(MaxNvtxGen)
         INTEGER mother(MaxNvtxGen)
         REAL    Tof(MaxNvtxGen)
         REAL    Xv(MaxNvtxGen)
         REAL    Yv(MaxNvtxGen)
         REAL    Zv(MaxNvtxGen)
         REAL    TrkVtx(MaxNvtxGen)
        END TYPE
        TYPE( GeanfiInformation) MC
C=== Include /kloe/soft/off/offline/inc/development/tls/vtxstru.cin ====
        TYPE Vertex
         SEQUENCE
         INTEGER n
         INTEGER Ntrk(MaxNumvtx)
         REAL    X(MaxNumVtx)
         REAL    Y(MaxNumVtx)
         REAL    Z(MaxNumVtx)
         REAL    COV1(MaxNumVtx)
         REAL    COV2(MaxNumVtx)
         REAL    COV3(MaxNumVtx)
         REAL    COV4(MaxNumVtx)
         REAL    COV5(MaxNumVtx)
         REAL    COV6(MaxNumVtx)
         REAL    CHI2(MaxNumVtx)
         INTEGER QUAL(MaxNumVtx)
         INTEGER FITID(MaxNumVtx)
        END TYPE
        TYPE (Vertex) VTX
        TYPE TracksVertex
         SEQUENCE
         INTEGER n
         INTEGER iv(MaxNumtrkv)
         INTEGER TrkPoi(MaxNumtrkv)
         REAL    cur(MaxNumtrkv)
         REAL    phi(MaxNumtrkv)
         REAL    cot(MaxNumtrkv)
         REAL    px(MaxNumtrkv)
         REAL    py(MaxNumtrkv)
         REAL    pz(MaxNumtrkv)
         REAL    pmod(MaxNumtrkv)
         REAL    Length(MaxNumtrkv)
         REAL    CHI2(MaxNumTrkV)
         INTEGER ipid(MaxNumtrkv)
         REAL cov11(MaxNumTrkV)
         REAL cov12(MaxNumTrkV)
         REAL cov13(MaxNumTrkV)
         REAL cov22(MaxNumTrkV)
         REAL cov23(MaxNumTrkV)
         REAL cov33(MaxNumTrkV)
        END TYPE
        TYPE (TracksVertex) TRKV
C== Include /kloe/soft/off/offline/inc/development/tls/celestruct.cin ==
      TYPE  EmcCells
        sequence
         INTEGER n
         INTEGER nmc
         INTEGER ICL(NeleCluMax)
         INTEGER ibcel(NeleCluMax)
         INTEGER DET(NeleCluMax)
         INTEGER WED(NeleCluMax)
         INTEGER PLA(NeleCluMax)
         INTEGER COL(NeleCluMax)
         REAL    E(NeleCluMax)
         REAL    T(NeleCluMax)
         REAL    X(NeleCluMax)
         REAL    Y(NeleCluMax)
         REAL    Z(NeleCluMax)
         REAL    EA(NeleCluMax)
         REAL    TA(NeleCluMax)
         REAL    EB(NeleCluMax)
         REAL    TB(NeleCluMax)
         REAL    Etrue(NeleCluMax)
         REAL    Ttrue(NeleCluMax)
         REAL    Xtrue(NeleCluMax)
         REAL    Ytrue(NeleCluMax)
         REAL    Ztrue(NeleCluMax)
         INTEGER ptyp (neleclumax)
         INTEGER knum (neleclumax)
         INTEGER numpar(neleclumax)
      END TYPE
      TYPE (EmcCells) CELE
C=== Include /kloe/soft/off/offline/inc/development/tls/trkstru.cin ====
        TYPE AllTracks
        SEQUENCE
         INTEGER n
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
         REAL    SigPCA(MaxNumTrk)
         REAL    SigZeta(MaxNumTrk)
         REAL    SigCurv(MaxNumTrk)
         REAL    SigCot(MaxNumTrk)
         REAL    SigPhi(MaxNumTrk)
         INTEGER NMSkink(MaxNumTrk)
        END TYPE
        TYPE (AllTracks) TRK
        TYPE AllTracksMC
        SEQUENCE
         INTEGER n
         INTEGER ncontr(MaxNumTrk)
         INTEGER kine1(MaxNumTrk)
         INTEGER type1(MaxNumTrk)
         INTEGER hits1(MaxNumTrk)
         INTEGER kine2(MaxNumTrk)
         INTEGER type2(MaxNumTrk)
         INTEGER hits2(MaxNumTrk)
         INTEGER kine3(MaxNumTrk)
         INTEGER type3(MaxNumTrk)
         INTEGER hits3(MaxNumTrk)
         REAL xfirst(MaxNumTrk)
         REAL yfirst(MaxNumTrk)
         REAL zfirst(MaxNumTrk)
         REAL pxfirst(MaxNumTrk)
         REAL pyfirst(MaxNumTrk)
         REAL pzfirst(MaxNumTrk)
         REAL xlast(MaxNumTrk)
         REAL ylast(MaxNumTrk)
         REAL zlast(MaxNumTrk)
         REAL pxlast(MaxNumTrk)
         REAL pylast(MaxNumTrk)
         REAL pzlast(MaxNumTrk)
         REAL xmcfirst(MaxNumTrk)
         REAL ymcfirst(MaxNumTrk)
         REAL zmcfirst(MaxNumTrk)
         REAL pxmcfirst(MaxNumTrk)
         REAL pymcfirst(MaxNumTrk)
         REAL pzmcfirst(MaxNumTrk)
         REAL xmclast(MaxNumTrk)
         REAL ymclast(MaxNumTrk)
         REAL zmclast(MaxNumTrk)
         REAL pxmclast(MaxNumTrk)
         REAL pymclast(MaxNumTrk)
         REAL pzmclast(MaxNumTrk)
        END TYPE
        TYPE (AllTracksMC) TRKMC
C= Include /kloe/soft/off/offline/inc/development/tls/dprs_struct.cin ==
      Integer           MAX_DPRS
      Parameter        (MAX_DPRS = 200)
      Type DPRS_TYPE
        Sequence
        Integer
     &      NDPRS,
     &      NVIEW(3)
        Integer
     &      IDPRS(MAX_DPRS),
     &      VERS(MAX_DPRS),
     &      NPOS(MAX_DPRS),
     &      NNEG(MAX_DPRS)
        Real
     &      XPCA(MAX_DPRS),
     &      YPCA(MAX_DPRS),
     &      ZPCA(MAX_DPRS),
     &      XLST(MAX_DPRS),
     &      YLST(MAX_DPRS),
     &      ZLST(MAX_DPRS),
     &      CURP(MAX_DPRS),
     &      PHIP(MAX_DPRS),
     &      COTP(MAX_DPRS),
     &      QUAL(MAX_DPRS)
        Integer
     &      IPFL(MAX_DPRS),
     &      KINE(MAX_DPRS),
     &      NHKINE(MAX_DPRS)
      End Type
      TYPE (DPRS_TYPE)
     &    DPRS
      Character*(*)     DPRS_NTP_STR
      Parameter        (DPRS_NTP_STR =
     &    'nDPRS[0,200]:U,'//
     &    'nView(3):U:8,'//
     &    'iDPRS(nDPRS):U:8,'//
     &    'DPRSver(nDPRS):U:8,'//
     &    'nPos(nDPRS):U:8,'//
     &    'nNeg(nDPRS):U:8,'//
     &    'xPCA(nDPRS):R,'//
     &    'yPCA(nDPRS):R,'//
     &    'zPCA(nDPRS):R,'//
     &    'xLst(nDPRS):R,'//
     &    'yLst(nDPRS):R,'//
     &    'zLst(nDPRS):R,'//
     &    'curP(nDPRS):R,'//
     &    'phiP(nDPRS):R,'//
     &    'cotP(nDPRS):R,'//
     &    'qual(nDPRS):R,'//
     &    'IPFl(nDPRS):U:4,'//
     &    'prKINE(nDPRS):U:8,'//
     &    'prKHIT(nDPRS):U:8')
C=== Include /kloe/soft/off/offline/inc/development/tls/dhspstru.cin ===
        TYPE AllDCDhsp
         SEQUENCE
         INTEGER numDHSP
         INTEGER itrk(MaxNumDHSP)
         INTEGER layer(MaxNumDHSP)      
         INTEGER wire(MaxNumDHSP)
         REAL    time(MaxNumDHSP)
         REAL    drift(MaxNumDHSP)
         REAL    res(MaxNumDHSP)
         REAL    x(MaxNumDHSP)
         REAL    y(MaxNumDHSP)
         REAL    z(MaxNumDHSP)
        END TYPE
        TYPE (AllDCDhsp) DHSPSTRU
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
C== Include /kloe/soft/off/offline/inc/development/tls/cfhistruct.cin ==
        TYPE emcfirsthit
        SEQUENCE
        integer n
        integer pid(maxnumfirsthit)
        integer kinum(maxnumfirsthit)
        integer celadr(maxnumfirsthit)
        integer convfl(maxnumfirsthit)
        real    time(maxnumfirsthit)
        real    x(maxnumfirsthit)
        real    y(maxnumfirsthit)
        real    z(maxnumfirsthit)
        real    px(maxnumfirsthit)
        real    py(maxnumfirsthit)
        real    pz(maxnumfirsthit)
        real    tof(maxnumfirsthit)
        real    tlen(maxnumfirsthit)
        END TYPE
        TYPE (emcfirsthit) cfhi
C== Include /kloe/soft/off/offline/inc/development/tls/qihistruct.cin ==
        TYPE QcalHits
          SEQUENCE
                integer  N
                integer  PTY (nqihimax)
                integer  ADD (nqihimax)
                integer  KINE(nqihimax)
                real     X   (nqihimax)
                real     Y   (nqihimax)
                real     Z   (nqihimax)
                real     PX  (nqihimax)
                real     PY  (nqihimax)
                real     PZ  (nqihimax)
                real     TOF (nqihimax)
                real     ENE (nqihimax)
                real     TRL (nqihimax)
        END TYPE
        TYPE (QcalHits) QHIT
C== Include /kloe/soft/off/offline/inc/development/tls/qcalstruct.cin ==
        TYPE QcalEle
        SEQUENCE
           integer n
           integer wed(nqcalmax)
           integer det(nqcalmax)
           real    E  (nqcalmax)
           real    T  (nqcalmax)
        END TYPE
        TYPE (QcalEle) QELE
        TYPE QcalRealHit
        SEQUENCE
           integer n
           real ene (nqcalmax)
           real x   (nqcalmax)
           real y   (nqcalmax)
           real z   (nqcalmax)
           real t   (nqcalmax)
        END TYPE
        TYPE (QcalRealHit) QCAL
C== Include /kloe/soft/off/offline/inc/development/trg/telestruct.cin ==
      TYPE trgELE
      sequence
         integer ntele
         integer sector(maxtrgchan)  
         integer det(maxtrgchan)
         integer serkind(maxtrgchan)
         real Ea(maxtrgchan)    
         real Eb(maxtrgchan)    
         real Ta(maxtrgchan)    
         real Tb(maxtrgchan)    
         integer bitp(maxtrgchan)  
      end type
      type(trgELE) TELE
C= Include /kloe/soft/off/offline/inc/development/trg/pizzastruct.cin ==
      TYPE pizzastruct
      sequence
         integer npizza
         integer sector(maxtrgchan)  
         integer det(maxtrgchan)
         integer serkind(maxtrgchan)
         real Ea(maxtrgchan)    
         real Eb(maxtrgchan)    
         real E_rec(maxtrgchan)
         real Z_mod(maxtrgchan)
      end type
      type(pizzastruct) PIZZA
C= Include /kloe/soft/off/offline/inc/development/tls/preclustruct.cin =
        TYPE EmcPreCluster      
         SEQUENCE
         INTEGER n
         REAL    E(MaxNumCLu)
         REAL    X(MaxNumCLu)
         REAL    Y(MaxNumCLu)
         REAL    Z(MaxNumCLu)
         REAL    T(MaxNumCLu)
         REAL    TA(MaxNumCLu)
         REAL    TB(MaxNumCLu)
         REAL    TrmsA(MaxNumCLu)
         REAL    TrmsB(MaxNumCLu)
         INTEGER Flag (MaxNumCLu)
        END TYPE
        TYPE (EmcPreCluster) PRECLU
C=== Include /kloe/soft/off/offline/inc/development/tls/nvostru.cin ====
      INTEGER MaxNumKNVO
      PARAMETER (MaxNumKNVO = 40)       
      TYPE KNVOStru
      SEQUENCE
      integer n                
      integer iknvo(MaxNumKNVO) 
      real    px(MaxNumKNVO)   
      real    py(MaxNumKNVO)
      real    pz(MaxNumKNVO)
      integer pid(MaxNumKNVO)  
      integer bank(MaxNumKNVO) 
      integer vlinked(MaxNumKNVO) 
      END TYPE
      TYPE (KNVOStru) KNVO
      INTEGER MaxNumVNVO
      PARAMETER (MaxNumVNVO = 40)       
      TYPE VNVOStru
      SEQUENCE
      integer n                 
      integer ivnvo(MaxNumVNVO) 
      real vx(MaxNumVNVO)  
      real vy(MaxNumVNVO)
      real vz(MaxNumVNVO)
      integer kori(MaxNumVNVO) 
      integer idvfs(MaxNumVNVO) 
      integer nknv(MaxNumVNVO) 
      integer fknv(MaxNumVNVO) 
      END TYPE
      TYPE (VNVOStru) VNVO
      INTEGER MaxNumVNVOb
      PARAMETER (MaxNumVNVOb = 40)      
      TYPE VNVBStru
      SEQUENCE
      integer n                 
      integer ibank(MaxNumVNVOb) 
      END TYPE
      TYPE (VNVBStru) VNVB
      INTEGER MaxNumINVO
      PARAMETER (MaxNumINVO = 40)       
      TYPE INVOStru
      SEQUENCE
      integer n                 
      integer iinvo(MaxNumINVO) 
      integer iclps(MaxNumINVO) 
      real xi(MaxNumINVO)     
      real yi(MaxNumINVO)
      real zi(MaxNumINVO)
      real ti(MaxNumINVO)     
      real lk(MaxNumINVO)     
      real sigmalk(MaxNumINVO) 
      END TYPE
      TYPE (INVOStru) INVO
C=== Include /kloe/soft/off/offline/inc/development/tls/eclostru.cin ===
      INTEGER MaxNumCLINF
      PARAMETER (MaxNumCLINF = 100)     
      TYPE ECLOStru
        SEQUENCE
          INTEGER  n
          INTEGER  TotWord(MaxNumCLINF)
          INTEGER  idpart(MaxNumCLINF)
          INTEGER  dtclpo(MaxNumCLINF)
          INTEGER  dvvnpo(MaxNumCLINF)
          INTEGER  stre(MaxNumCLINF)
          INTEGER  algo(MaxNumCLINF)
          INTEGER  n2
          INTEGER  TotWord2(MaxNumCLINF)
          INTEGER  idpart2(MaxNumCLINF)
          INTEGER  dtclpo2(MaxNumCLINF)
          INTEGER  dvvnpo2(MaxNumCLINF)
          INTEGER  stre2(MaxNumCLINF)
          INTEGER  algo2(MaxNumCLINF)
        END TYPE
      TYPE (ECLOStru) CLINF
C=== Include /kloe/soft/off/offline/inc/development/tls/t0struct.cin ===
      TYPE t0struct
        SEQUENCE
          REAL     dc_step0
          REAL     hit_step0
          REAL     clus_step0
          REAL     step1
          REAL     cable
          REAL     tbunch
          REAL     tphased_mc
        END TYPE
      TYPE (t0struct) T0STRU
C== Include /kloe/soft/off/offline/inc/development/tls/cwrkstruct.cin ==
      TYPE  EmcHits
        sequence
         INTEGER n
         INTEGER add  (NeleCluMax)
         INTEGER cele (NeleCluMax)
         INTEGER icl  (NeleCluMax)
         INTEGER Nhit (NeleCluMax)
         INTEGER Kine (NeleCluMax)
         REAL    E(NeleCluMax)
         REAL    T(NeleCluMax)
         REAL    X(NeleCluMax)
         REAL    Y(NeleCluMax)
         REAL    Z(NeleCluMax)
      END TYPE
      TYPE (EmcHits) CWRK
C=== Include /kloe/soft/off/offline/inc/development/tls/tellina.cin ====
      TYPE tele_short
      sequence
         integer n
         integer add(maxtrgchan)  
         real Ea(maxtrgchan)    
         real Eb(maxtrgchan)    
         real Ta(maxtrgchan)    
         real Tb(maxtrgchan)    
         integer bitp(maxtrgchan)  
      end type
      type(tele_short) TELLINA
C=== Include /kloe/soft/off/offline/inc/development/tls/pizzetta.cin ===
      TYPE pizza_short
      sequence
         integer n
         integer add(maxtrgchan)
         real Ea(maxtrgchan)    
         real Eb(maxtrgchan)    
         real E_rec(maxtrgchan)
         real Z_mod(maxtrgchan)
      end type
      type(pizza_short) PIZZETTA
C== Include /kloe/soft/off/offline/inc/development/trg/trgstruct.cin ===
      integer NSLAYER
      parameter(NSLAYER=10)
      TYPE triggerstruct
      sequence
        real    tspent
        real    tdead
        integer type
        integer bphi
        integer ephi
        integer wphi
        integer bbha
        integer ebha
        integer wbha
        integer bcos
        integer ecos
        integer wcos
        integer e1w1_dwn
        integer b1_dwn
        integer t0d_dwn
        integer vetocos
        integer vetobha
        integer bdw
        integer rephasing
        integer tdc1_pht1
        integer dt2_t1
        integer fiducial
        integer t1c
        integer t1d
        integer t2d
        integer tcr
        integer tcaf_tcrd
        integer tcaf_t2d
        integer moka_t2d
        integer moka_t2dsl(NSLAYER)
      end type
      type(triggerstruct) TRG
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
C== Include /kloe/soft/off/offline/inc/development/tls/gdchitstru.cin ==
      TYPE gdchitStru
      SEQUENCE
      INTEGER  nhit
      INTEGER  nhpr
      INTEGER  nhtf
      END TYPE
      TYPE (gdchitStru) ghit
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
C=== Include /kloe/soft/off/offline/inc/development/tls/trkqstru.cin ===
      INTEGER MaxNumTrkQ
      PARAMETER (MaxNumTrkQ = 100)
        TYPE AllTracksQ
        SEQUENCE
        INTEGER  flagqt                 
         REAL    dist                   
         INTEGER n                      
         REAL    Xi(2,MaxNumTrkQ)       
         REAL    Yi(2,MaxNumTrkQ)       
         REAL    Zi(2,MaxNumTrkQ)       
         INTEGER det(2,MaxNumTrkQ)      
         INTEGER wed(2,MaxNumTrkQ)      
         INTEGER Fnearest(2,MaxNumTrkQ) 
         INTEGER Ferror(MaxNumTrkQ)     
         INTEGER Fqhit(2,MaxNumTrkQ)    
         INTEGER FqhitRAW(MaxNumTrkQ)   
         REAL    PHYabs(2,MaxNumTrkQ)   
         REAL    PHYrel(2,MaxNumTrkQ)   
         REAL    theta(MaxNumTrkQ)      
         INTEGER itrk(MaxNumTrkQ)       
      END TYPE
      TYPE (AllTracksQ) TRKQ
C== Include /kloe/soft/off/offline/inc/development/tls/dtcestruct.cin ==
      Type DChits
        Sequence
        Integer nDTCE
        Integer nSmall
        Integer iLayerDTCE(nMaxDC)
        Integer iWireDTCE(nMaxDC)
        Real    tDTCE(nMaxDC)
      End Type
      Type (DChits) DTCE
C== Include /kloe/soft/off/offline/inc/development/tls/dhrestruct.cin ==
      Type DCdrift
        Sequence
        Integer nDHRE
        Integer iLayerDHRE(nMaxDC)
        Integer iWireDHRE(nMaxDC)
        Real    rDHRE(nMaxDC)
        Real    eDHRE(nMaxDC)
        Integer iTrkDHRE(nMaxDC)
      End Type
      Type (DCdrift) DHRE
C= Include /kloe/soft/off/offline/inc/development/tls/sec2clustru.cin ==
      Type Sector
        Sequence
        Integer Nsect
        Integer Nsect_noclu
        Integer Nsect_clu
        Integer NocluAdd(MaxNumClu) 
        Integer nclus               
        Integer NNorm(MaxNumClu)    
        Integer Nover(MaxNumclu)
        Integer Ncosm(MaxNumclu)
        Integer NormAdd(MaxNumClu)  
        Integer OverAdd(MaxNumClu)  
        Integer CosmAdd(MaxNumClu)  
      End Type
      Type (Sector) S2CLU
C== Include /kloe/soft/off/offline/inc/development/tls/cspsstruct.cin ==
      INTEGER NhitCluMax
      PARAMETER (NhitCluMax = 2000 )
      Type EmcSpacePoints
        Sequence
        Integer Ncel
        Integer Nclu
        Integer Iclu(NhitCluMax)
        Integer Icel(NhitCluMax)
        Integer Ibcel(NhitCluMax)
        Integer Flag(NhitCluMax)
        Integer Add (NhitCluMax)
        Integer Nhit(NhitCluMax)
        Real    TA  (NhitCluMax)
        Real    TB  (NhitCluMax)
        Real    Ea  (NhitCluMax)
        Real    Eb  (NhitCluMax)
        Real    T   (NhitCluMax)
        Real    E   (NhitCluMax)
        Real    X   (NhitCluMax)
        Real    Y   (NhitCluMax)
        Real    Z   (NhitCluMax)
      End Type
      Type (EmcSpacePoints) CSPS
      TYPE  EmcMCSpacePoints
        sequence
          Integer Ncel
          Integer Nclu
          Integer IHit(NhitCluMax)
          Integer Nhit(NhitCluMax)
          Integer knum(NhitCluMax)
          Real    X(NhitCluMax)
          Real    Y(NhitCluMax)
          Real    Z(NhitCluMax)
          Real    T(NhitCluMax)
          Real    E(NhitCluMax)
      END TYPE
      TYPE (EmcMCSpacePoints) CSPSMC
C== Include /kloe/soft/off/offline/inc/development/tls/cluostruct.cin ==
      INTEGER NcluoMax
      PARAMETER (NcluoMax = 100 )
      Type EmcCluObjects
        Sequence
        Integer N
        Integer Ncel(NcluoMax)
        Real    Flag(NcluoMax)
        Real    Chi2(NcluoMax)
        Real    Like(NcluoMax)
        Real    E   (NcluoMax)
        Real    X   (NcluoMax)
        Real    Y   (NcluoMax)
        Real    Z   (NcluoMax)
        Real    T   (NcluoMax)
      End Type
      Type (EmcCluObjects) CLUO
C= Include /kloe/soft/off/offline/inc/development/tls/cluomcstruct.cin =
      INTEGER NMCcluoMax
      PARAMETER (NMCcluoMax = 100 )
      Type EmcMCCluObjects
        Sequence
        Integer Npar
        Integer Nclu
        Integer Ncel(NMCcluoMax)
        Integer Iclu(NMCcluoMax)
        Integer Kine(NMCcluoMax)
        REAL    E   (NMCcluoMax)
        REAL    X   (NMCcluoMax)
        REAL    Y   (NMCcluoMax)
        REAL    Z   (NMCcluoMax)
        REAL    T   (NMCcluoMax)
      End Type
      Type (EmcMCCluObjects) CLUOMC
C== Include /kloe/soft/off/offline/inc/development/tls/dhitstruct.cin ==
      INTEGER maxnumdhit
      parameter (maxnumdhit = 2500)
      TYPE mcdc_dhit
        SEQUENCE
         integer n
         integer pid(maxnumdhit)
         integer kinum(maxnumdhit)
         integer celadr(maxnumdhit)
         real    x(maxnumdhit)
         real    y(maxnumdhit)
         real    z(maxnumdhit)
         real    px(maxnumdhit)
         real    py(maxnumdhit)
         real    pz(maxnumdhit)
         real    time(maxnumdhit)
         real    dedx(maxnumdhit)
         real    tlen(maxnumdhit)
         real    dtime(maxnumdhit)
         real    dfromw(maxnumdhit)
         integer flag(maxnumdhit)
      END TYPE
      TYPE (mcdc_dhit) dhit
C== Include /kloe/soft/off/offline/inc/development/tls/dedx2stru.cin ===
       INTEGER  MAXNUMEROADC
       PARAMETER(MAXNUMEROADC = 200)
       INTEGER  MAXNUMTRACCE
       PARAMETER(MAXNUMTRACCE = 20)
       Type DEDX2STRUstruct
        SEQUENCE
        integer numdedx
        integer numeroadc(MaxNumTRACCE)
        integer indicededx(MaxNumTRACCE)
        INTEGER whw1(MAXNUMEROADC,MAXNUMTRACCE)
        INTEGER whw2(MAXNUMEROADC,MAXNUMTRACCE)
        INTEGER Lay(MAXNUMEROADC,MAXNUMTRACCE)
        INTEGER Wir1(MAXNUMEROADC,MAXNUMTRACCE)
        INTEGER Wir2(MAXNUMEROADC,MAXNUMTRACCE)
        INTEGER Was1(MAXNUMEROADC,MAXNUMTRACCE)
        INTEGER Was2(MAXNUMEROADC,MAXNUMTRACCE)
        REAL    step(MAXNUMEROADC,MAXNUMTRACCE)
        REAL    effs(MAXNUMEROADC,MAXNUMTRACCE)
        REAL    Tim1(MAXNUMEROADC,MAXNUMTRACCE)
        REAL    Tim2(MAXNUMEROADC,MAXNUMTRACCE)
        REAL    carica(MAXNUMEROADC,MAXNUMTRACCE)
       end Type
       type(dedx2strustruct) DEDX2STRU
C= Include /kloe/soft/off/offline/inc/development/tls/eleqcaltstru.cin =
      INTEGER     MaxQCALTChan
      PARAMETER ( MaxQCALTChan = 1920 ) 
      INTEGER     MaxQCALTHits
      PARAMETER ( MaxQCALTHits = 5)
      TYPE  QCALTStructure
      SEQUENCE
      INTEGER Nele
      INTEGER Nhit(MaxQCALTChan)
      INTEGER Addr(MaxQCALTChan)
      INTEGER Qdet(MaxQCALTChan)
      INTEGER Qmod(MaxQCALTChan)
      INTEGER Qpla(MaxQCALTChan)
      INTEGER Qtil(MaxQCALTChan)
      REAL    Time(MaxQCALTChan,MaxQCALTHits)
      END TYPE
C$$INCLUDE 'K$ITLS:qcalthitstru.cin' !QCALT hit Struc
C= Include /kloe/soft/off/offline/inc/development/tls/ele2hitqcalt.cin =
      INTEGER     RunN, EvtN
      INTEGER     NtuId
      INTEGER     MaxNChan
      PARAMETER ( MaxNChan = 1920 )
      INTEGER     MaxNHits
      PARAMETER ( MaxNHits = 5)
      TYPE  QHITStructure
      SEQUENCE
      INTEGER Nele
      INTEGER Nhit(MaxNChan)
      REAL X(MaxNChan)
      REAL Y(MaxNChan)
      REAL Z(MaxNChan)
      REAL Time(MaxNChan,MaxNHits)
      END TYPE
      TYPE (QHITStructure) QCALTHIT
      LOGICAL HitNtuBok
      COMMON /ELE2HITCom/ HitNtuBok,RunN,EvtN
C=== Include /kloe/soft/off/offline/inc/development/tls/ccaltnum.cin ===
        integer    CCALT_A,   CCALT_B                   
        parameter (CCALT_A=5, CCALT_B=6)
        integer    CCALT_CRY    
        parameter (CCALT_CRY=48)
        integer    CCALT_LAYMIN,   CCALT_LAYMAX
        parameter (CCALT_LAYMIN=1, CCALT_LAYMAX=2)
        integer    CCALT_COLMIN,CCALT_COLMAX            
        parameter (CCALT_COLMIN=1, CCALT_COLMAX=24)
        Integer    CCALTCHAN
        Parameter (CCALTCHAN=96)
C== Include /kloe/soft/off/offline/inc/development/tls/ccaltstru.cin ===
        TYPE  CCALTStructure
          SEQUENCE
           INTEGER NEle
           INTEGER Cry(CCALTChan)
           INTEGER Det(CCALTChan)
           INTEGER Col(CCALTChan)
           INTEGER Pla(CCALTChan)
           REAL    T(CCALTChan)
        END TYPE
        TYPE(CCALTStructure) CCALTStru
C== Include /kloe/soft/off/offline/inc/development/tls/letestruct.cin ==
      INTEGER     LETMaxCh
      PARAMETER ( LETMaxCh = 40)
        TYPE  LETEStr
          SEQUENCE
           INTEGER NEle
           INTEGER Calib
           INTEGER Cry(LETMaxCh)
           INTEGER Det(LETMaxCh)
           INTEGER Col(LETMaxCh)
           INTEGER Pla(LETMaxCh)
           REAL    E(LETMaxCh)
           REAL    T(LETMaxCh)
        END TYPE
        TYPE(LETEStr) LETE
C$$INCLUDE 'k$itls:raw2itce.cin'  ! IT Stru
C== Include /kloe/soft/off/offline/inc/development/tls/itcestruct.cin ==
        integer nmax_itce
        parameter (nmax_itce=25000)
        type itcestruct
        sequence
           integer nitce
           integer foil(nmax_itce)
           integer layer(nmax_itce)
           integer strip(nmax_itce)
           integer view(nmax_itce)
           integer inditkine(nmax_itce)
        end type
        type(itcestruct) itce
C=== Include /kloe/soft/off/offline/inc/development/tls/hetenum.cin ====
      Integer   HETECHAN
      Parameter (HETECHAN = 64)   
      Integer   MAXHITHET
      Parameter (MAXHITHET = 30)  
      Integer   TURNNUM
      Parameter (TURNNUM = 4)     
      Integer   MAXHETTDCVAL      
      Parameter (MAXHETTDCVAL = 1920)
C=== Include /kloe/soft/off/offline/inc/development/tls/hetestru.cin ===
      TYPE HETEStructure
        SEQUENCE
          INTEGER NHETDCs                    
          INTEGER HDet(MAXHETTDCVAL)         
          INTEGER HCol(MAXHETTDCVAL)         
          INTEGER nTurnHet(MAXHETTDCVAL)     
          REAL    TimeHet(MAXHETTDCVAL)      
      END TYPE
      TYPE (HETEStructure) HETE
C=== Include /kloe/soft/off/offline/inc/development/tls/prod2ntu.cin ===
        TYPE prod2ntu_Params
          SEQUENCE
                INTEGER NtId
                CHARACTER*80 NtTitle
        END TYPE
      INTEGER prod2ntu_NtId
      PARAMETER (prod2ntu_NtId = 1)
      CHARACTER*(*) prod2ntu_Title
      PARAMETER (prod2ntu_Title = 'prod')
        TYPE NtupleEvent
          SEQUENCE
            TYPE (EventInfo)         INFO
            TYPE (EmcCluster)        CLU
            TYPE (EmcCells)          CELE
            TYPE (Vertex)            VTX        
            TYPE (TracksVertex)      TRKV
            TYPE (AllTracks)         TRK
            TYPE (AllTracksMC)       TRKMC
            TYPE (DPRS_TYPE)         DPRS
            TYPE (TrackCluster)      TCLO
            TYPE (GeanfiInformation) MC
            TYPE (emcfirsthit)       CFHI
            TYPE (QcalHits)          QHIT
            TYPE (QcalEle)           QELE
            TYPE (QcalRealHit)       QCAL
            TYPE (AllDCDhsp)         DHSP
            TYPE (EmcPreCluster)     PRECLU
            TYPE (KNVOStru)          KNVO
            TYPE (VNVOStru)          VNVO
            TYPE (VNVBStru)          VNVB
            TYPE (INVOStru)          INVO
            TYPE (Eclostru)          ECLO
            TYPE (TrgEle)            TELE
            TYPE (pizzastruct)       PIZZA
            TYPE (t0struct)          T0STRU
            TYPE (EmcHits)           CWRK
            TYPE (pizza_short)       PIZZETTA
            TYPE (tele_short)        TELLINA
            TYPE (triggerstruct)     TRG
            TYPE (ECLSStru)          ECLS
            TYPE (gdchitStru)        GHIT
            TYPE (Bposition)         BPOS
            TYPE (AllTracksQ)        TRKQ
            TYPE (DChits)            DTCE
            TYPE (DCdrift)           DHRE
            TYPE (Sector)            S2CLU
            TYPE (EmcSpacePoints)    CSPS
            TYPE (EmcMCSpacePoints)  CSPSMC
            TYPE (EmcCluObjects)     CLUO
            TYPE (EmcMCCluObjects)   CLUOMC
            TYPE (Vertex)            VTXOLD     
            TYPE (TracksVertex)      TRKVOLD
            TYPE (AllTracks)         TRKOLD
            TYPE (AllTracksMC)       TRKMCOLD
            TYPE (TrackCluster)      TCLOLD
            TYPE (DEDX2STRUstruct)   DEDX2STRU
            TYPE (mcdc_dhit)         DHIT
            TYPE (QCALTStructure)    QCALT
            TYPE (CCALTStructure)    CCLE
            TYPE (LETEStr)           LETE
            TYPE(itcestruct)         ITCE
            TYPE(QHITStructure)      QCALTHIT
            TYPE(HETEStructure)      HETE
        END TYPE
        TYPE ( NtupleEvent) Evt
        TYPE (prod2ntu_Params) params
      COMMON /prod2ntu/ Evt,params
C Include /kloe/soft/off/offline/inc/development/tls/prod2ntu_talk.cin =
        logical CLUSFLAG,CELEFLAG,TRIGFLAG
        logical TRKSFLAG,TRKVFLAG,DPRSFLAG
        logical CFHIFLAG,TCLOFLAG
        logical QCALFLAG,GEANFIFLAG
        logical DHSPFLAG,TELEFLAG
        logical PRECLUSFLAG,NVOFLAG
        logical ECLOFLAG,T0FLAG
        logical CWRKFLAG, ENECORFLAG
        logical ECLSFLAG, GDCHITFG
        logical BPOSFLAG
        Logical dtceFlag,dtce0Flag,DCnHitsFlag,dhreFlag
        logical c2trFlag
        Logical BENEFLAG
        Logical CSPSFLAG,CSPSMCFLAG,CLUOFLAG
        logical TRKSOLDFLAG,TRKVOLDFLAG,TCLOLDFLAG
        logical DHITFLAG,DEDXFLAG
        logical QCALTELEFLAG
        logical CCLEFLAG
        logical LETEFLAG
        logical ITCEFLAG
        logical HETEFLAG
        logical QCALTHITFLAG
        common /PRODMENU/CLUSFLAG,CELEFLAG,TRIGFLAG,TRKSFLAG,
     &  TRKVFLAG,DPRSFLAG,CFHIFLAG,QCALFLAG,TCLOFLAG,
     &  GEANFIFLAG,DHSPFLAG,TELEFLAG,PRECLUSFLAG,NVOFLAG,
     &  ECLOFLAG,T0FLAG,CWRKFLAG,ENECORFLAG,ECLSFLAG,GDCHITFG,
     &  BPOSFLAG,dtceFlag,dtce0Flag,DCnHitsFlag,dhreFlag,
     &  C2TRFLAG,BENEFLAG,CSPSFLAG,CSPSMCFLAG,CLUOFLAG,
     &  TRKSOLDFLAG,TRKVOLDFLAG,TCLOLDFLAG,DHITFLAG,DEDXFLAG,
     &  QCALTELEFLAG,CCLEFLAG,LETEFLAG,ITCEFLAG,HETEFLAG,
     &  QCALTHITFLAG
C-----------------------------------------------------------------------
      CHARACTER*(*) SubName
      PARAMETER (SubName = 'prod2ntu_ev')
      LOGICAL Analysis_Get_Hist_Active
      REAL    T0G_PHASED_DC, T0G_HIT_STEP0
      REAL    T0G_CLUSTER, T0G_STEP1
      REAL    DELTA_CAVI_CALO, BUNCH_PERIOD
      REAL    tphased_mc
      INTEGER istat, OldRunNumber
      data OldRunNumber/0/
      save OldRunNumber
      integer ind1,inddat
      Integer trgwrd1,trgwrd2,numdhit
      common /trgcom/trgwrd1,trgwrd2,numdhit
      LOGICAL mcflag_1
      INTEGER mcflag_tg
C
C ------------  External Functions ----------------
C
      INTEGER GETCLUSTRU,GETMCSTRU,GETCELESTRU,GETEVCL,GETCLUOSTRU
      INTEGER TRKV2STRU,GETTCLOSTRU,GETCFHISTRU,BLOCAT
      INTEGER ANGPAR, ParSet, GETQIHISTRU,GETQCALSTRU
      INTEGER GETQCAESTRU, GETDHSPSTRU
      INTEGER GETTELESTRU, GETPRECLUSTRU
      INTEGER GETPIZZASTRU, TPIE_UPK
      INTEGER pizza_reset,torta_reset,tele_reset
      Integer GET_DPRS_STRUCT,GETNVO
      Integer GETECLO,T0GLRD,GETCLUSTRUCORR
      INTEGER BIGEST,banknum, fillbposcommon
      INTEGER GETQCALTSTRU,getqcthstru,GETCCALTSTRU,getletestru,itce_upk
      INTEGER gethetestru, hete_dump
C
      INTEGER AlgoNum,StreamNum,TimeSec,TimeMusec,Ndtce,EventType
      integer icurr
      real    currpos,currele,luminosity
      COMMON /EventInfo/StreamNum,AlgoNum,
     &     TimeSec,TimeMusec,Ndtce,mcflag_tg,currpos,currele,luminosity
      INTEGER GETECLS,GETTIME,GETPIZZETTA
      INTEGER GETTELLINA,GETCWRKSTRU,GETTRIGGER,TRKQ2STRU
      INTEGER Ncwrkhit,j
      REAL Rstat,getbpos
      INTEGER GETSEC2CLUSTRU
      INTEGER GETCSPSSTRU, GETCLUOMCSTRU
      INTEGER T0MCRD
Cvp
      INTEGER TRKVOLD2STRU, GETOLDTCLOSTRU, DHIT_RESET, DHIT_UPK
      INTEGER DEDX2STRU_GET, DEDX2STRU_RESET
Cvp
      INTEGER BNKNUM
C
C Start of Code:
C ==============
C Simulation
      IF( exptyp.eq.exofsi )then 
         mcflag_1 = .true.
      else
         mcflag_1 = .false.
      endif
      If (mcflag_1) then
         mcflag_tg=1
      Else
         mcflag_tg=0
      EndIf
C-----------------------------------------------------------------------
C Fill event classification information
C-----------------------------------------------------------------------
      IF( mcflag_1 )  THEN
         istat = GETEVCL(evt%Info)
         istat = BLOCAT(iw,'EVCL',1,ind1,inddat)
         IF( TRIGFLAG ) THEN
           trgwrd1 = IW( inddat+1 )
           trgwrd2 = IW( inddat+2 )
         ENDIF
      ELSE
         istat = GETTIME(timesec,timemusec)
C Reduce the timing
         timesec = timesec-946080000  
         ISTAT = BIGEST(IW,'EVCL',BNKNUM)
         IF( ISTAT.ne.YESUCC ) THEN
            Call ERLOGR ('PROD2NTU_EV',ERWARN,0,ISTAT,
     &           'No EVCL bank found')
         END IF
         ISTAT = BLOCAT(IW,'EVCL',BNKNUM,IND1,INDDAT )
         IF( ISTAT.ne.YESUCC ) THEN
            Call ERLOGR ('PROD2NTU_EV',ERWARN,0,ISTAT,
     &           'No EVCL bank found')
         END IF
         icurr = IW(INDDAT+5)
         currpos=iand(icurr,'FFFF'X)*1.e-4
         currele=(icurr/2**16)*1.e-4
         luminosity = iw(inddat+6)*1.e-6
      ENDIF
C-----------------------------------------------------------------------
C Fill Event Infos
C-----------------------------------------------------------------------
      if(mcflag_1)then
         istat=blocat(iw,'BRID',1,ind1,inddat)
         Evt%Info%RunNumber = iw(inddat)
         if(Evt%Info%RunNumber.ne.OldRunNumber)then
            istat = fillbposcommon(Evt%Info%RunNumber)
            OldRunNumber = Evt%Info%RunNumber
         end if
      else
         Evt%Info%RunNumber   = Nrun
      end if
      Evt%Info%EventNumber = Nev
Cms ----------------------------------------------------
Cms      streamnum = 0
Cms      Algonum = 0
Cms      istat = GETECLS(StreamNum,AlgoNum,EventType)
Cms--- Moving toward a final ECLS unpacking 18-5-2000
Cms-----------------------------------------------------
      IF( ECLSFLAG ) THEN
        istat = GETECLS(evt%ecls)
      ENDIF
      IF( GDCHITFG ) THEN
        CALL   Getgdchit(evt%ghit)
      ENDIF
C
C---- to be inserted in GetGDchit ------------------
C
      istat = BIGEST(iw,'DTCE',banknum)
      istat = BLOCAT(iw,'DTCE',banknum,ind1,inddat)
      IF( istat.ne.YESUCC )THEN
        NDtce =0
      else
        NDtce = IW(inddat+DTCNRO)
      endif
C---------------------------------------------------
      IF( BPOSFLAG ) THEN
C------- to be filled with Simon's calls to HEPDB ---
C Average values for X
      evt%bpos%x     = 0.   
C " "      " "   for Y
      evt%bpos%y     = 0.    
C " "      " "   for Z
      evt%bpos%z     = 0.   
C Error on determination of X
      evt%bpos%errx  = 0.  
      evt%bpos%erry  = 0.
      evt%bpos%errz  = 0.
C Luminous region  in X
      evt%bpos%lumx  = 0.   
C Error on Lregion in X
      evt%bpos%elumx = 0.   
C Luminous region  in Z
      evt%bpos%lumz  = 0.   
C Error on Lregion in Z
      evt%bpos%elumz = 0.  
C ----------  fill Beam Momentum -------------------------------
      evt%bpos%px    = 0.
      evt%bpos%py    = 0.
      evt%bpos%pz    = 0.
      evt%bpos%errpx = 0.
      evt%bpos%errpy = 0.
      evt%bpos%errpz = 0.
      evt%bpos%larpx = 0.
      evt%bpos%larpy = 0.
      evt%bpos%larpz = 0.
      evt%bpos%elarpx= 0.
      evt%bpos%elarpy= 0.
      evt%bpos%elarpz= 0.
      evt%bpos%ene    = 0.
      evt%bpos%errene = 0.
      evt%bpos%dum1   = 0.
      evt%bpos%errdum1= 0.
      evt%bpos%dum2   = 0.
      evt%bpos%ErrDum2= 0.
        rstat =  getbpos( evt%Bpos )
      ENDIF
C---------------------------------------------------
      IF( TELEFLAG ) THEN
C------------------------------------------
C From Palutan and trigger group
C-----------------------------------------
         istat = tele_reset(evt%tele)
         istat = pizza_reset(evt%pizza)
         istat = GETTELESTRU(evt%tele)
         istat = GETPIZZASTRU(evt%pizza)
       ENDIF
       IF( TRIGFLAG ) THEN
          istat = GETTRIGGER(evt%trg)
          IF( C2TRFLAG ) THEN
            istat = GETSEC2CLUSTRU(evt%s2clu)
          ELSE
            istat = GETPIZZETTA (evt%pizzetta)
            istat = GETTELLINA  (evt%tellina)
          ENDIF
      ENDIF
C-----------------------------------------------------------------------
C Fill QCAL Information
C-----------------------------------------------------------------------
      if( QCALFLAG ) then
         if( mcflag_1 ) THEN
Cms           istat = GETQIHISTRU(evt%qhit)
           istat = GETQCAESTRU(evt%qele)
         ENDIF
         istat = GETQCALSTRU(evt%qcal)
      endif
C-----------------------------------------------------------------------
C Fill PreCluster Information
C-----------------------------------------------------------------------
      if( PRECLUSFLAG ) then
C         write(*,*)' Calling GetPreClusStru'
         istat = GETPRECLUSTRU(evt%preclu)
      endif
C-----------------------------------------------------------------------
C Fill Cluster Information
C-----------------------------------------------------------------------
      if( CLUSFLAG ) then
C         istat = GETCLUSTRUCORR(evt%clu,enecorflag)
         istat = GETCLUSTRU(evt%clu)
      endif
C-----------------------------------------------------------------------
C Fill Cluster Element Information
C-----------------------------------------------------------------------
      if( CELEFLAG ) then
         istat = GETCELESTRU(evt%cele)
      endif
      IF( CWRKFLAG ) THEN
        istat = GETCWRKSTRU(evt%cwrk)
      ENDIF
C------------------------------
C Fill CSPS + CLUO
C------------------------------ 
        IF( CSPSFLAG ) THEN
           Istat = GETCSPSSTRU(0,evt%CSPS,evt%CSPSMC)
        ENDIF
        IF( CLUOFLAG ) THEN
           Istat = GETCLUOSTRU(evt%CLUO )
           IF( exptyp.EQ. EXOFSI ) THEN
              Istat = GETCLUOMCSTRU(evt%CLUOMC)
           ENDIF
        ENDIF
C-----------------------------------------------------------------------
C Fill DTCE Information
C-----------------------------------------------------------------------
      If (dtceFlag.OR.DCnHitsFlag) Then
        call getDTCEstru(evt%DTCE)
      EndIf
C-----------------------------------------------------------------------
C Fill DHRE Information
C-----------------------------------------------------------------------
      If (dhreFlag) Then
        call getDHREstru(evt%DHRE)
      EndIf
C-----------------------------------------------------------------------
C Fill Montecarlo Information
C-----------------------------------------------------------------------
      if( GEANFIFLAG .and. mcflag_1 )then
         istat = GETMCSTRU(evt%mc)
      endif
C-----------------------------------------------------------------------
C Fill tracks/verticies Information
C-----------------------------------------------------------------------
      IF( TRKSFLAG .or. TRKVFLAG ) then
         istat = TRKV2STRU(evt%vtx,evt%trkv,evt%trk,evt%trkmc)
         IF( QCALFLAG ) istat = TRKQ2STRU( evt%trk, evt%trkq )
C-----------------------------------------------------------------------
C Fill DHSP
C-----------------------------------------------------------------------
         IF( DHSPFLAG )THEN
            istat =  GETDHSPSTRU(evt%trk%n,evt%dhsp)
         ENDIF
      endif
Cvp
C-----------------------------------------------------------------------
C ( KPM Stream ) Fill tracks/verticies Information before retracking
C-----------------------------------------------------------------------
      IF( TRKSOLDFLAG .or. TRKVOLDFLAG ) then
         istat = TRKVOLD2STRU(evt%vtxold,evt%trkvold,evt%trkold
     $        ,evt%trkmcold)
      endif
C-----------------------------------------------------------------------
C (KPM STREAM) Fill TCLO bank before retracking (bank TCL1)
C-----------------------------------------------------------------------
      IF( TCLOLDFLAG ) then
         istat =  GETOLDTCLOSTRU(evt%tclold)
      endif
C-----------------------------------------------------------------------
C Fill the Monte Carlo Drift Chamber hit information (DHIT Bank)
C-----------------------------------------------------------------------
      IF( TCLOLDFLAG ) then
         istat =  GETOLDTCLOSTRU(evt%tclold)
      endif
C-----------------------------------------------------------------------
C Fill the DEDX info in drift chamber (bank DEDX)
C-----------------------------------------------------------------------
      IF( DEDXFLAG ) then
         istat = DEDX2STRU_RESET(Evt%DEDX2STRU)
         istat = DEDX2STRU_GET(Evt%DEDX2STRU)
      endif
Cvp-
C-----------------------------------------------------------------------
C Fill tracks/verticies Information
C-----------------------------------------------------------------------
      If (DPRSFLAG) Then
        ISTAT = GET_DPRS_STRUCT(Evt%DPRS%NDPRS)
      End If
C-----------------------------------------------------------------------
C Fill TCLO
C-----------------------------------------------------------------------
      IF( TCLOFLAG ) then
         istat =  GETTCLOSTRU(evt%tclo)
      endif
C-----------------------------------------------------------------------
C Fill CFHI
C-----------------------------------------------------------------------
      If( CFHIFLAG .and. mcflag_1 )then
         istat = GETCFHISTRU(evt%cfhi)
      endif
C-----------------------------------------------------------------------
C Fill VNVO
C-----------------------------------------------------------------------
      IF( NVOFLAG ) then
         istat = GETNVO(evt%knvo,evt%vnvo,evt%vnvb,evt%invo)
      endif
C-----------------------------------------------------------------------
C Fill CLINF
C-----------------------------------------------------------------------
      IF( ECLOFLAG ) then
        istat = GETECLO(evt%eclo)
      endif
C-----------------------------------------------------------------------
C Fill T0GLOBAL
C-----------------------------------------------------------------------
      IF( T0FLAG ) THEN
        istat = T0GLRD( T0G_PHASED_DC, T0G_HIT_STEP0,
     &       T0G_CLUSTER, T0G_STEP1,DELTA_CAVI_CALO, BUNCH_PERIOD )
        Evt%T0stru%dc_step0   = T0G_PHASED_DC
        Evt%T0stru%hit_step0  = T0G_HIT_STEP0
        Evt%T0stru%clus_step0 = T0G_CLUSTER
        Evt%T0stru%step1      = T0G_STEP1
        Evt%T0stru%cable      = DELTA_CAVI_CALO
        Evt%T0stru%tbunch     = BUNCH_PERIOD
        IF( mcflag_1  ) THEN
           istat = T0MCRD(tphased_mc)
           Evt%T0stru%tphased_mc = tphased_mc
        ELSE
           Evt%T0stru%tphased_mc = 0.
        ENDIF
      ENDIF
C-----------------------------------------------------------------------
C Fill QCALTELE
C-----------------------------------------------------------------------
      IF( QCALTELEFLAG ) THEN
         istat = GETQCALTSTRU(Evt%QCALT)
      ENDIF
C-----------------------------------------------------------------------
C Fill QCALTHIT
C-----------------------------------------------------------------------
      IF( QCALTHITFLAG ) THEN
         istat = GETQCTHSTRU(Evt%QCALTHIT)
      ENDIF
C-----------------------------------------------------------------------
C Fill CCLE
C-----------------------------------------------------------------------
      IF( CCLEFLAG ) THEN
         istat = GETCCALTSTRU(Evt%CCLE)
      ENDIF
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
C Fill LET
C-----------------------------------------------------------------------
      IF(LETEFLAG)THEN
         istat = getletestru(evt%lete)
      ENDIF
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
C Fill IT
      IF(ITCEFLAG)THEN
         istat = itce_upk(evt%itce)
      ENDIF
C-----------------------------------------------------------------------
C Fill HET
      IF(HETEFLAG)THEN
         istat = gethetestru(evt%hete)
      ENDIF
C-----------------------------------------------------------------------
C now fill the NTUPLE
C-----------------------------------------------------------------------
      IF (Analysis_Get_Hist_Active()) THEN
         ParSet = ANGPAR()
C         IF( ParSet.EQ.1 ) CALL HFNt(Params%NtId) ! fill the ntuple
         IF( ParSet.EQ.1.and.evt%itce%nitce.le.4032)
C fill the ntuple
     &        CALL HFNt(Params%NtId) 
      ENDIF
C-----------------------------------------------------------------------
C Return to caller:
C-----------------------------------------------------------------------
999   CONTINUE
      RETURN
      END
C
C-----------------------------------------------------------------------
      SUBROUTINE prod2ntu_FormatBankReport(BankName,N,String)
C-----------------------------------------------------------------------
        IMPLICIT NONE
C-----------------------------------------------------------------------
      CHARACTER*4 BankName
      INTEGER N
      CHARACTER*(*) String
C-----------------------------------------------------------------------
      IF (N.LT.0) THEN
        WRITE(String,'(A)') 'Found '//BankName//' bank'
      ELSEIF (N.EQ.1) THEN
        WRITE(String,'(A,I1,A)') 'Found ',N,' '//BankName//' bank'
      ELSEIF (N.LT.10) THEN
        WRITE(String,'(A,I1,A)') 'Found ',N,' '//BankName//' banks'
      ELSEIF (N.LT.100) THEN
        WRITE(String,'(A,I2,A)') 'Found ',N,' '//BankName//' banks'
      ELSE
        WRITE(String,'(A,I3,A)') 'Found ',N,' '//BankName//' banks'
      ENDIF
C-----------------------------------------------------------------------
      RETURN
      END
C--------
C----------------------------------------
      subroutine prod2ntu_rin
C----------------------------------------
        IMPLICIT NONE
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
      integer istat,fillbposcommon
      istat = fillbposcommon(nrun)
C
C----------------------------------------
      return
      end
C
      subroutine prod2ntu_rfi
      return
      end
      subroutine prod2ntu_end
      return
      end
C
C------------------------------------------------------------------------
      subroutine prod2ntu_tk
C------------------------------------------------------------------------
C
C  Description:
C  ------------
C===========================================================================
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
C Include /kloe/soft/off/offline/inc/development/tls/prod2ntu_talk.cin =
        logical CLUSFLAG,CELEFLAG,TRIGFLAG
        logical TRKSFLAG,TRKVFLAG,DPRSFLAG
        logical CFHIFLAG,TCLOFLAG
        logical QCALFLAG,GEANFIFLAG
        logical DHSPFLAG,TELEFLAG
        logical PRECLUSFLAG,NVOFLAG
        logical ECLOFLAG,T0FLAG
        logical CWRKFLAG, ENECORFLAG
        logical ECLSFLAG, GDCHITFG
        logical BPOSFLAG
        Logical dtceFlag,dtce0Flag,DCnHitsFlag,dhreFlag
        logical c2trFlag
        Logical BENEFLAG
        Logical CSPSFLAG,CSPSMCFLAG,CLUOFLAG
        logical TRKSOLDFLAG,TRKVOLDFLAG,TCLOLDFLAG
        logical DHITFLAG,DEDXFLAG
        logical QCALTELEFLAG
        logical CCLEFLAG
        logical LETEFLAG
        logical ITCEFLAG
        logical HETEFLAG
        logical QCALTHITFLAG
        common /PRODMENU/CLUSFLAG,CELEFLAG,TRIGFLAG,TRKSFLAG,
     &  TRKVFLAG,DPRSFLAG,CFHIFLAG,QCALFLAG,TCLOFLAG,
     &  GEANFIFLAG,DHSPFLAG,TELEFLAG,PRECLUSFLAG,NVOFLAG,
     &  ECLOFLAG,T0FLAG,CWRKFLAG,ENECORFLAG,ECLSFLAG,GDCHITFG,
     &  BPOSFLAG,dtceFlag,dtce0Flag,DCnHitsFlag,dhreFlag,
     &  C2TRFLAG,BENEFLAG,CSPSFLAG,CSPSMCFLAG,CLUOFLAG,
     &  TRKSOLDFLAG,TRKVOLDFLAG,TCLOLDFLAG,DHITFLAG,DEDXFLAG,
     &  QCALTELEFLAG,CCLEFLAG,LETEFLAG,ITCEFLAG,HETEFLAG,
     &  QCALTHITFLAG
C
C External functions
C
      INTEGER   UIDFFI, UIUSGP, UIACME
      INTEGER   UIGTYE, UIGTRE, UIGTIN
C
C Local declarations
C
      INTEGER   Status, MENUF, MENUL, IGROUP
      CHARACTER Verb*40, Prompt*100
      CHARACTER*3 flag
C
C Clus-Cwrk-Cele-pclu-corr
      character*3 calosel(5)   
C DTCE-DTCE0-DCHITS-DHRE
      character*3 dchSel (4)   
C t0g-tclo-eclo-ecls-bpos-neuv-tclold
      character*3 recsel (7)   
Cvp
C Trkv-TRKS-DPRS-DSPS-trkvold-trksold-dedx
      character*3 trksel (7)   
C Gean-Cfhi-DHIT
      character*3 mcsel  (3)   
Cvp
C Trig-Tele-C2TRG
      character*3 trigsel(3)   
C Qcal
      character*3 qcalsel(1)   
C CSPS-CSPSMC-CLUO
      character*3 newemchit(3) 
C Hete
      character*3 hetesel(3)   
C
C===========================================================================
C
      Status = UIDFFI
     &         ('k$tls:prod2ntu_v5.uid',
     &          IGROUP,MENUF,N$A,N$A,MENUL,N$A)
        Status = UIUSGP(IGROUP,N$A)
C Display menu
 10     Status = UIACME(MENUF,Verb,N$A)             
C
        IF( Verb.EQ.'CLUS' )THEN
           write(Prompt,123)'CLUS'
           Status = UIGTYE(Prompt,CLUSFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'VNVO' )THEN
           write(Prompt,123)'VNVO'
           Status = UIGTYE(Prompt,NVOFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'ECLO' )THEN
           write(Prompt,123)'ECLO'
           Status = UIGTYE(Prompt,ECLOFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'ECLS' )THEN
           write(Prompt,123)'ECLS'
           Status = UIGTYE(Prompt,ECLSFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'GDHI' )THEN
           write(Prompt,123)'GDHI'
           Status = UIGTYE(Prompt,GDCHITFG)
           GOTO 10
        ELSE IF( Verb.EQ.'BPOS' )THEN
           write(Prompt,123)'BPOS'
           Status = UIGTYE(Prompt,BPOSFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'T0GL') THEN
           write(Prompt,123)'T0GL'
           Status = UIGTYE(Prompt,T0FLAG )
           GOTO 10
        ELSE IF( Verb.EQ.'PREC' )THEN
           write(Prompt,123)'PREC'
           Status = UIGTYE(Prompt,PRECLUSFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'CELE' )THEN
           write(Prompt,123)'CELE'
           Status = UIGTYE(Prompt,CELEFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'TRIG' )THEN
           write(Prompt,123)'TRIG'
           Status = UIGTYE(Prompt,TRIGFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'TELE' )THEN
           write(Prompt,123)'TELE'
           Status = UIGTYE(Prompt,TELEFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'C2TRG') THEN
           write(Prompt,123)'CTRG'      
           Status = UIGTYE(Prompt,C2TRFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'TRKS' )THEN
           write(Prompt,123)'TRKS'
           Status = UIGTYE(Prompt,TRKSFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'TRKV' )THEN
           write(Prompt,123)'TRKV'
           Status = UIGTYE(Prompt,TRKVFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'DPRS' )THEN
           write(Prompt,123)'DPRS'
           Status = UIGTYE(Prompt,DPRSFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'DHSP' )THEN
           write(Prompt,123)'DHSP'
           Status = UIGTYE(Prompt,DHSPFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'DTCE' )THEN
           write(Prompt,123)'DTCE'
           Status = UIGTYE(Prompt,DTCEFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'NSDTCE' )THEN
           write(Prompt,123)'DTCE0'
           Status = UIGTYE(Prompt,DTCE0FLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'DCHITS' )THEN
           write(Prompt,123)'DCHITS'
           Status = UIGTYE(Prompt,DCnHitsFlag)
           GOTO 10
        ELSE IF( Verb.EQ.'DHRE' )THEN
           write(Prompt,123)'DHRE'
           Status = UIGTYE(Prompt,DHREFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'GEAN' )THEN
           write(Prompt,123)'GEAN'
           Status = UIGTYE(Prompt,GEANFIFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'TCLO' )THEN
           write(Prompt,123)'TCLO'
           Status = UIGTYE(Prompt,TCLOFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'CFHI' )THEN
           write(Prompt,123)'CFHI'
           Status = UIGTYE(Prompt,CFHIFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'QCAL' )THEN
           write(Prompt,123)'QCAL'
           Status = UIGTYE(Prompt,QCALFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'CWRK') THEN
          write(Prompt,123)'CWRK'
          Status = UIGTYE(Prompt,CWRKFLAG)
          GOTO 10
        ELSE IF( Verb.EQ.'CSPS') THEN
          write(Prompt,123)'CSPS'
          Status = UIGTYE(Prompt,CSPSFLAG  )
          GOTO 10
        ELSE IF( Verb.EQ.'MCCSPS') THEN
          write(Prompt,123)'MCCSPS'
          Status = UIGTYE(Prompt,CSPSMCFLAG )
          GOTO 10
        ELSE IF( Verb.eq.'CLUO') THEN   
          write(Prompt,123)'CLUO'
          Status = UIGTYE(Prompt,CLUOFLAG )
          GOTO 10
        ELSE IF( Verb.eq.'BENE') THEN
          write(Prompt,123)'BENE'
          Status = UIGTYE(Prompt,BENEFLAG )
          goto 10
Ckpm
        ELSE IF( Verb.EQ.'OTRK' )THEN
           write(Prompt,123)'OTRK'
           Status = UIGTYE(Prompt,TRKSOLDFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'OTRV' )THEN
           write(Prompt,123)'OTRV'
           Status = UIGTYE(Prompt,TRKVOLDFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'OTCL' )THEN
           write(Prompt,123)'OTCL'
           Status = UIGTYE(Prompt,TCLOLDFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'DEDX' )THEN
           write(Prompt,123)'DEDX'
           Status = UIGTYE(Prompt,DEDXFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'DHIT' )THEN
           write(Prompt,123)'DHIT'
           Status = UIGTYE(Prompt,DHITFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'QLTE' )THEN
           write(Prompt,123)'QLTE'
           Status = UIGTYE(Prompt,QCALTELEFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'QCTH' )THEN
           write(Prompt,123)'QCTH'
           Status = UIGTYE(Prompt,QCALTHITFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'CCLE' )THEN
           write(Prompt,123)'CCLE'
           Status = UIGTYE(Prompt,CCLEFLAG)
           GOTO 10
Ckpm
        ELSE IF( Verb.EQ.'LETE' )THEN
           write(Prompt,123)'LETE'
           Status = UIGTYE(Prompt,LETEFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'ITCE' )THEN
           write(Prompt,123)'ITCE'
           Status = UIGTYE(Prompt,ITCEFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'HETE' )THEN
           write(Prompt,123)'HETE'
           Status = UIGTYE(Prompt,HETEFLAG)
           GOTO 10
        ELSE IF( Verb.EQ.'DEFA' )THEN
           write(6,*)' Setting Default Conditions !'
           PRECLUSFLAG= .false.
           CLUSFLAG   = .true.
           CELEFLAG   = .false.
           TRIGFLAG   = .true.
           TRKSFLAG   = .true.
           TRKVFLAG   = .true.
           DHSPFLAG   = .false.
           DPRSFLAG   = .true.
           DTCEFLAG   = .false.
           DTCE0FLAG  = .false.
           DCnHitsFlag= .false.
           DHREFLAG   = .false.
           TCLOFLAG   = .true.
           TCLOLDFLAG   = .false.
           CFHIFLAG   = .false.
           QCALFLAG   = .true.
           GEANFIFLAG = .true.
           TELEFLAG   = .false.
           NVOFLAG    = .true.
           ECLOFLAG   = .true.
           ECLSFLAG   = .true.
           GDCHITFG   = .true.
           BPOSFLAG   = .true.
           BENEFLAG   = .false.
           T0FLAG     = .true.
           C2TRFLAG   = .true.
           ENECORFLAG = .false.
           CWRKFLAG   = .true.
           CSPSFLAG   = .false.
           CSPSMCFLAG = .false.
           CLUOFLAG   = .false.
Cvp
           TRKSOLDFLAG   = .false.
           TRKVOLDFLAG   = .false.
           TCLOLDFLAG   = .false.
           DEDXFLAG     = .false.
           DHITFLAG     = .false.
Cvp
           QCALTELEFLAG = .FALSE.
           QCALTHITFLAG = .FALSE.
           CCLEFLAG = .FALSE.
           LETEFLAG = .FALSE.
           ITCEFLAG = .FALSE.
           HETEFLAG = .FALSE.
           GOTO 10
        ELSE IF( Verb.EQ.'SHOW' )THEN
C
          WRITE(6,*)' ************* PRODNTU SELECTED BLOCKS ***********'
C------------------------------------------------------------------------
           Calosel(1)= 'OFF'
           Calosel(2)= 'OFF'
           Calosel(3)= 'OFF'
           Calosel(4)= 'OFF'
           Calosel(5)= 'OFF'
           IF( CLUSFLAG   )Calosel(1) = 'ON '
           IF( CWRKFLAG   )Calosel(2) = 'ON '
           IF( CELEFLAG   )Calosel(3) = 'ON '
           IF( PRECLUSFLAG)Calosel(4) = 'ON '
           IF( ENECORFLAG )Calosel(5) = 'ON '
           WRITE(6,*)' CALO/ Clus: ',calosel(1),' Hits: ',calosel(2),
     &  ' Cell: ',calosel(3),' Prec: ',calosel(4),' Corr: ',calosel(5)
C------------------------------------------------------------------------
           trksel(1) = 'OFF'
           trksel(2) = 'OFF'
           trksel(3) = 'OFF'
           trksel(4) = 'OFF'
           trksel(5) = 'OFF'
           trksel(6) = 'OFF'
           trksel(7) = 'OFF'
           IF (TRKVFLAG)    trksel(1) = 'ON '
           IF (TRKSFLAG)    trksel(2) = 'ON '
           IF (DPRSFLAG)    trksel(3) = 'ON '
           IF (DHSPFLAG)    trksel(4) = 'ON '
Cvp
           IF (TRKVOLDFLAG)    trksel(5) = 'ON '
           IF (TRKSOLDFLAG)    trksel(6) = 'ON '
           IF (DEDXFLAG)    trksel(7) = 'ON '
           write(6,*)' TRKS/ Trkv: ',trksel(1),' Trks: ',trksel(2),
     &               ' Dprs: ',trksel(3),' Dhsp: ',trksel(4),
     &               ' TrkvOld: ',trksel(5),' TrksOld: ',trksel(6),
     %               ' Dedx: ',trksel(7)
Cvp
           dchSel(1) = 'OFF'
           dchSel(2) = 'OFF'
           dchSel(3) = 'OFF'
           dchSel(4) = 'OFF'
           IF (DTCEFLAG)    dchSel(1) = 'ON '
           IF (DTCE0FLAG)   dchSel(2) = 'ON '
           IF (DCnHitsFlag) dchSel(3) = 'ON '
           IF (DHREFLAG)    dchSel(4) = 'ON '
           write(6,*)' DCH/  Dtce: ',dchSel(1),' Dtce0:',dchSel(2),
     +               ' Dchit:',dchSel(2),'Dhre: ',dchSel(4)
C------------------------------------------------------------------------
           recsel(1) = 'OFF'
           recsel(2) = 'OFF'
           recsel(3) = 'OFF'
           recsel(4) = 'OFF'
           recsel(5) = 'OFF'
           recsel(6) = 'OFF'
           recsel(7) = 'OFF'
           IF( T0FLAG   ) recsel(1) = 'ON'
           IF( TCLOFLAG ) recsel(2) = 'ON'
           IF( ECLOFLAG ) recsel(3) = 'ON'
           IF( ECLSFLAG ) recsel(4) = 'ON'
           IF( BPOSFLAG ) recsel(5) = 'ON'
           IF( NVOFLAG  ) recsel(6) = 'ON'
           IF(TCLOLDFLAG) recsel(7) = 'ON'
           write(6,*)' RECO/ T0gl: ',recsel(1),' Tclo: ',recsel(2),
     &   ' Eclo: ',recsel(3),' Ecls: ',recsel(4),' Bpos: ',recsel(5),
     &   ' Nvo: ',recsel(6),' TCLOLD: ',recsel(7)
C-------------------------------------------------------------------------
           trigsel(1) = 'OFF'
           trigsel(2) = 'OFF'
           trigsel(3) = 'OFF'
           IF( TRIGFLAG )trigsel(1) = 'ON '
           IF( TELEFLAG )trigsel(2) = 'ON '
           IF( C2TRFLAG  )trigsel(3) = 'ON'
           write(6,*)' TRIG/ Tort: ',trigsel(1),' Pizz: ',trigsel(2),
     &   ' C2tr: ',trigsel(3)
C--------------------------------------------------------------------------
Cvp
           mcsel(1) = 'OFF'
           mcsel(2) = 'OFF'
           mcsel(3) = 'OFF'
           IF( GEANFIFLAG )mcsel(1) = 'ON '
           IF( CFHIFLAG   )mcsel(2) = 'ON '
           IF( DHITFLAG   )mcsel(3) = 'ON '
           write(6,*)' GPHI/ Kine: ',mcsel(1),' Fhit: ',mcsel(2),
     $          ' DHIT: ',mcsel(3)
Cvp
           newemchit(1) = 'OFF'
           newemchit(2) = 'OFF'
           newemchit(3) = 'OFF'
           IF( CSPSFLAG  ) newemchit(1) = 'ON'
           IF( CSPSMCFLAG) newemchit(2) = 'ON'
           IF( CLUOFLAG  ) newemchit(3) = 'ON'
           write(6,*)' CSPS/ Hits: ',newemchit(1),' MCHit ',
     &     newemchit(2),' Cluo: ',newemchit(3)
C------------------------------------------------------------------------
           qcalsel(1) = 'OFF'
           IF( QCALFLAG )qcalsel(1)= 'ON '
           write(6,*)' QCAL/ Qcal: ',qcalsel(1)
C------------------------------------------------------------------------
           hetesel(1) = 'OFF'
           IF( HETEFLAG )hetesel(1)= 'ON '
           write(6,*)' HETE: ',hetesel(1)
C------------------------------------------------------------------------
C -
         WRITE(6,*)' *******End of Prod2ntu Selected Blocks **********'
         GOTO 10
       ENDIF
Cvp
 127   FORMAT(1x,'Select ',a7,' Ntuple-block?')
 126   FORMAT(1x,'Select ',a6,' Ntuple-block?')
Cvp
 123   FORMAT(1x,'Select ',a4,' Ntuple-block?')
 125   FORMAT(1x,'Select ',a5,' Ntuple-block?')
 124   FORMAT(1x,'Correct Energy for cells-losses?')
C------------------------------------------------------------------------
       return
       end
