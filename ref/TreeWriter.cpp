#include <iostream>
#include <TROOT.h>
#include <TBranch.h>
#include <TTree.h>
#include <TBranch.h>
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

    // General Block
    fNewTree->Branch("nRun", &elena_.bb, "nRun/I");
    fNewTree->Branch("Info", &evtinfo_, "RunNumber/I:EventNumber:Pileup:GenCod:PhiDecay:A1type:A2Type:A3type:B1type:B2type:B3type");
    fNewTree->Branch("Data", &eventinfo_, "StreamNum/I:AlgoNum:TimeSec:TimeMusec:Ndtce:Mcflag_tg:Currpos/F:Currele:Luminosity");
   
    // Ecl Block
    addBlockEcl();

    // Write to the disk
    outfile->Write();
}

// Closes output file and deallocates variables from memory.
//
// input:   -
// return:  -
TreeWriter::~TreeWriter() {
    /* std::cout << "Destructor " << std::endl; */
    if(outfile) {
        outfile->Write(0,TObject::kOverwrite);
        outfile->Close();
        delete outfile;
    }
    if(fNewTree){
        delete fNewTree;
    }
}

// Add to the tree all the branches related to the block Ecl.
//
// input:   -
// output:  -
void TreeWriter::addBlockEcl() {
    fNewTree->Branch("necls",     &evtecls_.necls,     "necls/I");
    fNewTree->Branch("EclStream", &evtecls_.EclStream, "EclStream[necls]/I");
    fNewTree->Branch("EclTrgw",   &evtecls_.EclTrgw,   "EclTrgw/I");
    fNewTree->Branch("EclFilfo",  &evtecls_.EclFilfo,  "EclFilfo/I");
    fNewTree->Branch("EclWord",   &evtecls_.EclWord,   "EclWord[necls]/I");
    fNewTree->Branch("EclTagNum", &evtecls_.EclTagNum, "EclTagNum[necls]/I");
    fNewTree->Branch("EclEvType", &evtecls_.EclEvType, "EclEvType[necls]/I");
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
    /* std::cout <<"CC " << elena_.bb << std::endl; */
    tree->Fill();
}
