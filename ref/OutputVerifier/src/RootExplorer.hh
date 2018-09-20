#ifndef ROOTEXPLORER_HH
#define ROOTEXPLORER_HH
#include <TLeaf.h>

class RootExplorer {
    public:
        RootExplorer(const char *inFile, const char *outDir);
        ~RootExplorer();
        void exportEntriesToTxt();
        void printInfo();
    private:
        const char *sampleFilepath;
        const char *outputDir;
       
        // Declaration of tree
        TTree *tree;
        
        // Declaration of leaves
        TLeaf *nRun;
        TLeaf *Info_RunNumber;
        TLeaf *Info_EventNumber;
        TLeaf *Info_Pileup;
        TLeaf *Info_GenCod;
        TLeaf *Info_PhiDecay;
        TLeaf *Info_A1type;
        TLeaf *Info_A2Type;
        TLeaf *Info_A3type;
        TLeaf *Info_B1type;
        TLeaf *Info_B2type;
        TLeaf *Info_B3type;
        TLeaf *Data_StreamNum;
        TLeaf *Data_AlgoNum;
        TLeaf *Data_TimeSec;
        TLeaf *Data_TimeMusec;
        TLeaf *Data_Ndtce;
        TLeaf *Data_Mcflag_tg;
        TLeaf *Data_Currpos;
        TLeaf *Data_Currele;
        TLeaf *Data_Luminosity;
        TLeaf *necls;
        TLeaf *EclStream;
        TLeaf *EclTrgw;
        TLeaf *EclFilfo;
        TLeaf *EclWord;
        TLeaf *EclTagNum;
        TLeaf *EclEvType;

        // Declaration of branches
        TBranch *b_nRun;
        TBranch *b_Info;
        TBranch *b_Data;
        TBranch *b_necls;
        TBranch *b_EclStream;
        TBranch *b_EclTrgw;
        TBranch *b_EclFilfo;
        TBranch *b_EclWord;
        TBranch *b_EclTagNum;
        TBranch *b_EclEvType;
};

#endif
