#include <iostream>
#include <TROOT.h>
#include <TBranch.h>
#include <TTree.h>
#include "TreeWriter.hh"
#include "Struct.hh"
#include <typeinfo>

// Creates the TreeWriter object, opens/creates output file
// and initializes the TTree structure.
//
// input:   -
// return:  -
TreeWriter::TreeWriter() {
    outfile  = new TFile("sample.root", "recreate");    //Open or create file 
    fNewTree = new TTree("sample", "Event Infos");      //Create "sample" tree

   
    // Block Info
    addBlockInfo();
    // Block Data
    addBlockData();
    // Block Ecl
    addBlockEcl();
    // Block BPOS
    addBlockBPOS();
    // Block Time
    addBlockTime();

    // Write to the disk
    outfile->Write();
}

// Closes output file and deallocates variables from memory.
//
// input:   -
// return:  -
TreeWriter::~TreeWriter() {
    if(fNewTree){
      delete fNewTree;
      fNewTree = NULL;
    }

    if(outfile) {
        outfile->Write(0,TObject::kOverwrite);
        outfile->Close();
        delete outfile;
	outfile = NULL;
    }
}

// Add to the tree all the branches related to the block Info.
//
// input:   -
// output:  -
void TreeWriter::addBlockInfo() {
    fNewTree->Branch("NRun",    &evtinfo_.NumRun,   "NumRun/I");
    fNewTree->Branch("NEv",     &evtinfo_.NumEv,    "NumEv/I");
    fNewTree->Branch("Pileup",  &evtinfo_.Pileup,   "Pileup/I");
    fNewTree->Branch("GCod",    &evtinfo_.GCod,     "GCod/I");
    fNewTree->Branch("PhiD",    &evtinfo_.PhiD,     "PhiD/I");
    fNewTree->Branch("A1Typ",   &evtinfo_.A1Typ,    "A1Typ/I");
    fNewTree->Branch("A2Typ",   &evtinfo_.A2Typ,    "A2Typ/I");
    fNewTree->Branch("A3Typ",   &evtinfo_.A3Typ,    "A3Typ/I");
    fNewTree->Branch("B1Typ",   &evtinfo_.B1Typ,    "B1Typ/I");
    fNewTree->Branch("B2Typ",   &evtinfo_.B2Typ,    "B2Typ/I");
    fNewTree->Branch("B3Typ",   &evtinfo_.B3Typ,    "B3Typ/I");
}

// Add to the tree all the branches related to the block Data.
//
// input:   -
// output:  -
void TreeWriter::addBlockData() {
    fNewTree->Branch("StreamNum",   &eventinfo_.StreamNum,  "StreamNum/I");
    fNewTree->Branch("AlgoNum",     &eventinfo_.AlgoNum,    "AlgoNum/I");
    fNewTree->Branch("TimeSec",     &eventinfo_.TimeSec,    "TimeSec/I");
    fNewTree->Branch("TimeMusec",   &eventinfo_.TimeMusec,  "TimeMusec/I");
    fNewTree->Branch("Ndtce",       &eventinfo_.Ndtce,      "Ndtce/I");
    fNewTree->Branch("McFlag",      &eventinfo_.McFlag,     "McFlag/I");
    fNewTree->Branch("IPos",        &eventinfo_.IPos,       "IPos/F");
    fNewTree->Branch("IEle",        &eventinfo_.IEle,       "IEle/F");
    fNewTree->Branch("Lumi",        &eventinfo_.Lumi,       "Lumi/F");
}

// Add to the tree all the branches related to the block Ecl.
//
// input:   -
// output:  -
void TreeWriter::addBlockEcl() {
    fNewTree->Branch("NEcls",     &evtecls_.NEcls,     "NEcls/I");
    fNewTree->Branch("EclStream", &evtecls_.EclStream, "EclStream[NEcls]/I");
    fNewTree->Branch("EclTrgw",   &evtecls_.EclTrgw,   "EclTrgw/I");
    fNewTree->Branch("EclFilfo",  &evtecls_.EclFilfo,  "EclFilfo/I");
    fNewTree->Branch("EclWord",   &evtecls_.EclWord,   "EclWord[NEcls]/I");
    fNewTree->Branch("EclTagNum", &evtecls_.EclTagNum, "EclTagNum[NEcls]/I");
    fNewTree->Branch("EclEvType", &evtecls_.EclEvType, "EclEvType[NEcls]/I");
}

// Add to the tree all the branches related to the block BPOS.
//
// input:   -
// output:  -
void TreeWriter::addBlockBPOS() {
    fNewTree->Branch("BPx",     &evtbpos_.BPx,      "BPx/F");
    fNewTree->Branch("BPy",     &evtbpos_.BPy,      "BPy/F");
    fNewTree->Branch("BPz",     &evtbpos_.BPz,      "BPz/F");
    fNewTree->Branch("Bx",      &evtbpos_.Bx,       "Bx/F");
    fNewTree->Branch("By",      &evtbpos_.By,       "By/F");
    fNewTree->Branch("Bz",      &evtbpos_.Bz,       "Bz/F");
    fNewTree->Branch("BWidPx",  &evtbpos_.BWidPx,   "BWidPx/F");
    fNewTree->Branch("BWidPy",  &evtbpos_.BWidPy,   "BWidPy/F");
    fNewTree->Branch("BWidPz",  &evtbpos_.BWidPz,   "BWidPz/F");
    fNewTree->Branch("BSx",     &evtbpos_.BSx,      "BSx/F");
    fNewTree->Branch("BSy",     &evtbpos_.BSy,      "BSy/F");
    fNewTree->Branch("BSz",     &evtbpos_.BSz,      "BSz/F");
    fNewTree->Branch("BLumx",   &evtbpos_.BLumx,    "BLumx/F");
    fNewTree->Branch("BLumz",   &evtbpos_.BLumz,    "BLumz/F");
}

// Add to the tree all the branches related to the block DGHIT.
//
// input:   -
// output:  -
void TreeWriter::addBlockTime() {
    fNewTree->Branch("TPhased_mc", &evttime_.TPhased_mc, "TPhased_mc/F");
    fNewTree->Branch("T0Dc0", &evttime_.T0Dc0, "T0Dc0/F");
    fNewTree->Branch("T0Hit0", &evttime_.T0Hit0, "T0Hit0/F");
    fNewTree->Branch("T0Clu0", &evttime_.T0Clu0, "T0Clu0/F");
    fNewTree->Branch("T0Step1", &evttime_.T0Step1, "T0Step1/F");
    fNewTree->Branch("DelayCable", &evttime_.DelayCable, "DelayCable/F");
    fNewTree->Branch("TBunch", &evttime_.TBunch, "TBunch/F");
}

// Returns the output file object.
//
// input:   -
// output:  output TFile 
TFile* TreeWriter::getTFile() {
    return outfile;
}

// Fills the Tree with event infos.
//
// input:   -
// output:  -
void TreeWriter::fillTTree() {
    TTree *tree = (TTree*)outfile->Get("sample");
    tree->Fill();
}
