#!/bin/sh

FINAL=ODINORDER.txt
LOG=DETERMINEORDER.txt

function synchronize {
    rm -f $FINAL
    rm -f $LOG
    
    HOSTNUMBER=`hostname | grep -o -P '(?<=odin).*(?=.cs.indiana.edu)' | sed 's/^0*//'`
    sleep $HOSTNUMBER
    HOST=`hostname`
    
    echo "$HOST" >> $LOG
    OUTPUT=`wc --lines $LOG | cut -d 'L' -f 1 | cut -d 'D' -f 1`
    echo "$HOST$OUTPUT" >> $FINAL
}

synchronize
NUMBERSTRING=`grep $HOST $FINAL | cut -d 'u' -f 2`
NUMBER=$(($NUMBERSTRING * 1))
echo $HOST is at $NUMBER