#!/bin/sh

echo "[Info] Starting compilation..."
rm -rf main.o
g++ -ggdb3 -o main main.cpp src/MyFunctions.cpp src/OutputVerifier.cpp -I . `root-config --cflags --libs`
echo "[Info] Compilation    DONE"

echo ""

echo "[Info] Terminated."
