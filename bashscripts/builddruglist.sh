#!/bin/bash

STARTTIME=$(date '+%s')
TOTAL=0
LETTERS=abcdefghijklmnopqrstuvwxyz
CURRENT=0
FILENAME=drugslist.txt

rm -f $FILENAME
echo Results will be output to file: $FILENAME
echo " "
touch $FILENAME
PREVIOUS=0

until [ $CURRENT = 26 ]; do
    CHECK=${LETTERS:$CURRENT:1}
    URL=http://www.rxlist.com/drugs/alpha_$CHECK.htm
    #echo Checking $CHECK
    #echo $URL
    PREVIOUS=$TOTAL
    PAGE="`wget --no-check-certificate -q -O - $URL`"
    TOTAL=$[TOTAL+$(echo "$PAGE" | grep FDA | wc --lines | cut -d ' ' -f 1)]
    #echo Checking $CHECK "  |  "  found $[TOTAL-$PREVIOUS] "  |  " $TOTAL found so far
    printf "%-11s | %-10s | %-10s" "Checking $CHECK" "Found $[TOTAL-$PREVIOUS]" "$TOTAL so far"
    echo " "
    echo "$PAGE" | grep FDA | grep -o -P '(?<=">).*(?=\ \()' | grep -E -v '\(|\%|\.|\,|\+|\-|\;|\)|\[|\]|\#|\&' | sed 's/ \+/+AND+/g' | grep -v '+$' >> $FILENAME
    let CURRENT=$[CURRENT+1]
done
FINALWORDS=$(wc --lines $FILENAME | cut -d ' ' -f 1)

echo " "
echo Finished
echo Compiled $TOTAL drugs / $[$(date '+%s')-STARTTIME] seconds
echo " "
echo Formatted to work with the openFDA api.
echo In total there were $TOTAL
echo $[TOTAL-$FINALWORDS] were removed due to unsafe characters.
sort $FILENAME | uniq > $FILENAME-2
mv $FILENAME-2 $FILENAME
echo $[FINALWORDS-$(wc --lines $FILENAME | cut -d ' ' -f 1)] duplicates were removed.
echo There are $(wc --lines $FILENAME | cut -d ' ' -f 1) drugs listed in $FILENAME
echo " "
echo " "
