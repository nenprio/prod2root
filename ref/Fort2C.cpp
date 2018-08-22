#ifndef FORT2C_CXX
#define FORT2C_CXX
#include <iostream>
#include "Fort2C.hh"
#include <TROOT.h>
#include <TBranch.h>

TreeWriter::TreeWriter(){
  outfile = new TFile("sample.root","recreate");
  TTree *fNewTree = new TTree("sample","Event Infos");
  fNewTree->Branch("nRun",&elena_.bb,"nRun/I");
  fNewTree->Branch("Info",&evtinfo_,"RunNumber/I:EventNumber:Pileup:GenCod:PhiDecay:A1type:A2Type:A3type:B1type:B2type:B3type");
  fNewTree->Branch("Data",&eventinfo_,"StreamNum/I:AlgoNum:TimeSec:TimeMusec:Ndtce:Mcflag_tg:Currpos/F:Currele:Luminosity");
  fNewTree->Branch("nEcls",&evtecls_.necls,"necls/I");
  fNewTree->Branch("Ecls",myArray,"myArray[necls]/I");

  outfile->Write();
}
TreeWriter::~TreeWriter(){
  std::cout << "Destructor " << std::endl;
  if(outfile){
    outfile->Write(0,TObject::kOverwrite);
    outfile->Close();
    delete outfile;

  }
}
TreeWriter *writer;

void inittree_(){
  writer = new TreeWriter();
}
void fillntu_(){
  //  newClass();
  writer->CopyArray();
  writer->FillTtree();

}
// void newClass(){
//   newevtecls_.newnecls = evtecls_.necls;
//   for(int i = 0; i < newevtecls_.newnecls; ++i){
//     newevtecls_.newEclWord.push_back(evtecls_.EclWord[i]);
//     newevtecls_.newEclStream.push_back(evtecls_.EclStream[i]);
//     newevtecls_.newEclTagNum.push_back(evtecls_.EclTagNum[i]);
//     newevtecls_.newEclEvType.push_back(evtecls_.EclEvType[i]);
//     std::cout<<"vector "<<newevtecls_.newEclStream[i]<<std::endl;
//   }
// }
void closetree_(){
  delete writer;
}
#endif





















