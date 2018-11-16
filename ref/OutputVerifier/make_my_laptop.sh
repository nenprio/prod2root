#!/bin/sh

echo "[Info] Starting compilation..."
rm -rf main.o
g++ -o cmp_files main_no_root.cpp src/MyFunctions.cpp -I . `root-config --cflags --libs`
echo "[Info] Compilation    DONE"

echo ""

echo "[Info] Terminated."
