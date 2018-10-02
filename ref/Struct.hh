#ifndef STRUCT_HH
#define STRUCT_HH
// This header contains all the structs needed to 
// write ntuple data to C++ format.

const int MaxNumClu  = 100;
const int MaxEclSize = 8;
const int MaxTrgChan = 1000;

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
    int Ndtce;
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

#endif
