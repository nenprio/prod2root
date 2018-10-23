#!/usr/bin/tcsh
# Run it from prod2root main folder with the cmd: source testing_mc/loop_unit_tests.csh

# set TESTING_DIR=testing_mc
set TESTING_DIR=$1
set TOOLS=tools
set UNIT_TEST_SCRIPT=${TOOLS}/unit_test.csh

foreach f (${TESTING_DIR}/*.uic)
    echo -n "Running Unit Test on ${f}..."
    source ${UNIT_TEST_SCRIPT} $f
    echo "DONE"
end
