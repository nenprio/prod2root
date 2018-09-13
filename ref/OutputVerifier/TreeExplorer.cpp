void TreeExplorer() {
    TFile* f = new TFile("sample.root");
    TTree* tree = (TTree*) f->Get("sample");
    
    Int_t numEntries = tree->GetEntries();
   

    // Declaration of leave types
    TLeaf*           nRun;
    TLeaf*           Info_RunNumber;
    TLeaf*           Info_EventNumber;
    TLeaf*           Info_Pileup;
    TLeaf*           Info_GenCod;
    TLeaf*           Info_PhiDecay;
    TLeaf*           Info_A1type;
    TLeaf*           Info_A2Type;
    TLeaf*           Info_A3type;
    TLeaf*           Info_B1type;
    TLeaf*           Info_B2type;
    TLeaf*           Info_B3type;
    TLeaf*           Data_StreamNum;
    TLeaf*           Data_AlgoNum;
    TLeaf*           Data_TimeSec;
    TLeaf*           Data_TimeMusec;
    TLeaf*           Data_Ndtce;
    TLeaf*           Data_Mcflag_tg;
    TLeaf*           Data_Currpos;
    TLeaf*           Data_Currele;
    TLeaf*           Data_Luminosity;
    TLeaf*           necls;
    TLeaf*           EclStream;
    TLeaf*           EclTrgw;
    TLeaf*           EclFilfo;
    TLeaf*           EclWord;
    TLeaf*           EclTagNum;
    TLeaf*           EclEvType;

    // List of branches
    TBranch        *b_nRun;
    TBranch        *b_Info;
    TBranch        *b_Data;
    TBranch        *b_necls;
    TBranch        *b_EclStream;
    TBranch        *b_EclTrgw;
    TBranch        *b_EclFilfo;
    TBranch        *b_EclWord;
    TBranch        *b_EclTagNum;
    TBranch        *b_EclEvType;

    b_nRun      = tree->GetBranch("nRun");
    b_Info      = tree->GetBranch("Info");
    b_Data      = tree->GetBranch("Data");
    b_necls     = tree->GetBranch("necls");
    b_EclStream = tree->GetBranch("EclStream");
    b_EclTrgw   = tree->GetBranch("EclTrgw");
    b_EclFilfo  = tree->GetBranch("EclFilfo");
    b_EclWord   = tree->GetBranch("EclWord");
    b_EclTagNum = tree->GetBranch("EclTagNum");
    b_EclEvType = tree->GetBranch("EclEvType");
    
    nRun = b_nRun->GetLeaf("nRun");
    Info_RunNumber = b_Info->GetLeaf("RunNumber");
    Info_EventNumber = b_Info->GetLeaf("EventNumber");
    Info_Pileup = b_Info->GetLeaf( "Pileup" );
    Info_GenCod = b_Info->GetLeaf( "GenCod" );
    Info_PhiDecay = b_Info->GetLeaf( "PhiDecay" );
    Info_A1type = b_Info->GetLeaf("A1type");
    Info_A2Type = b_Info->GetLeaf("A2Type");
    Info_A3type = b_Info ->GetLeaf("A3type");
    Info_B1type = b_Info->GetLeaf("B1type");
    Info_B2type = b_Info ->GetLeaf("B2type");
    Info_B3type = b_Info ->GetLeaf("B3type");
    Data_StreamNum  = b_Data->GetLeaf("StreamNum" );
    Data_AlgoNum    = b_Data->GetLeaf("AlgoNum" );
    Data_TimeSec    = b_Data->GetLeaf( "TimeSec" );
    Data_TimeMusec  = b_Data->GetLeaf( "TimeMusec" );
    Data_Ndtce      = b_Data->GetLeaf( "Ndtce" );
    Data_Mcflag_tg  = b_Data->GetLeaf( "Mcflag_tg" );
    Data_Currpos    = b_Data->GetLeaf( "Currpos" );
    Data_Currele    = b_Data->GetLeaf( "Currele" );
    Data_Luminosity = b_Data->GetLeaf( "Luminosity" );
    necls       = b_necls->GetLeaf( "necls" );
    EclStream   = b_EclStream->GetLeaf( "EclStream" );
    EclTrgw     = b_EclTrgw->GetLeaf( "EclTrgw" );
    EclFilfo    = b_EclFilfo->GetLeaf( "EclFilfo" );
    EclWord     = b_EclWord->GetLeaf( "EclWord" );
    EclTagNum   = b_EclTagNum->GetLeaf( "EclTagNum" );
    EclEvType   = b_EclEvType->GetLeaf( "EclEvType" );


    for(Int_t i=0; i<numEntries; i++) {
        b_nRun->GetEntry(i);
        b_Info->GetEntry(i);
        b_Data->GetEntry(i);
        b_necls->GetEntry(i);
        b_EclStream->GetEntry(i);
        b_EclTrgw->GetEntry(i);
        b_EclFilfo->GetEntry(i);
        b_EclWord->GetEntry(i);
        b_EclTagNum->GetEntry(i);
        b_EclEvType->GetEntry(i);

        std::cout << std::endl;
        std::cout << "================================" << std::endl;
        std::cout << "ENTRY " << i << std::endl;
        std::cout << "nRun: " << nRun->GetValue(0) << std::endl;
        std::cout << "Info_RunNumber: " << Info_RunNumber->GetValue(0) << std::endl;
        std::cout << "Info_EventNumber: " << Info_EventNumber->GetValue(0) << std::endl;
        std::cout << "Info_Pileup: " << Info_Pileup->GetValue(0) << std::endl;
        std::cout << "Info_GenCod: " <<  Info_GenCod->GetValue(0) << std::endl;
        std::cout << "Info_PhiDecay: " << Info_PhiDecay->GetValue(0) << std::endl;
        std::cout << "Info_A1type: " << Info_A1type->GetValue(0) << std::endl;
        std::cout << "Info_A2Type: " << Info_A2Type->GetValue(0) << std::endl;
        std::cout << "Info_A3type: " << Info_A3type->GetValue(0) << std::endl;
        std::cout << "Info_B1type: " << Info_B1type->GetValue(0) << std::endl;
        std::cout << "Info_B2type: " << Info_B2type->GetValue(0) << std::endl;
        std::cout << "Info_B3type: " << Info_B3type->GetValue(0) << std::endl;
        std::cout << "Data_StreamNum: " << Data_StreamNum->GetValue(0) << std::endl;
        std::cout << "Data_AlgoNum: " << Data_AlgoNum->GetValue(0) << std::endl;
        std::cout << "Data_TimeSec: " << Data_TimeSec->GetValue(0) << std::endl;
        std::cout << "Data_TimeMusec: " << Data_TimeMusec->GetValue(0) << std::endl;
        std::cout << "Data_Ndtce: " << Data_Ndtce->GetValue(0) << std::endl;
        std::cout << "Data_Mcflag_tg: " << Data_Mcflag_tg->GetValue(0) << std::endl;
        std::cout << "Data_Currpos: " << Data_Currpos->GetValue(0) << std::endl;
        std::cout << "Data_Currele: " << Data_Currele->GetValue(0) << std::endl;
        std::cout << "Data_Luminosity: " << Data_Luminosity->GetValue(0) << std::endl;
    }
}
