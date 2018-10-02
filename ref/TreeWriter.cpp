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
    // Block Time
    addBlockTime();
    // Block BPOS
    addBlockBPOS();
    // Block GdHit
    addBlockGdHit();
    // Block Ecl
    addBlockEcl();
    // Block Trig
    addBlockTrig();
    // Block C2Trig
    addBlockC2Trig();
    // Block Tellina
    addBlockTellina();
    // Block Pizzetta
    addBlockPizzetta();

    // Write to the disk
    outfile->Write();
}

// Closes output file and deallocates variables from memory.
//
// input:   -
// return:  -
TreeWriter::~TreeWriter() {
    /* if(fNewTree){ */
      /* delete fNewTree; */
      /* fNewTree = NULL; */
    /* } */

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
    fNewTree->Branch("NEcls2",    &evtecls_.NEcls2,     "NEcls2/I");
    fNewTree->Branch("EclStream2",&evtecls_.EclStream2, "EclStream2[NEcls2]/I");
    fNewTree->Branch("EclTrgw2",  &evtecls_.EclTrgw2,   "EclTrgw2/I");
    fNewTree->Branch("EclFilfo2", &evtecls_.EclFilfo2,  "EclFilfo2/I");
    fNewTree->Branch("EclWord2",  &evtecls_.EclWord2,   "EclWord2[NEcls2]/I");
    fNewTree->Branch("EclTagNum2",&evtecls_.EclTagNum2, "EclTagNum2[NEcls2]/I");
    fNewTree->Branch("EclEvType2",&evtecls_.EclEvType2, "EclEvType2[NEcls2]/I");
}

// Add to the tree all the branches related to the block BPOS.
//
// input:   -
// output:  -
void TreeWriter::addBlockBPOS() {
    fNewTree->Branch("BPx",       &evtbpos_.BPx,      "BPx/F");
    fNewTree->Branch("BPy",       &evtbpos_.BPy,      "BPy/F");
    fNewTree->Branch("BPz",       &evtbpos_.BPz,      "BPz/F");
    fNewTree->Branch("Bx",        &evtbpos_.Bx,       "Bx/F");
    fNewTree->Branch("By",        &evtbpos_.By,       "By/F");
    fNewTree->Branch("Bz",        &evtbpos_.Bz,       "Bz/F");
    fNewTree->Branch("BWidPx",    &evtbpos_.BWidPx,   "BWidPx/F");
    fNewTree->Branch("BWidPy",    &evtbpos_.BWidPy,   "BWidPy/F");
    fNewTree->Branch("BWidPz",    &evtbpos_.BWidPz,   "BWidPz/F");
    fNewTree->Branch("BSx",       &evtbpos_.BSx,      "BSx/F");
    fNewTree->Branch("BSy",       &evtbpos_.BSy,      "BSy/F");
    fNewTree->Branch("BSz",       &evtbpos_.BSz,      "BSz/F");
    fNewTree->Branch("BLumx",     &evtbpos_.BLumx,    "BLumx/F");
    fNewTree->Branch("BLumz",     &evtbpos_.BLumz,    "BLumz/F");
    fNewTree->Branch("Broots",    &evtbpos_.Broots,   "Broots/F");
    fNewTree->Branch("BrootsErr", &evtbpos_.BrootsErr,"BrootsErr/F");
}

// Add to the tree all the branches related to the block BPOS.
//
// input:   -
// output:  -
void TreeWriter::addBlockGdHit() {
    fNewTree->Branch("DtceHit",   &evtgdhit_.DtceHit,    "DtceHit/I");
    fNewTree->Branch("DhreHit",   &evtgdhit_.DhreHit,    "DhreHit/I");
    fNewTree->Branch("DprsHit",   &evtgdhit_.DprsHit,    "DprsHit/I");
    fNewTree->Branch("DtfsHit",   &evtgdhit_.DtfsHit,    "DtfsHit/I");
}

// Add to the tree all the branches realted to the block EVTTRIG.
//
// input:	-
// output: -
void TreeWriter::addBlockTrig() {
    fNewTree->Branch("Trgw1", &evttrig_.Trgw1, "Trgw1/I");
    fNewTree->Branch("Trgw2", &evttrig_.Trgw2, "Trgw2/I");
}

// Add to the tree all the branches realted to the block EVTC2TRIG.
//
// input:	-
// output: -
void TreeWriter::addBlockC2Trig() {
    fNewTree->Branch("NSec", &evtc2trig_.NSec, "NSec/I");
    fNewTree->Branch("NSec_NoClu", &evtc2trig_.NSec_NoClu, "NSec_NoClu/I");
    fNewTree->Branch("NSec2Clu", &evtc2trig_.NSec2Clu, "NSec2Clu/I");
    fNewTree->Branch("NClu2s", &evtc2trig_.NClu2s, "NClu2s/I");
    fNewTree->Branch("NNorm", &evtc2trig_.NNorm, "NNorm[NClu2s]/I");
    fNewTree->Branch("NormAdd", &evtc2trig_.NormAdd, "NormAdd[NClu2s]/I");
    fNewTree->Branch("NOver", &evtc2trig_.NOver, "NOver[NClu2s]/I");
    fNewTree->Branch("OverAdd", &evtc2trig_.OverAdd, "OverAdd[NClu2s]/I");
    fNewTree->Branch("NCosm", &evtc2trig_.NCosm, "NCosm[NClu2s]/I");
    fNewTree->Branch("CosmAdd", &evtc2trig_.CosmAdd, "CosmAdd[NClu2s]/I");
}

// Add to the tree all the branches realted to the block TELLINA.
//
// input:	-
// output: -
void TreeWriter::addBlockTellina() {
    fNewTree->Branch("NTel",     &tellina_.NTel,     "NTel/I");
    fNewTree->Branch("Add_Tel",  &tellina_.Add_Tel,  "Add_Tel[NTel]/I");
    fNewTree->Branch("Bitp_Tel", &tellina_.Bitp_Tel, "Bitp_Tel[NTel]/I");
    fNewTree->Branch("Ea_Tel",   &tellina_.Ea_Tel,   "Ea_Tel[NTel]/F");
    fNewTree->Branch("Eb_Tel",   &tellina_.Eb_Tel,   "Eb_Tel[NTel]/F");
    fNewTree->Branch("Ta_Tel",   &tellina_.Ta_Tel,   "Ta_Tel[NTel]/F");
    fNewTree->Branch("Tb_Tel",   &tellina_.Tb_Tel,   "Tb_Tel[NTel]/F");
}

// Add to the tree all the branches realted to the block PIZZETTA.
//
// input:	-
// output: -
void TreeWriter::addBlockPizzetta() {
    fNewTree->Branch("NPiz",    &pizzetta_.NPiz,    "NPiz/I");
    fNewTree->Branch("Add_Piz", &pizzetta_.Add_Piz, "Add_Piz[NPiz]/I");
    fNewTree->Branch("Ea_Piz",  &pizzetta_.Ea_Piz,  "Ea_Piz[NPiz]/F");
    fNewTree->Branch("Eb_Piz",  &pizzetta_.Eb_Piz,  "Eb_Piz[NPiz]/F");
    fNewTree->Branch("E_Piz",   &pizzetta_.E_Piz,   "E_Piz[NPiz]/F");
    fNewTree->Branch("Z_Piz",   &pizzetta_.Z_Piz,   "Z_Piz[NPiz]/F");
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
