#ifndef ROOTEXPLORER_HH
#define ROOTEXPLORER_HH
#include <string>

class RootExplorer {
    public:
        RootExplorer(std::string inFile, std::string outDir);
        ~RootExplorer();
        void printInfo();
    private:
        std::string sampleFilepath;
        std::string outputDir;
};

#endif
