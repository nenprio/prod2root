#!/bin/bash

IN_DIR="./root"
ROOT_FILE="sample.root"
HBCONV_FILE="hbConv.root"
SRC_DIR="./src/macro"
ROOT_SCRIPT="RootExplorer.cxx"
HBCONV_SCRIPT="HBConvExplorer.cxx"
OUT_DIR="./out"
ROOT_OUTDIR="sample_root_out"
HBCONV_OUTDIR="hb_conv_out"
ROOT_EXE="/home/luigi/Development/INFN/ROOT/my_root/bin/root -l"

# Create output directory, if doesn't exist
mkdir -p ${OUT_DIR}

${ROOT_EXE} -q -b "${SRC_DIR}/${ROOT_SCRIPT}(\"${IN_DIR}/${ROOT_FILE}\",\"${OUT_DIR}/${ROOT_OUTDIR}\")"
${ROOT_EXE} -q -b "${SRC_DIR}/${HBCONV_SCRIPT}(\"${IN_DIR}/${HBCONV_FILE}\",\"${OUT_DIR}/${HBCONV_OUTDIR}\")"

#TODO compare files
