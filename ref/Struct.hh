#ifndef STRUCT_HH
#define STRUCT_HH
// This header contains all the structs needed to 
// write ntuple data to C++ format.

const int MaxNumClu   = 100;
const int MaxEclSize  = 8;
const int MaxTrgChan  = 1000;
const int TriggerElm  = 300;
const int MaxNTele    = 300;
const int MaxNPack    = 300;
const int NeleCluMax  = 2000;
const int NMaxDC      = 1500;
const int MaxNumDHSP  = 500;
const int MaxNumTrkV  = 30;
const int MaxNumVtx   = 10;
const int MaxNumTrk   = 100;
const int MaxNumDHIT  = 2500;
const int MaxRowsDEDx = 20;
const int MaxColsDEDx = 100;
const int MaxNumDPRS  = 200;
const int MaxNTrkGen  = 50;
const int MaxNVtxGen  = 30;

//Verb for Talk_to module
extern "C"{
  extern struct{
    int infoFlag;
    int dataFlag;
    int bposFlag;
    int gdhitFlag;
    int eclsFlag;
    int trigFlag;
    int c2trgFlag;
    int tellinaFlag;
    int pizzettaFlag;
    int tortaFlag;
    int teleFlag;
    int pizzaFlag;
    int timeFlag;
    int clusFlag;
    int cluMCFlag;
    int preclusFlag;
    int cwrkFlag;
    int celeFlag;
    int celeMCFlag;
    int dtceFlag;
    int dtce0Flag;
    int dchitsFlag;
    int dhreFlag;
    int dhspFlag;
    int trkvFlag;
    int vtxFlag;
    int trksFlag;
    int trkMCFlag;
    int trkvOldFlag;
    int vtxOldFlag;
    int trksOldFlag;
    int trkMCOldFlag;
    int dhitFlag;
    int dedxFlag;
    int dprsFlag;
    int mcFlag;
  }sammenu_;
}
// Block:   evtinfo
extern "C"{
  extern struct{
    int NumRun;
    int NumEv;
    int Pileup;
    int GCod;
    int PhiD;
    int A1Typ;
    int A2Typ;
    int A3Typ;
    int B1Typ;
    int B2Typ;
    int B3Typ;
  }evtinfo_;
}

// Block:   evtdata
extern "C"{
  extern struct{
    int StreamNum;
    int AlgoNum;
    int TimeSec;
    int TimeMusec;
    int Ndtce_copy;
    int McFlag;
    float IPos;
    float IEle;
    float Lumi;
  }eventinfo_;
}

// Block:   evtecls
extern "C"{
  extern struct{
    int NEcls;
    int EclTrgw;
    int EclFilfo;
    int EclWord[MaxEclSize];
    int EclStream[MaxEclSize];
    int EclTagNum[MaxEclSize];
    int EclEvType[MaxEclSize];
    int NEcls2;
    int EclTrgw2;
    int EclFilfo2;
    int EclWord2[MaxEclSize];
    int EclStream2[MaxEclSize];
    int EclTagNum2[MaxEclSize];
    int EclEvType2[MaxEclSize];
  }evtecls_;
}

// Block:    evtbpos
extern "C" {
  extern struct {
    float BPx;
    float BPy;
    float BPz;
    float Bx;
    float By;
    float Bz;
    float BWidPx;
    float BWidPy;
    float BWidPz;
    float BSx;
    float BSy;
    float BSz;
    float BLumx;
    float BLumz;
    float Broots;
    float BrootsErr;
  }evtbpos_;
}

// Block:   evttime
extern "C"{
  extern struct{
    float TPhased_mc;
    float T0Dc0;
    float T0Hit0;
    float T0Clu0;
    float T0Step1;
    float DelayCable;
    float TBunch;
  }evttime_;
}

// Block:   evtgdhit
extern "C" {
  extern struct {
    int DtceHit;
    int DhreHit;
    int DprsHit;
    int DtfsHit;
  }evtgdhit_;
}

// Block:   evttrig
extern "C" {
  extern struct {
    int Trgw1;
    int Trgw2;
  }evttrig_;
}

// Block:   evtc2trig
extern "C" {
  extern struct {
    int NSec;
    int NSec_NoClu;
    int NSec2Clu;
    int NClu2s;
    int NNorm[MaxNumClu];
    int NormAdd[MaxNumClu];
    int NOver[MaxNumClu];
    int OverAdd[MaxNumClu];
    int NCosm[MaxNumClu];
    int CosmAdd[MaxNumClu];
  }evtc2trig_;
}

// Block:   tellina
extern "C" {
  extern struct {
    int NTel;
    int Add_Tel[TriggerElm];
    int Bitp_Tel[TriggerElm];
    float Ea_Tel[TriggerElm];
    float Eb_Tel[TriggerElm];
    float Ta_Tel[TriggerElm];
    float Tb_Tel[TriggerElm];
  }tellina_;
}

// Block:   pizzetta
extern "C" {
  extern struct {
    int NPiz;
    int Add_Piz[TriggerElm];
    float Ea_Piz[TriggerElm];
    float Eb_Piz[TriggerElm];
    float E_Piz[TriggerElm];
    float Z_Piz[TriggerElm];
  }pizzetta_;
}

// Block:   torta
extern "C" {
  extern struct {
    float tSpent;
    float tDead;
    int Type;
    int BPhi;
    int EPhi;
    int WPhi;
    int BBha;
    int EBha;
    int WBha;
    int BCos;
    int ECos;
    int WCos;
    int E1W1_Dwn;
    int B1_Dwn;
    int T0d_Dwn;
    int VetoCos;
    int VetoBha;
    int Bdw;
    int Rephasing;
    int TDC1_Pht1;
    int Dt2_T1;
    int Fiducial;
    int T1c;
    int T1d;
    int T2d;
    int Tcr;
    int TCaf_Tcrd;
    int TCaf_T2d;
    int Moka_T2d;
    int Moka_T2Dsl[10];
  }torta_;
}

// Block:   evttele
extern "C" {
  extern struct {
    int NTele;
    int Det_Trg[MaxNTele];
    int BitP[MaxNTele];
    int Sector[MaxNTele];
    int SerKind[MaxNTele];
    float Ea_Trg[MaxNTele];
    float Eb_Trg[MaxNTele];
    float Ta_Trg[MaxNTele];
    float Tb_Trg[MaxNTele];
  }tele_;
}

// Block:   pizza
extern "C" {
  extern struct {
    int NPack;
    int PakSect[MaxNPack];
    int PakDet[MaxNPack];
    int PakSerk[MaxNPack];
    float Ea_Pack[MaxNPack];
    float Eb_Pack[MaxNPack];
    float E_Rec[MaxNPack];
    float Z_mod[MaxNPack];
  }pizza_;
}

// Block:   evtclu
extern "C" {
  extern struct {
    int NClu;
    float EneCl[MaxNumClu];
    float TCl[MaxNumClu];
    float XCl[MaxNumClu];
    float YCl[MaxNumClu];
    float ZCl[MaxNumClu];
    float XaCl[MaxNumClu];
    float YaCl[MaxNumClu];
    float ZaCl[MaxNumClu];
    float XRmCl[MaxNumClu];
    float YRmsCl[MaxNumClu];
    float ZrmsCl[MaxNumClu];
    float TrmsCl[MaxNumClu];
    int FlagCl[MaxNumClu];
  }evtclu_;
}

// Block:   CluMC
extern "C" {
  extern struct {
    int NCluMc;
    int NPar[MaxNumClu];
    int PNum1[MaxNumClu];
    int Pid1[MaxNumClu];
    int PNum2[MaxNumClu];
    int Pid2[MaxNumClu];
    int PNum3[MaxNumClu];
    int Pid3[MaxNumClu];
  }clumc_;
}

// Block:   preclu
extern "C" {
  extern struct {
    int NPClu;
    float EPre[MaxNumClu];
    float TPre[MaxNumClu];
    float XPre[MaxNumClu];
    float YPre[MaxNumClu];
    float ZPre[MaxNumClu];
    float TAPre[MaxNumClu];
    float TBPre[MaxNumClu];
    float TARPre[MaxNumClu];
    float TBRPre[MaxNumClu];
  }preclu_;
}

// Block:   cwrk
extern "C" {
  extern struct {
    int NCHit;
    int IClu[NeleCluMax];
    int ICel[NeleCluMax];
    int CAdd[NeleCluMax];
    int CmcHit[NeleCluMax];
    int Ckine[NeleCluMax];
    float Ene[NeleCluMax];
    float T[NeleCluMax];
    float X[NeleCluMax];
    float Y[NeleCluMax];
    float Z[NeleCluMax];
  }cwrk_;
}

// Block:   cele
extern "C" {
  extern struct {
    int NCel;
    int ICl[NeleCluMax];
    int Det[NeleCluMax];
    int Wed[NeleCluMax];
    int Pla[NeleCluMax];
    int Col[NeleCluMax];
    float Ea[NeleCluMax];
    float Ta[NeleCluMax];
    float Eb[NeleCluMax];
    float Tb[NeleCluMax];
  }cele_;
}

// Block:   celeMC
extern "C" {
  extern struct {
    int NCelMc;
    float EMc[NeleCluMax];
    float TMc[NeleCluMax];
    float XMc[NeleCluMax];
    float YMc[NeleCluMax];
    float ZMc[NeleCluMax];
    int PTyp[NeleCluMax];
    int KNum[NeleCluMax];
    int NHit[NeleCluMax];
  }celemc_;
}

// Block:   dtce
extern "C" {
  extern struct {
    int nDTCE;
    int nSmall;
    int iLayerDTCE[NMaxDC];
    int iWireDTCE[NMaxDC];
    float tDTCE[NMaxDC];
  }dtce_;
}

// Block:   dtce0
extern "C" {
  extern struct {
    int nDTCE0;
    int iLayerDTCE0[NMaxDC];
    int iWireDTCE0[NMaxDC];
    float tDTCE0[NMaxDC];
  }dtce0_;
}

// Block:   dcnhits
extern "C" {
  extern struct {
    int nDCHR;
    int nSmallDCm;
    int nSmallDCp;
    int nBigDCm;
    int nBigDCp;
    int nCellDC;
    int nSmallDC;
  }dchits_;
}

// Block:   dhre
extern "C" {
  extern struct {
    int nDHRE;
    int iLayerDHRE[NMaxDC];
    int iWireDHRE[NMaxDC];
    int iTrkDHRE[NMaxDC];
    float rDHRE[NMaxDC];
    float eDHRE[NMaxDC];
  }dhre_;
}

// Block:   dhsp
extern "C" {
  extern struct {
    int nDHSP;
    int TrkDh[MaxNumDHSP];
    int Layer[MaxNumDHSP];
    int Wire[MaxNumDHSP];
    float Time[MaxNumDHSP];
    float DPar[MaxNumDHSP];
    float Res[MaxNumDHSP];
    float XDh[MaxNumDHSP];
    float YDh[MaxNumDHSP];
    float ZDh[MaxNumDHSP];
  }dhsp_;
}

// Block:   trkv
extern "C" {
  extern struct {
    int nTv;
    int iV[MaxNumTrkV];
    int TrkNumV[MaxNumTrkV];
    float CurV[MaxNumTrkV];
    float PhiV[MaxNumTrkV];
    float CoTv[MaxNumTrkV];
    float PxTv[MaxNumTrkV];
    float PyTv[MaxNumTrkV];
    float PzTv[MaxNumTrkV];
    float pModV[MaxNumTrkV];
    float LenV[MaxNumTrkV];
    float ChiV[MaxNumTrkV];
    int PidTv[MaxNumTrkV];
    float Cov11Tv[MaxNumTrkV];
    float Cov12Tv[MaxNumTrkV];
    float Cov13Tv[MaxNumTrkV];
    float Cov22Tv[MaxNumTrkV];
    float Cov23Tv[MaxNumTrkV];
    float Cov33Tv[MaxNumTrkV];
  }trkv_;
}

// Block:   vtx
extern "C" {
  extern struct {
    int nV;
    int Vetx[MaxNumVtx];
    float xV[MaxNumVtx];
    float yV[MaxNumVtx];
    float zV[MaxNumVtx];
    float ChiVtx[MaxNumVtx];
    int QuaLv[MaxNumVtx];
    int FitiDv[MaxNumVtx];
    float VTXCov1[MaxNumVtx];
    float VTXCov2[MaxNumVtx];
    float VTXCov3[MaxNumVtx];
    float VTXCov4[MaxNumVtx];
    float VTXCov5[MaxNumVtx];
    float VTXCov6[MaxNumVtx];
  }vertices_;
}

// Block:   trks
extern "C" {
  extern struct {
    int nT;
    int TrkInd[MaxNumTrk];
    int TrkVer[MaxNumTrk];
    float Cur[MaxNumTrk];
    float Phi[MaxNumTrk];
    float Cot[MaxNumTrk];
    float Pxt[MaxNumTrk];
    float Pyt[MaxNumTrk];
    float Pzt[MaxNumTrk];
    float PMod[MaxNumTrk];
    float Len[MaxNumTrk];
    float xFirst[MaxNumTrk];
    float yFirst[MaxNumTrk];
    float zFirst[MaxNumTrk];
    float CurLa[MaxNumTrk];
    float PhiLa[MaxNumTrk];
    float CotLa[MaxNumTrk];
    float PxtLa[MaxNumTrk];
    float PytLa[MaxNumTrk];
    float PztLa[MaxNumTrk];
    float PModLa[MaxNumTrk];
    float SPca[MaxNumTrk];
    float SZeta[MaxNumTrk];
    float SCurV[MaxNumTrk];
    float SCotG[MaxNumTrk];
    float SPhi[MaxNumTrk];
    float xLast[MaxNumTrk];
    float yLast[MaxNumTrk];
    float zLast[MaxNumTrk];
    float xPca2[MaxNumTrk];
    float yPca2[MaxNumTrk];
    float zPca2[MaxNumTrk];
    float QTrk2[MaxNumTrk];
    float CotPca2[MaxNumTrk];
    float PhiPca2[MaxNumTrk];
    int nPrHit[MaxNumTrk];
    int nFitHit[MaxNumTrk];
    int nMskInk[MaxNumTrk];
    float Chi2Fit[MaxNumTrk];
    float Chi2Ms[MaxNumTrk];
  }trks_;
}

// Block:   trkmc
extern "C" {
  extern struct {
    int nTfMC;
    int NConTr[MaxNumTrk];
    int TrkIne1[MaxNumTrk];
    int TrType1[MaxNumTrk];
    int TrHits1[MaxNumTrk];
    int TrkIne2[MaxNumTrk];
    int TrType2[MaxNumTrk];
    int TrHits2[MaxNumTrk];
    int TrkIn3[MaxNumTrk];
    int TrType3[MaxNumTrk];
    int TrHits3[MaxNumTrk];
    float xFMC[MaxNumTrk];
    float yFMC[MaxNumTrk];
    float zFMC[MaxNumTrk];
    float PxFMC[MaxNumTrk];
    float PyFMC[MaxNumTrk];
    float PzFMC[MaxNumTrk];
    float xLMC[MaxNumTrk];
    float yLMC[MaxNumTrk];
    float zLMC[MaxNumTrk];
    float PxLMC[MaxNumTrk];
    float PyLMC[MaxNumTrk];
    float PzLMC[MaxNumTrk];
    float xFMC2[MaxNumTrk];
    float yFMC2[MaxNumTrk];
    float zFMC2[MaxNumTrk];
    float PxFMC2[MaxNumTrk];
    float PyFMC2[MaxNumTrk];
    float PzFMC2[MaxNumTrk];
    float xLMC2[MaxNumTrk];
    float yLMC2[MaxNumTrk];
    float zLMC2[MaxNumTrk];
    float PxLMC2[MaxNumTrk];
    float PyLMC2[MaxNumTrk];
    float PzLMC2[MaxNumTrk];
  }trkmc_;
}

// Block:   trkvold
extern "C" {
  extern struct {
    int nTVOld;
    int iVOld[MaxNumTrkV];
    int TrkNumVOld[MaxNumTrkV];
    float CurVOld[MaxNumTrkV];
    float PhiVOld[MaxNumTrkV];
    float CotVOld[MaxNumTrkV];
    float PxTVOld[MaxNumTrkV];
    float PyTVOld[MaxNumTrkV];
    float PzTVOld[MaxNumTrkV];
    float PModVOld[MaxNumTrkV];
    float LenVOld[MaxNumTrkV];
    float ChiVOld[MaxNumTrkV];
    int PidTVOld[MaxNumTrkV];
    float Cov11TVOld[MaxNumTrkV];
    float Cov12TVOld[MaxNumTrkV];
    float Cov13TVOld[MaxNumTrkV];
    float Cov22TVOld[MaxNumTrkV];
    float Cov23TVOld[MaxNumTrkV];
    float Cov33TVOld[MaxNumTrkV];
  }trkvold_;
}

// Block:   vtxold
extern "C" {
  extern struct {
    int nVOld;
    int VtxOld[MaxNumVtx];
    float xVOld[MaxNumVtx];
    float yVOld[MaxNumVtx];
    float ZVOld[MaxNumVtx];
    float ChiVTxOld[MaxNumVtx];
    int QuaLVOld[MaxNumVtx];
    int FitIdVOld[MaxNumVtx];
    float VtxCov1Old[MaxNumVtx];
    float VtxCov2Old[MaxNumVtx];
    float VtxCov3Old[MaxNumVtx];
    float VtxCov4Old[MaxNumVtx];
    float VtxCov5Old[MaxNumVtx];
    float VtxCov6Old[MaxNumVtx];
  }vtxold_;
}

// Block:   trkold
extern "C" {
  extern struct {
    int nTOld;
    int TrkIndOld[MaxNumTrk];
    int TrkVerOld[MaxNumTrk];
    float CurOld[MaxNumTrk];
    float PhiOld[MaxNumTrk];
    float CotOld[MaxNumTrk];
    float PxTOld[MaxNumTrk];
    float PyTOld[MaxNumTrk];
    float PzTOld[MaxNumTrk];
    float PModOld[MaxNumTrk];
    float LenOld[MaxNumTrk];
    float xFirstOld[MaxNumTrk];
    float yFirstOld[MaxNumTrk];
    float zFirstOld[MaxNumTrk];
    float CurLaOld[MaxNumTrk];
    float PhiLaOld[MaxNumTrk];
    float CotLaOld[MaxNumTrk];
    float PxTLaOld[MaxNumTrk];
    float PyTLaOld[MaxNumTrk];
    float PzTLaOld[MaxNumTrk];
    float PModLaOld[MaxNumTrk];
    float SPcaOld[MaxNumTrk];
    float SZetaOld[MaxNumTrk];
    float SCurVOld[MaxNumTrk];
    float SCotGOld[MaxNumTrk];
    float SPhiOld[MaxNumTrk];
    float xLastOld[MaxNumTrk];
    float yLastOld[MaxNumTrk];
    float zLastOld[MaxNumTrk];
    float xPca2Old[MaxNumTrk];
    float yPca2Old[MaxNumTrk];
    float zPca2Old[MaxNumTrk];
    float QTrk2Old[MaxNumTrk];
    float CotPca2Old[MaxNumTrk];
    float PhiPca2Old[MaxNumTrk];
    int nPrhiTOld[MaxNumTrk];
    int nFifthITOld[MaxNumTrk];
    int nMskInkOld[MaxNumTrk];
    float Chi2FitOld[MaxNumTrk];
    float Chi2MSOld[MaxNumTrk];
  }trkold_;
}

// Block:   trkmcold
extern "C" {
  extern struct {
    int nTfMCOld;
    int nContrOld[MaxNumTrk];
    int TrkIne1Old[MaxNumTrk];
    int TrType1Old[MaxNumTrk];
    int TrHits1Old[MaxNumTrk];
    int TrkIne2Old[MaxNumTrk];
    int TrType2Old[MaxNumTrk];
    int TrHits2Old[MaxNumTrk];
    int TrkIne3Old[MaxNumTrk];
    int TrType3Old[MaxNumTrk];
    int TrHits3Old[MaxNumTrk];
    float xFMCOld[MaxNumTrk];
    float yFMCOld[MaxNumTrk];
    float zFMCOld[MaxNumTrk];
    float PxFMCOld[MaxNumTrk];
    float PyFMCOld[MaxNumTrk];
    float PzFMCOld[MaxNumTrk];
    float xLMCOld[MaxNumTrk];
    float yLMCOld[MaxNumTrk];
    float zLMCOld[MaxNumTrk];
    float PxLMCOld[MaxNumTrk];
    float PyLMCOld[MaxNumTrk];
    float PzLMCOld[MaxNumTrk];
    float xFMC2Old[MaxNumTrk];
    float yFMC2Old[MaxNumTrk];
    float zFMC2Old[MaxNumTrk];
    float PxFMC2Old[MaxNumTrk];
    float PyFMC2Old[MaxNumTrk];
    float PzFMC2Old[MaxNumTrk];
    float xLMC2Old[MaxNumTrk];
    float yLMC2Old[MaxNumTrk];
    float zLMC2Old[MaxNumTrk];
    float PxLMC2Old[MaxNumTrk];
    float PyLMC2Old[MaxNumTrk];
    float PzLMC2Old[MaxNumTrk];
  }trkmcold_;
}

// Block:   dhit
extern "C" {
  extern struct {
    int nDHIT;
    int DHPid[MaxNumDHIT];
    int DHKin[MaxNumDHIT];
    int DHAdd[MaxNumDHIT];
    float DHx[MaxNumDHIT];
    float DHy[MaxNumDHIT];
    float DHz[MaxNumDHIT];
    float DHPx[MaxNumDHIT];
    float DHPy[MaxNumDHIT];
    float DHPz[MaxNumDHIT];
    float DHt[MaxNumDHIT];
    float DHDedx[MaxNumDHIT];
    float DHTLen[MaxNumDHIT];
    float DHDTime[MaxNumDHIT];
    float DHDFromW[MaxNumDHIT];
    int DHFlag[MaxNumDHIT];
  }dhit_;
}

// Block:   dedx
extern "C" {
  extern struct {
    int nDEDx;
    int nADC[MaxRowsDEDx];
    int iDEDx[MaxRowsDEDx];
    int ADCLayer[MaxRowsDEDx][MaxColsDEDx];
    int ADCWi1[MaxRowsDEDx][MaxColsDEDx];
    int ADCWi2[MaxRowsDEDx][MaxColsDEDx];
    float ADCLen[MaxRowsDEDx][MaxColsDEDx];
    float ADCLeff[MaxRowsDEDx][MaxColsDEDx];
    float ADCTim1[MaxRowsDEDx][MaxColsDEDx];
    float ADCTim2[MaxRowsDEDx][MaxColsDEDx];
    float ADCCharge[MaxRowsDEDx][MaxColsDEDx];
  }dedx_;
}

// Block:   dprs
extern "C" {
  extern struct {
    unsigned int nDPRS;
    unsigned int nView[MaxNumDPRS];
    unsigned int iDPRS[MaxNumDPRS];
    unsigned int DPRSVer[MaxNumDPRS];
    unsigned int nPos[MaxNumDPRS];
    unsigned int nNeg[MaxNumDPRS];
    float xPCA[MaxNumDPRS];
    float yPCA[MaxNumDPRS];
    float zPCA[MaxNumDPRS];
    float xLst[MaxNumDPRS];
    float yLst[MaxNumDPRS];
    float zLst[MaxNumDPRS];
    float CurP[MaxNumDPRS];
    float PhiP[MaxNumDPRS];
    float CotP[MaxNumDPRS];
    float Qual[MaxNumDPRS];
    unsigned int iPFl[MaxNumDPRS];
    unsigned int PrKine[MaxNumDPRS];
    unsigned int PrKHit[MaxNumDPRS];
  }dprs_;
}

// Block:   mc
extern "C" {
  extern struct {
    int nTMC;
    int Kine[MaxNTrkGen];
    int PidMC[MaxNTrkGen];
    int VirMom[MaxNTrkGen];
    float PxMC[MaxNTrkGen];
    float PyMC[MaxNTrkGen];
    float PzMC[MaxNTrkGen];
    float xCv[MaxNTrkGen];
    float yCv[MaxNTrkGen];
    float zCv[MaxNTrkGen];
    float TOfCv[MaxNTrkGen];
    float TheMC[MaxNTrkGen];
    float PhiMC[MaxNTrkGen];
    int VtxMC[MaxNTrkGen];
    int nDchMC[MaxNTrkGen];
    float xFhMC[MaxNTrkGen];
    float yFhMC[MaxNTrkGen];
    float zFhMC[MaxNTrkGen];
    float PxFhMC[MaxNTrkGen];
    float PyFhMC[MaxNTrkGen];
    float PzFhMC[MaxNTrkGen];
    float xLhMC[MaxNTrkGen];
    float yLhMC[MaxNTrkGen];
    float zLhMC[MaxNTrkGen];
    float PxLhMC[MaxNTrkGen];
    float PyLhMC[MaxNTrkGen];
    float PzLhMC[MaxNTrkGen];
    int nVtxMC;
    int KinMom[MaxNVtxGen];
    int Mother[MaxNVtxGen];
    float xVMC[MaxNVtxGen];
    float yVMC[MaxNVtxGen];
    float zVMC[MaxNVtxGen];
    float TOfVMC[MaxNVtxGen];
    float nTvTx[MaxNVtxGen];
  }mc_;
}

#endif
