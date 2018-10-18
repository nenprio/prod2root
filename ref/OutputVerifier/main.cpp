#include <stdlib.h>
#include "src/MyFunctions.hh"
#include "src/OutputVerifier.hh"

int main(int argc, char *argv[]) {
    // Check input args 
    if (argc!=3){
        printf("[Error] Number of arguments not valid.\n\n");
        printf("\tUsage:\t%s root-file output-directory\n", argv[0]);
        return(EXIT_FAILURE);
    }

    // Input/Output definition
    const char *rFile   = argv[1];
    /* const char *hbFile  = "root/hbConv.root"; */
    const char *outDir  = argv[2];
   
    OutputVerifier *verifier = new OutputVerifier(rFile, "", outDir);
    /* OutputVerifier *verifier = new OutputVerifier(rFile, hbFile, outDir); */
    
    /* verifier->printInfo(); */
    
    verifier->exportRootTree();
    /* verifier->exportHBConvTree(); */
   
    /* bool debug = true; */
    /* verifier->verifyEvent(52, debug); */ 
    /* verifier->verify(750, 1000, debug);*/
    if (verifier) {
        delete verifier;
        verifier = NULL;
    }
    return(EXIT_SUCCESS);
}
