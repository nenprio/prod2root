#ifndef OUTPUT_VERIFIER_CXX
#define OUTPUT_VERIFIER_CXX
#include <iostream>
#include <OutputVerifier.hh>

OutputVerifier::OutputVerifier(char* rootFilePath, char* hbConvFilePath) {
    root = new TFile(rootFilePath);
    hbConv = new TFile(hbConvFilePath);

    std::cout << "[Info] OutputVerifier created" << std::endl;
}

OutputVerifier::~OutputVerifier() {
    delete root;
    delete hbConv;

    std::cout << "[Info] OutputVerifier closed" << std::endl;
}

#endif
