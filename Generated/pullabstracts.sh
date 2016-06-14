#!/bin/bash

export PERL5LIB=$PERL5LIB:/u/hayesall/REU/PMDataDump/Generated/perlscripts

function shrink1 {
    tail -n +2 "$FILE1" > drugs1.tmp && mv drugs1.tmp "$FILE1"
    cp $STABLE $FILE2
}

function shrink2 {
    tail -n +2 "$FILE2" > drugs2.tmp && mv drugs2.tmp "$FILE2"
}

FILE1=drugs1.txt
FILE2=drugs2.txt
STABLE=STABLE.txt
BEGIN=`wc --lines drugs1.txt | cut -d ' ' -f 1`

while [ $(wc --bytes $FILE1 | cut -d ' ' -f 1) -gt 0 ]; do
    while [ $(wc --bytes $FILE2 | cut -d ' ' -f 1) -gt 0 ]; do
	DRUG1=`head -n 1 "$FILE1"`
	DRUG2=`head -n 1 "$FILE2"`
	if [ $DRUG1 = $DRUG2 ]; then
	    tail -n +2 "$FILE2" > drugs2.tmp && mv drugs2.tmp "$FILE2"
	    DRUG2=`head -n 1 "$FILE2"`
	fi
	TEST=`perl pmsearch -c -t 800 -d 50 $DRUG1 $DRUG2`
	echo " "
	echo Found $TEST for $DRUG1 and $DRUG2 " | " Progress: $[`wc --lines drugs1.txt | cut -d ' ' -f 1`-$BEGIN] / $BEGIN
	if [ $TEST -gt 0 ]; then
	    FILENAME=$DRUG1-$DRUG2.txt
	    echo Creating $FILENAME
	    perl pmsearch -t 800 -d 50 $DRUG1 $DRUG2 | perl pmid2text -a -i > Abstracts/$FILENAME
	    echo " "
	    shrink2
	else
	    echo " "
	    shrink2
	fi
    done
    shrink1
done
exit
