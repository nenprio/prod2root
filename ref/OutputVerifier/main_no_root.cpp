#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <iostream>
#include <fstream>
#include "src/MyFunctions.hh"

int main(int argc, char *argv[]) {
    bool printInfo = true;

    // Check input args 
    if (argc!=3){
        printf("[Error] Number of arguments not valid.\n\n");
        printf("\tUsage:\t%s root-file hb-conv-file\n", argv[0]);
        return(EXIT_FAILURE);
    }

    // Input/Output definition
    const char *rFile   = argv[1];
    const char *hbFile  = argv[2];
  
    return(EXIT_SUCCESS);
}

int verifyFiles(const char *rF, const char *hbF) {
    // Define error strings
    const char *ErrorFileOpen     = "\t[Error]\tCannot open file";
    const char *ErrorLeafDiff     = "\t[Error]\tDifference on leaf";
    const char *ErrorLeafNotFound = "\t[Error]\tNot found correspondance for leaf";
    int errorCounter = 0;

    // Define control strings
    std::string rootFile = rF;
    std::string hbFile = hbF;
    std::string error;
    std::string printout;

    // Define file streams
    std::ifstream streamRoot;
    std::ifstream streamHB;
    std::string rootLine;
    std::string hbLine;

    // Open file streams
    streamRoot.open(streamRoot.c_str());
    streamHB.open(streamHB.c_str());

    // Check open file
     if(!streamRoot.is_open()){
         sprintf(error, "%s %s", ErrorFileOpen, rootFile.c_str());
         if (printInfo) {
             printf("%s\n", error);
         }
         return(EXIT_FAILURE);
     }
     if(!streamHB.is_open()){
         sprintf(error, "%s %s", ErrorFileOpen, hbEventFile.c_str());
         if (printInfo) {
             printf("%s\n", error);
         }
         return(EXIT_FAILURE);
     }

     // Get number of lines
     int nLinesRoot = 0;
     int nLinesHB   = 0;
     std::string nameRoot;
     std::string nameHB;
     std::string valueRoot;
     std::string valueHB;
     bool fieldFound;

     // Loop on lines
     while( getline(streamRoot, rootLine) ) {
        fieldFound = false;
        nameRoot = cut(rootLine, ":", 1);
        valueRoot = cut(rootLine, ":", 2);
        
        while( getline(streamRoot, rootLine) ) {
            nameHB = cut(hbLine, ":", 1);
            valueHB = cut(hbLine, ":", 2);

            if (myStricmp(nameRoot.c_str(), nameHB.c_str())==0) {

            } 
            nLinesHB++;
        }
        // If the current field in not in hb file
        if (fieldFound==false) {
            if (printInfo) {
                sprintf(error, "%s %s", ErrorLeafNotFound, nameRoot.c_str());
                printf(error.c_str());
            }
            errorCounter++;
        }
        // Reset hb file to the beginning
        streamHB.clear();
        streamHB.seekg (0, std::ios::beg);
        nLinesRoot ++;
    }
}
