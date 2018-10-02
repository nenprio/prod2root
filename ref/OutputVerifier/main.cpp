#include "src/MyFunctions.hh"
#include "src/RootExplorer.hh"
#include "src/HBConvExplorer.hh"
#include <TFile.h>

int main() {
    println("[Debug] Hello World!");
    println(""); //Debug 
    
    // Input/Output definition
    const char *haddFile    ="root/result.root";
    const char *hbConvFile  ="root/hbConv.root";
    const char *sampleFile  ="root/sample.root";
    const char *outSampleDir="out/sample_root_out";
    const char *outHbConvDir="out/hb_conv_out";
    
    // Create object RootExplorer
    RootExplorer *rootExplorer = new RootExplorer(sampleFile, outSampleDir);
    rootExplorer->printInfo();

    //Create object HBConvExplorer
    HBConvExplorer *hbConvExplorer = new HBConvExplorer(hbConvFile, outHbConvDir);
    hbConvExplorer->printInfo();
   
    /* TFile *f = new TFile(haddFile.c_str(), "READ"); */
    /* if(f->IsOpen()) */
    /*     println("Hadd file open"); */
    /* else */
    /*     println("ERROR during hadd opening"); */

    return(0);
}
