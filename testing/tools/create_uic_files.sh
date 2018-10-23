#!/bin/bash

SEED_FILE=both_files_single.uic

for name in info bpos gdhit ecls trig c2trg tellina pizzetta torta tele pizza time clus clumc preclus cwrk cele celmc dtce dtc0 dchits dhre dhsp trv vtx trs trmc trkvo vto trkso trkmco dhit dprs geanfi tclo tcold cfhi qihi trkq qele qcal knvo vnvo vnvb invo eclo ecltwo csps cspmc cluo clomc qtele qcth ccle lete itce hete
do
    NEW_FILE=both_files_${name}.uic
    cp ${SEED_FILE} ${NEW_FILE}
    sed -i -e "s/talk sample single yes/talk sample ${name} yes/" ${NEW_FILE}
    echo "$name done"
done
