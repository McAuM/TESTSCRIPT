#!/bin/bash
path_base="/home/hadoop/TESAPI/TESTSCRIPT/baseperformance.txt"
choose_base=0
min_score=99999
count=0
line1=$(sed -n 2p ${path_base})
line2=$(sed -n 3p ${path_base})
for word in $line2; do
	account[count]=$word
	count=$((count+1))
done
count=0
for word in $line1; do
	if [ "$word" -lt "$min_score" ]; then
		min_score=$((word))
		choose_base=$((count))
		#echo "$count"
	fi
	count=$((count+1))
done

echo "Count = ${count}"
echo "Select Base = ${choose_base}"
echo "Score = ${min_score}"
echo "Account = ${account[$choose_base]}"

exit 1
