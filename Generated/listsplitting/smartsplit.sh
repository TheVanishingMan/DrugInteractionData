#!/bin/bash

LISTLENGTH=4881
NODES=132

#expr $LISTLENGTH \* $LISTLENGTH
#expr $LISTLENGTH \* $[LISTLENGTH-1]
#echo " "
#TEST1=`expr $[LISTLENGTH-1]`
#echo "4881 - 1 is " $TEST1
#TEST2=`expr $LISTLENGTH \* $TEST1`
#echo "4881 * (4881 - 1) = " $TEST2
#echo " "
#Absolute Value:
#TEST0=-1219
#echo $TEST0
#echo ${TEST0#-}
function newline {
    echo " "
}
#function to compute n(n-1)/2, not to be confused with n(n+1)/2. We need 0+1+2+3+4...+n instead of 1+2+3+4..+n
function gauss {
    N=$1
    expr $N \* $[N-1] / 2
}

function gaussdist {
    N1=$1
    N2=$2
    G1=`gauss $1`
    G2=`gauss $2`
    expr $[G2-$G1] 
}

function splitcolumns {
    #Demonstrate the rough maximum:
    ROUGHMAX=`expr $LISTLENGTH \* $[LISTLENGTH-1] / 2 / $NODES`
    echo Trying with $NODES max possible nodes
    echo List contains $LISTLENGTH drugs to split between $NODES nodes, about $ROUGHMAX drugs per node.
    TOTAL=0
    MAX=0
    NODE=1
    START=$1
    NEXT=$2
    while [ $NEXT -le $LISTLENGTH ]; do
	DIST=`gaussdist $START $NEXT`
	if [ $DIST -gt $ROUGHMAX ]; then
	    DIST1=$[DIST-$ROUGHMAX]
	    DIST2=`gaussdist $START $[NEXT-1]`
	    DIST3=$[DIST2-$ROUGHMAX]
	    #echo DIST1 is $DIST1, DIST3 is $DIST3 " | " add to get is $[DIST1+$DIST3]
	    if [ $[DIST1+$DIST3] -gt 0 ]; then
		DIST=$DIST2
		NEXT=$[NEXT-1]
		COLUMNS=$[NEXT-$START+1]
		TOTAL=$[TOTAL+$COLUMNS]
		echo "$NODE) $START to $NEXT:" $DIST " | " $COLUMNS columns " | " $TOTAL so far
		START=$[NEXT+1]
		NODE=$[NODE+1]
		if [ $DIST -gt $MAX ]; then
		    MAX=$DIST
		fi
		#echo PATH1 CHOSEN && newline
	    else
		COLUMNS=$[NEXT-$START+1]
		TOTAL=$[TOTAL+$COLUMNS]
		echo "$NODE) $START to $NEXT:" $DIST " | " $COLUMNS columns " | " $TOTAL so far
		START=$[NEXT+1]
		NODE=$[NODE+1]
		if [ $DIST -gt $MAX ]; then
		    MAX=$DIST
		fi
		#echo PATH2 CHOSEN && newline
	    fi
	else
	    NEXT=$[NEXT+1]
	fi
    done
    COLUMNS=$[LISTLENGTH-$START+1]
    TOTAL=$[TOTAL+$COLUMNS]
    echo "$NODE) $START to $LISTLENGTH:" `gaussdist $START $LISTLENGTH` " | " $[LISTLENGTH-$START+1] columns " | " $TOTAL so far
    newline && newline
    echo Time estimate: $[MAX / 2 / 60 / 60] hours at 2 searches per second using $NODE nodes effectively out of $NODES possible && newline
}

#gaussdist 1 488
#while [ $NODES -le 135 ]; do
#    splitcolumns 1 1
#    NODES=$[NODES+1]
#done
splitcolumns 1 1
