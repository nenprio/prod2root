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
  fNewTree->Branch("Ecls",&evtecls_,"necls/I:EclTrgw:EclFilfo:EclWord[8]:EclStream[8]:EclsTagNum[8]:EclEvType[8]");

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
  std::cout << evtinfo_.PhiD << std::endl;
  writer->FillTtree();
}

void closetree_(){
  delete writer;
}
#endif





















