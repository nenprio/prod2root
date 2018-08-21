#ifndef FORT2C_HH
#define FORT2C_HH
#include <iostream>
#include <TFile.h>
#include <TTree.h>


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
class TreeWriter{
public:
  TreeWriter();
  ~TreeWriter();
  TFile* GetTFile(){
    return outfile;
  }
  void FillTtree(){
    TTree *tree = (TTree*)outfile->Get("sample");
    std::cout <<"CC " << elena_.bb << std::endl;
    tree->Fill();

  }
private:
  TFile *outfile;
};
//   // int EventNumber;
    // int McFlag;
    // int EvFlag;
    // int Pileup;
    // int GenCod;
    // int PhiDecay;
    // int A1type;
    // int A2type;
    // int A3type;
    // int B1type;
    // int B2type;
    // int B3type;
    // int T3DOWN;
    // int T3FLAG;
    // double ECAP[2];
  //   // double DCNOISE[4];
  // } elena_;

extern "C" void fillntu_();
extern "C" void inittree_();
extern "C" void closetree_();

#endif






