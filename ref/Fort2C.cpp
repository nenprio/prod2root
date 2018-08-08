#ifndef FORT2C_CXX
#define FORT2C_CXX
#include <iostream>
#include "Fort2C.hh"
#include <TROOT.h>
#include <TFile.h>
#include <TTree.h>
#include <TBranch.h>

void inittree_(){
   TFile *outfile = new TFile("sample.root","recreate");
   TTree *fNewTree = new TTree("sample","Event Infos");
   fNewTree->Branch("nrun",&elena_.bb,"nrun/I");
   outfile->Write();
   outfile->Close();
}
void fillntu_(){
  TFile *outfile = new TFile("sample.root","update");
    //    std::cout<<"run number "<<elena_.bb<<std::endl;
  TTree *tree = (TTree*)outfile->Get("sample");
  int nrun = -1000;
  tree->SetBranchAddress("nrun", &nrun);
  nrun=elena_.bb;
  tree->Fill();
  outfile->Write();
  outfile->Close();
}
#endif





















