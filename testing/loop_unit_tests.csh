#!/usr/bin/tcsh

cd ..
foreach f (testing/*.uic)
    echo $f
end
cd testing
