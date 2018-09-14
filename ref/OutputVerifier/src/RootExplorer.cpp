#include <string>
#include "MyFunctions.hh"
#include "RootExplorer.hh"

RootExplorer::RootExplorer(std::string inFile, std::string outDir) {
    sampleFilepath=inFile;    
    outputDir=outDir;
    
    int statusOutDir = createDirRecursively(outDir);
    if(statusOutDir==false){
        println("EXIT DURING CREATION");
        exit(1);
    }
}

RootExplorer::~RootExplorer() {
    println("[Info] Run ends. Memory released.");
}



// Print information about internal variables.
//
// input:   -
// output:  -
void RootExplorer::printInfo() {
    std::string line1 = "[Info] ROOT File:\t";
    std::string line2 = "[Info] Output dir:\t";
    println(line1 + sampleFilepath);
    println(line2 + outputDir);
    println("");
}
