#ifndef OUTPUTVERIFIER_HH
#define OUTPUTVERIFIER_HH
#include <TFile.h>
#include <TTree.h>

class OutputVerifier {
    public:
        OutputVerifier(const char *rFile, const char *hbFile, const char *outDir);
        ~OutputVerifier();
        char* getRootFile();
        char* getHBConvFile();
        char* getOutputDir();
        void  exportTreeToTxt(TTree *tree);
        void  exportRootTree();
        void  exportHBConvTree();
        int verifyEvent(int i, bool printInfo);
        bool  verify(int from, int to, bool printInfo);
        void  printInfo();
    private:
        const char *rootFile;
        const char *hbConvFile;
        const char *outputDir;

        const char *ENTRY_PREFIX;       // Output i-th file name: <tree_name><ENTRY_PREFIX><i>.out
};
#endif

