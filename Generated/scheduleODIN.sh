#!/bin/sh

TIME=$1

if [[ -z $TIME ]]; then
    echo Please enter a number greater than 1
    exit
fi

FINAL=ODINORDER.txt
LOG=DETERMINEORDER.txt

#rm -f $FINAL
#rm -f $LOG

function checkawake {
    COUNTER=1
    while [ $COUNTER -le 71 ]; do
	FIRST=`wc -l Data/$COUNTER/drugs.txt | cut -d ' ' -f 1`
	echo Node $COUNTER: $FIRST

	sleep $TIME
	SECOND=`wc -l Data/$COUNTER/drugs.txt | cut -d ' ' -f 1`
	echo Node $COUNTER: $SECOND
	echo Remaining checks: `wc -l Data/$COUNTER/check_$COUNTER | cut -d ' ' -f 1`
	DIFFERENCE=$[FIRST-$SECOND]
	echo $DIFFERENCE
	
	if [ $FIRST -eq $SECOND ]; then
	    echo $COUNTER is not working
	    echo "$COUNTER" >> DEADNODES.txt
	fi
	echo " "
	COUNTER=$[COUNTER+1]
    done
}

checkawake
echo " " >> DEADNODES.txt

#function synchronize {
#
#    HOSTNUMBER=`hostname | grep -o -P '(?<=odin).*(?=.cs.indiana.edu)' | sed 's/^0*//'`
#    sleep $HOSTNUMBER
#    HOST=`hostname`

#    echo "$HOST" >> $LOG
#    OUTPUT=`wc --lines $LOG | cut -d 'L' -f 1 | cut -d 'D' -f 1`
#    echo "$HOST$OUTPUT" >> $FINAL
#}

#synchronize
#NUMBERSTRING=`grep $HOST $FINAL | cut -d 'u' -f 2`
#NUMBER=$(($NUMBERSTRING * 1))
#echo $HOST is at $NUMBER