#!/bin/sh

echo "[Info] Starting compilation..."
rm -rf main.o
g++ -o main main.cpp src/MyFunctions.cpp src/OutputVerifier.cpp -I . `root-config --cflags --libs`
echo "[Info] Compilation    DONE"

echo ""

# echo "[Info] Configure root libraries..."
# set ROOTCONFIG = 'root-config '
# set ROOTLIBS   = `$ROOTCONFIG --libs`
# echo "ROOTLIBS : $ROOTLIBS"
# echo "[Info] ROOT libs    LOADED"

echo ""

# echo "[Info] Configure personal libraries..."
# setenv MYLIBS "$ROOTLIBS -lm -lC -Wl,-bloadmap:map.txt"
# echo "MYLIBS : $MYLIBS"
# echo "[Info] My libraries    LOADED"

echo ""

echo "[Info] Terminated."
