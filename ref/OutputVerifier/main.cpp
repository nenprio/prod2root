#include "src/MyFunctions.hh"
#include "src/OutputVerifier.hh"

int main() {
    println("[Debug] Hello World!");
    println(""); //Debug 
    
    // Input/Output definition
    const char *rFile   ="root/sample.root";
    const char *hbFile  ="root/hbConv.root";
    const char *outDir  ="out/";
   
    OutputVerifier *verifier = new OutputVerifier(rFile, hbFile, outDir);
    
    verifier->printInfo();
    
//    verifier->exportRootTree();
  //  verifier->exportHBConvTree();
    
    verifier->verifyEvent(0);

    return(0);
}
