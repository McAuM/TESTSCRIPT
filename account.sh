#!/bin/bash
javahome="/usr/java/jdk1.7.0_09/bin/java"
pathbox="/home/hadoop/TESAPI/TESTSCRIPT/box.jar"
pathgdrive="/home/hadoop/TESAPI/TESTSCRIPT/gdrive.jar"
pathdb="/home/hadoop/TESAPI/TESTSCRIPT/Dropbox.jar"
pathtxt="/home/hadoop/TESAPI/TESTSCRIPT/show_accountAll.txt"


line=$(sed -n 3p /home/hadoop/TESAPI/TESTSCRIPT/active_Dropbox.txt)
count=0
for word in $line; do
	if [ "$count" -eq 0 ];then
		if [ "$word" = "0" ];then
			db1="Non-active"
		else
			db1="Active"
		fi
	elif [ "$count" -eq 1 ];then
		if [ "$word" = "0" ];then
			db2="Non-active"
		else
			db2="Active"
		fi
	elif [ "$count" -eq 2 ];then
		if [ "$word" = "0" ]; then
			db3="Non-active"
		else
			db3="Active"
		fi
	fi
	count=$((count+1))
done

line=$(sed -n 3p /home/hadoop/TESAPI/TESTSCRIPT/active_GoogleDrive.txt)
count=0
for word in $line; do
	if [ "$count" -eq 0 ];then
		if [ "$word" = "0" ];then
			gd1="Non-active"
		else
			gd1="Active"
		fi
	fi
	count=$((count+1))
done

line=$(sed -n 3p /home/hadoop/TESAPI/TESTSCRIPT/active_Box.txt)
count=0
for word in $line; do
	if [ "$count" -eq 0 ];then
		if [ "$word" = "0" ];then
			box1="Non-active"
		else
			box1="Active"
		fi
	elif [ "$count" -eq 1 ];then
		if [ "$word" = "0" ];then
			box2="Non-active"
		else
			box2="Active"
		fi
	fi
	count=$((count+1))
done

echo "<h2 style="clear:both">Dropbox</h2>" > $pathtxt
echo "<p style="clear:both">" >> $pathtxt
echo "____________________________ Cloud1 ___________________________" >> $pathtxt
echo "Status: $db1" >> $pathtxt
echo "$(java -jar $pathdb account2 /home/hadoop/TESAPI/TESTSCRIPT/token.pcs1)" >> $pathtxt
echo "____________________________ Cloud2 ___________________________" >> $pathtxt
echo "Status: $db2" >> $pathtxt
echo "$(java -jar $pathdb account2 /home/hadoop/TESAPI/TESTSCRIPT/token.pcs2)" >> $pathtxt
echo "____________________________ Cloud3 ___________________________" >> $pathtxt
echo "Status: $db3" >> $pathtxt
echo "$(java -jar $pathdb account2 /home/hadoop/TESAPI/TESTSCRIPT/token.pcs3)" >> $pathtxt


echo "<h2 style="clear:both">Google Drive</h2>" >> $pathtxt
echo "<p style="clear:both">" >> $pathtxt
echo "____________________________ Cloud1 ___________________________" >> $pathtxt
echo "Status: $gd1" >> $pathtxt
echo "$(java -jar $pathgdrive account 1)" >> $pathtxt


echo "<h2 style="clear:both">Box</h2>" >> $pathtxt
echo "<p style="clear:both">" >> $pathtxt
echo "____________________________ Cloud1 ___________________________" >> $pathtxt
echo "Status: $box1" >> $pathtxt
echo "$(java -jar $pathbox account 1)" >> $pathtxt
echo "____________________________ Cloud2 ___________________________" >> $pathtxt
echo "Status: $box2" >> $pathtxt
echo "$(java -jar $pathbox account 2)" >> $pathtxt


exit 1

