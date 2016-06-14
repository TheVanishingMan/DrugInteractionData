#!/bin/bash

DRUG1=$1
DRUG2=$2

TEST=`perl pmsearch -c -t 800 -d 50 $DRUG1 $DRUG2`

echo " "
echo Found $TEST for $DRUG1 and $DRUG2

if [ $TEST -gt 0 ]; then
    FILENAME=$DRUG1-$DRUG2.txt
    echo Creating $FILENAME
    perl pmsearch -t 800 -d 50 $DRUG1 $DRUG2 | perl pmid2text -a -i > $FILENAME
    echo " "
    
else
    echo " "
fi
