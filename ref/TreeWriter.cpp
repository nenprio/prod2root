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
    // TODO: create a function printHeader()
    std::cout<<"Flags "<<sammenu_.bposFlag<<" "<<sammenu_.eclsFlag<<" "<<sammenu_.trigFlag<<" "<<sammenu_.c2trgFlag<<" "<<sammenu_.tellinaFlag<<" "<<sammenu_.pizzaFlag<<std::endl;
    
    // Block Info
    addBlockInfo();
    // Block Data
    addBlockData();
    // Block Time
    addBlockTime();
    // Block BPOS
    if(sammenu_.bposFlag) addBlockBPOS();
    // Block GdHit
    addBlockGdHit();
    // Block Ecl
    if(sammenu_.eclsFlag) addBlockEcl();
    // Block Trig
    if(sammenu_.trigFlag) addBlockTrig();
    // Block C2Trig
    if(sammenu_.c2trgFlag) addBlockC2Trig();
    // Block Tellina
    if(sammenu_.tellinaFlag) addBlockTellina();
    // Block Pizzetta
    if(sammenu_.pizzaFlag) addBlockPizzetta();
    // Block Torta
    addBlockTorta();
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
    fNewTree->Branch("nRun",    &evtinfo_.NumRun,   "NumRun/I");
    fNewTree->Branch("nEv",     &evtinfo_.NumEv,    "NumEv/I");
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
    fNewTree->Branch("nDTCE",       &eventinfo_.Ndtce_copy, "Ndtce/I");
    fNewTree->Branch("MCFlag",      &eventinfo_.McFlag,     "McFlag/I");
    fNewTree->Branch("iPos",        &eventinfo_.IPos,       "IPos/F");
    fNewTree->Branch("iEle",        &eventinfo_.IEle,       "IEle/F");
    fNewTree->Branch("Lumi",        &eventinfo_.Lumi,       "Lumi/F");
}

// Add to the tree all the branches related to the block Ecl.
//
// input:   -
// output:  -
void TreeWriter::addBlockEcl() {
    fNewTree->Branch("nEcls",     &evtecls_.NEcls,     "NEcls/I");
    fNewTree->Branch("EclStream", &evtecls_.EclStream, "EclStream[NEcls]/I");
    fNewTree->Branch("EclTrgw",   &evtecls_.EclTrgw,   "EclTrgw/I");
    fNewTree->Branch("EclFilfo",  &evtecls_.EclFilfo,  "EclFilfo/I");
    fNewTree->Branch("EclWord",   &evtecls_.EclWord,   "EclWord[NEcls]/I");
    fNewTree->Branch("EclTagNum", &evtecls_.EclTagNum, "EclTagNum[NEcls]/I");
    fNewTree->Branch("EclEvType", &evtecls_.EclEvType, "EclEvType[NEcls]/I");
    fNewTree->Branch("nEcls2",    &evtecls_.NEcls2,     "NEcls2/I");
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
    fNewTree->Branch("DTCEHit",   &evtgdhit_.DtceHit,    "DtceHit/I");
    fNewTree->Branch("DHREHit",   &evtgdhit_.DhreHit,    "DhreHit/I");
    fNewTree->Branch("DPRSHit",   &evtgdhit_.DprsHit,    "DprsHit/I");
    fNewTree->Branch("DTFSHit",   &evtgdhit_.DtfsHit,    "DtfsHit/I");
}

// Add to the tree all the branches realted to the block EVTTRIG.
//
// input:	-
// output: -
void TreeWriter::addBlockTrig() {
    fNewTree->Branch("TrgW1", &evttrig_.Trgw1, "Trgw1/I");
    fNewTree->Branch("TrgW2", &evttrig_.Trgw2, "Trgw2/I");
}

// Add to the tree all the branches realted to the block EVTC2TRIG.
//
// input:	-
// output: -
void TreeWriter::addBlockC2Trig() {
    fNewTree->Branch("nSec", &evtc2trig_.NSec, "NSec/I");
    fNewTree->Branch("nSec_NoClu", &evtc2trig_.NSec_NoClu, "NSec_NoClu/I");
    fNewTree->Branch("nSec2Clu", &evtc2trig_.NSec2Clu, "NSec2Clu/I");
    fNewTree->Branch("nClu2s", &evtc2trig_.NClu2s, "NClu2s/I");
    fNewTree->Branch("nNorm", &evtc2trig_.NNorm, "NNorm[NClu2s]/I");
    fNewTree->Branch("NormAdd", &evtc2trig_.NormAdd, "NormAdd[NClu2s]/I");
    fNewTree->Branch("nOver", &evtc2trig_.NOver, "NOver[NClu2s]/I");
    fNewTree->Branch("OverAdd", &evtc2trig_.OverAdd, "OverAdd[NClu2s]/I");
    fNewTree->Branch("nCosm", &evtc2trig_.NCosm, "NCosm[NClu2s]/I");
    fNewTree->Branch("CosmAdd", &evtc2trig_.CosmAdd, "CosmAdd[NClu2s]/I");
}

// Add to the tree all the branches realted to the block TELLINA.
//
// input:	-
// output: -
void TreeWriter::addBlockTellina() {
    fNewTree->Branch("nTel",     &tellina_.NTel,     "NTel/I");
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
    fNewTree->Branch("nPiz",    &pizzetta_.NPiz,    "NPiz/I");
    fNewTree->Branch("Add_Piz", &pizzetta_.Add_Piz, "Add_Piz[NPiz]/I");
    fNewTree->Branch("Ea_Piz",  &pizzetta_.Ea_Piz,  "Ea_Piz[NPiz]/F");
    fNewTree->Branch("Eb_Piz",  &pizzetta_.Eb_Piz,  "Eb_Piz[NPiz]/F");
    fNewTree->Branch("E_Piz",   &pizzetta_.E_Piz,   "E_Piz[NPiz]/F");
    fNewTree->Branch("Z_Piz",   &pizzetta_.Z_Piz,   "Z_Piz[NPiz]/F");
}

// Add to the tree all the branches realted to the block Torta.
//
// input:	-
// output: -
void TreeWriter::addBlockTorta() {
    fNewTree->Branch("tSpent", &torta_.tSpent, "tSpent/F");
    fNewTree->Branch("tDead",  &torta_.tDead,  "tDead/F");
    fNewTree->Branch("Type",   &torta_.Type,   "Type/I");
    fNewTree->Branch("BPhi",   &torta_.BPhi,   "BPhi/I");
    fNewTree->Branch("EPhi",   &torta_.EPhi,   "EPhi/I");
    fNewTree->Branch("WPhi",   &torta_.WPhi,   "WPhi/I");
    fNewTree->Branch("BBha",   &torta_.BBha,   "BBha/I");
    fNewTree->Branch("EBha",   &torta_.EBha,   "EBha/I");
    fNewTree->Branch("WBha",   &torta_.WBha,   "WBha/I");
    fNewTree->Branch("BCos",   &torta_.BCos,   "BCos/I");
    fNewTree->Branch("ECos",   &torta_.ECos,   "ECos/I");
    fNewTree->Branch("WCos",   &torta_.WCos,   "WCos/I");
    fNewTree->Branch("E1W1_Dwn",   &torta_.E1W1_Dwn,   "E1W1_Dwn/I");
    fNewTree->Branch("B1_Dwn",     &torta_.B1_Dwn,     "B1_Dwn/I");
    fNewTree->Branch("T0d_Dwn",    &torta_.T0d_Dwn,    "T0d_Dwn/I");
    fNewTree->Branch("VetoCos",    &torta_.VetoCos,    "VetoCos/I");
    fNewTree->Branch("VetoBha",    &torta_.VetoBha,    "VetoBha/I");
    fNewTree->Branch("Bdw",        &torta_.Bdw,        "Bdw/I");
    fNewTree->Branch("Rephasing",  &torta_.Rephasing,  "Rephasing/I");
    fNewTree->Branch("TDC1_Pht1",  &torta_.TDC1_Pht1,  "TDC1_Pht1/I");
    fNewTree->Branch("Dt2_T1",     &torta_.Dt2_T1,     "Dt2_T1/I");
    fNewTree->Branch("Fiducial",   &torta_.Fiducial,   "Fiducial/I");
    fNewTree->Branch("T1c",        &torta_.T1c,        "T1c/I");
    fNewTree->Branch("T1d",        &torta_.T1d,        "T1d/I");
    fNewTree->Branch("T2d",        &torta_.T2d,        "T2d/I");
    fNewTree->Branch("Tcr",        &torta_.Tcr,        "Tcr/I");
    fNewTree->Branch("TCaf_Tcrd",  &torta_.TCaf_Tcrd,  "TCaf_Tcrd/I");
    fNewTree->Branch("TCaf_T2d",   &torta_.TCaf_T2d,   "TCaf_T2d/I");
    fNewTree->Branch("Moka_T2d",   &torta_.Moka_T2d,   "Moka_T2d/I");
    fNewTree->Branch("Moka_T2Dsl", &torta_.Moka_T2Dsl, "Moka_T2Dsl/I");
}

// Add to the tree all the branches realted to the block EVTTELE.
//
// input:	-
// output: -
void TreeWriter::addBlockTele() {
    fNewTree->Branch("nTele",   &tele_.NTele,    "NTele/I");
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
    fNewTree->Branch("nPack",   &pizza_.NPack,   "NPack/I");
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
    fNewTree->Branch("TPhased_MC", &evttime_.TPhased_mc, "TPhased_mc/F");
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
    fNewTree->Branch("nClu",   &evtclu_.NClu,   "NClu/I");
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
    fNewTree->Branch("nCluMC", &evtclu_.NCluMc, "NCluMc/I");
    fNewTree->Branch("nPar",   &evtclu_.NPar,   "NPar[NCluMc]/I");
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
    fNewTree->Branch("nPClu",  &preclu_.NPClu,  "NPClu/I");
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
    fNewTree->Branch("nCHit",   &cwrk_.NCHit,  "NCHit/I");
    fNewTree->Branch("iClu",    &cwrk_.IClu,   "IClu[NCHit]/I");
    fNewTree->Branch("iCel",    &cwrk_.ICel,   "ICel[NCHit]/I");
    fNewTree->Branch("CAdd",    &cwrk_.CAdd,   "CAdd[NCHit]/I");
    fNewTree->Branch("CMCHit",  &cwrk_.CmcHit, "CmcHit[NCHit]/I");
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
    fNewTree->Branch("nCel",    &cele_.NCel,    "NCel/I");
    fNewTree->Branch("iCl",     &cele_.ICl,     "ICl[NCel]/I");
    fNewTree->Branch("Det",     &cele_.Det,     "Det[NCel]/I");
    fNewTree->Branch("Wed",     &cele_.Wed,     "Wed[NCel]/I");
    fNewTree->Branch("Pla",     &cele_.Pla,     "Pla[NCel]/I");
    fNewTree->Branch("Col",     &cele_.Col,     "Col[NCel]/I");
    fNewTree->Branch("Ea",      &cele_.Ea,      "Ea[NCel]/F");
    fNewTree->Branch("Ta",      &cele_.Ta,      "Ta[NCel]/F");
    fNewTree->Branch("Eb",      &cele_.Eb,      "Eb[NCel]/F");
    fNewTree->Branch("Tb",      &cele_.Tb,      "Tb[NCel]/F");
    fNewTree->Branch("nCelMc",  &cele_.NCelMc,  "NCelMc/I");
    fNewTree->Branch("EMc",     &cele_.EMc,     "EMc[NCelMc]/F");
    fNewTree->Branch("TMc",     &cele_.TMc,     "TMc[NCelMc]/F");
    fNewTree->Branch("XMc",     &cele_.XMc,     "XMc[NCelMc]/F");
    fNewTree->Branch("YMc",     &cele_.YMc,     "YMc[NCelMc]/F");
    fNewTree->Branch("ZMc",     &cele_.ZMc,     "ZMc[NCelMc]/F");
    fNewTree->Branch("PTyp",    &cele_.PTyp,    "PTyp[NCelMc]/I");
    fNewTree->Branch("KNum",    &cele_.KNum,    "KNum[NCelMc]/I");
    fNewTree->Branch("nHit",    &cele_.NHit,    "NHit[NCelMc]/I");
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

// Add to the tree all the branches realted to the block DCHits.
//
// input:	-
// output: -
void TreeWriter::addBlockDCHits() {
    fNewTree->Branch("nDCHR", &dchits_.nDCHR, "nDCHR/I");
    fNewTree->Branch("nSmallDCm", &dchits_.nSmallDCm, "nSmallDCm/I");
    fNewTree->Branch("nSmallDCp", &dchits_.nSmallDCp, "nSmallDCp/I");
    fNewTree->Branch("nBigDCm", &dchits_.nBigDCm, "nBigDCm/I");
    fNewTree->Branch("nBigDCp", &dchits_.nBigDCp, "nBigDCp/I");
    fNewTree->Branch("nCellDC", &dchits_.nCellDC, "nCellDC/I");
    fNewTree->Branch("nSmallDC", &dchits_.nSmallDC, "nSmallDC/I");
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

// Add to the tree all the branches realted to the block TrkV.
//
// input:	-
// output: -
void TreeWriter::addBlockTrkV() {
    fNewTree->Branch("nTv",     &trkv_.nTv,     "nTv/I");
    fNewTree->Branch("iV",      &trkv_.iV,      "iV[nTv]/I");
    fNewTree->Branch("TrkNumV", &trkv_.TrkNumV, "TrkNumV[nTv]/I");
    fNewTree->Branch("CurV",    &trkv_.CurV,    "CurV[nTv]/F");
    fNewTree->Branch("PhiV",    &trkv_.PhiV,    "PhiV[nTv]/F");
    fNewTree->Branch("CoTv",    &trkv_.CoTv,    "CoTv[nTv]/F");
    fNewTree->Branch("PxTv",    &trkv_.PxTv,    "PxTv[nTv]/F");
    fNewTree->Branch("PyTv",    &trkv_.PyTv,    "PyTv[nTv]/F");
    fNewTree->Branch("PzTv",    &trkv_.PzTv,    "PzTv[nTv]/F");
    fNewTree->Branch("pModV",   &trkv_.pModV,   "pModV[nTv]/F");
    fNewTree->Branch("LenV",    &trkv_.LenV,    "LenV[nTv]/F");
    fNewTree->Branch("ChiV",    &trkv_.ChiV,    "ChiV[nTv]/F");
    fNewTree->Branch("PidTv",   &trkv_.PidTv,   "PidTv[nTv]/I");
    fNewTree->Branch("Cov11Tv", &trkv_.Cov11Tv, "Cov11Tv[nTv]/F");
    fNewTree->Branch("Cov12Tv", &trkv_.Cov12Tv, "Cov12Tv[nTv]/F");
    fNewTree->Branch("Cov13Tv", &trkv_.Cov13Tv, "Cov13Tv[nTv]/F");
    fNewTree->Branch("Cov22Tv", &trkv_.Cov22Tv, "Cov22Tv[nTv]/F");
    fNewTree->Branch("Cov23Tv", &trkv_.Cov23Tv, "Cov23Tv[nTv]/F");
    fNewTree->Branch("Cov33Tv", &trkv_.Cov33Tv, "Cov33Tv[nTv]/F");
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
