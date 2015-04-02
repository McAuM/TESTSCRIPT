#!/bin/bash
javahome="/usr/java/jdk1.7.0_09/bin/java"
pathnas="/home/hadoop/TESAPI/TESTSCRIPT/nasapi"
pathtxt="/home/hadoop/TESAPI/TESTSCRIPT/show_file_innas_all.txt"

echo "<h2 style="clear:both">NAS</h2>" > $pathtxt
echo "<p style="clear:both">" >> $pathtxt
echo "____________________________ NAS1 ___________________________" >> $pathtxt
sh $pathnas showlist 1 /Max >> $pathtxt


exit 1
