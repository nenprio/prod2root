#ifndef TREEWRITER_HH
#define TREEWRITER_HH
#include <TFile.h>

class TreeWriter{
     public:
         TreeWriter();
         ~TreeWriter();
         TFile* GetTFile();
         void FillTTree();
     private:
         TFile *outfile;
 };

#endif
