#include <iostream>
/* #include "OutputVerifier.hh" */

/* bool DEBUG = true; */

int main(int argc, char* argv[]) {
    //Check input correctness (trivial implementation)
    std::string USAGE = "Usage: script root_filepath hbook_converted_filepath";
    /* if(argc!=4){ */
    /*     std::cout << USAGE << std::endl; */
    /*     exit(1); */
    /* } */

    //Extract input parameters
    char* scriptFileName    = argv[0];
    char* rootFilePath      = argv[1];
    char* hbConvFilePath    = argv[2];
    char* outDirectoryPath  = argv[3];

    //TODO: check if these files exist, otherwise exit with error
    //TODO: check if exist output directory, otherwise create it

    //Debug printing
    /* if(DEBUG==true) { */
        std::cout << "[Info] Main started." << std::endl;    
        std::cout << "[Info] ROOT File: " << rootFilePath << std::endl;    
        std::cout << "[Info] Hbook Conv File: " << hbConvFilePath << std::endl;    
        std::cout << "[Info] Output Directory: " << outDirectoryPath << std::endl << std::endl;    
    /* } */

    //OutputVerifier object creation
    /* OutputVerifier* verifier = new OutputVerifier(rootFilePath, hbConvFilePath); */

    return 0;
}
