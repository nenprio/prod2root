#ifndef TREEWRITER_HH
#define TREEWRITER_HH
#include <TFile.h>
#include <TTree.h>

class TreeWriter{
     public:
         TreeWriter();
         ~TreeWriter();
         void printHeaderFlags();
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
         void addBlockTorta();
         void addBlockTele();
         void addBlockPizza();
         void addBlockClu();
         void addBlockCluMC();
         void addBlockPreClu();
         void addBlockCWRK();
         void addBlockCele();
         void addBlockCeleMC();
         void addBlockDTCE();
         void addBlockDTCE0();
         void addBlockDCHits();
         void addBlockDHRE();
         void addBlockDHSP();
         void addBlockTrkV();
         void addBlockVtx();
         void addBlockTrkS();
         void addBlockTrkMC();
         void addBlockTrkVOld();
         void addBlockVtxOld();
         void addBlockTrkSOld();
         void addBlockTrkMCOld();
         void addBlockDHIT();
         void addBlockDEDx();
         void addBlockDPRS();
         void addBlockMC();
         void addBlockTCLO();
         void addBlockTCLOld();
         void addBlockCFHI();
         void addBlockQIHI();
         void addBlockTRKQ();
         void addBlockQELE();
         void addBlockQCal();
         void addBlockKNVO();
         void addBlockVNVO();
         void addBlockVNVB();
         void addBlockINVO();
         void addBlockECLO();
         void addBlockECLO2();
         void addBlockCSPS();
         void addBlockCSPSMC();
         TFile* getTFile();
         void fillTTree();
         bool logicalToBool(int flag);
     private:
         TFile* outfile;
         TTree* fNewTree;
 };

#endif
