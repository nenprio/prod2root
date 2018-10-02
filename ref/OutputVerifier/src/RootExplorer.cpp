#include <iostream>
#include <TFile.h>
#include <TTree.h>
#include <TBranch.h>
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

    // Load the input file, the tree and get the number of events
    TFile *f = new TFile(sampleFilepath, "READ");

    if(f->IsOpen()){
        println("[Debug] File open");
    } else{
        println("[Debug] File close");
    }
    
    tree = (TTree*) f->Get("sample");
    if(tree){
        println("[Debug] Tree true");
    } else {
        println("[Debug] Tree false");
    } 

    int n = tree->GetEntries(); 
    std::cout << "[Info] The number of events is ";
    std::cout << n << std::endl;

    // Branches initialization
    b_nRun      = tree->GetBranch("nRun");
    b_Info      = tree->GetBranch("Info");
    b_Data      = tree->GetBranch("Data");
    b_necls     = tree->GetBranch("necls");
    b_EclStream = tree->GetBranch("EclStream");
    b_EclTrgw   = tree->GetBranch("EclTrgw");
    b_EclFilfo  = tree->GetBranch("EclFilfo");
    b_EclWord   = tree->GetBranch("EclWord");
    b_EclTagNum = tree->GetBranch("EclTagNum");
    b_EclEvType = tree->GetBranch("EclEvType");

    // Leaves initialization
    nRun            = b_nRun->GetLeaf("nRun");
    Info_RunNumber  = b_Info->GetLeaf("RunNumber");
    Info_EventNumber= b_Info->GetLeaf("EventNumber");
    Info_Pileup     = b_Info->GetLeaf("Pileup");
    Info_GenCod     = b_Info->GetLeaf("GenCod");
    Info_PhiDecay   = b_Info->GetLeaf("PhiDecay");
    Info_A1type     = b_Info->GetLeaf("A1type");
    Info_A2Type     = b_Info->GetLeaf("A2Type");
    Info_A3type     = b_Info ->GetLeaf("A3type");
    Info_B1type     = b_Info->GetLeaf("B1type");
    Info_B2type     = b_Info ->GetLeaf("B2type");
    Info_B3type     = b_Info ->GetLeaf("B3type");
    Data_StreamNum  = b_Data->GetLeaf("StreamNum");
    Data_AlgoNum    = b_Data->GetLeaf("AlgoNum");
    Data_TimeSec    = b_Data->GetLeaf("TimeSec");
    Data_TimeMusec  = b_Data->GetLeaf("TimeMusec");
    Data_Ndtce      = b_Data->GetLeaf("Ndtce");
    Data_Mcflag_tg  = b_Data->GetLeaf("Mcflag_tg");
    Data_Currpos    = b_Data->GetLeaf("Currpos");
    Data_Currele    = b_Data->GetLeaf("Currele");
    Data_Luminosity = b_Data->GetLeaf("Luminosity");
    necls           = b_necls->GetLeaf("necls");
    EclStream       = b_EclStream->GetLeaf("EclStream");
    EclTrgw         = b_EclTrgw->GetLeaf("EclTrgw");
    EclFilfo        = b_EclFilfo->GetLeaf("EclFilfo");
    EclWord         = b_EclWord->GetLeaf("EclWord");
    EclTagNum       = b_EclTagNum->GetLeaf("EclTagNum");
    EclEvType       = b_EclEvType->GetLeaf("EclEvType");

    f->Close();
    delete f;
}

RootExplorer::~RootExplorer() {
    delete b_nRun;
    delete b_Info;
    delete b_Data;
    delete b_necls;
    delete b_EclStream;
    delete b_EclTrgw;
    delete b_EclFilfo;
    delete b_EclWord;
    delete b_EclTagNum;
    delete b_EclEvType;
    
    delete nRun;
    delete Info_RunNumber;
    delete Info_EventNumber;
    delete Info_Pileup;
    delete Info_GenCod;
    delete Info_PhiDecay;
    delete Info_A1type;
    delete Info_A2Type;
    delete Info_A3type;
    delete Info_B1type;
    delete Info_B2type;
    delete Info_B3type;
    delete Data_StreamNum;
    delete Data_AlgoNum;
    delete Data_TimeSec;
    delete Data_TimeMusec;
    delete Data_Ndtce;
    delete Data_Mcflag_tg;
    delete Data_Currpos;
    delete Data_Currele;
    delete Data_Luminosity;
    delete necls;
    delete EclStream;
    delete EclTrgw;
    delete EclFilfo;
    delete EclWord;
    delete EclTagNum;
    delete EclEvType;

    delete tree;
    println("[Info] Run ends. Memory released.");
}


// Loop over the entries (events) and for each one, export the leaf data to a txt file.
// The txt files will be created in the output directory.
//
// input:    -
// output:   -
void RootExplorer::exportEntriesToTxt() {
    //Declare file stream and the output filename
    /* ofstream myfile; */
    /* TString name; */ 
    /* std::string currentFile; */
    /* Int_t numEntries = tree->GetEntries(); */

    /* for(Int_t i=0; i<numEntries; i++) { */
    /*     // Update the output filename with respect to the current entry */
    /*     name.Form("%s/entry%d.out", outputDir, type); */ 
    /*     currentFile = str(name.Data()); */
 
    /*     // For each branch, get the i-th entry */
    /*     b_nRun->GetEntry(i); */
        /* b_Info->GetEntry(i); */
        /* b_Data->GetEntry(i); */
        /* b_necls->GetEntry(i); */
        /* b_EclStream->GetEntry(i); */
        /* b_EclTrgw->GetEntry(i); */
        /* b_EclFilfo->GetEntry(i); */
        /* b_EclWord->GetEntry(i); */
        /* b_EclTagNum->GetEntry(i); */
        /* b_EclEvType->GetEntry(i); */
 
        /* // Open the file stream */
        /* myfile.open (currentFile); */
 
        /* // Write leaves name and value to the file stream */
        /* myfile << "nRun: " << nRun->GetValue(0) << std::endl; */
        /* myfile << "Info_RunNumber: " << Info_RunNumber->GetValue(0) << std::endl; */
        /* myfile << "Info_EventNumber: " << Info_EventNumber->GetValue(0) << std::endl; */
        /* myfile << "Info_Pileup: " << Info_Pileup->GetValue(0) << std::endl; */
        /* myfile << "Info_GenCod: " <<  Info_GenCod->GetValue(0) << std::endl; */
        /* myfile << "Info_PhiDecay: " << Info_PhiDecay->GetValue(0) << std::endl; */
        /* myfile << "Info_A1type: " << Info_A1type->GetValue(0) << std::endl; */
        /* myfile << "Info_A2Type: " << Info_A2Type->GetValue(0) << std::endl; */
        /* myfile << "Info_A3type: " << Info_A3type->GetValue(0) << std::endl; */
        /* myfile << "Info_B1type: " << Info_B1type->GetValue(0) << std::endl; */
        /* myfile << "Info_B2type: " << Info_B2type->GetValue(0) << std::endl; */
        /* myfile << "Info_B3type: " << Info_B3type->GetValue(0) << std::endl; */
        /* myfile << "Data_StreamNum: " << Data_StreamNum->GetValue(0) << std::endl; */
        /* myfile << "Data_AlgoNum: " << Data_AlgoNum->GetValue(0) << std::endl; */
        /* myfile << "Data_TimeSec: " << Data_TimeSec->GetValue(0) << std::endl; */
        /* myfile << "Data_TimeMusec: " << Data_TimeMusec->GetValue(0) << std::endl; */
        /* myfile << "Data_Ndtce: " << Data_Ndtce->GetValue(0) << std::endl; */
        /* myfile << "Data_Mcflag_tg: " << Data_Mcflag_tg->GetValue(0) << std::endl; */
        /* myfile << "Data_Currpos: " << Data_Currpos->GetValue(0) << std::endl; */
        /* myfile << "Data_Currele: " << Data_Currele->GetValue(0) << std::endl; */
        /* myfile << "Data_Luminosity: " << Data_Luminosity->GetValue(0) << std::endl; */
 
        /* // Close the file stream */
        /* myfile.close(); */
     /* } */
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
