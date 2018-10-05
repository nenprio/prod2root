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
         void addBlockTele();
         void addBlockPizza();
         void addBlockClu();
         void addBlockPreClu();
         void addBlockCWRK();
         void addBlockCele();
         void addBlockDTCE();
         void addBlockDTCE0();
         void addBlockDCHits();
         void addBlockDHRE();
         void addBlockDHSP();
         TFile* getTFile();
         void fillTTree();
     private:
         TFile* outfile;
         TTree* fNewTree;
 };

#endif
