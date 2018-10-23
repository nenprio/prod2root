#!/usr/bin/tcsh

set INPUT_FILE=$1
set UIC_TEST_DIR=../uic_test
set EXE_DIR=../exe
set EXE_SCRIPT=${EXE_DIR}/sample.exe
set REM_SCRIPT=remove_files.csh
set TESTING_DIR=testing_mc

set block_name=`basename $INPUT_FILE | cut -d '.' -f 1 | cut -d '_' -f 3`
set output_dir=${TESTING_DIR}/${block_name}_block
set log_file=${output_dir}/log.out 
set result_file=${output_dir}/result.out
mkdir -p ${output_dir}

source ${UIC_TEST_DIR}/${REM_SCRIPT} >/dev/null
${EXE_SCRIPT} < ${INPUT_FILE} > ${log_file}

mv sample.root ${output_dir}
mv test.hbook ${output_dir}
mv ${INPUT_FILE} ${output_dir}

# Write some statistics
echo -n "Number of INV errors: " > ${result_file} 
grep -ir 'index not valid' ${output_dir}/log.out | wc -l >> ${output_dir}/result.out

echo -n "Number of OOB errors: " >> ${result_file} 
grep -ir 'out of domain' ${output_dir}/log.out | wc -l >> ${result_file} 

echo -n "Number of MISSING_DATA errors: " >> ${result_file} 
grep -ir 'missing data' ${output_dir}/log.out | wc -l >> ${result_file} 

# Write on CSV global result file
set global_result_file = ${TESTING_DIR}/result.csv
set now = `date`

touch ${global_result_file}
echo -n "${now},${block_name}," >> ${global_result_file}
echo -n `grep -ir 'index not valid' ${output_dir}/log.out | wc -l`, >> ${global_result_file}
echo -n `grep -ir 'out of domain' ${output_dir}/log.out | wc -l`, >> ${global_result_file}
echo -n `grep -ir 'missing data' ${output_dir}/log.out | wc -l` >> ${global_result_file}
echo '' >> ${global_result_file}
