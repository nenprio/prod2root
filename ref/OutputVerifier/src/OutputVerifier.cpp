#include <iostream>
#include <fstream>
#include <string>
#include <string.h>
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
    
    fRoot->Close();
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

    fHB->Close();
    if (fHB) {
        delete fHB;
        fHB = NULL;
    }
}

// Compare the files in output dir associated with the event i-th.
//
// input:   id    event identifier
// output:  the number of errors found
int OutputVerifier::verifyEvent(int i, bool printInfo) {
    const char *ErrorFileOpen     = "\t[Error]\tCannot open file";
    const char *ErrorLeafDiff     = "\t[Error]\tDifference on leaf";
    const char *ErrorLeafNotFound = "\t[Error]\tNot found correspondance for leaf";

    int errorCounter = 0;   //Result counter
    TString rEventFile;
    TString hbEventFile;
    TString error;
    TString printout;
    ifstream fRoot;
    ifstream fHB;
    std::string lRoot;
    std::string lHB;

    rEventFile.Form("%s/sample%s%d.out", outputDir, ENTRY_PREFIX, i);
    hbEventFile.Form("%s/h1%s%d.out", outputDir, ENTRY_PREFIX, i);

    // Open files
    fRoot.open(rEventFile.Data());
    fHB.open(hbEventFile.Data());

    // Check open file
    if(!fRoot.is_open()){
        error.Form("%s %s", ErrorFileOpen, rEventFile);
        if (printInfo) {
            println(error.Data());
        }
        return -1;
    }
    if(!fHB.is_open()){
        error.Form("%s %s", ErrorFileOpen, hbEventFile);
        if (printInfo) {
            println(error.Data());
        }
        return -1;
    }
    
    // Get Num lines
    Int_t nLinesRoot = 0;
    Int_t nLinesHB   = 0;
    TString nameRoot;
    TString nameHB;
    TString valueRoot;
    TString valueHB;
    bool fieldFound;
    while ( getline(fRoot, lRoot) ) {
        fieldFound = false;     // Field of curr line not yet found
        nameRoot.Form("%s", cut(lRoot.c_str(), ":",  1));
        valueRoot.Form("%s", cut(lRoot.c_str(), ":" , 2));
        
        while ( getline(fHB, lHB) ) {
            nameHB.Form("%s", cut(lHB.c_str(), ":", 1));
            valueHB.Form("%s", cut(lHB.c_str(), ":", 2));

            // Check equality name
            if (myStricmp(nameRoot.Data(), nameHB.Data())==0) {
                fieldFound = true;
                if (myStricmp(valueRoot.Data(), valueHB.Data())!=0) {
                    if (printInfo) {
                        error.Form("%s %s - (%s != %s)", ErrorLeafDiff, nameRoot.Data(), valueRoot.Data(), valueHB.Data());
                        println(error.Data());
                    }
                    errorCounter++;
                    break;
                }
            }
            nLinesHB++;
        }
     
        // If the current field in not in hb file
        if (fieldFound==false) {
            if (printInfo) {
                error.Form("%s %s", ErrorLeafNotFound, nameRoot.Data());
                println(error.Data());
            }
            errorCounter++;
        }
        // Reset hb file to the beginning
        fHB.clear();
        fHB.seekg (0, ios::beg);
        nLinesRoot ++;
    }

    // Close files
    fRoot.close();
    fHB.close();

    delete fRoot;
    delete fHB;
    delete ErrorFileOpen;
    delete ErrorLeafDiff;
    delete ErrorLeafNotFound;

    // Return the number of errors found
    return errorCounter;
}

// Loop over all events and invoke comparison.
//
// input:   id    event identifier
// output:  -
bool OutputVerifier::verify(int from, int to, bool printInfo) {
    // Auxiliar strings
    TString error;
    TString printout;
    std::string currentFile;

    // Error/Info declarations
    const char* ErrorNumEvents    = "[Error]\tNumber of events are different.";
    const char* ErrorEventDiff    = "[Error]\tEvent verification return false.";
    const char* ErrorInitialPhase = "[Error]\tInitial phase failed, probably there are problems with files.";
    const char* InfoNoError       = "[Info]\tEvent verified, no error occurs.";
    
    // Result variables
    bool result  = true;
    int eventRes;

    // First check: Number events of trees
    TFile *fRoot      = new TFile(rootFile,   "READ");
    TFile *fHB        = new TFile(hbConvFile, "READ");
    TTree *rTree      = (TTree*) fRoot->Get("sample");
    TTree *hbTree     = (TTree*) fHB->Get("PROD2NTU/h1");
    Int_t rootEntries = rTree->GetEntries();
    Int_t hbEntries   = hbTree->GetEntries();

    // Check if both trees have the same number of events
    if(rootEntries!=hbEntries) {
        if (printInfo) {
            error.Form("%s - (%d != %d)", ErrorNumEvents, rootEntries, hbEntries);
            println(error.Data());
        }
        result = false;
    }

    // Loop on events in [0, rootEntries]
    if (from<0)
        from = 0;
    if (to+1>rootEntries)
        to = rootEntries;
    for(Int_t i=from; i<to+1; i++) {
        eventRes = verifyEvent(i, false);
        switch (eventRes ) {
            case -1:                // Error during the initial phase (file opening...)
                if (printInfo) {
                    error.Form("%s", ErrorInitialPhase);
                    println(error.Data());
                }
                result = false;
            break;
            case 0:                 // No error occurs
                if (printInfo) {
                    printout.Form("%s", InfoNoError);
                    println(printout.Data());
                }
            break;
            default:                // Error during scanning leaves
                if (printInfo) {
                    error.Form("%s (Event #%d > %d errors)", ErrorEventDiff, i, eventRes);
                    println(error.Data());
                }
                result = false;
            break;
        }
    }
    
    fRoot->Close();
    fHB->Close();

    if (fRoot) {
        delete fRoot;
        fRoot = NULL;
    }
    if (fHB) {
        delete fHB;
        fHB = NULL;
    }

    delete ErrorNumEvents;
    delete ErrorEventDiff;  
    delete ErrorInitialPhase;
    delete InfoNoError;
    delete error;
    delete printout;

    // Return boolean result
    return result;
}

// Print information about internal variables.
//
// input:   -
// output:  -
void OutputVerifier::printInfo() {
    TString printout;
    printout.Form("[Info] ROOT File:\t%s\n[Info] HBConv File:\t%s\n[Info] Output dir:\t%s\n\n", rootFile, hbConvFile, outputDir);
    println(printout.Data());
}
