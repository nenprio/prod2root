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
    // Block Tele
    addBlockTele();
    // Block Pizza
    addBlockPizza();
    // Block Clu
    addBlockClu();
    // Block PreClu
    addBlockPreClu();
    // Block CWRK
    addBlockCWRK();
    // Block Cele
    addBlockCele();
    // Block DTCE
    addBlockDTCE();
    // Block DTCE0
    addBlockDTCE0();
    // Block DHRE
    addBlockDHRE();
    // Block DHSP
    addBlockDHSP();

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

// Add to the tree all the branches realted to the block EVTTELE.
//
// input:	-
// output: -
void TreeWriter::addBlockTele() {
    fNewTree->Branch("NTele",   &tele_.NTele,    "NTele/I");
    fNewTree->Branch("Det_Trg", &tele_.Det_Trg,  "Det_Trg[NTele]/I");
    fNewTree->Branch("BitP",    &tele_.BitP,     "BitP[NTele]/I");
    fNewTree->Branch("Sector",  &tele_.Sector,   "Sector[NTele]/I");
    fNewTree->Branch("SerKind", &tele_.SerKind,  "SerKind[NTele]/I");
    fNewTree->Branch("Ea_Trg",  &tele_.Ea_Trg,   "Ea_Trg[NTele]/F");
    fNewTree->Branch("Eb_Trg",  &tele_.Eb_Trg,   "Eb_Trg[NTele]/F");
    fNewTree->Branch("Ta_Trg",  &tele_.Ta_Trg,   "Ta_Trg[NTele]/F");
    fNewTree->Branch("Tb_Trg",  &tele_.Tb_Trg,   "Tb_Trg[NTele]/F");
}

// Add to the tree all the branches realted to the block Pizza.
//
// input:	-
// output: -
void TreeWriter::addBlockPizza() {
    fNewTree->Branch("NPack",   &pizza_.NPack,   "NPack/I");
    fNewTree->Branch("PakSect", &pizza_.PakSect, "PakSect[NPack]/I");
    fNewTree->Branch("PakDet",  &pizza_.PakDet,  "PakDet[NPack]/I");
    fNewTree->Branch("PakSerk", &pizza_.PakSerk, "PakSerk[NPack]/I");
    fNewTree->Branch("Ea_Pack", &pizza_.Ea_Pack, "Ea_Pack[NPack]/F");
    fNewTree->Branch("Eb_Pack", &pizza_.Eb_Pack, "Eb_Pack[NPack]/F");
    fNewTree->Branch("E_Rec",   &pizza_.E_Rec,   "E_Rec[NPack]/F");
    fNewTree->Branch("Z_mod",   &pizza_.Z_mod,   "Z_mod[NPack]/F");
}

// Add to the tree all the branches related to the block T0.
//
// input:   -
// output:  -
void TreeWriter::addBlockTime() {
    fNewTree->Branch("TPhased_mc", &evttime_.TPhased_mc, "TPhased_mc/F");
    fNewTree->Branch("T0Dc0",      &evttime_.T0Dc0,      "T0Dc0/F");
    fNewTree->Branch("T0Hit0",     &evttime_.T0Hit0,     "T0Hit0/F");
    fNewTree->Branch("T0Clu0",     &evttime_.T0Clu0,     "T0Clu0/F");
    fNewTree->Branch("T0Step1",    &evttime_.T0Step1,    "T0Step1/F");
    fNewTree->Branch("DelayCable", &evttime_.DelayCable, "DelayCable/F");
    fNewTree->Branch("TBunch",     &evttime_.TBunch,     "TBunch/F");
}

// Add to the tree all the branches realted to the block Clu.
//
// input:   -
// output: -
void TreeWriter::addBlockClu() {
    fNewTree->Branch("NClu",   &evtclu_.NClu,   "NClu/I");
    fNewTree->Branch("EneCl",  &evtclu_.EneCl,  "EneCl[NClu]/F");
    fNewTree->Branch("TCl",    &evtclu_.TCl,    "TCl[NClu]/F");
    fNewTree->Branch("XCl",    &evtclu_.XCl,    "XCl[NClu]/F");
    fNewTree->Branch("YCl",    &evtclu_.YCl,    "YCl[NClu]/F");
    fNewTree->Branch("ZCl",    &evtclu_.ZCl,    "ZCl[NClu]/F");
    fNewTree->Branch("XaCl",   &evtclu_.XaCl,   "XaCl[NClu]/F");
    fNewTree->Branch("YaCl",   &evtclu_.YaCl,   "YaCl[NClu]/F");
    fNewTree->Branch("ZaCl",   &evtclu_.ZaCl,   "ZaCl[NClu]/F");
    fNewTree->Branch("XRmCl",  &evtclu_.XRmCl,  "XRmCl[NClu]/F");
    fNewTree->Branch("YRmsCl", &evtclu_.YRmsCl, "YRmsCl[NClu]/F");
    fNewTree->Branch("ZrmsCl", &evtclu_.ZrmsCl, "ZrmsCl[NClu]/F");
    fNewTree->Branch("TrmsCl", &evtclu_.TrmsCl, "TrmsCl[NClu]/F");
    fNewTree->Branch("FlagCl", &evtclu_.FlagCl, "FlagCl[NClu]/I");
    fNewTree->Branch("NCluMc", &evtclu_.NCluMc, "NCluMc/I");
    fNewTree->Branch("NPar",   &evtclu_.NPar,   "NPar[NCluMc]/I");
    fNewTree->Branch("PNum1",  &evtclu_.PNum1,  "PNum1[NCluMc]/I");
    fNewTree->Branch("Pid1",   &evtclu_.Pid1,   "Pid1[NCluMc]/I");
    fNewTree->Branch("PNum2",  &evtclu_.PNum2,  "PNum2[NCluMc]/I");
    fNewTree->Branch("Pid2",   &evtclu_.Pid2,   "Pid2[NCluMc]/I");
    fNewTree->Branch("PNum3",  &evtclu_.PNum3,  "PNum3[NCluMc]/I");
    fNewTree->Branch("Pid3",   &evtclu_.Pid3,   "Pid3[NCluMc]/I");
}

// Add to the tree all the branches realted to the block PreClu.
//
// input:	-
// output: -
void TreeWriter::addBlockPreClu() {
    fNewTree->Branch("NPClu",  &preclu_.NPClu,  "NPClu/I");
    fNewTree->Branch("EPre",   &preclu_.EPre,   "EPre[NPClu]/F");
    fNewTree->Branch("TPre",   &preclu_.TPre,   "TPre[NPClu]/F");
    fNewTree->Branch("XPre",   &preclu_.XPre,   "XPre[NPClu]/F");
    fNewTree->Branch("YPre",   &preclu_.YPre,   "YPre[NPClu]/F");
    fNewTree->Branch("ZPre",   &preclu_.ZPre,   "ZPre[NPClu]/F");
    fNewTree->Branch("TAPre",  &preclu_.TAPre,  "TAPre[NPClu]/F");
    fNewTree->Branch("TBPre",  &preclu_.TBPre,  "TBPre[NPClu]/F");
    fNewTree->Branch("TARPre", &preclu_.TARPre, "TARPre[NPClu]/F");
    fNewTree->Branch("TBRPre", &preclu_.TBRPre, "TBRPre[NPClu]/F");
}

// Add to the tree all the branches realted to the block CWRK.
//
// input:	-
// output: -
void TreeWriter::addBlockCWRK() {
    fNewTree->Branch("NCHit",   &cwrk_.NCHit,  "NCHit/I");
    fNewTree->Branch("IClu",    &cwrk_.IClu,   "IClu[NCHit]/I");
    fNewTree->Branch("ICel",    &cwrk_.ICel,   "ICel[NCHit]/I");
    fNewTree->Branch("CAdd",    &cwrk_.CAdd,   "CAdd[NCHit]/I");
    fNewTree->Branch("CmcHit",  &cwrk_.CmcHit, "CmcHit[NCHit]/I");
    fNewTree->Branch("Ckine",   &cwrk_.Ckine,  "Ckine[NCHit]/I");
    fNewTree->Branch("Ene",     &cwrk_.Ene,    "Ene[NCHit]/F");
    fNewTree->Branch("T",       &cwrk_.T,      "T[NCHit]/F");
    fNewTree->Branch("X",       &cwrk_.X,      "X[NCHit]/F");
    fNewTree->Branch("Y",       &cwrk_.Y,      "Y[NCHit]/F");
    fNewTree->Branch("Z",       &cwrk_.Z,      "Z[NCHit]/F");
}

// Add to the tree all the branches realted to the block Cele.
//
// input:	-
// output: -
void TreeWriter::addBlockCele() {
    fNewTree->Branch("NCel",    &cele_.NCel,    "NCel/I");
    fNewTree->Branch("ICl",     &cele_.ICl,     "ICl[NCel]/I");
    fNewTree->Branch("Det",     &cele_.Det,     "Det[NCel]/I");
    fNewTree->Branch("Wed",     &cele_.Wed,     "Wed[NCel]/I");
    fNewTree->Branch("Pla",     &cele_.Pla,     "Pla[NCel]/I");
    fNewTree->Branch("Col",     &cele_.Col,     "Col[NCel]/I");
    fNewTree->Branch("Ea",      &cele_.Ea,      "Ea[NCel]/F");
    fNewTree->Branch("Ta",      &cele_.Ta,      "Ta[NCel]/F");
    fNewTree->Branch("Eb",      &cele_.Eb,      "Eb[NCel]/F");
    fNewTree->Branch("Tb",      &cele_.Tb,      "Tb[NCel]/F");
    fNewTree->Branch("NCelMc",  &cele_.NCelMc,  "NCelMc/I");
    fNewTree->Branch("EMc",     &cele_.EMc,     "EMc[NCelMc]/F");
    fNewTree->Branch("TMc",     &cele_.TMc,     "TMc[NCelMc]/F");
    fNewTree->Branch("XMc",     &cele_.XMc,     "XMc[NCelMc]/F");
    fNewTree->Branch("YMc",     &cele_.YMc,     "YMc[NCelMc]/F");
    fNewTree->Branch("ZMc",     &cele_.ZMc,     "ZMc[NCelMc]/F");
    fNewTree->Branch("PTyp",    &cele_.PTyp,    "PTyp[NCelMc]/I");
    fNewTree->Branch("KNum",    &cele_.KNum,    "KNum[NCelMc]/I");
    fNewTree->Branch("NHit",    &cele_.NHit,    "NHit[NCelMc]/I");
}

// Add to the tree all the branches realted to the block DTCE.
//
// input:	-
// output: -
void TreeWriter::addBlockDTCE() {
    fNewTree->Branch("nDTCE", &dtce_.nDTCE, "nDTCE/I");
    fNewTree->Branch("nSmall", &dtce_.nSmall, "nSmall/I");
    fNewTree->Branch("iLayerDTCE", &dtce_.iLayerDTCE, "iLayerDTCE[nDTCE]/I");
    fNewTree->Branch("iWireDTCE", &dtce_.iWireDTCE, "iWireDTCE[nDTCE]/I");
    fNewTree->Branch("tDTCE", &dtce_.tDTCE, "tDTCE[nDTCE]/F");
}

// Add to the tree all the branches realted to the block DTCE0.
//
// input:	-
// output: -
void TreeWriter::addBlockDTCE0() {
    fNewTree->Branch("nDTCE0", &dtce0_.nDTCE0, "nDTCE0/I");
    fNewTree->Branch("iLayerDTCE0", &dtce0_.iLayerDTCE0, "iLayerDTCE0[nDTCE0]/I");
    fNewTree->Branch("iWireDTCE0", &dtce0_.iWireDTCE0, "iWireDTCE0[nDTCE0]/I");
    fNewTree->Branch("tDTCE0", &dtce0_.tDTCE0, "tDTCE0[nDTCE0]/F");
}

/ Add to the tree all the branches realted to the block DCNHITS.
//
// input:	-
// output: -
void TreeWriter::addBlockDCNHits() {
    fNewTree->Branch("nDCHR", &dcnhits_.nDCHR, "nDCHR/I");
    fNewTree->Branch("nSmallDCm", &dcnhits_.nSmallDCm, "nSmallDCm/I");
    fNewTree->Branch("nSmallDCp", &dcnhits_.nSmallDCp, "nSmallDCp/I");
    fNewTree->Branch("nBigDCm", &dcnhits_.nBigDCm, "nBigDCm/I");
    fNewTree->Branch("nBigDCp", &dcnhits_.nBigDCp, "nBigDCp/I");
    fNewTree->Branch("nCellDC", &dcnhits_.nCellDC, "nCellDC/I");
    fNewTree->Branch("nSmallDC", &dcnhits_.nSmallDC, "nSmallDC/I");
}

// Add to the tree all the branches realted to the block DHRE.
//
// input:	-
// output: -
void TreeWriter::addBlockDHRE() {
    fNewTree->Branch("nDHRE", &dhre_.nDHRE, "nDHRE/I");
    fNewTree->Branch("iLayerDHRE", &dhre_.iLayerDHRE, "iLayerDHRE[nDHRE]/I");
    fNewTree->Branch("iWireDHRE", &dhre_.iWireDHRE, "iWireDHRE[nDHRE]/I");
    fNewTree->Branch("iTrkDHRE", &dhre_.iTrkDHRE, "iTrkDHRE[nDHRE]/I");
    fNewTree->Branch("rDHRE", &dhre_.rDHRE, "rDHRE[nDHRE]/F");
    fNewTree->Branch("eDHRE", &dhre_.eDHRE, "eDHRE[nDHRE]/F");
}

// Add to the tree all the branches realted to the block DHSP.
//
// input:	-
// output: -
void TreeWriter::addBlockDHSP() {
    fNewTree->Branch("nDHSP", &dhsp_.nDHSP, "nDHSP/I");
    fNewTree->Branch("TrkDh", &dhsp_.TrkDh, "TrkDh[nDHSP]/I");
    fNewTree->Branch("Layer", &dhsp_.Layer, "Layer[nDHSP]/I");
    fNewTree->Branch("Wire", &dhsp_.Wire, "Wire[nDHSP]/I");
    fNewTree->Branch("Time", &dhsp_.Time, "Time[nDHSP]/F");
    fNewTree->Branch("DPar", &dhsp_.DPar, "DPar[nDHSP]/F");
    fNewTree->Branch("Res", &dhsp_.Res, "Res[nDHSP]/F");
    fNewTree->Branch("XDh", &dhsp_.XDh, "XDh[nDHSP]/F");
    fNewTree->Branch("YDh", &dhsp_.YDh, "YDh[nDHSP]/F");
    fNewTree->Branch("ZDh", &dhsp_.ZDh, "ZDh[nDHSP]/F");
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
