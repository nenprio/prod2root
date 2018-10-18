#!/bin/bash

for name in preclus cwrk cele celmc dtce dtc0 dchits dhre dhsp trv vtx trs trmc trkvo vto trkso trkmco dhit dprs geanfi tclo tcold cfhi qihi trkq qele knvo vnvo vnvb invo eclo ecltwo csps cspmc cluo clomc qtele qcth ccle lete itce hete
do
    cp both_files_clumc.uic both_files_${name}.uic
    sed -i -e "s/talk sample clumc yes/talk sample ${name} yes/" both_files_${name}.uic
    echo "$name done"
done
