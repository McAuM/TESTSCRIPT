#!/bin/bash
javahome="/usr/java/jdk1.7.0_09/bin/java"
pathbox="/home/hadoop/TESAPI/TESTSCRIPT/box.jar"
pathgdrive="/home/hadoop/TESAPI/TESTSCRIPT/gdrive.jar"
pathdb="/home/hadoop/TESAPI/TESTSCRIPT/Dropbox.jar"
pathtxt="/home/hadoop/TESAPI/TESTSCRIPT/show_file_incloud_all.txt"

echo "<h2 style="clear:both">Dropbox</h2>" > $pathtxt
echo "<p style="clear:both">" >> $pathtxt
echo "____________________________ Cloud1 ___________________________" >> $pathtxt
echo "$(java -jar $pathdb listing /home/hadoop/TESAPI/TESTSCRIPT/token.pcs1 /53211503/home)" >> $pathtxt
echo "____________________________ Cloud2 ___________________________" >> $pathtxt
echo "$(java -jar $pathdb listing /home/hadoop/TESAPI/TESTSCRIPT/token.pcs2 /53211503/home)" >> $pathtxt
echo "____________________________ Cloud3 ___________________________" >> $pathtxt
echo "$(java -jar $pathdb listing /home/hadoop/TESAPI/TESTSCRIPT/token.pcs3 /)" >> $pathtxt


echo "<h2 style="clear:both">Google Drive</h2>" >> $pathtxt
echo "<p style="clear:both">" >> $pathtxt
echo "____________________________ Cloud1 ___________________________" >> $pathtxt
echo "$(java -jar $pathgdrive 1 listingAll)" >> $pathtxt


echo "<h2 style="clear:both">Box</h2>" >> $pathtxt
echo "<p style="clear:both">" >> $pathtxt
echo "____________________________ Cloud1 ___________________________" >> $pathtxt
echo "$(java -jar $pathbox 1 listingAll )" >> $pathtxt
echo "____________________________ Cloud2 ___________________________" >> $pathtxt
echo "$(java -jar $pathbox 2 listingAll )" >> $pathtxt


exit 1
