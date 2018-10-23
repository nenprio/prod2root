#!/usr/bin/tcsh
# Run it with Root version 3.06

set TESTING_DIR=$1
set CMD=h2root

# Check if the root version is correctly set
if (`echo ${ROOTSYS} | grep '3.06' | wc -l` == 0) then
    echo "This script runs only with ROOT 3.06. Set the correct version    in your .cshrc file, log out and log in again."
    exit 1
endif

foreach d (${TESTING_DIR}/*_block)
    set INPUT_FILE=${d}/test.hbook
    set OUTPUT_FILE=${d}/hbook.root

    echo -n "Converting ${INPUT_FILE} to ${OUTPUT_FILE}..."

    ${CMD} ${INPUT_FILE} ${OUT_SUBDIR}

    echo "DONE"
end
