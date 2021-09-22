#ifndef FORT2C_HH
#define FORT2C_HH
#include <iostream>

#include <TFile.h>
#include <TTree.h>
#include <vector>

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
  struct MyStruct{
    int newEclTrgw;
    int newEclFilfo;
    int newEclWord[];
    int newEclStream[];
    int newEclTagNum[];
    int newEclEvType[];
  };


class TreeWriter{
public:
  TreeWriter();
  ~TreeWriter();
  TFile* GetTFile(){
    return outfile;
  }
  void FillTtree(){
    TTree *tree = (TTree*)outfile->Get("sample");
    for(int i =0; i< evtecls_.necls; ++i)
      std::cout<<"myArray "<<myArray[i]<<" "<<evtecls_.EclStream[i]<<std::endl;
    
    tree->Fill();

  }
  void CopyArray(){
    //myArray = new int[evtecls_.necls];
    
    for(int i =0; i< evtecls_.necls; ++i){
      myArray[i] = evtecls_.EclStream[i];
    }
  }
private:
  TFile *outfile;
  int myArray[8];  
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
extern "C" void initstruct_();
extern "C" void closetree_();

extern "C" void showheader_();

MyStruct newevtecls_;


void newClass();
#endif






