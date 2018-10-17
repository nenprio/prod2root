#!/usr/bin/tcsh
# Run it from prod2root main folder with the cmd: source testing/loop_unit_tests.csh

foreach f (testing/*.uic)
    echo -n "Running Unit Test on ${f}..."
    source testing/unit_test.csh $f
    echo "DONE"
end
