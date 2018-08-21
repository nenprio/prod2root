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
  writer->FillTtree();
}

void closetree_(){
  delete writer;
}
#endif





















