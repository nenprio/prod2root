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

    ENTRY_PREFIX = "_event_";    
    rootFile     = rFile;    
    hbConvFile   = hbFile;    
    outputDir    = outDir;
  
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
        name.Form("%s/%s%s%d.out", outputDir, fTree->GetName(), ENTRY_PREFIX, i); 
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
    
    fRoot.close();
    if (fRoot) {
        delete fRoot;
        fRoot = NULL;
    }
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

    fHB.close();
    if (fHB) {
        delete fHB;
        fHB = NULL;
    }
}

// Compare the files in output dir associated with the event i-th.
//
// input:   id    event identifier
// output:  -
bool OutputVerifier::verifyEvent(int i) {
    const char *ErrorFileOpen = "[Error] Cannot open file";
    const char *ErrorLeafDiff = "[Error] Difference on leaf";
    TString rEventFile;
    TString hbEventFile;
    TString error;
    TString printout;
    ifstream fRoot;
    ifstream fHB;
    std::string lRoot;
    std::string lHB;
    bool result = true;

    rEventFile.Form("%s/sample%s%d.out", outputDir, ENTRY_PREFIX, i);
    hbEventFile.Form("%s/h1%s%d.out", outputDir, ENTRY_PREFIX, i);

    // Open files
    fRoot.open(rEventFile.Data());
    fHB.open(hbEventFile.Data());

    // Check open file
    if(!fRoot.is_open()){
        error.Form("%s %s", ErrorFileOpen, rEventFile);
        println(error.Data());
        return false;
    }
    if(!fHB.is_open()){
        error.Form("%s %s", ErrorFileOpen, hbEventFile);
        println(error.Data());
        return false;
    }
    
    // Get Num lines
    Int_t nLinesRoot = 0;
    Int_t nLinesHB   = 0;
    TString nameRoot;
    TString nameHB;
    TString valueRoot;
    TString valueHB;
    while ( getline(fRoot, lRoot) ) {
        nameRoot.Form("%s", cut(lRoot.c_str(), " : ", 1));
        valueRoot.Form("%s", cut(lRoot.c_str(), " : ", 2));
        while ( getline(fHB, lHB) ) {
            nameHB.Form("%s", cut(lHB.c_str(), " : ", 1));
            valueHB.Form("%s", cut(lHB.c_str(), " : ", 2));
            // Check equality name
            // TODO: ignore case
            if (nameRoot == nameHB) {
                if (valueRoot != valueHB) {
                    error.Form("%s %s - (%s != %s)", ErrorEventDiff, nameRoot, valueRoot, valueHB);
                    println(error.Data());

                    result = false;
                    break;
                }
            }
            nLinesHB++;
        }
        nLinesRoot ++;
    }

    // Close files
    fRoot.close();
    fHB.close();

    // Return boolean result
    return result;
}

// Loop over all events and invoke comparison.
//
// input:   id    event identifier
// output:  -
void OutputVerifier::verify() {
    bool result = true;
    TString error;
    std::string currentFile;

    const char* ErrorNumEvents = "[Error] Number of events are different.";
    const char* ErrorEventDiff = "[Error] Event verification return false.";
    
    // First check: Number events of trees
    TFile *fRoot = new TFile(rootFile,   "READ");
    TFile *fHB   = new TFile(hbConvFile, "READ");
    TTree *rTree  = (TTree*) fRoot->Get("sample");
    TTree *hbTree = (TTree*) fHB->Get("PROD2NTU/h1");
    Int_t rootEntries = rTree->GetEntries();
    Int_t hbEntries   = hbTree->GetEntries();
    if(rootEntries!=hbEntries) {
        error.Form("%s - (%d != %d)", ErrorNumEvents, rootEntries, hbEntries);
        println(error.Data());
        result = false;
    }

    for(Int_t i=0; i<rootEntries; i++) {
        if(!verifyEvent(i)) {
            error.Form("%s - (%d)", ErrorEventDiff, i);
            println(error.Data());
            result = false;
        }
    }
    
    fRoot.close();
    fHB.close();

    if (fRoot) {
        delete fRoot;
        fRoot = NULL;
    }
    if (fHB) {
        delete fHB;
        fHB = NULL;
    }
}

// Print information about internal variables.
//
// input:   -
// output:  -
void OutputVerifier::printInfo() {
    TString printout;
    printout.Form("[Info] ROOT File:\t%s\n
                   [Info] HBConv File:\t%s\n
                   [Info] Output dir:\t%s\n\n", rootFile, hbConvFile, outputDir);
}
