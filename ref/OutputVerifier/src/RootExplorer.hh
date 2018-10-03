#ifndef ROOTEXPLORER_HH
#define ROOTEXPLORER_HH
#include <TFile.h>
#include <TTree.h>

class RootExplorer {
    public:
        RootExplorer(const char *inFile, const char *outDir);
        ~RootExplorer();
        void exportEntriesToTxt();
        void printInfo();
    private:
        const char *sampleFilepath;
        const char *outputDir;
       
        // Declaration of tree and file
        TTree *fTree;
        TFile *f;
};

#endif
