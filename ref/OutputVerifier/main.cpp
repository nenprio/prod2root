#include "src/MyFunctions.hh"
#include "src/RootExplorer.hh"

int main() {
    println("Hello world"); 
    std::string sampleFile="root/sample.root";
    std::string outDir="out/sample_root_out";
    RootExplorer* rootExplorer = new RootExplorer(sampleFile, outDir);
    rootExplorer->printInfo();
    return(0);
}
