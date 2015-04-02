#!/bin/bash
javahome="/usr/java/jdk1.7.0_09/bin/java"
pathnas="/home/hadoop/TESAPI/TESTSCRIPT/nasapi"
pathtxt="/home/hadoop/TESAPI/TESTSCRIPT/show_accountNAS.txt"



echo "<h2 style="clear:both">NAS</h2>" > $pathtxt
echo "<p style="clear:both">" >> $pathtxt
echo "____________________________ NAS1 ___________________________" >> $pathtxt
echo "Status: Active" >> $pathtxt
echo "User account info:" >> $pathtxt
echo "display name = $(sh $pathnas account 1)" >> $pathtxt
echo "" >> $pathtxt
#sh $pathnas account 1 >> $pathtxt
sh $pathnas space 1 >> $pathtxt

exit 1

