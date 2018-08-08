      real function newt0find()
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
      real emax, rclu, rf, vlight
      real xoff, yoff, zoff
      integer imax, ncl, nbunch
      integer getclustru, getbpos, istat
      rf=2.715
      vlight=29.979
      newt0find=0.
      emax=0.
      imax=0
      ncl=0
      nbunch=0
      rclu=0
      xoff=0
      yoff=0
      zoff=0
      istat = GETCLUSTRU(cluster)
      istat =  getbpos( Bpos )
      if(bpos%x.ne.666)then
        xoff=bpos%x
        yoff=bpos%y
        zoff=bpos%z
      endif
      do ncl=1,cluster%n
         if(cluster%e(ncl).gt.emax)then
                emax=cluster%e(ncl)
                imax=ncl
         endif
      enddo
      rclu=sqrt((cluster%x(imax)-xoff)**2+(cluster%y(imax)-yoff)**2
     $     +(cluster%z(imax)-zoff)**2)
      newt0find=cluster%t(imax)-rclu/vlight
      nbunch=NINT(newt0find/rf)
      newt0find=nbunch*rf
      return
      end
