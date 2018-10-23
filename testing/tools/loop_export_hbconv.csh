#!/usr/bin/tcsh
# Run it from prod2root main folder with the cmd: source testing_mc/loop_export_root.csh

set TESTING_DIR=$1
set TOOLS=tools
set EXPORT_EXE=${TOOLS}/export_hbconv

foreach d (${TESTING_DIR}/*_block)
    set INPUT_FILE=${d}/hbook.root
    set OUT_DIR=${d}/export
    set OUT_SUBDIR=${OUT_DIR}/hb
    set LOG_FILE=${OUT_DIR}/export_hb.log
    
    echo -n "Exporting ${INPUT_FILE}..."

    mkdir -p ${OUT_SUBDIR}
    touch ${LOG_FILE}

    ./${EXPORT_EXE} ${INPUT_FILE} ${OUT_SUBDIR} >> ${LOG_FILE}
    
    echo "DONE"
end
