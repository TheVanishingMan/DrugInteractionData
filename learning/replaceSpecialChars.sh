#!/bin/bash
NAME=$1
FILE=`cat $1`
FILE2=TEMPORARY.tmp

SIMPLIFIED=`echo "$FILE" | sed -n 'l0' | grep -v "\-\-"`
DRUGINTERACTIONS=`echo "$SIMPLIFIED" | grep -A 1 "\"drug_interactions\"" | grep -v "drug_interactions" | grep -v "\-\-" | sed -r 's/^[[:blank:]]+//'`
ADVERSEREACTIONS=`echo "$SIMPLIFIED" | grep -A 1 "\"adverse_reactions\"" | grep -v "adverse_reactions" | grep -v "\-\-" | sed -r 's/^[[:blank:]]+//'`
WARNINGS=`echo "$SIMPLIFIED" | grep -A 1 "\"warnings_and_cautions\"" | grep -v "warnings_and_cautions" | grep -v "\-\-" | sed -r 's/^[[:blank:]]+//'`
echo "$DRUGINTERACTIONS" > $FILE2
echo "$ADVERSEREACTIONS" >> $FILE2
echo "$WARNINGS" >> $FILE2

sort -u $FILE2 > ABCDE.tmp && mv ABCDE.tmp $FILE2
mv $FILE2 $NAME
