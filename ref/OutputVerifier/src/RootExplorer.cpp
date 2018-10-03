#include <iostream>
#include <fstream>
#include <string>
#include <TFile.h>
#include <TTree.h>
#include <TBranch.h>
#include <TLeaf.h>
#include "MyFunctions.hh"
#include "RootExplorer.hh"

// Create the object RootExplorer. 
// Pre-condition: the input file is a root file containing a tree with id "sample".
//
// input:   inFile      root file with "sample" tree
//          outDir      directory where write the output files
// output:  -
RootExplorer::RootExplorer(const char *inFile, const char *outDir) {
    println("[Info] RootExplorer constructor");
    const char *errorInputFile="[Error] An error occurs during checking on input file.\n\tVerify that the path given as first argument exists and it refers to a regular file.";
    const char *errorOutputDir="[Error] An error occurs during the checking on output directory.\n\tVerify that the dir already exists or that the writing permission are allowed and no name mismatch occurs with that path.";
    const char *errorOpenFile="[Error] An error occurs during the opening of input file.\n\tVerify that you can open the file as ROOT TFile.";
    const char *errorOpenTree="[Error] An error occurs during the extraction of tree.\n\tVerify that the input file contains a tree with id \"sample\".";
    sampleFilepath  = inFile;    
    outputDir       = outDir;
  
    // Check existance of input file
    if(checkIfFileExists(inFile)==false) {
        println(errorInputFile);
        exit(1);
    }

    // Create output dir if it doesn't exist
    if(createDirRecursively(outDir)==false) {
        println(errorOutputDir);
        exit(1);
    }

    // Test if you can open the file
    f = new TFile(sampleFilepath, "READ");

    if(f->IsOpen()){
        println("[Debug] Open Input file.");
    } else{
        println(errorOpenFile);
        exit(1);
    }
   
    // Test if you can open the tree
    fTree = (TTree*) f->Get("sample");
    if(fTree){
        println("[Debug] Get Sample tree.");
    } else {
        println(errorOpenTree);
        exit(1);
    } 
}

// Destruct the RootExplorer object.
// Free the memory. Let the manage of fTree to ROOT.
//
// input:   -
// output:  -
RootExplorer::~RootExplorer() {
    if(sampleFilepath) {
        delete sampleFilepath;
        sampleFilepath = NULL;
    }
    if(outputDir) {
        delete outputDir;
        outputDir = NULL;
    }
    if(f) {
        f->Close();
        delete f;
        f = NULL;
    }

    println("[Info] Run ends. Memory released.");
}

// Loop over the entries (events) and for each one,
// export the leaf data to a txt file.
// The txt files will be created in the output directory.
//
// input:    -
// output:   -
void RootExplorer::exportEntriesToTxt() {
    ofstream myfile;
    TString name; 
    std::string currentFile;
    
    Int_t nEntries = fTree->GetEntries();
    TObjArray *leaves = fTree->GetListOfLeaves();
    Int_t nLeaves = leaves ? leaves->GetEntriesFast() : 0;
    
    for(Int_t i=0; i<nEntries; i++) {
        name.Form("%s/entry%d.out", outputDir, i); 
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

// Print information about internal variables.
//
// input:   -
// output:  -
void RootExplorer::printInfo() {
    const char *line1 = "[Info] ROOT File:\t";
    const char *line2 = "[Info] Output dir:\t";
    print(line1);
    println(sampleFilepath);

    print(line2);
    println(outputDir);
    println("");
}
