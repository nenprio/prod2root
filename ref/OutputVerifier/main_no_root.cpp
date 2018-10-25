#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <iostream>
#include <fstream>
#include "src/MyFunctions.hh"

int verifyFiles(const char *rF, const char *hbF, bool printInfo);

int main(int argc, char *argv[]) {
    // Check input args 
    if (argc!=3){
        printf("[Error] Number of arguments not valid.\n\n");
        printf("\tUsage:\t%s root-file hb-conv-file\n", argv[0]);
        return(EXIT_FAILURE);
    }

    // Input/Output definition
    const char *rFile   = argv[1];
    const char *hbFile  = argv[2];
    int num_err = verifyFiles(rFile, hbFile, true);
    printf("[Info] File: %s - Execution ends with %d errors.\n", rFile, num_err);

    return(EXIT_SUCCESS);
}

int verifyFiles(const char *rF, const char *hbF, bool printInfo) {
    // Define error strings
    const char *ErrorFileOpen     = "\t[Error]\tCannot open file";
    const char *ErrorLeafDiff     = "\t[Error]\tDifference on leaf";
    const char *ErrorLeafNotFound = "\t[Error]\tNot found correspondance for leaf";
    int errorCounter = 0;
    
    // Define control strings
    std::string rootFile = rF;
    std::string hbFile = hbF;
    char *error = 0;
    char *printout;

    // Define file streams
    std::ifstream streamRoot;
    std::ifstream streamHB;
    std::string rootLine;
    std::string hbLine;

    // Open file streams
    streamRoot.open(rootFile.c_str());
    streamHB.open(hbFile.c_str());

    // Check open file
     if(!streamRoot.is_open()){
         sprintf(error, "%s %s", ErrorFileOpen, rootFile.c_str());
         if (printInfo) {
             printf("%s\n", error);
         }
         return(-1);
     }
     if(!streamHB.is_open()){
         sprintf(error, "%s %s", ErrorFileOpen, hbFile.c_str());
         if (printInfo) {
             printf("%s\n", error);
         }
         return(-1);
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
     while( std::getline(streamRoot, rootLine) ) {
        nLinesRoot = 0;
        fieldFound = false;
        nameRoot = cut(rootLine.c_str(), ":", 1);
        valueRoot = cut(rootLine.c_str(), ":", 2);

        while( std::getline(streamHB, hbLine) ) {
            nLinesHB=0;
            nameHB = cut(hbLine.c_str(), ":", 1);
            valueHB = cut(hbLine.c_str(), ":", 2);

            if (myStricmp(nameRoot.c_str(), nameHB.c_str())==0) {
                fieldFound = true;
                /* printf("%s\t=>\t%s == %s\t\tOK\n", nameRoot.c_str(), valueRoot.c_str(), valueHB.c_str()); */
                if (myStricmp(valueRoot.c_str(), valueHB.c_str())!=0) {
                    sprintf(error, "[Error] Leaf %s: %s != %s", nameRoot.c_str(), valueRoot.c_str(), valueHB.c_str());
                    /* printf("%s\t=>\t%s != %s\t\tX\n", nameRoot.c_str(), valueRoot.c_str(), valueHB.c_str()); */
                    printf("%s\n", error);
                    errorCounter++;
                } 
                break;
            } 
            nLinesHB++;
        }

        // If the current field in not in hb file
        if (fieldFound==0) {
            printf("[Error] Leaf %s not found.\n", nameRoot.c_str());
            /* printf("%s\t=>\t???\t\t\t\t\tX\n", nameRoot.c_str()); */
            errorCounter++;
        } 
        
        // Reset hb file to the beginning
        streamHB.clear();
        streamHB.seekg(0, std::ios::beg);
        nLinesRoot ++;
    }

    return errorCounter;
}
