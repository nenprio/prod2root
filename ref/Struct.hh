#ifndef STRUCT_HH
#define STRUCT_HH
// This header contains all the structs needed to 
// write ntuple data to C++ format.

// Block:   elena
extern "C" struct{
  int bb;
} elena_;

// Block:   evtinfo
extern "C"{
  extern struct{
    int RunNumber;
    int EventNumber;
    int Pileup;
    int GCod;
    int PhiD;
    int A1typ;
    int A2typ;
    int A3typ;
    int B1typ;
    int B2typ;
    int B3typ;
  }evtinfo_;
}

// Block:  eventinfo 
extern "C"{
  extern struct{
    int StreamNum;
    int AlgoNum;
    int TimeSec;
    int TimeMusec;
    int Ndtce;
    int Mcflag_tg;
    float Currpos;
    float Currele;
    float Luminosity;
  }eventinfo_;
}

// Block:   evtecls
extern "C"{
  extern struct{
    int necls;
    int EclTrgw;
    int EclFilfo;
    int EclWord[8];
    int EclStream[8];
    int EclTagNum[8];
    int EclEvType[8];
  }evtecls_;
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
