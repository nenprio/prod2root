#!/usr/bin/tcsh

set INPUT_FILE=$1
set UIC_TEST_DIR=uic_test
set EXE_DIR=exe
set TESTING_DIR=testing

set block_name=`echo $INPUT_FILE | cut -d '.' -f 1 | cut -d '_' -f 3`
set output_dir=${TESTING_DIR}/${block_name}_block
mkdir ${output_dir}

source ${UIC_TEST_DIR}/remove_files.csh
${EXE_DIR}/sample.exe < ${INPUT_FILE} > ${output_dir}/log.out 

mv sample.root ${output_dir}
mv ${INPUT_FILE} ${output_dir}

# Write some statistics
echo -n "Number of INV errors: " > ${output_dir}/result.out
grep -ir 'index not valid' ${output_dir}/log.out | wc -l >> ${output_dir}/result.out

echo -n "Number of OOB errors: " >> ${output_dir}/result.out
grep -ir 'out of' ${output_dir}/log.out | wc -l >> ${output_dir}/result.out

echo -n "Number of NO_MC_Data errors: " >> ${output_dir}/result.out
grep -ir 'missing mc data' ${output_dir}/log.out | wc -l >> ${output_dir}/result.out

# Write on CSV global result file
set result_file = testing/result.csv
set now = `date`
echo -n "${now},${block_name}," >> ${result_file}
echo -n `grep -ir 'index not valid' ${output_dir}/log.out | wc -l`, >> ${result_file}
echo -n `grep -ir 'out of' ${output_dir}/log.out | wc -l`, >> ${result_file}
echo -n `grep -ir 'missing mc data' ${output_dir}/log.out | wc -l` >> ${result_file}
echo '' >> ${result_file}
