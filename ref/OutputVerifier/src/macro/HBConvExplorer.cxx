#include <string>
#include <iostream>
#include <sys/types.h>
#include <sys/stat.h>

void HBConvExplorer(std::string sampleFilepath, std::string outputDir) {
    std::string ERR_OUTDIR_CREATION         = "[Error] Output dir creation fails.";
    std::string WARN_OUTDIR_ALREADY_EXISTS  = "[Warning] Output dir already exists. Its content will be overwritten.";
    std::string INFO_END_EXEC               = "[Info] Execution ends successfully. You can find the entries in the output directory.";

    // Input information
    std::cout << "[Info] HBConv file:\t" << sampleFilepath << std::endl;
    std::cout << "[Info] Output dir:\t" << outputDir << std::endl;
    std::cout << std::endl;

    // Check if output dir exists and is a dir, otherwise try to create it
    int checkCreated;
    int existsDir=0;
    struct stat statbuf;
    if (stat(outputDir.c_str(), &statbuf) != -1) {
        if (S_ISDIR(statbuf.st_mode)){
            existsDir=1;
            std::cout << WARN_OUTDIR_ALREADY_EXISTS << std::endl;
        }
    }

    if (existsDir==0){
        checkCreated=mkdir(outputDir.c_str(), S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
        if(checkCreated==-1) {
            std::cout << ERR_OUTDIR_CREATION << errno << std::endl;
            exit(1);
        }
    }

    // Load the file, the tree and get the number of events
    TFile* f = new TFile(sampleFilepath.c_str());
    TTree* tree = (TTree*) f->Get("PROD2NTU/h1");
    Int_t numEntries = tree->GetEntries();
   
    // Declaration of leave types
    TLeaf*           nRun;
    /* TLeaf*           Info_RunNumber; */
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
    /* TLeaf*           Data_StreamNum; */
    /* TLeaf*           Data_AlgoNum; */
    TLeaf*           Data_TimeSec;
    TLeaf*           Data_TimeMusec;
    /* TLeaf*           Data_Ndtce; */
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

    TBranch        *b_nev;   //!
    TBranch        *b_pileup;   //!
    TBranch        *b_gcod;   //!
    TBranch        *b_phid;   //!
    TBranch        *b_a1typ;   //!
    TBranch        *b_a2typ;   //!
    TBranch        *b_a3typ;   //!
    TBranch        *b_b1typ;   //!
    TBranch        *b_b2typ;   //!
    TBranch        *b_b3typ;   //!
    
    TBranch        *b_Timesec;   //!
    TBranch        *b_Timemusec;   //!
    TBranch        *b_Ipos;   //!
    TBranch        *b_Iele;   //!
    TBranch        *b_Lumi;   //!
    TBranch        *b_mcflag;   //!

    TBranch        *b_necls;
    TBranch        *b_EclStream;
    TBranch        *b_EclTrgw;
    TBranch        *b_EclFilfo;
    TBranch        *b_EclWord;
    TBranch        *b_EclTagNum;
    TBranch        *b_EclEvType;

    b_nRun      = tree->GetBranch("nrun");
    b_nev       = tree->GetBranch("nev");
    b_pileup    = tree->GetBranch("pileup");
    b_gcod      = tree->GetBranch("gcod");
    b_phid      = tree->GetBranch("phid");
    b_a1typ     = tree->GetBranch("a1typ");
    b_a2typ     = tree->GetBranch("a2typ");
    b_a3typ     = tree->GetBranch("a3typ");
    b_b1typ     = tree->GetBranch("b1typ");
    b_b2typ     = tree->GetBranch("b2typ");
    b_b3typ     = tree->GetBranch("b3typ");

    b_Timesec   = tree->GetBranch("Timesec");
    b_Timemusec = tree->GetBranch("Timemusec");
    b_Ipos      = tree->GetBranch("Ipos");
    b_Iele      = tree->GetBranch("Iele");
    b_Lumi      = tree->GetBranch("Lumi");
    b_mcflag    = tree->GetBranch("mcflag");
    
    b_necls     = tree->GetBranch("necls");
    b_EclStream = tree->GetBranch("Eclstream");
    b_EclTrgw   = tree->GetBranch("Ecltrgw");
    b_EclFilfo  = tree->GetBranch("Eclfilfo");
    b_EclWord   = tree->GetBranch("Eclword");
    b_EclTagNum = tree->GetBranch("Ecltagnum");
    b_EclEvType = tree->GetBranch("Eclevtype");
    
    nRun = b_nRun->GetLeaf("nrun");
    /* Info_RunNumber = b_Info->GetLeaf("RunNumber"); */
    Info_EventNumber= b_nev->GetLeaf("nev");
    Info_Pileup     = b_pileup->GetLeaf( "pileup" );
    Info_GenCod     = b_gcod->GetLeaf( "gcod" );
    Info_PhiDecay   = b_phid->GetLeaf( "phid" );
    Info_A1type     = b_a1typ->GetLeaf("a1typ");
    Info_A2Type     = b_a2typ->GetLeaf("a2typ");
    Info_A3type     = b_a3typ->GetLeaf("a3typ");
    Info_B1type     = b_b1typ->GetLeaf("b1typ");
    Info_B2type     = b_b2typ->GetLeaf("b2typ");
    Info_B3type     = b_b3typ->GetLeaf("b3typ");
    /* Data_StreamNum  = b_Data->GetLeaf("StreamNum" ); */
    /* Data_AlgoNum    = b_Data->GetLeaf("AlgoNum" ); */
    Data_TimeSec    = b_Timesec->GetLeaf( "Timesec" );
    Data_TimeMusec  = b_Timemusec->GetLeaf( "Timemusec" );
    /* Data_Ndtce      = b_Data->GetLeaf( "Ndtce" ); */
    Data_Mcflag_tg  = b_mcflag->GetLeaf( "mcflag" );
    Data_Currpos    = b_Ipos->GetLeaf( "Ipos" );
    Data_Currele    = b_Iele->GetLeaf( "Iele" );
    Data_Luminosity = b_Lumi->GetLeaf( "Lumi" );
    necls       = b_necls->GetLeaf( "necls" );
    EclStream   = b_EclStream->GetLeaf( "Eclstream" );
    EclTrgw     = b_EclTrgw->GetLeaf( "Ecltrgw" );
    EclFilfo    = b_EclFilfo->GetLeaf( "Eclfilfo" );
    EclWord     = b_EclWord->GetLeaf( "Eclword" );
    EclTagNum   = b_EclTagNum->GetLeaf( "Ecltagnum" );
    EclEvType   = b_EclEvType->GetLeaf( "Eclevtype" );

    //Declare file stream and the output filename
    ofstream myfile;
    std::string currentFile;

    for(Int_t i=0; i<numEntries; i++) {
        // Update the output filename with respect to the current entry
        currentFile = outputDir + "/entry" + std::to_string(i) + ".out";

        // For each branch, get the i-th entry
        b_nRun->GetEntry(i);
        
        b_nev->GetEntry(i);
        b_pileup->GetEntry(i);    
        b_gcod->GetEntry(i);     
        b_phid->GetEntry(i);    
        b_a1typ->GetEntry(i);  
        b_a2typ->GetEntry(i); 
        b_a3typ->GetEntry(i);
        b_b1typ->GetEntry(i);
        b_b2typ->GetEntry(i);
        b_b3typ->GetEntry(i);
 
        b_Timesec->GetEntry(i);
        b_Timemusec->GetEntry(i);
        b_Ipos->GetEntry(i);    
        b_Iele->GetEntry(i);   
        b_Lumi->GetEntry(i);  
        b_mcflag->GetEntry(i);
        
        b_necls->GetEntry(i);
        b_EclStream->GetEntry(i);
        b_EclTrgw->GetEntry(i);
        b_EclFilfo->GetEntry(i);
        b_EclWord->GetEntry(i);
        b_EclTagNum->GetEntry(i);
        b_EclEvType->GetEntry(i);

        // Open the file stream
        myfile.open (currentFile);
        
        // Write leaves name and value to the file stream
        myfile << "nRun: "              << nRun->GetValue(0)            << std::endl;
        myfile << "Info_RunNumber: "    << std::endl;
        myfile << "Info_EventNumber: "  << std::endl;
        myfile << "Info_Pileup: "       << Info_Pileup->GetValue(0)     << std::endl;
        myfile << "Info_GenCod: "       <<  Info_GenCod->GetValue(0)    << std::endl;
        myfile << "Info_PhiDecay: "     << Info_PhiDecay->GetValue(0)   << std::endl;
        myfile << "Info_A1type: "       << Info_A1type->GetValue(0)     << std::endl;
        myfile << "Info_A2Type: "       << Info_A2Type->GetValue(0)     << std::endl;
        myfile << "Info_A3type: "       << Info_A3type->GetValue(0)     << std::endl;
        myfile << "Info_B1type: "       << Info_B1type->GetValue(0)     << std::endl;
        myfile << "Info_B2type: "       << Info_B2type->GetValue(0)     << std::endl;
        myfile << "Info_B3type: "       << Info_B3type->GetValue(0)     << std::endl;
        myfile << "Data_StreamNum: "    << std::endl;
        myfile << "Data_AlgoNum: "      << std::endl;
        myfile << "Data_TimeSec: "      << Data_TimeSec->GetValue(0)    << std::endl;
        myfile << "Data_TimeMusec: "    << Data_TimeMusec->GetValue(0)  << std::endl;
        myfile << "Data_Ndtce: "        << std::endl;
        myfile << "Data_Mcflag_tg: "    << Data_Mcflag_tg->GetValue(0)  << std::endl;
        myfile << "Data_Currpos: "      << Data_Currpos->GetValue(0)    << std::endl;
        myfile << "Data_Currele: "      << Data_Currele->GetValue(0)    << std::endl;
        myfile << "Data_Luminosity: "   << Data_Luminosity->GetValue(0) << std::endl;

        // Close the file stream
        myfile.close();
    }

    std::cout << INFO_END_EXEC << std::endl;
}
