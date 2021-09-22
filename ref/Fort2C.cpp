#ifndef FORT2C_CXX
#define FORT2C_CXX
#include <iostream>
#include "Fort2C.hh"
#include "TreeWriter.hh"
#include "Struct.hh"

//Declare the writer object as global
TreeWriter *writer;

// Initialize the writer.
//
// input:   -
// output:  -
void inittree_(){
  writer = new TreeWriter();
}
// Initialize the structs for the beginning of the event
//
// input:   -
// output:  -
void initstruct_(){
  memset(&evtinfo_, 0, sizeof(evtinfo_));
  memset(&eventinfo_, 0, sizeof(eventinfo_));
  memset(&evtecls_, 0, sizeof(evtecls_));
  memset(&evtbpos_, 0, sizeof(evtbpos_));
  memset(&evttime_, 0, sizeof(evttime_));
  memset(&evtgdhit_, 0, sizeof(evtgdhit_));
  memset(&evttrig_, 0, sizeof(evttrig_));
  memset(&evtc2trig_, 0, sizeof(evtc2trig_));
  memset(&tellina_, 0, sizeof(tellina_));
  memset(&pizzetta_, 0, sizeof(pizzetta_));
  memset(&torta_, 0, sizeof(torta_));
  memset(&tele_, 0, sizeof(tele_));
  memset(&pizza_, 0, sizeof(pizza_));
  memset(&evtclu_, 0, sizeof(evtclu_));
  memset(&preclu_, 0, sizeof(preclu_));
  memset(&cwrk_, 0, sizeof(cwrk_));
  memset(&cele_, 0, sizeof(cele_));
  memset(&dtce_, 0, sizeof(dtce_));
  memset(&dtce0_, 0, sizeof(dtce0_));
  memset(&dchits_, 0, sizeof(dchits_));
  memset(&dhre_, 0, sizeof(dhre_));
  memset(&dhsp_, 0, sizeof(dhsp_));
  memset(&trkv_, 0, sizeof(trkv_));
  memset(&vertices_, 0, sizeof(vertices_));
  memset(&trks_, 0, sizeof(trks_));
  memset(&trkvold_, 0, sizeof(trkvold_));
  memset(&vtxold_, 0, sizeof(vtxold_));
  memset(&trkold_, 0, sizeof(trkold_));
  memset(&dhit_, 0, sizeof(dhit_));
  memset(&dedx_, 0, sizeof(dedx_));
  memset(&dprs_, 0, sizeof(dprs_));
  memset(&mc_, 0, sizeof(mc_));
  memset(&tclo_, 0, sizeof(tclo_));
  memset(&tclold_, 0, sizeof(tclold_));
  memset(&cfhi_, 0, sizeof(cfhi_));
  memset(&qihi_, 0, sizeof(qihi_));
  memset(&trkq_, 0, sizeof(trkq_));
  memset(&qele_, 0, sizeof(qele_));
  memset(&qcal_, 0, sizeof(qcal_));
  memset(&knvo_, 0, sizeof(knvo_));
  memset(&vnvo_, 0, sizeof(vnvo_));
  memset(&vnvb_, 0, sizeof(vnvb_));
  memset(&invo_, 0, sizeof(invo_));
  memset(&eclo_, 0, sizeof(eclo_));
  memset(&csps_, 0, sizeof(csps_));
  memset(&cluo_, 0, sizeof(cluo_));
  memset(&qtele_, 0, sizeof(qtele_));
  memset(&qcth_, 0, sizeof(qcth_));
  memset(&ccle_, 0, sizeof(ccle_));
  memset(&lete_, 0, sizeof(lete_));
  memset(&itce_, 0, sizeof(itce_));  
  memset(&hete_, 0, sizeof(hete_));  
}
// Invoke the method for filling the tree.
//
// input:   -
// output:  -
void fillntu_(){
  // TFile *ftest = (TFile*)writer->getTFile();
  
  // TSeqCollection *files = gROOT->GetListOfFiles();
  // TIter next(files);
  
  // while (TObject *tt = (next())) {
  //   std::cout << "fillntu_ getlist " << tt->GetName() << std::endl;
  // }
  // std::cout<< "fillntu_ " << ftest->GetName() << std::endl; 
  writer->fillTTree();
}

// Deallocate writer variable.
//
// input:   -
// output:  -
void closetree_(){
  writer->printSummary();   // Print the summary of execution errors

  delete writer;
  writer = NULL;
}

// Print on std output the current configuration of flags.
//
// input:   -
// output:  -
void showheader_(){
    writer->printHeaderFlags();
}

#endif
