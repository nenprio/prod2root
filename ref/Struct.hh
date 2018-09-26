#ifndef STRUCT_HH
#define STRUCT_HH
// This header contains all the structs needed to 
// write ntuple data to C++ format.

// Block:   Event Info
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

// Block:  Event Data
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

// Block:   Event Ecl
extern "C"{
  extern struct{
    int NEcls;
    int EclTrgw;
    int EclFilfo;
    int EclWord[8];
    int EclStream[8];
    int EclTagNum[8];
    int EclEvType[8];
  }evtecls_;
}

// Block:   Event BPOS
extern "C"{
  extern struct{
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

#endif
