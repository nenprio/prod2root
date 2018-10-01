#ifndef STRUCT_HH
#define STRUCT_HH
// This header contains all the structs needed to 
// write ntuple data to C++ format.

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
    int EclWord[8];
    int EclStream[8];
    int EclTagNum[8];
    int EclEvType[8];
    int NEcls2;
    int EclTrgw2;
    int EclFilfo2;
    int EclWord2[8];
    int EclStream2[8];
    int EclTagNum2[8];
    int EclEvType2[8];
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

#endif
