#!/usr/bin/tcsh

set INPUT_FILE=$1
set UIC_TEST_DIR=uic_test
set EXE_DIR=exe
set TESTING_DIR=testing

set block_name=`echo $INPUT_FILE | cut -d '.' -f 1 | cut -d '_' -f 3`
set output_dir=${TESTING_DIR}/${block_name}_block
mkdir ${output_dir}

source ${UIC_TEST_DIR}/remove_files.csh
${EXE_DIR}/sample.exe < ${INPUT_FILE} > log.out 

mv log.out ${output_dir}
mv sample.root ${output_dir}
mv ${INPUT_FILE} ${output_dir}
