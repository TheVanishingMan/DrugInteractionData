#!/bin/bash
FILE=$1
echo $FILE
cat charactersToReplace.txt | 
	while read -r line; do 
		char=$(echo $line | cut -d',' -f1)
		replace=$(echo $line | cut -d',' -f2)
		sed -i "s/$char/$replace/Ig" $FILE
	done
sed -i 's///g' $FILE
