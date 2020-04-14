#include <iostream>
#include <TROOT.h>
#include <TSystem.h>
#include <TBranch.h>
#include <TTree.h>
#include "TreeWriter.hh"
#include "Struct.hh"
#include <TObjectTable.h>
#include <typeinfo>
#include <cstdlib>
#include <cstdio>
#include <stdlib.h>
#include <stdio.h>

int count = 0;
// Creates the TreeWriter object, opens/creates output file
// and initializes the TTree structure.
//
// input:   -
// return:  -
TreeWriter::TreeWriter() {
  char *filename = getenv("OUTFILE");
  std::cout<<"envim " << filename << std::endl;
  if(filename == NULL){
    std::cout<<"mal"<<std::endl;
    outfile  = new TFile("sample.root", "recreate");    //Open or create file
}
  else{
    std::cout<<"bien"<<std::endl;
    outfile  = new TFile(filename, "recreate");    //Open or create file
  }
  fNewTree = new TTree("sample", "Event Infos");      //Create "sample" tree
  outfile->SetCompressionLevel(2);//from 0 = no-compresion to 9-maximum gzip
  //fNewTree->SetMaxTreeSize(1000*Long64_t(2000000000)); 
  //8GB maximum
  fNewTree->SetMaxTreeSize(1000*Long64_t(8000000)); 

  
    // Block Info
    if(logicalToBool(sammenu_.infoFlag))        addBlockInfo();
    // Block Data
    if(logicalToBool(sammenu_.dataFlag))        addBlockData();
    // Block BPOS
    if(logicalToBool(sammenu_.bposFlag))        addBlockBPOS();
    // Block GdHit
    if(logicalToBool(sammenu_.gdhitFlag))       addBlockGdHit();
    // Block Ecl
    if(logicalToBool(sammenu_.eclsFlag))        addBlockEcl();
    // Block Trig
    if(logicalToBool(sammenu_.trigFlag))        addBlockTrig();
    // Block C2Trig
    if(logicalToBool(sammenu_.c2trgFlag))       addBlockC2Trig();
    // Block Tellina
    if(logicalToBool(sammenu_.tellinaFlag))     addBlockTellina();
    // Block Pizzetta
    if(logicalToBool(sammenu_.pizzettaFlag))    addBlockPizzetta();
    // Block Torta
    if(logicalToBool(sammenu_.tortaFlag))       addBlockTorta();
    // Block Tele
    if(logicalToBool(sammenu_.teleFlag))        addBlockTele();
    // Block Pizza
    if(logicalToBool(sammenu_.pizzaFlag))       addBlockPizza();
    // Block Time
    if(logicalToBool(sammenu_.timeFlag))        addBlockTime();
    // Block Clu
    if(logicalToBool(sammenu_.clusFlag))        addBlockClu();
    // Block PreClu
    if(logicalToBool(sammenu_.preclusFlag))     addBlockPreClu();
    // Block CWRK
    if(logicalToBool(sammenu_.cwrkFlag))        addBlockCWRK();
    // Block Cele
    if(logicalToBool(sammenu_.celeFlag))        addBlockCele();
    // Block DTCE
    if(logicalToBool(sammenu_.dtceFlag))        addBlockDTCE();
    // Block DTCE0
    if(logicalToBool(sammenu_.dtce0Flag))       addBlockDTCE0();
    // Block DCHITS
    if(logicalToBool(sammenu_.dchitsFlag))      addBlockDCHits();
    // Block DHRE
    if(logicalToBool(sammenu_.dhreFlag))        addBlockDHRE();
    // Block DHSP
    if(logicalToBool(sammenu_.dhspFlag))        addBlockDHSP();
    // Block TrkV
    if(logicalToBool(sammenu_.trkvFlag))        addBlockTrkV();
    // Block Vtx
    if(logicalToBool(sammenu_.vtxFlag))         addBlockVtx();
    // Block Trks
    if(logicalToBool(sammenu_.trksFlag))        addBlockTrkS();
    // Block TrkOld
    if(logicalToBool(sammenu_.trkvOldFlag))     addBlockTrkVOld();
    // Block VtxOld
    if(logicalToBool(sammenu_.vtxOldFlag))      addBlockVtxOld();
    // Block TrkOld
    if(logicalToBool(sammenu_.trksOldFlag))     addBlockTrkSOld();
    // Block DHIT
    if(logicalToBool(sammenu_.dhitFlag))        addBlockDHIT();
    // Block DEDx
    if(logicalToBool(sammenu_.dedxFlag))        addBlockDEDx();
    // Block DPRS
    if(logicalToBool(sammenu_.dprsFlag))        addBlockDPRS();
    // Block MC
    // TODO: Change name MC to GEANFI to avoid trubles with montecarloflag
    if(logicalToBool(sammenu_.geanfiFlag))      addBlockMC();
    // Block TCLO
    if(logicalToBool(sammenu_.tcloFlag))        addBlockTCLO();
    // Block TCLOld
    if(logicalToBool(sammenu_.tcloldFlag))      addBlockTCLOld();
    // Block CFHI
    if(logicalToBool(sammenu_.cfhiFlag))        addBlockCFHI();
    // Block QIHI
    if(logicalToBool(sammenu_.qihiFlag))        addBlockQIHI();
    // Block TRKQ
    if(logicalToBool(sammenu_.trkqFlag))        addBlockTRKQ();
    // Block QELE
    if(logicalToBool(sammenu_.qeleFlag))        addBlockQELE();
    // Block QCal
    if(logicalToBool(sammenu_.qcalFlag))        addBlockQCal();
    // Block KNVO
    if(logicalToBool(sammenu_.knvoFlag))        addBlockKNVO();
    // Block VNVO
    if(logicalToBool(sammenu_.vnvoFlag))        addBlockVNVO();
    // Block VNVB
    if(logicalToBool(sammenu_.vnvbFlag))        addBlockVNVB();
    // Block INVO
    if(logicalToBool(sammenu_.invoFlag))        addBlockINVO();
    // Block ECLO 
    if(logicalToBool(sammenu_.ecloFlag))        addBlockECLO();
    // Block CSPS 
    if(logicalToBool(sammenu_.cspsFlag))        addBlockCSPS();
    // Block CLUO 
    if(logicalToBool(sammenu_.cluoFlag))        addBlockCluO();
    // Block QTELE
    if(logicalToBool(sammenu_.qteleFlag))       addBlockQTELE();
    // Block QCTH 
    if(logicalToBool(sammenu_.qcthFlag))        addBlockQCTH();
    // Block CCELE 
    if(logicalToBool(sammenu_.ccleFlag))        addBlockCCLE();
    // Block LETE
    if(logicalToBool(sammenu_.leteFlag))        addBlockLETE();
    // Block ITCE 
    if(logicalToBool(sammenu_.itceFlag))        addBlockITCE();
    // Block HETE 
    if(logicalToBool(sammenu_.heteFlag))        addBlockHETE();

    // Write to the disk
    outfile->Write();
    //    fNewTree->Print();
    // ROOT Memory Profiling
    // Only for debugging
    //    gObjectTable->Print(); 
    
}

// Closes output file and deallocates variables from memory.
//
// input:   -
// return:  -
TreeWriter::~TreeWriter() {
  // if(fNewTree){
  //   delete fNewTree; 
  //   fNewTree = NULL; 
  // } 

  if(outfile) {
    outfile->Write(0,TObject::kOverwrite);
    outfile->Close();
    delete outfile;
    outfile = NULL;
  }
}

void TreeWriter::printHeaderFlags() {
    TString header = "\n\n==========================================================================\n";
    header +=        "\n                             PROD2ROOT FLAGS\n";
    header +=        "\n==========================================================================\n";
    
    header += Form("INFO: %d ",      logicalToBool(sammenu_.infoFlag)); 
    header += Form("DATA: %d ",      logicalToBool(sammenu_.dataFlag));
    header += Form("BPOS: %d ",      logicalToBool(sammenu_.bposFlag));
    header += Form("GDHIT: %d ",     logicalToBool(sammenu_.gdhitFlag));
    header += Form("ECLS: %d ",      logicalToBool(sammenu_.eclsFlag));
    header += Form("TRIG: %d ",      logicalToBool(sammenu_.trigFlag));
    header += Form("C2TRG: %d ",     logicalToBool(sammenu_.c2trgFlag));
    header += Form("TELLINA: %d\n",  logicalToBool(sammenu_.tellinaFlag));
    header += Form("PIZZETTA: %d ",  logicalToBool(sammenu_.pizzettaFlag));
    header += Form("TORTA: %d ",     logicalToBool(sammenu_.tortaFlag));
    header += Form("TELE: %d ",      logicalToBool(sammenu_.teleFlag));
    header += Form("PIZZA: %d ",     logicalToBool(sammenu_.pizzaFlag));
    header += Form("TIME: %d ",      logicalToBool(sammenu_.timeFlag));
    header += Form("CLUS: %d ",      logicalToBool(sammenu_.clusFlag));
    header += Form("PRECLUS: %d ",  logicalToBool(sammenu_.preclusFlag));
    header += Form("CWRK: %d\n",      logicalToBool(sammenu_.cwrkFlag));
    header += Form("CELE: %d ",      logicalToBool(sammenu_.celeFlag));
    header += Form("DTCE: %d ",      logicalToBool(sammenu_.dtceFlag));
    header += Form("DTCE0: %d ",     logicalToBool(sammenu_.dtce0Flag));
    header += Form("DCHITS: %d ",    logicalToBool(sammenu_.dchitsFlag));
    header += Form("DHRE: %d ",      logicalToBool(sammenu_.dhreFlag));
    header += Form("DHSP: %d ",     logicalToBool(sammenu_.dhspFlag));
    header += Form("TRKV: %d ",      logicalToBool(sammenu_.trkvFlag));
    header += Form("VTX: %d\n",       logicalToBool(sammenu_.vtxFlag));
    header += Form("TRKS: %d ",      logicalToBool(sammenu_.trksFlag));
    header += Form("TRKVOLD: %d ",   logicalToBool(sammenu_.trkvOldFlag));
    header += Form("VTXOLD: %d ",    logicalToBool(sammenu_.vtxOldFlag));
    header += Form("TRKSOLD: %d ",   logicalToBool(sammenu_.trksOldFlag));
    header += Form("DHIT: %d ",      logicalToBool(sammenu_.dhitFlag));
    header += Form("DEDX: %d ",      logicalToBool(sammenu_.dedxFlag));
    header += Form("DPRS: %d ",      logicalToBool(sammenu_.dprsFlag));
    header += Form("GEANFI: %d\n",    logicalToBool(sammenu_.geanfiFlag));
    header += Form("TCLO: %d ",      logicalToBool(sammenu_.tcloFlag));
    header += Form("TCOLD: %d ",     logicalToBool(sammenu_.tcloldFlag));
    header += Form("CFHI: %d ",      logicalToBool(sammenu_.cfhiFlag));
    header += Form("QIHI: %d ",      logicalToBool(sammenu_.qihiFlag));
    header += Form("TRKQ: %d ",      logicalToBool(sammenu_.trkqFlag));
    header += Form("QELE: %d ",     logicalToBool(sammenu_.qeleFlag));
    header += Form("QCAL: %d ",      logicalToBool(sammenu_.qcalFlag));
    header += Form("KNVO: %d ",      logicalToBool(sammenu_.knvoFlag));
    header += Form("VNVO: %d\n",      logicalToBool(sammenu_.vnvoFlag));
    header += Form("VNVB: %d ",      logicalToBool(sammenu_.vnvbFlag));
    header += Form("INVO: %d ",      logicalToBool(sammenu_.invoFlag));
    header += Form("ECLO: %d ",      logicalToBool(sammenu_.ecloFlag));
    header += Form("CSPS: %d ",       logicalToBool(sammenu_.cspsFlag));
    header += Form("CLUO: %d ",      logicalToBool(sammenu_.cluoFlag));
    header += Form("QTELE: %d ",     logicalToBool(sammenu_.qteleFlag));
    header += Form("QCTH: %d ",      logicalToBool(sammenu_.qcthFlag));
    header += Form("CCLE: %d\n",     logicalToBool(sammenu_.ccleFlag));
    header += Form("LETE: %d ",      logicalToBool(sammenu_.leteFlag));
    header += Form("ITCE: %d ",      logicalToBool(sammenu_.itceFlag));
    header += Form("HETE: %d ",      logicalToBool(sammenu_.heteFlag));
    header += Form("MCFLG: %d ",     logicalToBool(sammenu_.mcFlg));
    header += "\n==========================================================================\n";
    
    // Print to std output
    std::cout << header.Data() << std::endl;
}

void TreeWriter::printSummary() {
    TString summary = "\n\n=============================================================================\n";
    summary +=         "\n                           PROD2ROOT SUMMARY\n";
    summary +=         "\n=============================================================================\n";
    summary +=         "  Block  Err.1\t\tErr.2\t\tErr.3\t\tErr.4\t\tErr.5";
    summary +=         "\n=============================================================================\n";
    summary += Form("  INFO   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.InfoErrorCounter[0], errorcounter_.InfoErrorCounter[1], 
                    errorcounter_.InfoErrorCounter[2], errorcounter_.InfoErrorCounter[3], errorcounter_.InfoErrorCounter[4]);
    summary += Form("  BPOS   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.BPOSErrorCounter[0], errorcounter_.BPOSErrorCounter[1], 
                    errorcounter_.BPOSErrorCounter[2], errorcounter_.BPOSErrorCounter[3], errorcounter_.BPOSErrorCounter[4]);
    summary += Form("  GDHIT  %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.GDHitErrorCounter[0], errorcounter_.GDHitErrorCounter[1], 
                    errorcounter_.GDHitErrorCounter[2], errorcounter_.GDHitErrorCounter[3], errorcounter_.GDHitErrorCounter[4]);
    summary += Form("  ECLS   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.EclsErrorCounter[0], errorcounter_.EclsErrorCounter[1], 
                    errorcounter_.EclsErrorCounter[2], errorcounter_.EclsErrorCounter[3], errorcounter_.EclsErrorCounter[4]);
    summary += Form("  TRIG   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.TrigErrorCounter[0], errorcounter_.TrigErrorCounter[1], 
                    errorcounter_.TrigErrorCounter[2], errorcounter_.TrigErrorCounter[3], errorcounter_.TrigErrorCounter[4]);
    summary += Form("  C2TRIG %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.C2TrigErrorCounter[0], errorcounter_.C2TrigErrorCounter[1], 
                    errorcounter_.C2TrigErrorCounter[2], errorcounter_.C2TrigErrorCounter[3], errorcounter_.C2TrigErrorCounter[4]);
    summary += Form("  TELLIN %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.TellinaErrorCounter[0], errorcounter_.TellinaErrorCounter[1], 
                    errorcounter_.TellinaErrorCounter[2], errorcounter_.TellinaErrorCounter[3], errorcounter_.TellinaErrorCounter[4]);
    summary += Form("  PIZZET %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.PizzettaErrorCounter[0], errorcounter_.PizzettaErrorCounter[1], 
                    errorcounter_.PizzettaErrorCounter[2], errorcounter_.PizzettaErrorCounter[3], errorcounter_.PizzettaErrorCounter[4]);
    summary += Form("  TORTA  %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.TortaErrorCounter[0], errorcounter_.TortaErrorCounter[1], 
                    errorcounter_.TortaErrorCounter[2], errorcounter_.TortaErrorCounter[3], errorcounter_.TortaErrorCounter[4]);
    summary += Form("  TELE   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.TeleErrorCounter[0], errorcounter_.TeleErrorCounter[1], 
                    errorcounter_.TeleErrorCounter[2], errorcounter_.TeleErrorCounter[3], errorcounter_.TeleErrorCounter[4]);
    summary += Form("  TIME   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.TimeErrorCounter[0], errorcounter_.TimeErrorCounter[1], 
                    errorcounter_.TimeErrorCounter[2], errorcounter_.TimeErrorCounter[3], errorcounter_.TimeErrorCounter[4]);
    summary += Form("  CLUS   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.ClusErrorCounter[0], errorcounter_.ClusErrorCounter[1], 
                    errorcounter_.ClusErrorCounter[2], errorcounter_.ClusErrorCounter[3], errorcounter_.ClusErrorCounter[4]);
    summary += Form("  PRECLU %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.PreClusErrorCounter[0], errorcounter_.PreClusErrorCounter[1], 
                    errorcounter_.PreClusErrorCounter[2], errorcounter_.PreClusErrorCounter[3], errorcounter_.PreClusErrorCounter[4]);
    summary += Form("  CWRK   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.CWRKErrorCounter[0], errorcounter_.CWRKErrorCounter[1], 
                    errorcounter_.CWRKErrorCounter[2], errorcounter_.CWRKErrorCounter[3], errorcounter_.CWRKErrorCounter[4]);
    summary += Form("  CELE   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.CeleErrorCounter[0], errorcounter_.CeleErrorCounter[1], 
                    errorcounter_.CeleErrorCounter[2], errorcounter_.CeleErrorCounter[3], errorcounter_.CeleErrorCounter[4]);
    summary += Form("  DTCE   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.DTCEErrorCounter[0], errorcounter_.DTCEErrorCounter[1], 
                    errorcounter_.DTCEErrorCounter[2], errorcounter_.DTCEErrorCounter[3], errorcounter_.DTCEErrorCounter[4]);
    summary += Form("  DTCE0  %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.DTCE0ErrorCounter[0], errorcounter_.DTCE0ErrorCounter[1], 
                    errorcounter_.DTCE0ErrorCounter[2], errorcounter_.DTCE0ErrorCounter[3], errorcounter_.DTCE0ErrorCounter[4]);
    summary += Form("  DCHITS %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.DCHitsErrorCounter[0], errorcounter_.DCHitsErrorCounter[1], 
                    errorcounter_.DCHitsErrorCounter[2], errorcounter_.DCHitsErrorCounter[3], errorcounter_.DCHitsErrorCounter[4]);
    summary += Form("  DHRE   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.DHREErrorCounter[0], errorcounter_.DHREErrorCounter[1], 
                    errorcounter_.DHREErrorCounter[2], errorcounter_.DHREErrorCounter[3], errorcounter_.DHREErrorCounter[4]);
    summary += Form("  DHSP   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.DHSPErrorCounter[0], errorcounter_.DHSPErrorCounter[1], 
                    errorcounter_.DHSPErrorCounter[2], errorcounter_.DHSPErrorCounter[3], errorcounter_.DHSPErrorCounter[4]);
    summary += Form("  TRKV   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.TrkVErrorCounter[0], errorcounter_.TrkVErrorCounter[1], 
                    errorcounter_.TrkVErrorCounter[2], errorcounter_.TrkVErrorCounter[3], errorcounter_.TrkVErrorCounter[4]);
    summary += Form("  VTX    %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.VtxErrorCounter[0], errorcounter_.VtxErrorCounter[1], 
                    errorcounter_.VtxErrorCounter[2], errorcounter_.VtxErrorCounter[3], errorcounter_.VtxErrorCounter[4]);
    summary += Form("  TRKS   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.TrksErrorCounter[0], errorcounter_.TrksErrorCounter[1], 
                    errorcounter_.TrksErrorCounter[2], errorcounter_.TrksErrorCounter[3], errorcounter_.TrksErrorCounter[4]);
    summary += Form("  TRVOLD %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.TrkVOldErrorCounter[0], errorcounter_.TrkVOldErrorCounter[1], 
                    errorcounter_.TrkVOldErrorCounter[2], errorcounter_.TrkVOldErrorCounter[3], errorcounter_.TrkVOldErrorCounter[4]);
    summary += Form("  VTXOLD %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.VtxOldErrorCounter[0], errorcounter_.VtxOldErrorCounter[1], 
                    errorcounter_.VtxOldErrorCounter[2], errorcounter_.VtxOldErrorCounter[3], errorcounter_.VtxOldErrorCounter[4]);
    summary += Form("  TRKOLD %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.TrksOldErrorCounter[0], errorcounter_.TrksOldErrorCounter[1], 
                    errorcounter_.TrksOldErrorCounter[2], errorcounter_.TrksOldErrorCounter[3], errorcounter_.TrksOldErrorCounter[4]);
    summary += Form("  DHIT   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.DHitErrorCounter[0], errorcounter_.DHitErrorCounter[1], 
                    errorcounter_.DHitErrorCounter[2], errorcounter_.DHitErrorCounter[3], errorcounter_.DHitErrorCounter[4]);
    summary += Form("  DEDx   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.DEDxErrorCounter[0], errorcounter_.DEDxErrorCounter[1], 
                    errorcounter_.DEDxErrorCounter[2], errorcounter_.DEDxErrorCounter[3], errorcounter_.DEDxErrorCounter[4]);
    summary += Form("  DPRS   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.DPRSErrorCounter[0], errorcounter_.DPRSErrorCounter[1], 
                    errorcounter_.DPRSErrorCounter[2], errorcounter_.DPRSErrorCounter[3], errorcounter_.DPRSErrorCounter[4]);
    summary += Form("  GEANFI %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.GeanfiErrorCounter[0], errorcounter_.GeanfiErrorCounter[1], 
                    errorcounter_.GeanfiErrorCounter[2], errorcounter_.GeanfiErrorCounter[3], errorcounter_.GeanfiErrorCounter[4]);
    summary += Form("  TCLO   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.TcloErrorCounter[0], errorcounter_.TcloErrorCounter[1], 
                    errorcounter_.TcloErrorCounter[2], errorcounter_.TcloErrorCounter[3], errorcounter_.TcloErrorCounter[4]);
    summary += Form("  TCLOLD %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.TclOldErrorCounter[0], errorcounter_.TclOldErrorCounter[1], 
                    errorcounter_.TclOldErrorCounter[2], errorcounter_.TclOldErrorCounter[3], errorcounter_.TclOldErrorCounter[4]);
    summary += Form("  CFHI   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.CFhiErrorCounter[0], errorcounter_.CFhiErrorCounter[1], 
                    errorcounter_.CFhiErrorCounter[2], errorcounter_.CFhiErrorCounter[3], errorcounter_.CFhiErrorCounter[4]);
    summary += Form("  QIHI   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.QihiErrorCounter[0], errorcounter_.QihiErrorCounter[1], 
                    errorcounter_.QihiErrorCounter[2], errorcounter_.QihiErrorCounter[3], errorcounter_.QihiErrorCounter[4]);
    summary += Form("  TRQ    %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.TrqErrorCounter[0], errorcounter_.TrqErrorCounter[1], 
                    errorcounter_.TrqErrorCounter[2], errorcounter_.TrqErrorCounter[3], errorcounter_.TrqErrorCounter[4]);
    summary += Form("  QELE   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.QeleErrorCounter[0], errorcounter_.QeleErrorCounter[1], 
                    errorcounter_.QeleErrorCounter[2], errorcounter_.QeleErrorCounter[3], errorcounter_.QeleErrorCounter[4]);
    summary += Form("  QCAL   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.QCalErrorCounter[0], errorcounter_.QCalErrorCounter[1], 
                    errorcounter_.QCalErrorCounter[2], errorcounter_.QCalErrorCounter[3], errorcounter_.QCalErrorCounter[4]);
    summary += Form("  KNVO   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.KNVOErrorCounter[0], errorcounter_.KNVOErrorCounter[1], 
                    errorcounter_.KNVOErrorCounter[2], errorcounter_.KNVOErrorCounter[3], errorcounter_.KNVOErrorCounter[4]);
    summary += Form("  VNVO   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.VNVOErrorCounter[0], errorcounter_.VNVOErrorCounter[1], 
                    errorcounter_.VNVOErrorCounter[2], errorcounter_.VNVOErrorCounter[3], errorcounter_.VNVOErrorCounter[4]);
    summary += Form("  VNVB   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.VNVBErrorCounter[0], errorcounter_.VNVBErrorCounter[1], 
                    errorcounter_.VNVBErrorCounter[2], errorcounter_.VNVBErrorCounter[3], errorcounter_.VNVBErrorCounter[4]);
    summary += Form("  INVO   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.INVOErrorCounter[0], errorcounter_.INVOErrorCounter[1], 
                    errorcounter_.INVOErrorCounter[2], errorcounter_.INVOErrorCounter[3], errorcounter_.INVOErrorCounter[4]);
    summary += Form("  ECLO   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.EcloErrorCounter[0], errorcounter_.EcloErrorCounter[1], 
                    errorcounter_.EcloErrorCounter[2], errorcounter_.EcloErrorCounter[3], errorcounter_.EcloErrorCounter[4]);
    summary += Form("  CSPS   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.CSPSErrorCounter[0], errorcounter_.CSPSErrorCounter[1], 
                    errorcounter_.CSPSErrorCounter[2], errorcounter_.CSPSErrorCounter[3], errorcounter_.CSPSErrorCounter[4]);
    summary += Form("  CLUO   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.CluoErrorCounter[0], errorcounter_.CluoErrorCounter[1], 
                    errorcounter_.CluoErrorCounter[2], errorcounter_.CluoErrorCounter[3], errorcounter_.CluoErrorCounter[4]);
    summary += Form("  QTELE  %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.QTeleErrorCounter[0], errorcounter_.QTeleErrorCounter[1], 
                    errorcounter_.QTeleErrorCounter[2], errorcounter_.QTeleErrorCounter[3], errorcounter_.QTeleErrorCounter[4]);
    summary += Form("  QCTH   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.QCTHErrorCounter[0], errorcounter_.QCTHErrorCounter[1], 
                    errorcounter_.QCTHErrorCounter[2], errorcounter_.QCTHErrorCounter[3], errorcounter_.QCTHErrorCounter[4]);
    summary += Form("  CCLE   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.CCleErrorCounter[0], errorcounter_.CCleErrorCounter[1], 
                    errorcounter_.CCleErrorCounter[2], errorcounter_.CCleErrorCounter[3], errorcounter_.CCleErrorCounter[4]);
    summary += Form("  LETE   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.LeteErrorCounter[0], errorcounter_.LeteErrorCounter[1], 
                    errorcounter_.LeteErrorCounter[2], errorcounter_.LeteErrorCounter[3], errorcounter_.LeteErrorCounter[4]);
    summary += Form("  ITCE   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.ITCEErrorCounter[0], errorcounter_.ITCEErrorCounter[1], 
                    errorcounter_.ITCEErrorCounter[2], errorcounter_.ITCEErrorCounter[3], errorcounter_.ITCEErrorCounter[4]);
    summary += Form("  HETE   %d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
                    errorcounter_.HeteErrorCounter[0], errorcounter_.HeteErrorCounter[1], 
                    errorcounter_.HeteErrorCounter[2], errorcounter_.HeteErrorCounter[3], errorcounter_.HeteErrorCounter[4]);
    summary += "\n=============================================================================\n\n";
    summary += "  Err.1\t At least one bank required by the specified block is missing.\n";
    summary += "  Err.2\t Banks exist but get function returns empty data.\n";
    summary += "  Err.3\t Get-function returns an invalid index\n\t\t(negative or bigger than expected).\n";
    summary += "  Err.4\t Get function returns a value out of domain for a variable.\n";
    summary += "  Err.5\t Require MC data and newer blocks HETE, ITCE, ...TODO remove it\n";
    summary += "\n=============================================================================\n";

    // Print summary to std output
    std::cout << summary.Data() << std::endl;
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
  //    fNewTree->Branch("StreamNum",   &eventinfo_.StreamNum,  "StreamNum/I");
  //    fNewTree->Branch("AlgoNum",     &eventinfo_.AlgoNum,    "AlgoNum/I");
    fNewTree->Branch("TimeSec",     &eventinfo_.TimeSec,    "TimeSec/I");
    fNewTree->Branch("TimeMusec",   &eventinfo_.TimeMusec,  "TimeMusec/I");
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
    fNewTree->Branch("nSec",       &evtc2trig_.NSec,       "NSec/I");
    fNewTree->Branch("nSec_NoClu", &evtc2trig_.NSec_NoClu, "NSec_NoClu/I");
    fNewTree->Branch("nSec2Clu",   &evtc2trig_.NSec2Clu,   "NSec2Clu/I");
    fNewTree->Branch("nClu2s",     &evtc2trig_.NClu2s,     "NClu2s/I");
    fNewTree->Branch("nNorm",      &evtc2trig_.NNorm,      "NNorm[NClu2s]/I");
    fNewTree->Branch("NormAdd",    &evtc2trig_.NormAdd,    "NormAdd[NClu2s]/I");
    fNewTree->Branch("nOver",      &evtc2trig_.NOver,      "NOver[NClu2s]/I");
    fNewTree->Branch("OverAdd",    &evtc2trig_.OverAdd,    "OverAdd[NClu2s]/I");
    fNewTree->Branch("nCosm",      &evtc2trig_.NCosm,      "NCosm[NClu2s]/I");
    fNewTree->Branch("CosmAdd",    &evtc2trig_.CosmAdd,    "CosmAdd[NClu2s]/I");
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
    fNewTree->Branch("tSpent",     &torta_.tSpent, "tSpent/F");
    fNewTree->Branch("tDead",      &torta_.tDead,  "tDead/F");
    fNewTree->Branch("Type",       &torta_.Type,   "Type/I");
    fNewTree->Branch("BPhi",       &torta_.BPhi,   "BPhi/I");
    fNewTree->Branch("EPhi",       &torta_.EPhi,   "EPhi/I");
    fNewTree->Branch("WPhi",       &torta_.WPhi,   "WPhi/I");
    fNewTree->Branch("BBha",       &torta_.BBha,   "BBha/I");
    fNewTree->Branch("EBha",       &torta_.EBha,   "EBha/I");
    fNewTree->Branch("WBha",       &torta_.WBha,   "WBha/I");
    fNewTree->Branch("BCos",       &torta_.BCos,   "BCos/I");
    fNewTree->Branch("ECos",       &torta_.ECos,   "ECos/I");
    fNewTree->Branch("WCos",       &torta_.WCos,   "WCos/I");
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
    // Create MC leaves only if they exists
    if (logicalToBool(sammenu_.mcFlg)) {
        fNewTree->Branch("nCluMC", &evtclu_.NCluMc, "NCluMc/I");
        fNewTree->Branch("nPar",   &evtclu_.NPar,   "NPar[NCluMc]/I");
        fNewTree->Branch("PNum1",  &evtclu_.PNum1,  "PNum1[NCluMc]/I");
        fNewTree->Branch("Pid1",   &evtclu_.Pid1,   "Pid1[NCluMc]/I");
        fNewTree->Branch("PNum2",  &evtclu_.PNum2,  "PNum2[NCluMc]/I");
        fNewTree->Branch("Pid2",   &evtclu_.Pid2,   "Pid2[NCluMc]/I");
        fNewTree->Branch("PNum3",  &evtclu_.PNum3,  "PNum3[NCluMc]/I");
        fNewTree->Branch("Pid3",   &evtclu_.Pid3,   "Pid3[NCluMc]/I");
    }
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

    if(logicalToBool(sammenu_.mcFlg)) {
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
}

// Add to the tree all the branches realted to the block DTCE.
//
// input:	-
// output: -
void TreeWriter::addBlockDTCE() {
    fNewTree->Branch("nDTCE",      &dtce_.nDTCE,      "nDTCE/I");
    fNewTree->Branch("nSmall",     &dtce_.nSmall,     "nSmall/I");
    fNewTree->Branch("iLayerDTCE", &dtce_.iLayerDTCE, "iLayerDTCE[nDTCE]/I");
    fNewTree->Branch("iWireDTCE",  &dtce_.iWireDTCE,  "iWireDTCE[nDTCE]/I");
    fNewTree->Branch("tDTCE",      &dtce_.tDTCE,      "tDTCE[nDTCE]/F");
}

// Add to the tree all the branches realted to the block DTCE0.
//
// input:	-
// output: -
void TreeWriter::addBlockDTCE0() {
    fNewTree->Branch("nDTCE0",      &dtce0_.nDTCE0,      "nDTCE0/I");
    fNewTree->Branch("iLayerDTCE0", &dtce0_.iLayerDTCE0, "iLayerDTCE0[nDTCE0]/I");
    fNewTree->Branch("iWireDTCE0",  &dtce0_.iWireDTCE0,  "iWireDTCE0[nDTCE0]/I");
    fNewTree->Branch("tDTCE0",      &dtce0_.tDTCE0,      "tDTCE0[nDTCE0]/F");
}

// Add to the tree all the branches realted to the block DCHits.
//
// input:	-
// output: -
void TreeWriter::addBlockDCHits() {
    fNewTree->Branch("nDCHR",     &dchits_.nDCHR,     "nDCHR/I");
    fNewTree->Branch("nSmallDCm", &dchits_.nSmallDCm, "nSmallDCm/I");
    fNewTree->Branch("nSmallDCp", &dchits_.nSmallDCp, "nSmallDCp/I");
    fNewTree->Branch("nBigDCm",   &dchits_.nBigDCm,   "nBigDCm/I");
    fNewTree->Branch("nBigDCp",   &dchits_.nBigDCp,   "nBigDCp/I");
    fNewTree->Branch("nCellDC",   &dchits_.nCellDC,   "nCellDC/I");
    fNewTree->Branch("nSmallDC",  &dchits_.nSmallDC,  "nSmallDC/I");
}

// Add to the tree all the branches realted to the block DHRE.
//
// input:	-
// output: -
void TreeWriter::addBlockDHRE() {
    fNewTree->Branch("nDHRE",      &dhre_.nDHRE,      "nDHRE/I");
    fNewTree->Branch("iLayerDHRE", &dhre_.iLayerDHRE, "iLayerDHRE[nDHRE]/I");
    fNewTree->Branch("iWireDHRE",  &dhre_.iWireDHRE,  "iWireDHRE[nDHRE]/I");
    fNewTree->Branch("iTrkDHRE",   &dhre_.iTrkDHRE,   "iTrkDHRE[nDHRE]/I");
    fNewTree->Branch("rDHRE",      &dhre_.rDHRE,      "rDHRE[nDHRE]/F");
    fNewTree->Branch("eDHRE",      &dhre_.eDHRE,      "eDHRE[nDHRE]/F");
}

// Add to the tree all the branches realted to the block DHSP.
//
// input:	-
// output: -
void TreeWriter::addBlockDHSP() {
    fNewTree->Branch("nDHSP", &dhsp_.nDHSP, "nDHSP/I");
    fNewTree->Branch("TrkDh", &dhsp_.TrkDh, "TrkDh[nDHSP]/I");
    fNewTree->Branch("Layer", &dhsp_.Layer, "Layer[nDHSP]/I");
    fNewTree->Branch("Wire",  &dhsp_.Wire,  "Wire[nDHSP]/I");
    fNewTree->Branch("Time",  &dhsp_.Time,  "Time[nDHSP]/F");
    fNewTree->Branch("DPar",  &dhsp_.DPar,  "DPar[nDHSP]/F");
    fNewTree->Branch("Res",   &dhsp_.Res,   "Res[nDHSP]/F");
    fNewTree->Branch("XDh",   &dhsp_.XDh,   "XDh[nDHSP]/F");
    fNewTree->Branch("YDh",   &dhsp_.YDh,   "YDh[nDHSP]/F");
    fNewTree->Branch("ZDh",   &dhsp_.ZDh,   "ZDh[nDHSP]/F");
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

// Add to the tree all the branches realted to the block Vtx.
//
// input:	-
// output: -
void TreeWriter::addBlockVtx() {
    fNewTree->Branch("nV",      &vertices_.nV,      "nV/I");
    fNewTree->Branch("Vtx",     &vertices_.Vetx,     "Vetx[nV]/I");
    fNewTree->Branch("xV",      &vertices_.xV,      "xV[nV]/F");
    fNewTree->Branch("yV",      &vertices_.yV,      "yV[nV]/F");
    fNewTree->Branch("zV",      &vertices_.zV,      "zV[nV]/F");
    fNewTree->Branch("ChiVtx",  &vertices_.ChiVtx,  "ChiVtx[nV]/F");
    fNewTree->Branch("QuaLv",   &vertices_.QuaLv,   "QuaLv[nV]/I");
    fNewTree->Branch("FitiDv",  &vertices_.FitiDv,  "FitiDv[nV]/I");
    fNewTree->Branch("VTXCov1", &vertices_.VTXCov1, "VTXCov1[nV]/F");
    fNewTree->Branch("VTXCov2", &vertices_.VTXCov2, "VTXCov2[nV]/F");
    fNewTree->Branch("VTXCov3", &vertices_.VTXCov3, "VTXCov3[nV]/F");
    fNewTree->Branch("VTXCov4", &vertices_.VTXCov4, "VTXCov4[nV]/F");
    fNewTree->Branch("VTXCov5", &vertices_.VTXCov5, "VTXCov5[nV]/F");
    fNewTree->Branch("VTXCov6", &vertices_.VTXCov6, "VTXCov6[nV]/F");
}

// Add to the tree all the branches realted to the block Trks.
//
// input:	-
// output: -
void TreeWriter::addBlockTrkS() {
    fNewTree->Branch("nT",      &trks_.nT,      "nT/I");
    fNewTree->Branch("TrkInd",  &trks_.TrkInd,  "TrkInd[nT]/I");
    fNewTree->Branch("TrkVer",  &trks_.TrkVer,  "TrkVer[nT]/I");
    fNewTree->Branch("Cur",     &trks_.Cur,     "Cur[nT]/F");
    fNewTree->Branch("Phi",     &trks_.Phi,     "Phi[nT]/F");
    fNewTree->Branch("Cot",     &trks_.Cot,     "Cot[nT]/F");
    fNewTree->Branch("Pxt",     &trks_.Pxt,     "Pxt[nT]/F");
    fNewTree->Branch("Pyt",     &trks_.Pyt,     "Pyt[nT]/F");
    fNewTree->Branch("Pzt",     &trks_.Pzt,     "Pzt[nT]/F");
    fNewTree->Branch("PMod",    &trks_.PMod,    "PMod[nT]/F");
    fNewTree->Branch("Len",     &trks_.Len,     "Len[nT]/F");
    fNewTree->Branch("xFirst",  &trks_.xFirst,  "xFirst[nT]/F");
    fNewTree->Branch("yFirst",  &trks_.yFirst,  "yFirst[nT]/F");
    fNewTree->Branch("zFirst",  &trks_.zFirst,  "zFirst[nT]/F");
    fNewTree->Branch("CurLa",   &trks_.CurLa,   "CurLa[nT]/F");
    fNewTree->Branch("PhiLa",   &trks_.PhiLa,   "PhiLa[nT]/F");
    fNewTree->Branch("CotLa",   &trks_.CotLa,   "CotLa[nT]/F");
    fNewTree->Branch("PxtLa",   &trks_.PxtLa,   "PxtLa[nT]/F");
    fNewTree->Branch("PytLa",   &trks_.PytLa,   "PytLa[nT]/F");
    fNewTree->Branch("PztLa",   &trks_.PztLa,   "PztLa[nT]/F");
    fNewTree->Branch("PModLa",  &trks_.PModLa,  "PModLa[nT]/F");
    fNewTree->Branch("SPca",    &trks_.SPca,    "SPca[nT]/F");
    fNewTree->Branch("SZeta",   &trks_.SZeta,   "SZeta[nT]/F");
    fNewTree->Branch("SCurV",   &trks_.SCurV,   "SCurV[nT]/F");
    fNewTree->Branch("SCotG",   &trks_.SCotG,   "SCotG[nT]/F");
    fNewTree->Branch("SPhi",    &trks_.SPhi,    "SPhi[nT]/F");
    fNewTree->Branch("xLast",   &trks_.xLast,   "xLast[nT]/F");
    fNewTree->Branch("yLast",   &trks_.yLast,   "yLast[nT]/F");
    fNewTree->Branch("zLast",   &trks_.zLast,   "zLast[nT]/F");
    fNewTree->Branch("xPca2",   &trks_.xPca2,   "xPca2[nT]/F");
    fNewTree->Branch("yPca2",   &trks_.yPca2,   "yPca2[nT]/F");
    fNewTree->Branch("zPca2",   &trks_.zPca2,   "zPca2[nT]/F");
    fNewTree->Branch("QTrk2",   &trks_.QTrk2,   "QTrk2[nT]/F");
    fNewTree->Branch("CotPca2", &trks_.CotPca2, "CotPca2[nT]/F");
    fNewTree->Branch("PhiPca2", &trks_.PhiPca2, "PhiPca2[nT]/F");
    fNewTree->Branch("nPrHit",  &trks_.nPrHit,  "nPrHit[nT]/I");
    fNewTree->Branch("nFitHit", &trks_.nFitHit, "nFitHit[nT]/I");
    fNewTree->Branch("nMskInk", &trks_.nMskInk, "nMskInk[nT]/I");
    fNewTree->Branch("Chi2Fit", &trks_.Chi2Fit, "Chi2Fit[nT]/F");
    fNewTree->Branch("Chi2Ms",  &trks_.Chi2Ms,  "Chi2Ms[nT]/F");

    fNewTree->Branch("nTfMC",   &trks_.nTfMC,   "nTfMC/I");
    fNewTree->Branch("NConTr",  &trks_.NConTr,  "NConTr[nTfMC]/I");
    fNewTree->Branch("TrkIne1", &trks_.TrkIne1, "TrkIne1[nTfMC]/I");
    fNewTree->Branch("TrType1", &trks_.TrType1, "TrType1[nTfMC]/I");
    fNewTree->Branch("TrHits1", &trks_.TrHits1, "TrHits1[nTfMC]/I");
    fNewTree->Branch("TrkIne2", &trks_.TrkIne2, "TrkIne2[nTfMC]/I");
    fNewTree->Branch("TrType2", &trks_.TrType2, "TrType2[nTfMC]/I");
    fNewTree->Branch("TrHits2", &trks_.TrHits2, "TrHits2[nTfMC]/I");
    fNewTree->Branch("TrkIn3",  &trks_.TrkIn3,  "TrkIn3[nTfMC]/I");
    fNewTree->Branch("TrType3", &trks_.TrType3, "TrType3[nTfMC]/I");
    fNewTree->Branch("TrHits3", &trks_.TrHits3, "TrHits3[nTfMC]/I");
    fNewTree->Branch("xFMC",    &trks_.xFMC,    "xFMC[nTfMC]/F");
    fNewTree->Branch("yFMC",    &trks_.yFMC,    "yFMC[nTfMC]/F");
    fNewTree->Branch("zFMC",    &trks_.zFMC,    "zFMC[nTfMC]/F");
    fNewTree->Branch("PxFMC",   &trks_.PxFMC,   "PxFMC[nTfMC]/F");
    fNewTree->Branch("PyFMC",   &trks_.PyFMC,   "PyFMC[nTfMC]/F");
    fNewTree->Branch("PzFMC",   &trks_.PzFMC,   "PzFMC[nTfMC]/F");
    fNewTree->Branch("xLMC",    &trks_.xLMC,    "xLMC[nTfMC]/F");
    fNewTree->Branch("yLMC",    &trks_.yLMC,    "yLMC[nTfMC]/F");
    fNewTree->Branch("zLMC",    &trks_.zLMC,    "zLMC[nTfMC]/F");
    fNewTree->Branch("PxLMC",   &trks_.PxLMC,   "PxLMC[nTfMC]/F");
    fNewTree->Branch("PyLMC",   &trks_.PyLMC,   "PyLMC[nTfMC]/F");
    fNewTree->Branch("PzLMC",   &trks_.PzLMC,   "PzLMC[nTfMC]/F");
    fNewTree->Branch("xFMC2",   &trks_.xFMC2,   "xFMC2[nTfMC]/F");
    fNewTree->Branch("yFMC2",   &trks_.yFMC2,   "yFMC2[nTfMC]/F");
    fNewTree->Branch("zFMC2",   &trks_.zFMC2,   "zFMC2[nTfMC]/F");
    fNewTree->Branch("PxFMC2",  &trks_.PxFMC2,  "PxFMC2[nTfMC]/F");
    fNewTree->Branch("PyFMC2",  &trks_.PyFMC2,  "PyFMC2[nTfMC]/F");
    fNewTree->Branch("PzFMC2",  &trks_.PzFMC2,  "PzFMC2[nTfMC]/F");
    fNewTree->Branch("xLMC2",   &trks_.xLMC2,   "xLMC2[nTfMC]/F");
    fNewTree->Branch("yLMC2",   &trks_.yLMC2,   "yLMC2[nTfMC]/F");
    fNewTree->Branch("zLMC2",   &trks_.zLMC2,   "zLMC2[nTfMC]/F");
    fNewTree->Branch("PxLMC2",  &trks_.PxLMC2,  "PxLMC2[nTfMC]/F");
    fNewTree->Branch("PyLMC2",  &trks_.PyLMC2,  "PyLMC2[nTfMC]/F");
    fNewTree->Branch("PzLMC2",  &trks_.PzLMC2,  "PzLMC2[nTfMC]/F");
}

// Add to the tree all the branches realted to the block TrkVOld.
//
// input:	-
// output: -
void TreeWriter::addBlockTrkVOld() {
    fNewTree->Branch("nTVOld",     &trkvold_.nTVOld,     "nTVOld/I");
    fNewTree->Branch("iVOld",      &trkvold_.iVOld,      "iVOld[nTVOld]/I");
    fNewTree->Branch("TrkNumVOld", &trkvold_.TrkNumVOld, "TrkNumVOld[nTVOld]/I");
    fNewTree->Branch("CurVOld",    &trkvold_.CurVOld,    "CurVOld[nTVOld]/F");
    fNewTree->Branch("PhiVOld",    &trkvold_.PhiVOld,    "PhiVOld[nTVOld]/F");
    fNewTree->Branch("CotVOld",    &trkvold_.CotVOld,    "CotVOld[nTVOld]/F");
    fNewTree->Branch("PxTVOld",    &trkvold_.PxTVOld,    "PxTVOld[nTVOld]/F");
    fNewTree->Branch("PyTVOld",    &trkvold_.PyTVOld,    "PyTVOld[nTVOld]/F");
    fNewTree->Branch("PzTVOld",    &trkvold_.PzTVOld,    "PzTVOld[nTVOld]/F");
    fNewTree->Branch("PModVOld",   &trkvold_.PModVOld,   "PModVOld[nTVOld]/F");
    fNewTree->Branch("LenVOld",    &trkvold_.LenVOld,    "LenVOld[nTVOld]/F");
    fNewTree->Branch("ChiVOld",    &trkvold_.ChiVOld,    "ChiVOld[nTVOld]/F");
    fNewTree->Branch("PidTVOld",   &trkvold_.PidTVOld,   "PidTVOld[nTVOld]/I");
    fNewTree->Branch("Cov11TVOld", &trkvold_.Cov11TVOld, "Cov11TVOld[nTVOld]/F");
    fNewTree->Branch("Cov12TVOld", &trkvold_.Cov12TVOld, "Cov12TVOld[nTVOld]/F");
    fNewTree->Branch("Cov13TVOld", &trkvold_.Cov13TVOld, "Cov13TVOld[nTVOld]/F");
    fNewTree->Branch("Cov22TVOld", &trkvold_.Cov22TVOld, "Cov22TVOld[nTVOld]/F");
    fNewTree->Branch("Cov23TVOld", &trkvold_.Cov23TVOld, "Cov23TVOld[nTVOld]/F");
    fNewTree->Branch("Cov33TVOld", &trkvold_.Cov33TVOld, "Cov33TVOld[nTVOld]/F");
}

// Add to the tree all the branches realted to the block VtxOld.
//
// input:	-
// output: -
void TreeWriter::addBlockVtxOld() {
    fNewTree->Branch("nVOld",      &vtxold_.nVOld,      "nVOld/I");
    fNewTree->Branch("VtxOld",     &vtxold_.VtxOld,     "VtxOld[nVOld]/I");
    fNewTree->Branch("xVOld",      &vtxold_.xVOld,      "xVOld[nVOld]/F");
    fNewTree->Branch("yVOld",      &vtxold_.yVOld,      "yVOld[nVOld]/F");
    fNewTree->Branch("ZVOld",      &vtxold_.ZVOld,      "ZVOld[nVOld]/F");
    fNewTree->Branch("ChiVTxOld",  &vtxold_.ChiVTxOld,  "ChiVTxOld[nVOld]/F");
    fNewTree->Branch("QuaLVOld",   &vtxold_.QuaLVOld,   "QuaLVOld[nVOld]/I");
    fNewTree->Branch("FitIdVOld",  &vtxold_.FitIdVOld,  "FitIdVOld[nVOld]/I");
    fNewTree->Branch("VtxCov1Old", &vtxold_.VtxCov1Old, "VtxCov1Old[nVOld]/F");
    fNewTree->Branch("VtxCov2Old", &vtxold_.VtxCov2Old, "VtxCov2Old[nVOld]/F");
    fNewTree->Branch("VtxCov3Old", &vtxold_.VtxCov3Old, "VtxCov3Old[nVOld]/F");
    fNewTree->Branch("VtxCov4Old", &vtxold_.VtxCov4Old, "VtxCov4Old[nVOld]/F");
    fNewTree->Branch("VtxCov5Old", &vtxold_.VtxCov5Old, "VtxCov5Old[nVOld]/F");
    fNewTree->Branch("VtxCov6Old", &vtxold_.VtxCov6Old, "VtxCov6Old[nVOld]/F");
}

// Add to the tree all the branches realted to the block TrkOld.
//
// input:	-
// output: -
void TreeWriter::addBlockTrkSOld() {
    fNewTree->Branch("nTOld",       &trkold_.nTOld,       "nTOld/I");
    fNewTree->Branch("TrkIndOld",   &trkold_.TrkIndOld,   "TrkIndOld[nTOld]/I");
    fNewTree->Branch("TrkVerOld",   &trkold_.TrkVerOld,   "TrkVerOld[nTOld]/I");
    fNewTree->Branch("CurOld",      &trkold_.CurOld,      "CurOld[nTOld]/F");
    fNewTree->Branch("PhiOld",      &trkold_.PhiOld,      "PhiOld[nTOld]/F");
    fNewTree->Branch("CotOld",      &trkold_.CotOld,      "CotOld[nTOld]/F");
    fNewTree->Branch("PxTOld",      &trkold_.PxTOld,      "PxTOld[nTOld]/F");
    fNewTree->Branch("PyTOld",      &trkold_.PyTOld,      "PyTOld[nTOld]/F");
    fNewTree->Branch("PzTOld",      &trkold_.PzTOld,      "PzTOld[nTOld]/F");
    fNewTree->Branch("PModOld",     &trkold_.PModOld,     "PModOld[nTOld]/F");
    fNewTree->Branch("LenOld",      &trkold_.LenOld,      "LenOld[nTOld]/F");
    fNewTree->Branch("xFirstOld",   &trkold_.xFirstOld,   "xFirstOld[nTOld]/F");
    fNewTree->Branch("yFirstOld",   &trkold_.yFirstOld,   "yFirstOld[nTOld]/F");
    fNewTree->Branch("zFirstOld",   &trkold_.zFirstOld,   "zFirstOld[nTOld]/F");
    fNewTree->Branch("CurLaOld",    &trkold_.CurLaOld,    "CurLaOld[nTOld]/F");
    fNewTree->Branch("PhiLaOld",    &trkold_.PhiLaOld,    "PhiLaOld[nTOld]/F");
    fNewTree->Branch("CotLaOld",    &trkold_.CotLaOld,    "CotLaOld[nTOld]/F");
    fNewTree->Branch("PxTLaOld",    &trkold_.PxTLaOld,    "PxTLaOld[nTOld]/F");
    fNewTree->Branch("PyTLaOld",    &trkold_.PyTLaOld,    "PyTLaOld[nTOld]/F");
    fNewTree->Branch("PzTLaOld",    &trkold_.PzTLaOld,    "PzTLaOld[nTOld]/F");
    fNewTree->Branch("PModLaOld",   &trkold_.PModLaOld,   "PModLaOld[nTOld]/F");
    fNewTree->Branch("SPcaOld",     &trkold_.SPcaOld,     "SPcaOld[nTOld]/F");
    fNewTree->Branch("SZetaOld",    &trkold_.SZetaOld,    "SZetaOld[nTOld]/F");
    fNewTree->Branch("SCurVOld",    &trkold_.SCurVOld,    "SCurVOld[nTOld]/F");
    fNewTree->Branch("SCotGOld",    &trkold_.SCotGOld,    "SCotGOld[nTOld]/F");
    fNewTree->Branch("SPhiOld",     &trkold_.SPhiOld,     "SPhiOld[nTOld]/F");
    fNewTree->Branch("xLastOld",    &trkold_.xLastOld,    "xLastOld[nTOld]/F");
    fNewTree->Branch("yLastOld",    &trkold_.yLastOld,    "yLastOld[nTOld]/F");
    fNewTree->Branch("zLastOld",    &trkold_.zLastOld,    "zLastOld[nTOld]/F");
    fNewTree->Branch("xPca2Old",    &trkold_.xPca2Old,    "xPca2Old[nTOld]/F");
    fNewTree->Branch("yPca2Old",    &trkold_.yPca2Old,    "yPca2Old[nTOld]/F");
    fNewTree->Branch("zPca2Old",    &trkold_.zPca2Old,    "zPca2Old[nTOld]/F");
    fNewTree->Branch("QTrk2Old",    &trkold_.QTrk2Old,    "QTrk2Old[nTOld]/F");
    fNewTree->Branch("CotPca2Old",  &trkold_.CotPca2Old,  "CotPca2Old[nTOld]/F");
    fNewTree->Branch("PhiPca2Old",  &trkold_.PhiPca2Old,  "PhiPca2Old[nTOld]/F");
    fNewTree->Branch("nPrhiTOld",   &trkold_.nPrhiTOld,   "nPrhiTOld[nTOld]/I");
    fNewTree->Branch("nFitHitOld", &trkold_.nFitHitOld, "nFitHitOld[nTOld]/I");
    fNewTree->Branch("nMskInkOld",  &trkold_.nMskInkOld,  "nMskInkOld[nTOld]/I");
    fNewTree->Branch("Chi2FitOld",  &trkold_.Chi2FitOld,  "Chi2FitOld[nTOld]/F");
    fNewTree->Branch("Chi2MSOld",   &trkold_.Chi2MSOld,   "Chi2MSOld[nTOld]/F");
    if (logicalToBool(sammenu_.mcFlg)) {
        fNewTree->Branch("nTfMCOld",   &trkold_.nTfMCOld,   "nTfMCOld/I");
        fNewTree->Branch("nContrOld",  &trkold_.nContrOld,  "nContrOld[nTfMCOld]/I");
        fNewTree->Branch("TrkIne1Old", &trkold_.TrkIne1Old, "TrkIne1Old[nTfMCOld]/I");
        fNewTree->Branch("TrType1Old", &trkold_.TrType1Old, "TrType1Old[nTfMCOld]/I");
        fNewTree->Branch("TrHits1Old", &trkold_.TrHits1Old, "TrHits1Old[nTfMCOld]/I");
        fNewTree->Branch("TrkIne2Old", &trkold_.TrkIne2Old, "TrkIne2Old[nTfMCOld]/I");
        fNewTree->Branch("TrType2Old", &trkold_.TrType2Old, "TrType2Old[nTfMCOld]/I");
        fNewTree->Branch("TrHits2Old", &trkold_.TrHits2Old, "TrHits2Old[nTfMCOld]/I");
        fNewTree->Branch("TrkIne3Old", &trkold_.TrkIne3Old, "TrkIne3Old[nTfMCOld]/I");
        fNewTree->Branch("TrType3Old", &trkold_.TrType3Old, "TrType3Old[nTfMCOld]/I");
        fNewTree->Branch("TrHits3Old", &trkold_.TrHits3Old, "TrHits3Old[nTfMCOld]/I");
        fNewTree->Branch("xFMCOld",    &trkold_.xFMCOld,    "xFMCOld[nTfMCOld]/F");
        fNewTree->Branch("yFMCOld",    &trkold_.yFMCOld,    "yFMCOld[nTfMCOld]/F");
        fNewTree->Branch("zFMCOld",    &trkold_.zFMCOld,    "zFMCOld[nTfMCOld]/F");
        fNewTree->Branch("PxFMCOld",   &trkold_.PxFMCOld,   "PxFMCOld[nTfMCOld]/F");
        fNewTree->Branch("PyFMCOld",   &trkold_.PyFMCOld,   "PyFMCOld[nTfMCOld]/F");
        fNewTree->Branch("PzFMCOld",   &trkold_.PzFMCOld,   "PzFMCOld[nTfMCOld]/F");
        fNewTree->Branch("xLMCOld",    &trkold_.xLMCOld,    "xLMCOld[nTfMCOld]/F");
        fNewTree->Branch("yLMCOld",    &trkold_.yLMCOld,    "yLMCOld[nTfMCOld]/F");
        fNewTree->Branch("zLMCOld",    &trkold_.zLMCOld,    "zLMCOld[nTfMCOld]/F");
        fNewTree->Branch("PxLMCOld",   &trkold_.PxLMCOld,   "PxLMCOld[nTfMCOld]/F");
        fNewTree->Branch("PyLMCOld",   &trkold_.PyLMCOld,   "PyLMCOld[nTfMCOld]/F");
        fNewTree->Branch("PzLMCOld",   &trkold_.PzLMCOld,   "PzLMCOld[nTfMCOld]/F");
        fNewTree->Branch("xFMC2Old",   &trkold_.xFMC2Old,   "xFMC2Old[nTfMCOld]/F");
        fNewTree->Branch("yFMC2Old",   &trkold_.yFMC2Old,   "yFMC2Old[nTfMCOld]/F");
        fNewTree->Branch("zFMC2Old",   &trkold_.zFMC2Old,   "zFMC2Old[nTfMCOld]/F");
        fNewTree->Branch("PxFMC2Old",  &trkold_.PxFMC2Old,  "PxFMC2Old[nTfMCOld]/F");
        fNewTree->Branch("PyFMC2Old",  &trkold_.PyFMC2Old,  "PyFMC2Old[nTfMCOld]/F");
        fNewTree->Branch("PzFMC2Old",  &trkold_.PzFMC2Old,  "PzFMC2Old[nTfMCOld]/F");
        fNewTree->Branch("xLMC2Old",   &trkold_.xLMC2Old,   "xLMC2Old[nTfMCOld]/F");
        fNewTree->Branch("yLMC2Old",   &trkold_.yLMC2Old,   "yLMC2Old[nTfMCOld]/F");
        fNewTree->Branch("zLMC2Old",   &trkold_.zLMC2Old,   "zLMC2Old[nTfMCOld]/F");
        fNewTree->Branch("PxLMC2Old",  &trkold_.PxLMC2Old,  "PxLMC2Old[nTfMCOld]/F");
        fNewTree->Branch("PyLMC2Old",  &trkold_.PyLMC2Old,  "PyLMC2Old[nTfMCOld]/F");
        fNewTree->Branch("PzLMC2Old",  &trkold_.PzLMC2Old,  "PzLMC2Old[nTfMCOld]/F");
    }
}

// Add to the tree all the branches realted to the block DHIT.
//
// input:	-
// output: -
void TreeWriter::addBlockDHIT() {
    fNewTree->Branch("nDHIT",    &dhit_.nDHIT,    "nDHIT/I");
    fNewTree->Branch("DHPid",    &dhit_.DHPid,    "DHPid[nDHIT]/I");
    fNewTree->Branch("DHKin",    &dhit_.DHKin,    "DHKin[nDHIT]/I");
    fNewTree->Branch("DHAdd",    &dhit_.DHAdd,    "DHAdd[nDHIT]/I");
    fNewTree->Branch("DHx",      &dhit_.DHx,      "DHx[nDHIT]/F");
    fNewTree->Branch("DHy",      &dhit_.DHy,      "DHy[nDHIT]/F");
    fNewTree->Branch("DHz",      &dhit_.DHz,      "DHz[nDHIT]/F");
    fNewTree->Branch("DHPx",     &dhit_.DHPx,     "DHPx[nDHIT]/F");
    fNewTree->Branch("DHPy",     &dhit_.DHPy,     "DHPy[nDHIT]/F");
    fNewTree->Branch("DHPz",     &dhit_.DHPz,     "DHPz[nDHIT]/F");
    fNewTree->Branch("DHt",      &dhit_.DHt,      "DHt[nDHIT]/F");
    fNewTree->Branch("DHDedx",   &dhit_.DHDedx,   "DHDedx[nDHIT]/F");
    fNewTree->Branch("DHTLen",   &dhit_.DHTLen,   "DHTLen[nDHIT]/F");
    fNewTree->Branch("DHDTime",  &dhit_.DHDTime,  "DHDTime[nDHIT]/F");
    fNewTree->Branch("DHDFromW", &dhit_.DHDFromW, "DHDFromW[nDHIT]/F");
    fNewTree->Branch("DHFlag",   &dhit_.DHFlag,   "DHFlag[nDHIT]/I");
}

// Add to the tree all the branches realted to the block DEDx.
//
// input:	-
// output: -
void TreeWriter::addBlockDEDx() {
    fNewTree->Branch("nDEDx",     &dedx_.nDEDx,     "nDEDx/I");
    fNewTree->Branch("nADC",      &dedx_.nADC,      "nADC[nDEDx]/I");
    fNewTree->Branch("iDEDx",     &dedx_.iDEDx,     "iDEDx[nDEDx]/I");
    fNewTree->Branch("ADCLayer",  &dedx_.ADCLayer,  "ADCLayer[nDEDx][100]/I");
    fNewTree->Branch("ADCWi1",    &dedx_.ADCWi1,    "ADCWi1[nDEDx][100]/I");
    fNewTree->Branch("ADCWi2",    &dedx_.ADCWi2,    "ADCWi2[nDEDx][100]/I");
    fNewTree->Branch("ADCLen",    &dedx_.ADCLen,    "ADCLen[nDEDx][100]/F");
    fNewTree->Branch("ADCLeff",   &dedx_.ADCLeff,   "ADCLeff[nDEDx][100]/F");
    fNewTree->Branch("ADCTim1",   &dedx_.ADCTim1,   "ADCTim1[nDEDx][100]/F");
    fNewTree->Branch("ADCTim2",   &dedx_.ADCTim2,   "ADCTim2[nDEDx][100]/F");
    fNewTree->Branch("ADCCharge", &dedx_.ADCCharge, "ADCCharge[nDEDx][100]/F");
}

// Add to the tree all the branches realted to the block DPRS.
//
// input:	-
// output: -
void TreeWriter::addBlockDPRS() {
    fNewTree->Branch("nDPRS",   &dprs_.nDPRS,   "nDPRS/i");
    fNewTree->Branch("nView",   &dprs_.nView,   "nView[nDPRS]/b");
    fNewTree->Branch("iDPRS",   &dprs_.iDPRS,   "iDPRS[nDPRS]/b");
    fNewTree->Branch("DPRSVer", &dprs_.DPRSVer, "DPRSVer[nDPRS]/b");
    fNewTree->Branch("nPos",    &dprs_.nPos,    "nPos[nDPRS]/b");
    fNewTree->Branch("nNeg",    &dprs_.nNeg,    "nNeg[nDPRS]/b");
    fNewTree->Branch("xPCA",    &dprs_.xPCA,    "xPCA[nDPRS]/F");
    fNewTree->Branch("yPCA",    &dprs_.yPCA,    "yPCA[nDPRS]/F");
    fNewTree->Branch("zPCA",    &dprs_.zPCA,    "zPCA[nDPRS]/F");
    fNewTree->Branch("xLst",    &dprs_.xLst,    "xLst[nDPRS]/F");
    fNewTree->Branch("yLst",    &dprs_.yLst,    "yLst[nDPRS]/F");
    fNewTree->Branch("zLst",    &dprs_.zLst,    "zLst[nDPRS]/F");
    fNewTree->Branch("CurP",    &dprs_.CurP,    "CurP[nDPRS]/F");
    fNewTree->Branch("PhiP",    &dprs_.PhiP,    "PhiP[nDPRS]/F");
    fNewTree->Branch("CotP",    &dprs_.CotP,    "CotP[nDPRS]/F");
    fNewTree->Branch("Qual",    &dprs_.Qual,    "Qual[nDPRS]/F");
    fNewTree->Branch("iPFl",    &dprs_.iPFl,    "iPFl[nDPRS]/b");
    fNewTree->Branch("PrKine",  &dprs_.PrKine,  "PrKine[nDPRS]/b");
    fNewTree->Branch("PrKHit",  &dprs_.PrKHit,  "PrKHit[nDPRS]/b");
}

// Add to the tree all the branches realted to the block MC.
//
// input:	-
// output: -
void TreeWriter::addBlockMC() {
    fNewTree->Branch("nTMC",   &mc_.nTMC,   "nTMC/I");
    fNewTree->Branch("Kine",   &mc_.Kine,   "Kine[nTMC]/I");
    fNewTree->Branch("PidMC",  &mc_.PidMC,  "PidMC[nTMC]/I");
    fNewTree->Branch("VirMom", &mc_.VirMom, "VirMom[nTMC]/I");
    fNewTree->Branch("PxMC",   &mc_.PxMC,   "PxMC[nTMC]/F");
    fNewTree->Branch("PyMC",   &mc_.PyMC,   "PyMC[nTMC]/F");
    fNewTree->Branch("PzMC",   &mc_.PzMC,   "PzMC[nTMC]/F");
    fNewTree->Branch("xCv",    &mc_.xCv,    "xCv[nTMC]/F");
    fNewTree->Branch("yCv",    &mc_.yCv,    "yCv[nTMC]/F");
    fNewTree->Branch("zCv",    &mc_.zCv,    "zCv[nTMC]/F");
    fNewTree->Branch("TOfCv",  &mc_.TOfCv,  "TOfCv[nTMC]/F");
    fNewTree->Branch("TheMC",  &mc_.TheMC,  "TheMC[nTMC]/F");
    fNewTree->Branch("PhiMC",  &mc_.PhiMC,  "PhiMC[nTMC]/F");
    fNewTree->Branch("VtxMC",  &mc_.VtxMC,  "VtxMC[nTMC]/I");
    fNewTree->Branch("nDchMC", &mc_.nDchMC, "nDchMC[nTMC]/I");
    fNewTree->Branch("xFhMC",  &mc_.xFhMC,  "xFhMC[nTMC]/F");
    fNewTree->Branch("yFhMC",  &mc_.yFhMC,  "yFhMC[nTMC]/F");
    fNewTree->Branch("zFhMC",  &mc_.zFhMC,  "zFhMC[nTMC]/F");
    fNewTree->Branch("PxFhMC", &mc_.PxFhMC, "PxFhMC[nTMC]/F");
    fNewTree->Branch("PyFhMC", &mc_.PyFhMC, "PyFhMC[nTMC]/F");
    fNewTree->Branch("PzFhMC", &mc_.PzFhMC, "PzFhMC[nTMC]/F");
    fNewTree->Branch("xLhMC",  &mc_.xLhMC,  "xLhMC[nTMC]/F");
    fNewTree->Branch("yLhMC",  &mc_.yLhMC,  "yLhMC[nTMC]/F");
    fNewTree->Branch("zLhMC",  &mc_.zLhMC,  "zLhMC[nTMC]/F");
    fNewTree->Branch("PxLhMC", &mc_.PxLhMC, "PxLhMC[nTMC]/F");
    fNewTree->Branch("PyLhMC", &mc_.PyLhMC, "PyLhMC[nTMC]/F");
    fNewTree->Branch("PzLhMC", &mc_.PzLhMC, "PzLhMC[nTMC]/F");
    fNewTree->Branch("nVtxMC", &mc_.nVtxMC, "nVtxMC/I");
    fNewTree->Branch("KinMom", &mc_.KinMom, "KinMom[nVtxMC]/I");
    fNewTree->Branch("Mother", &mc_.Mother, "Mother[nVtxMC]/I");
    fNewTree->Branch("xVMC",   &mc_.xVMC,   "xVMC[nVtxMC]/F");
    fNewTree->Branch("yVMC",   &mc_.yVMC,   "yVMC[nVtxMC]/F");
    fNewTree->Branch("zVMC",   &mc_.zVMC,   "zVMC[nVtxMC]/F");
    fNewTree->Branch("TOfVMC", &mc_.TOfVMC, "TOfVMC[nVtxMC]/F");
    fNewTree->Branch("nTvTx",  &mc_.nTvTx,  "nTvTx[nVtxMC]/F");
}

// Add to the tree all the branches realted to the block TCLO.
//
// input:	-
// output: -
void TreeWriter::addBlockTCLO() {
    fNewTree->Branch("nTcl",    &tclo_.nTcl,    "nTcl/I");
    fNewTree->Branch("AssTr",   &tclo_.AssTr,   "AssTr[nTcl]/I");
    fNewTree->Branch("AssCl",   &tclo_.AssCl,   "AssCl[nTcl]/I");
    fNewTree->Branch("VerVer",  &tclo_.VerVer,  "VerVer[nTcl]/I");
    fNewTree->Branch("xExt",    &tclo_.xExt,    "xExt[nTcl]/F");
    fNewTree->Branch("yExt",    &tclo_.yExt,    "yExt[nTcl]/F");
    fNewTree->Branch("zExt",    &tclo_.zExt,    "zExt[nTcl]/F");
    fNewTree->Branch("AssLenG", &tclo_.AssLenG, "AssLenG[nTcl]/F");
    fNewTree->Branch("AssChi",  &tclo_.AssChi,  "AssChi[nTcl]/F");
    fNewTree->Branch("ExtPx",   &tclo_.ExtPx,   "ExtPx[nTcl]/F");
    fNewTree->Branch("ExtPy",   &tclo_.ExtPy,   "ExtPy[nTcl]/F");
    fNewTree->Branch("ExtPz",   &tclo_.ExtPz,   "ExtPz[nTcl]/F");
}

// Add to the tree all the branches realted to the block TCLOld.
//
// input:	-
// output: -
void TreeWriter::addBlockTCLOld() {
    fNewTree->Branch("nTclOld",    &tclold_.nTclOld,    "nTclOld/I");
    fNewTree->Branch("AssTrOld",   &tclold_.AssTrOld,   "AssTrOld[nTclOld]/I");
    fNewTree->Branch("AssClOld",   &tclold_.AssClOld,   "AssClOld[nTclOld]/I");
    fNewTree->Branch("VerVerOld",  &tclold_.VerVerOld,  "VerVerOld[nTclOld]/I");
    fNewTree->Branch("xExtOld",    &tclold_.xExtOld,    "xExtOld[nTclOld]/F");
    fNewTree->Branch("yExtOld",    &tclold_.yExtOld,    "yExtOld[nTclOld]/F");
    fNewTree->Branch("zExtOld",    &tclold_.zExtOld,    "zExtOld[nTclOld]/F");
    fNewTree->Branch("AssLenGOld", &tclold_.AssLenGOld, "AssLenGOld[nTclOld]/F");
    fNewTree->Branch("AssChiOld",  &tclold_.AssChiOld,  "AssChiOld[nTclOld]/F");
    fNewTree->Branch("ExtPxOld",   &tclold_.ExtPxOld,   "ExtPxOld[nTclOld]/F");
    fNewTree->Branch("ExtPyOld",   &tclold_.ExtPyOld,   "ExtPyOld[nTclOld]/F");
    fNewTree->Branch("ExtPzOld",   &tclold_.ExtPzOld,   "ExtPzOld[nTclOld]/F");
}

// Add to the tree all the branches realted to the block CFHI.
//
// input:	-
// output: -
void TreeWriter::addBlockCFHI() {
    fNewTree->Branch("nFhi",    &cfhi_.nFhi,    "nFhi/I");
    fNewTree->Branch("PidFhi",  &cfhi_.PidFhi,  "PidFhi[nFhi]/I");
    fNewTree->Branch("KinFhi",  &cfhi_.KinFhi,  "KinFhi[nFhi]/I");
    fNewTree->Branch("CelFhi",  &cfhi_.CelFhi,  "CelFhi[nFhi]/I");
    fNewTree->Branch("FlgFhi",  &cfhi_.FlgFhi,  "FlgFhi[nFhi]/I");
    fNewTree->Branch("xFhi",    &cfhi_.xFhi,    "xFhi[nFhi]/F");
    fNewTree->Branch("yFhi",    &cfhi_.yFhi,    "yFhi[nFhi]/F");
    fNewTree->Branch("zFhi",    &cfhi_.zFhi,    "zFhi[nFhi]/F");
    fNewTree->Branch("PxFhi",   &cfhi_.PxFhi,   "PxFhi[nFhi]/F");
    fNewTree->Branch("PyFhi",   &cfhi_.PyFhi,   "PyFhi[nFhi]/F");
    fNewTree->Branch("PzFhi",   &cfhi_.PzFhi,   "PzFhi[nFhi]/F");
    fNewTree->Branch("TofFhi",  &cfhi_.TofFhi,  "TofFhi[nFhi]/F");
    fNewTree->Branch("TLenFhi", &cfhi_.TLenFhi, "TLenFhi[nFhi]/F");
}

// Add to the tree all the branches realted to the block QIHI.
//
// input:	-
// output: -
void TreeWriter::addBlockQIHI() {
    fNewTree->Branch("nQIHI",    &qihi_.nQIHI,    "nQIHI/I");
    fNewTree->Branch("PidQIHI",  &qihi_.PidQIHI,  "PidQIHI[nQIHI]/I");
    fNewTree->Branch("AddQIHI",  &qihi_.AddQIHI,  "AddQIHI[nQIHI]/I");
    fNewTree->Branch("KinQIHI",  &qihi_.KinQIHI,  "KinQIHI[nQIHI]/I");
    fNewTree->Branch("xQIHI",    &qihi_.xQIHI,    "xQIHI[nQIHI]/F");
    fNewTree->Branch("yQIHI",    &qihi_.yQIHI,    "yQIHI[nQIHI]/F");
    fNewTree->Branch("zQIHI",    &qihi_.zQIHI,    "zQIHI[nQIHI]/F");
    fNewTree->Branch("PxQIHI",   &qihi_.PxQIHI,   "PxQIHI[nQIHI]/F");
    fNewTree->Branch("PyQIHI",   &qihi_.PyQIHI,   "PyQIHI[nQIHI]/F");
    fNewTree->Branch("PzQIHI",   &qihi_.PzQIHI,   "PzQIHI[nQIHI]/F");
    fNewTree->Branch("TofQIHI",  &qihi_.TofQIHI,  "TofQIHI[nQIHI]/F");
    fNewTree->Branch("EneQIHI",  &qihi_.EneQIHI,  "EneQIHI[nQIHI]/F");
    fNewTree->Branch("TLenQIHI", &qihi_.TLenQIHI, "TLenQIHI[nQIHI]/F");
}

// Add to the tree all the branches realted to the block TRKQ.
//
// input:	-
// output: -
void TreeWriter::addBlockTRKQ() {
    fNewTree->Branch("nTrkQ",  &trkq_.nTrkQ,  "nTrkQ/I");
    fNewTree->Branch("FlagQt", &trkq_.FlagQt, "FlagQt/I");
    fNewTree->Branch("DetQt",  &trkq_.DetQt,  "DetQt[nTrkQ][2]/I");
    fNewTree->Branch("WedQt",  &trkq_.WedQt,  "WedQt[nTrkQ][2]/I");
    fNewTree->Branch("xQt",    &trkq_.xQt,    "xQt[nTrkQ][2]/F");
    fNewTree->Branch("yQt",    &trkq_.yQt,    "yQt[nTrkQ][2]/F");
    fNewTree->Branch("zQt",    &trkq_.zQt,    "zQt[nTrkQ][2]/F");
    fNewTree->Branch("ItrQt",  &trkq_.ItrQt,  "ItrQt[nTrkQ]/I");
}

// Add to the tree all the branches realted to the block QELE.
//
// input:	-
// output: -
void TreeWriter::addBlockQELE() {
    fNewTree->Branch("nQELE", &qele_.nQELE, "nQELE/I");
    fNewTree->Branch("QWed",  &qele_.QWed,  "QWed[nQELE]/I");
    fNewTree->Branch("QDet",  &qele_.QDet,  "QDet[nQELE]/I");
    fNewTree->Branch("QEne",  &qele_.QEne,  "QEne[nQELE]/F");
    fNewTree->Branch("QTim",  &qele_.QTim,  "QTim[nQELE]/F");
}

// Add to the tree all the branches realted to the block QCal.
//
// input:	-
// output: -
void TreeWriter::addBlockQCal() {
    fNewTree->Branch("nQCal", &qcal_.nQCal, "nQCal/I");
    fNewTree->Branch("xQCal", &qcal_.xQCal, "xQCal[nQCal]/F");
    fNewTree->Branch("yQCal", &qcal_.yQCal, "yQCal[nQCal]/F");
    fNewTree->Branch("zQCal", &qcal_.zQCal, "zQCal[nQCal]/F");
    fNewTree->Branch("EQCal", &qcal_.EQCal, "EQCal[nQCal]/F");
    fNewTree->Branch("TQCal", &qcal_.TQCal, "TQCal[nQCal]/F");
}

// Add to the tree all the branches realted to the block KNVO.
//
// input:	-
// output: -
void TreeWriter::addBlockKNVO() {
    fNewTree->Branch("nKNVO",    &knvo_.nKNVO,    "nKNVO/I");
    fNewTree->Branch("iKNVO",    &knvo_.iKNVO,    "iKNVO[nKNVO]/I");
    fNewTree->Branch("PxKNVO",   &knvo_.PxKNVO,   "PxKNVO[nKNVO]/F");
    fNewTree->Branch("PyKNVO",   &knvo_.PyKNVO,   "PyKNVO[nKNVO]/F");
    fNewTree->Branch("PzKNVO",   &knvo_.PzKNVO,   "PzKNVO[nKNVO]/F");
    fNewTree->Branch("PidKNVO",  &knvo_.PidKNVO,  "PidKNVO[nKNVO]/I");
    fNewTree->Branch("BankKNVO", &knvo_.BankKNVO, "BankKNVO[nKNVO]/I");
    fNewTree->Branch("nVnvKNVO", &knvo_.nVnvKNVO, "nVnvKNVO[nKNVO]/I");
}

// Add to the tree all the branches realted to the block VNVO.
//
// input:	-
// output: -
void TreeWriter::addBlockVNVO() {
    fNewTree->Branch("nVNVO",    &vnvo_.nVNVO,    "nVNVO/I");
    fNewTree->Branch("iVNVO",    &vnvo_.iVNVO,    "iVNVO[nVNVO]/I");
    fNewTree->Branch("VxVNVO",   &vnvo_.VxVNVO,   "VxVNVO[nVNVO]/F");
    fNewTree->Branch("VyVNVO",   &vnvo_.VyVNVO,   "VyVNVO[nVNVO]/F");
    fNewTree->Branch("VzVNVO",   &vnvo_.VzVNVO,   "VzVNVO[nVNVO]/F");
    fNewTree->Branch("KorIVNVO", &vnvo_.KorIVNVO, "KorIVNVO[nVNVO]/I");
    fNewTree->Branch("DvfsVNVO", &vnvo_.DvfsVNVO, "DvfsVNVO[nVNVO]/I");
    fNewTree->Branch("nBnkVNVO", &vnvo_.nBnkVNVO, "nBnkVNVO[nVNVO]/I");
    fNewTree->Branch("fBnkVNVO", &vnvo_.fBnkVNVO, "fBnkVNVO[nVNVO]/I");
}

// Add to the tree all the branches realted to the block VNVB.
//
// input:	-
// output: -
void TreeWriter::addBlockVNVB() {
    fNewTree->Branch("nBnksVNVO", &vnvb_.nBnksVNVO, "nBnksVNVO/I");
    fNewTree->Branch("iBank",     &vnvb_.iBank,     "iBank[nBnksVNVO]/I");
}

// Add to the tree all the branches realted to the block INVO.
//
// input:	-
// output: -
void TreeWriter::addBlockINVO() {
    fNewTree->Branch("nINVO",   &invo_.nINVO,   "nINVO/I");
    fNewTree->Branch("iClps",   &invo_.iClps,   "iClps[nINVO]/I");
    fNewTree->Branch("xINVO",   &invo_.xINVO,   "xINVO[nINVO]/F");
    fNewTree->Branch("yINVO",   &invo_.yINVO,   "yINVO[nINVO]/F");
    fNewTree->Branch("zINVO",   &invo_.zINVO,   "zINVO[nINVO]/F");
    fNewTree->Branch("tINVO",   &invo_.tINVO,   "tINVO[nINVO]/F");
    fNewTree->Branch("Lk",      &invo_.Lk,      "Lk[nINVO]/F");
    fNewTree->Branch("SigmaLk", &invo_.SigmaLk, "SigmaLk[nINVO]/F");
}

// Add to the tree all the branches realted to the block ECLO.
//
// input:	-
// output: -
void TreeWriter::addBlockECLO() {
    fNewTree->Branch("nCli",      &eclo_.nCli,     "nCli/I");
    fNewTree->Branch("ECLOWord",  &eclo_.ECLOWord, "ECLOWord[nCli]/I");
    fNewTree->Branch("IdPart",    &eclo_.IdPart,   "IdPart[nCli]/I");
    fNewTree->Branch("DtClpo",    &eclo_.DtClpo,   "DtClpo[nCli]/I");
    fNewTree->Branch("DvVnpo",    &eclo_.DvVnpo,   "DvVnpo[nCli]/I");
    fNewTree->Branch("Stre",      &eclo_.Stre,     "Stre[nCli]/I");
    fNewTree->Branch("Algo",      &eclo_.Algo,     "Algo[nCli]/I");
    fNewTree->Branch("nCli2",     &eclo_.nCli2,     "nCli2/I");
    fNewTree->Branch("ECLOWord2", &eclo_.ECLOWord2, "ECLOWord2[nCli2]/I");
    fNewTree->Branch("IdPart2",   &eclo_.IdPart2,   "IdPart2[nCli2]/I");
    fNewTree->Branch("DtClpo2",   &eclo_.DtClpo2,   "DtClpo2[nCli2]/I");
    fNewTree->Branch("DvVnpo2",   &eclo_.DvVnpo2,  "DvVnpo2[nCli2]/I");
    fNewTree->Branch("Stre2",     &eclo_.Stre2,     "Stre2[nCli2]/I");
    fNewTree->Branch("Algo2",     &eclo_.Algo2,     "Algo2[nCli2]/I");
}

// Add to the tree all the branches realted to the block CSPS.
//
// input:	-
// output: -
void TreeWriter::addBlockCSPS() {
    fNewTree->Branch("nCS",   &csps_.nCS,   "nCS/I");
    fNewTree->Branch("CSClu", &csps_.CSClu, "CSClu[nCS]/I");
    fNewTree->Branch("CSCel", &csps_.CSCel, "CSCel[nCS]/I");
    fNewTree->Branch("CSFla", &csps_.CSFla, "CSFla[nCS]/I");
    fNewTree->Branch("CSAdd", &csps_.CSAdd, "CSAdd[nCS]/I");
    fNewTree->Branch("CSNhi", &csps_.CSNhi, "CSNhi[nCS]/I");
    fNewTree->Branch("CSTa",  &csps_.CSTa,  "CSTa[nCS]/F");
    fNewTree->Branch("CSTb",  &csps_.CSTb,  "CSTb[nCS]/F");
    fNewTree->Branch("CSEa",  &csps_.CSEa,  "CSEa[nCS]/F");
    fNewTree->Branch("CSEb",  &csps_.CSEb,  "CSEb[nCS]/F");
    fNewTree->Branch("CST",   &csps_.CST,   "CST[nCS]/F");
    fNewTree->Branch("CSE",   &csps_.CSE,   "CSE[nCS]/F");
    fNewTree->Branch("CSx",   &csps_.CSx,   "CSx[nCS]/F");
    fNewTree->Branch("CSy",   &csps_.CSy,   "CSy[nCS]/F");
    fNewTree->Branch("CSz",   &csps_.CSz,   "CSz[nCS]/F");
    if(logicalToBool(sammenu_.mcFlg)) {
        fNewTree->Branch("nCSMC",    &csps_.nCSMC,    "nCSMC/I");
        fNewTree->Branch("CSMCKine", &csps_.CSMCKine, "CSMCKine[nCSMC]/I");
        fNewTree->Branch("CSMCPoi",  &csps_.CSMCPoi,  "CSMCPoi[nCSMC]/I");
        fNewTree->Branch("CSMCNHit", &csps_.CSMCNHit, "CSMCNHit[nCSMC]/I");
        fNewTree->Branch("CSMCx",    &csps_.CSMCx,    "CSMCx[nCSMC]/F");
        fNewTree->Branch("CSMCy",    &csps_.CSMCy,    "CSMCy[nCSMC]/F");
        fNewTree->Branch("CSMCz",    &csps_.CSMCz,    "CSMCz[nCSMC]/F");
        fNewTree->Branch("CSMCt",    &csps_.CSMCt,    "CSMCt[nCSMC]/F");
        fNewTree->Branch("CSMCe",    &csps_.CSMCe,    "CSMCe[nCSMC]/F");
    }
}

// Add to the tree all the branches realted to the block CLUO.
//
// input:	-
// output: -
void TreeWriter::addBlockCluO() {
    fNewTree->Branch("nCluO",  &cluo_.nCluO,  "nCluO/I");
    fNewTree->Branch("CluCel", &cluo_.CluCel, "CluCel[nCluO]/I");
    fNewTree->Branch("CluFl",  &cluo_.CluFl,  "CluFl[nCluO]/F");
    fNewTree->Branch("CluE",   &cluo_.CluE,   "CluE[nCluO]/F");
    fNewTree->Branch("CluX",   &cluo_.CluX,   "CluX[nCluO]/F");
    fNewTree->Branch("CluY",   &cluo_.CluY,   "CluY[nCluO]/F");
    fNewTree->Branch("CluZ",   &cluo_.CluZ,   "CluZ[nCluO]/F");
    fNewTree->Branch("CluT",   &cluo_.CluT,   "CluT[nCluO]/F");
    
    if(logicalToBool(sammenu_.mcFlg)) { 
        fNewTree->Branch("nMCPar",   &cluo_.nMCPar,   "nMCPar/I");
        fNewTree->Branch("CluMCCel", &cluo_.CluMCCel, "CluMCCel[nMCPar]/I");
        fNewTree->Branch("CluMCiCl", &cluo_.CluMCiCl, "CluMCiCl[nMCPar]/I");
        fNewTree->Branch("CluMCKin", &cluo_.CluMCKin, "CluMCKin[nMCPar]/I");
        fNewTree->Branch("CluMCe",   &cluo_.CluMCe,   "CluMCe[nMCPar]/F");
        fNewTree->Branch("CluMCx",   &cluo_.CluMCx,   "CluMCx[nMCPar]/F");
        fNewTree->Branch("CluMCy",   &cluo_.CluMCy,   "CluMCy[nMCPar]/F");
        fNewTree->Branch("CluMCz",   &cluo_.CluMCz,   "CluMCz[nMCPar]/F");
        fNewTree->Branch("CluMCt",   &cluo_.CluMCt,   "CluMCt[nMCPar]/F");
    }
}

// Add to the tree all the branches realted to the block QTELE.
//
// input:	-
// output: -
void TreeWriter::addBlockQTELE() {
    fNewTree->Branch("nQCalT",    &qtele_.nQCalT,    "nQCalT/I");
    fNewTree->Branch("QLte_Hit",  &qtele_.QLte_Hit,  "QLte_Hit[nQCalT]/I");
    fNewTree->Branch("QLte_Det",  &qtele_.QLte_Det,  "QLte_Det[nQCalT]/I");
    fNewTree->Branch("QLte_Mod",  &qtele_.QLte_Mod,  "QLte_Mod[nQCalT]/I");
    fNewTree->Branch("QLte_Pla",  &qtele_.QLte_Pla,  "QLte_Pla[nQCalT]/I");
    fNewTree->Branch("QLte_Til",  &qtele_.QLte_Til,  "QLte_Til[nQCalT]/I");
    fNewTree->Branch("QLte_Tim1", &qtele_.QLte_Tim1, "QLte_Tim1[nQCalT]/F");
    fNewTree->Branch("QLte_Tim2", &qtele_.QLte_Tim2, "QLte_Tim2[nQCalT]/F");
    fNewTree->Branch("QLte_Tim3", &qtele_.QLte_Tim3, "QLte_Tim3[nQCalT]/F");
    fNewTree->Branch("QLte_Tim4", &qtele_.QLte_Tim4, "QLte_Tim4[nQCalT]/F");
    fNewTree->Branch("QLte_Tim5", &qtele_.QLte_Tim5, "QLte_Tim5[nQCalT]/F");
}

// Add to the tree all the branches realted to the block QCTH.
//
// input:	-
// output: -
void TreeWriter::addBlockQCTH() {
    fNewTree->Branch("nQCTHEle", &qcth_.nQCTHEle, "nQCTHEle/I");
    fNewTree->Branch("nQCTHHit", &qcth_.nQCTHHit, "nQCTHHit[nQCTHEle]/I");
    fNewTree->Branch("QCTHx",    &qcth_.QCTHx,    "QCTHx[nQCTHEle]/F");
    fNewTree->Branch("QCTHy",    &qcth_.QCTHy,    "QCTHy[nQCTHEle]/F");
    fNewTree->Branch("QCTHz",    &qcth_.QCTHz,    "QCTHz[nQCTHEle]/F");
    fNewTree->Branch("Tim1",     &qcth_.Tim1,     "Tim1[nQCTHEle]/F");
    fNewTree->Branch("Tim2",     &qcth_.Tim2,     "Tim2[nQCTHEle]/F");
    fNewTree->Branch("Tim3",     &qcth_.Tim3,     "Tim3[nQCTHEle]/F");
    fNewTree->Branch("Tim4",     &qcth_.Tim4,     "Tim4[nQCTHEle]/F");
    fNewTree->Branch("Tim5",     &qcth_.Tim5,     "Tim5[nQCTHEle]/F");
}

// Add to the tree all the branches realted to the block CCLE.
//
// input:	-
// output: -
void TreeWriter::addBlockCCLE() {
    fNewTree->Branch("nCCle",     &ccle_.nCCle,     "nCCle/I");
    fNewTree->Branch("CCle_Cry",  &ccle_.CCle_Cry,  "CCle_Cry[nCCle]/I");
    fNewTree->Branch("CCle_Det",  &ccle_.CCle_Det,  "CCle_Det[nCCle]/I");
    fNewTree->Branch("CCle_Col",  &ccle_.CCle_Col,  "CCle_Col[nCCle]/I");
    fNewTree->Branch("CCle_Pla",  &ccle_.CCle_Pla,  "CCle_Pla[nCCle]/I");
    fNewTree->Branch("CCle_Time", &ccle_.CCle_Time, "CCle_Time[nCCle]/F");
}

// Add to the tree all the branches realted to the block LETE.
//
// input:	-
// output: -
void TreeWriter::addBlockLETE() {
    fNewTree->Branch("LeteCalib", &lete_.LeteCalib, "LeteCalib/I");
    fNewTree->Branch("nLete",     &lete_.nLete,     "nLete/I");
    fNewTree->Branch("Lete_Cry",  &lete_.Lete_Cry,  "Lete_Cry[nLete]/I");
    fNewTree->Branch("Lete_Det",  &lete_.Lete_Det,  "Lete_Det[nLete]/I");
    fNewTree->Branch("Lete_Col",  &lete_.Lete_Col,  "Lete_Col[nLete]/I");
    fNewTree->Branch("Lete_Pla",  &lete_.Lete_Pla,  "Lete_Pla[nLete]/I");
    fNewTree->Branch("Lete_E",    &lete_.Lete_E,    "Lete_E[nLete]/F");
    fNewTree->Branch("Lete_Time", &lete_.Lete_Time, "Lete_Time[nLete]/F");
}

// Add to the tree all the branches realted to the block ITCE.
//
// input:	-
// output: -
void TreeWriter::addBlockITCE() {
    fNewTree->Branch("nITCE",     &itce_.nITCE,     "nITCE/I");
    fNewTree->Branch("Foil",      &itce_.Foil,      "Foil[nITCE]/I");
    fNewTree->Branch("ITLayer",   &itce_.ITLayer,   "ITLayer[nITCE]/I");
    fNewTree->Branch("Strip",     &itce_.Strip,     "Strip[nITCE]/I");
    fNewTree->Branch("View",      &itce_.View,      "View[nITCE]/I");
    fNewTree->Branch("IndItKine", &itce_.IndItKine, "IndItKine[nITCE]/I");
}

// Add to the tree all the branches realted to the block HETE.
//
// input:	-
// output: -
void TreeWriter::addBlockHETE() {
    fNewTree->Branch("nHetDcs",  &hete_.nHetDcs,  "nHetDcs/I");
    fNewTree->Branch("HDet",     &hete_.HDet,     "HDet[nHetDcs]/I");
    fNewTree->Branch("HCol",     &hete_.HCol,     "HCol[nHetDcs]/I");
    fNewTree->Branch("nTurnHet", &hete_.nTurnHet, "nTurnHet[nHetDcs]/I");
    fNewTree->Branch("TimeHet",  &hete_.TimeHet,  "TimeHet[nHetDcs]/F");
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
    // ROOT Memory Profiling
    // Only for debugging
    /* gObjectTable->Print(); */
  count++;
  //  std::cout << "Fill: "<< outfile->GetName() << std::endl; 
  // TTree *tree = (TTree*)outfile->Get("sample");
  // tree->Fill();
  fNewTree->Fill();
  //test performed to understand crash --> writing file every event
  // outfile = fNewTree->GetCurrentFile();
  // if(mem % 100 == 0)outfile->Write(0,TObject::kOverwrite);
  if(count % 100000 == 0){
    float mem = GetMemory();
    std::cout << "[Mem debug] Process memory: " << mem << " MB" << std::endl;
    
      //AutoSave("fAutoFlush");
    // outfile = fNewTree->GetCurrentFile();
    // outfile->Write(0,TObject::kOverwrite);
  }

}

// Convert the integer flag from FORTRAN to a boolean.
//
// input:   flag to be converted.
// output:  boolean value converted
bool TreeWriter::logicalToBool(int flag) {
    if (flag == 1)
        return true;
    return false;
}

Float_t TreeWriter::GetMemory()
{

// --- Program for extracting memory

// AIX


   Text_t* rstring = new Text_t[64];
   Text_t* fstring = new Text_t[64];
   FILE* fp;
   Int_t info = 0;

   sprintf(fstring, "ps -o vsz,pid | grep %d ",
           gSystem->GetPid());

   fp = popen(fstring, "r");
   while (fp) {
     if (!fgets(rstring, 64, fp)) break;

     sscanf(rstring, "%d", &info);
   }
   pclose(fp);

   delete [] fstring;
   fstring = 0;
   delete [] rstring;
   rstring = 0;

   return (Float_t(info) / 1000);
}
