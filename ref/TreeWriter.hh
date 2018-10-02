#ifndef TREEWRITER_HH
#define TREEWRITER_HH
#include <TFile.h>
#include <TTree.h>

class TreeWriter{
     public:
         TreeWriter();
         ~TreeWriter();
         void addBlockInfo();
         void addBlockData();
         void addBlockEcl();
         void addBlockBPOS();
         void addBlockGdHit();
         void addBlockTime();
         void addBlockTrig();
         void addBlockC2Trig();
         void addBlockTellina();
         void addBlockPizzetta();
         TFile* getTFile();
         void fillTTree();
     private:
         TFile* outfile;
         TTree* fNewTree;
 };

#endif
