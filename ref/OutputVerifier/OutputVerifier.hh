#ifndef OUTPUT_VERIFIER_HH
#define OUTPUT_VERIFIER_HH
#include <TFile.h>

class OutputVerifier {
    public:
        OutputVerifier(char* rootFilePath, char* hbConvFilePath);
        ~OutputVerifier();
    private:
        TFile* root;
        TFile* hbConv;
}

#endif
