#ifndef STRUCT_HH
#define STRUCT_HH
// This header contains all the structs needed to 
// write ntuple data to C++ format.

const int MaxNumClu  = 100;
const int MaxEclSize = 8;
const int MaxTrgChan = 1000;
const int MaxNTele   = 300;
const int MaxNPack   = 300;
const int NeleCluMax = 300;
const int NMaxDC     = 1500;
const int MaxNumDHSP = 500;

// Block:   evtinfo
extern "C"{
  extern struct{
    int NumRun;
    int NumEv;
    int Pileup;
    int GCod;
    int PhiD;
    int A1Typ;
    int A2Typ;
    int A3Typ;
    int B1Typ;
    int B2Typ;
    int B3Typ;
  }evtinfo_;
}

// Block:   evtdata
extern "C"{
  extern struct{
    int StreamNum;
    int AlgoNum;
    int TimeSec;
    int TimeMusec;
    int Ndtce_copy;
    int McFlag;
    float IPos;
    float IEle;
    float Lumi;
  }eventinfo_;
}

// Block:   evtecls
extern "C"{
  extern struct{
    int NEcls;
    int EclTrgw;
    int EclFilfo;
    int EclWord[MaxEclSize];
    int EclStream[MaxEclSize];
    int EclTagNum[MaxEclSize];
    int EclEvType[MaxEclSize];
    int NEcls2;
    int EclTrgw2;
    int EclFilfo2;
    int EclWord2[MaxEclSize];
    int EclStream2[MaxEclSize];
    int EclTagNum2[MaxEclSize];
    int EclEvType2[MaxEclSize];
  }evtecls_;
}

// Block:    evtbpos
extern "C" {
  extern struct {
    float BPx;
    float BPy;
    float BPz;
    float Bx;
    float By;
    float Bz;
    float BWidPx;
    float BWidPy;
    float BWidPz;
    float BSx;
    float BSy;
    float BSz;
    float BLumx;
    float BLumz;
    float Broots;
    float BrootsErr;
  }evtbpos_;
}

// Block:   evttime
extern "C"{
  extern struct{
    float TPhased_mc;
    float T0Dc0;
    float T0Hit0;
    float T0Clu0;
    float T0Step1;
    float DelayCable;
    float TBunch;
  }evttime_;
}

// Block:   evtgdhit
extern "C" {
  extern struct {
    int DtceHit;
    int DhreHit;
    int DprsHit;
    int DtfsHit;
  }evtgdhit_;
}

// Block:   evttrig
extern "C" {
  extern struct {
    int Trgw1;
    int Trgw2;
  }evttrig_;
}

// Block:   evtc2trig
extern "C" {
  extern struct {
    int NSec;
    int NSec_NoClu;
    int NSec2Clu;
    int NClu2s;
    int NNorm[MaxNumClu];
    int NormAdd[MaxNumClu];
    int NOver[MaxNumClu];
    int OverAdd[MaxNumClu];
    int NCosm[MaxNumClu];
    int CosmAdd[MaxNumClu];
  }evtc2trig_;
}

// Block:   tellina
extern "C" {
  extern struct {
    int NTel;
    int Add_Tel[MaxTrgChan];
    int Bitp_Tel[MaxTrgChan];
    float Ea_Tel[MaxTrgChan];
    float Eb_Tel[MaxTrgChan];
    float Ta_Tel[MaxTrgChan];
    float Tb_Tel[MaxTrgChan];
  }tellina_;
}

// Block:   pizzetta
extern "C" {
  extern struct {
    int NPiz;
    int Add_Piz[MaxTrgChan];
    float Ea_Piz[MaxTrgChan];
    float Eb_Piz[MaxTrgChan];
    float E_Piz[MaxTrgChan];
    float Z_Piz[MaxTrgChan];
  }pizzetta_;
}

// Block:   evttele
extern "C" {
  extern struct {
    int NTele;
    int Det_Trg[MaxNTele];
    int BitP[MaxNTele];
    int Sector[MaxNTele];
    int SerKind[MaxNTele];
    float Ea_Trg[MaxNTele];
    float Eb_Trg[MaxNTele];
    float Ta_Trg[MaxNTele];
    float Tb_Trg[MaxNTele];
  }tele_;
}

// Block:   pizza
extern "C" {
  extern struct {
    int NPack;
    int PakSect[MaxNPack];
    int PakDet[MaxNPack];
    int PakSerk[MaxNPack];
    float Ea_Pack[MaxNPack];
    float Eb_Pack[MaxNPack];
    float E_Rec[MaxNPack];
    float Z_mod[MaxNPack];
  }pizza_;
}

// Block:   evtclu
extern "C" {
  extern struct {
    int NClu;
    float EneCl[MaxNumClu];
    float TCl[MaxNumClu];
    float XCl[MaxNumClu];
    float YCl[MaxNumClu];
    float ZCl[MaxNumClu];
    float XaCl[MaxNumClu];
    float YaCl[MaxNumClu];
    float ZaCl[MaxNumClu];
    float XRmCl[MaxNumClu];
    float YRmsCl[MaxNumClu];
    float ZrmsCl[MaxNumClu];
    float TrmsCl[MaxNumClu];
    int FlagCl[MaxNumClu];
    int NCluMc;
    int NPar[MaxNumClu];
    int PNum1[MaxNumClu];
    int Pid1[MaxNumClu];
    int PNum2[MaxNumClu];
    int Pid2[MaxNumClu];
    int PNum3[MaxNumClu];
    int Pid3[MaxNumClu];
  }evtclu_;
}

// Block:   preclu
extern "C" {
  extern struct {
    int NPClu;
    float EPre[MaxNumClu];
    float TPre[MaxNumClu];
    float XPre[MaxNumClu];
    float YPre[MaxNumClu];
    float ZPre[MaxNumClu];
    float TAPre[MaxNumClu];
    float TBPre[MaxNumClu];
    float TARPre[MaxNumClu];
    float TBRPre[MaxNumClu];
  }preclu_;
}

// Block:   cwrk
extern "C" {
  extern struct {
    int NCHit;
    int IClu[NeleCluMax];
    int ICel[NeleCluMax];
    int CAdd[NeleCluMax];
    int CmcHit[NeleCluMax];
    int Ckine[NeleCluMax];
    float Ene[NeleCluMax];
    float T[NeleCluMax];
    float X[NeleCluMax];
    float Y[NeleCluMax];
    float Z[NeleCluMax];
  }cwrk_;
}

// Block:   cele
extern "C" {
  extern struct {
    int NCel;
    int ICl[NeleCluMax];
    int Det[NeleCluMax];
    int Wed[NeleCluMax];
    int Pla[NeleCluMax];
    int Col[NeleCluMax];
    float Ea[NeleCluMax];
    float Ta[NeleCluMax];
    float Eb[NeleCluMax];
    float Tb[NeleCluMax];
    int NCelMc;
    float EMc[NeleCluMax];
    float TMc[NeleCluMax];
    float XMc[NeleCluMax];
    float YMc[NeleCluMax];
    float ZMc[NeleCluMax];
    int PTyp[NeleCluMax];
    int KNum[NeleCluMax];
    int NHit[NeleCluMax];
  }cele_;
}

// Block:   dtce
extern "C" {
  extern struct {
    int nDTCE;
    int nSmall;
    int iLayerDTCE[NMaxDC];
    int iWireDTCE[NMaxDC];
    float tDTCE[NMaxDC];
  }dtce_;
}

// Block:   dtce0
extern "C" {
  extern struct {
    int nDTCE0;
    int iLayerDTCE0[NMaxDC];
    int iWireDTCE0[NMaxDC];
    float tDTCE0[NMaxDC];
  }dtce0_;
}

// Block:   dcnhits
extern "C" {
  extern struct {
    int nDCHR;
    int nSmallDCm;
    int nSmallDCp;
    int nBigDCm;
    int nBigDCp;
    int nCellDC;
    int nSmallDC;
  }dchits_;
}

// Block:   dhre
extern "C" {
  extern struct {
    int nDHRE;
    int iLayerDHRE[NMaxDC];
    int iWireDHRE[NMaxDC];
    int iTrkDHRE[NMaxDC];
    float rDHRE[NMaxDC];
    float eDHRE[NMaxDC];
  }dhre_;
}

// Block:   dhsp
extern "C" {
  extern struct {
    int nDHSP;
    int TrkDh[MaxNumDHSP];
    int Layer[MaxNumDHSP];
    int Wire[MaxNumDHSP];
    float Time[MaxNumDHSP];
    float DPar[MaxNumDHSP];
    float Res[MaxNumDHSP];
    float XDh[MaxNumDHSP];
    float YDh[MaxNumDHSP];
    float ZDh[MaxNumDHSP];
  }dhsp_;
}

#endif
