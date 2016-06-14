#!/bin/bash

OUTPUTFILE=checkup.txt

function checkfile {
    while [ $(wc --bytes drugslist.txt | cut -d ' ' -f 1) -gt 0 ]; do
	DRUGNAME=$(head -n 1 drugslist.txt)
	TEST=`grep $DRUGNAME' ' drugInteractionsFolder/LOG.txt`
	if [[ -z $TEST ]]; then
	    echo "$DRUGNAME1" >> $OUTPUTFILE
	fi
	tail -n +2 drugslist.txt > drugslist.tmp && mv drugslist.tmp drugslist.txt
    done
}

touch $OUTPUTFILE
checkfile
