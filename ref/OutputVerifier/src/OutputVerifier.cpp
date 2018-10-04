#include <iostream>
#include <fstream>
#include <string>
#include <TFile.h>
#include <TTree.h>
#include <TBranch.h>
#include <TLeaf.h>
#include "MyFunctions.hh"
#include "OutputVerifier.hh"

// Create the object OutputVerifier. 
// Pre-condition: the input file is a root file containing a tree with id "sample".
//
// input:   inFile      root file with "sample" tree
//          outDir      directory where write the output files
// output:  -
OutputVerifier::OutputVerifier(const char *rFile, const char *hbFile, const char *outDir) {
    println("[Info] OutputVerifier constructor");
    const char *errorInputFile="[Error] An error occurs during checking on input file.\n\tVerify that the path given as first argument exists and it refers to a regular file.";
    const char *errorOutputDir="[Error] An error occurs during the checking on output directory.\n\tVerify that the dir already exists or that the writing permission are allowed and no name mismatch occurs with that path.";
    const char *errorOpenFile="[Error] An error occurs during the opening of input file.\n\tVerify that you can open the file as ROOT TFile.";
    const char *errorOpenTree="[Error] An error occurs during the extraction of tree.\n\tVerify that the input file contains a tree with id \"sample\".";

    rootFile   = rFile;    
    hbConvFile = hbFile;    
    outputDir  = outDir;
  
    // Check existance of input root file
    if(checkIfFileExists(rootFile)==false) {
        println(errorInputFile);
        exit(1);
    }
    
    // Check existance of input hb file
    if(checkIfFileExists(hbConvFile)==false) {
        println(errorInputFile);
        exit(1);
    }

    // Create output dir if it doesn't exist
    if(createDirRecursively(outputDir)==false) {
        println(errorOutputDir);
        exit(1);
    }

    // Test if you can open the file
    TFile *fRoot = new TFile(rootFile, "READ");
    TFile *fHB   = new TFile(hbConvFile, "READ");

    if(fRoot->IsOpen() & fHB->IsOpen()){
        println("[Debug] Open Input files.");
    } else{
        println(errorOpenFile);
        exit(1);
    }
   
    // Test if you can open the tree
    TTree *tRoot = (TTree*) fRoot->Get("sample");
    TTree *tHB   = (TTree*) fHB->Get("PROD2NTU/h1");
    
    if((tRoot!=0) & (tHB!=0)){
        println("[Debug] Get Sample trees.");
    } else {
        println(errorOpenTree);
        exit(1);
    } 
    
    // Close the files
    fRoot->Close();
    fHB->Close();
}

// Destruct the OutputVerifier object.
// Free the memory. Let the manage of fTree to ROOT.
//
// input:   -
// output:  -
OutputVerifier::~OutputVerifier() {
    if(rootFile) {
        delete rootFile;
        rootFile = NULL;
    }
    if(hbConvFile) {
        delete hbConvFile;
        hbConvFile = NULL;
    }
    if(outputDir) {
        delete outputDir;
        outputDir = NULL;
    }

    println("[Info] Run ends. Memory released.");
}

// Loop over the entries (events) and for each one,
// export the leaf data to a txt file.
// The txt files will be created in the output directory.
//
// input:    -
// output:   -
void OutputVerifier::exportTreeToTxt(TTree *fTree) {
    ofstream myfile;
    TString name; 
    std::string currentFile;
    
    Int_t nEntries = fTree->GetEntries();
    TObjArray *leaves = fTree->GetListOfLeaves();
    Int_t nLeaves = leaves ? leaves->GetEntriesFast() : 0;
    
    for(Int_t i=0; i<nEntries; i++) {
        name.Form("%s/%sentry%d.out", outputDir, fTree->GetName(), i); 
        currentFile = name.Data();
        fTree->GetEntry(i);
        
        // Open the file stream
        myfile.open(currentFile.c_str());
        
        std::cout << "[Info] Export "<< currentFile << "." << std::endl; 
        
        for (int l=0;l<nLeaves;l++) {
            TLeaf *leaf = (TLeaf*)leaves->UncheckedAt(l);
            TBranch *branch = leaf->GetBranch();
            myfile << leaf->GetName() << ": " << leaf->GetValue(0) << std::endl;
        }
        // Close the file stream
        myfile.close();
    }
}

// Export content of tree in root file and
// write it to files in output directory.
//
// input:  -
// output: -
void OutputVerifier::exportRootTree() {
    TFile *fRoot = new TFile(rootFile, "READ");
    TTree *rTree = (TTree*) fRoot->Get("sample");
    exportTreeToTxt(rTree);
}

// Export content of tree in hb converted file and
// write it to files in output directory.
//
// input:  -
// output: -
void OutputVerifier::exportHBConvTree() {
    TFile *fHB = new TFile(hbConvFile, "READ");
    TTree *hbTree = (TTree*) fHB->Get("PROD2NTU/h1");
    exportTreeToTxt(hbTree);
}

// Print information about internal variables.
//
// input:   -
// output:  -
void OutputVerifier::printInfo() {
    const char *line1 = "[Info] ROOT File:\t";
    const char *line2 = "[Info] HBConv File:\t";
    const char *line3 = "[Info] Output dir:\t";
    print(line1);
    println(rootFile);
    print(line2);
    println(hbConvFile);
    print(line3);
    println(outputDir);
    println("");
}
