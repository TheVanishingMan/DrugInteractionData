#!/bin/bash
START=1

rm -f GENERIC.txt
rm -f generic-openfda.txt
rm -f generic-pubmed.txt

ls ../bashscripts/drugInteractionsFolder/ > GENERIC.txt

grep -v "WARNINGS" GENERIC.txt > generic.tmp && mv generic.tmp GENERIC.txt
grep -v "LOG" GENERIC.txt > generic.tmp && mv generic.tmp GENERIC.txt
grep -v "BRAND" GENERIC.txt > generic.tmp && mv generic.tmp GENERIC.txt
grep -v "UNKNOWN" GENERIC.txt > generic.tmp && mv generic.tmp GENERIC.txt

TOTAL=$(wc -l GENERIC.txt)
while [ $(wc --bytes GENERIC.txt | cut -d ' ' -f 1) -gt 0 ]; do
    FIRSTLINE=$(head -n 1 GENERIC.txt | cut -d '-' -f 1)
    echo $FIRSTLINE >> generic-openfda.txt
    echo $FIRSTLINE | sed 's/+AND+/+/g' >> generic-pubmed.txt
    echo "$START / $TOTAL"
    START=$((START + 1))
    tail -n +2 GENERIC.txt > generic.tmp && mv generic.tmp GENERIC.txt
done

rm -f GENERIC.txt

