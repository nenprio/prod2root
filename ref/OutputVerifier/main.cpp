#include "src/MyFunctions.hh"
#include "src/OutputVerifier.hh"

int main() {
    println("[Debug] Hello World!");
    println(""); //Debug 
    
    // Input/Output definition
    const char *rFile   = "root/sample.root";
    const char *hbFile  = "root/hbConv.root";
    const char *outDir  = "out/";
   
    OutputVerifier *verifier = new OutputVerifier(rFile, hbFile, outDir);
    
    verifier->printInfo();
    
    /* verifier->exportRootTree(); */
    /* verifier->exportHBConvTree(); */
   
    bool debug = true;
/*    verifier->verifyEvent(52, debug); */
    verifier->verify(750, 1000, debug);

    if (verifier) {
        delete verifier;
        verifier = NULL;
    }
    return(0);
}
