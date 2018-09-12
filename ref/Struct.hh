#ifndef STRUCT_HH
#define STRUCT_HH

extern "C" struct{
  int bb;
} elena_;

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

#endif






