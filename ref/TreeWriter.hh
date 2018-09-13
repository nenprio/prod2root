#ifndef TREEWRITER_HH
#define TREEWRITER_HH
#include <TFile.h>
#include <TTree.h>

class TreeWriter{
     public:
         TreeWriter();
         ~TreeWriter();
         void addBlockEcl();
         TFile* getTFile();
         void fillTTree();
     private:
         TFile* outfile;
         TTree* fNewTree;
 };

#endif
