#ifndef FORT2C_CXX
#define FORT2C_CXX
#include <iostream>
#include "Fort2C.hh"
#include "TreeWriter.hh"
#include "Struct.hh"
#include "TString.h"

//Declare the writer object as global
TreeWriter *writer;

// Initialize the writer.
//
// input:   -
// output:  -
void inittree_(){
  writer = new TreeWriter();
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





















