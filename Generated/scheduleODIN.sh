#!/bin/bash

OUTPUTFILE=ODINschedule
hostname > $OUTPUTFILE

#following lines for testing
echo "odin005.cs.indiana.edu" >> $OUTPUTFILE
echo "odin120.cs.indiana.edu" >> $OUTPUTFILE
echo "odin018.cs.indiana.edu" >> $OUTPUTFILE
echo "odin091.cs.indiana.edu" >> $OUTPUTFILE
echo "odin004.cs.indiana.edu" >> $OUTPUTFILE
echo "odin043.cs.indiana.edu" >> $OUTPUTFILE

#cat $OUTPUTFILE
echo Waiting 5 seconds to ensure all data is present
#sleep 5
#OUTPUT=
#sort $OUTPUTFILE | cat -n #| grep hostname | cut -d 'o' -f 1 | grep -E  '[0-60]'`
#expr $OUTPUT \* 1
HOST=`hostname`
echo $HOST
OUTPUT=`sort $OUTPUTFILE | cat -n | grep $HOST | cut -d 's' -f 1 | grep -E '[0-9]'`
echo $OUTPUT
NUMBER=`expr $OUTPUT \* 1`
echo $NUMBER
#cat $OUTPUTFILE
