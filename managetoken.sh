#!/bin/bash

sh /home/hadoop/TESAPI/TESTSCRIPT/Box/refreshboxapi.sh
sh /home/hadoop/TESAPI/TESTSCRIPT/GoogleDrive/refreshgoogledriveapi.sh

path_conf_active1="/home/hadoop/TESAPI/TESTSCRIPT/active_GoogleDrive.txt"
path_conf_active2="/home/hadoop/TESAPI/TESTSCRIPT/active_Box.txt"
countGdrive=$(awk 'END{print NF}' $path_conf_active1)
countBox=$(awk 'END{print NF}' $path_conf_active2)

rm -rf /home/hadoop/TESAPI/TESTSCRIPT/cliID.box
rm -rf /home/hadoop/TESAPI/TESTSCRIPT/cliSECRET.box
cp /home/hadoop/TESAPI/TESTSCRIPT/Box/cliID.box /home/hadoop/TESAPI/TESTSCRIPT/cliID.box
cp /home/hadoop/TESAPI/TESTSCRIPT/Box/cliSECRET.box /home/hadoop/TESAPI/TESTSCRIPT/cliSECRET.box

rm -rf /home/hadoop/TESAPI/TESTSCRIPT/cliID.gdrive
rm -rf /home/hadoop/TESAPI/TESTSCRIPT/cliSECRET.gdrive
cp /home/hadoop/TESAPI/TESTSCRIPT/GoogleDrive/cliID.gdrive /home/hadoop/TESAPI/TESTSCRIPT/cliID.gdrive
cp /home/hadoop/TESAPI/TESTSCRIPT/GoogleDrive/cliSECRET.gdrive /home/hadoop/TESAPI/TESTSCRIPT/cliSECRET.gdrive

for (( i=1; i<=$countBox; i++ ))
do

	rm -rf /home/hadoop/TESAPI/TESTSCRIPT/token.box$i
	rm -rf /home/hadoop/TESAPI/TESTSCRIPT/refreshtoken.box$i
	cp /home/hadoop/TESAPI/TESTSCRIPT/Box/token.box$i /home/hadoop/TESAPI/TESTSCRIPT/token.box$i
	cp /home/hadoop/TESAPI/TESTSCRIPT/Box/refreshtoken.box$i /home/hadoop/TESAPI/TESTSCRIPT/refreshtoken.box$i
done

for (( i=1; i<=$countGdrive; i++ ))
do
	rm -rf /home/hadoop/TESAPI/TESTSCRIPT/token.gdrive$i
	rm -rf /home/hadoop/TESAPI/TESTSCRIPT/refreshtoken.gdrive$i
	cp /home/hadoop/TESAPI/TESTSCRIPT/GoogleDrive/token.gdrive$i /home/hadoop/TESAPI/TESTSCRIPT/token.gdrive$i
	cp /home/hadoop/TESAPI/TESTSCRIPT/GoogleDrive/refreshtoken.gdrive$i /home/hadoop/TESAPI/TESTSCRIPT/refreshtoken.gdrive$i
done
# rm -rf /home/hadoop/TESAPI/TESTSCRIPT/token.box1
# rm -rf /home/hadoop/TESAPI/TESTSCRIPT/token.box2
# rm -rf /home/hadoop/TESAPI/TESTSCRIPT/token.gdrive1
# rm -rf /home/hadoop/TESAPI/TESTSCRIPT/refreshtoken.box1
# rm -rf /home/hadoop/TESAPI/TESTSCRIPT/refreshtoken.box2

# cp /home/hadoop/TESAPI/TESTSCRIPT/Box/token.box1 /home/hadoop/TESAPI/TESTSCRIPT/token.box1
# cp /home/hadoop/TESAPI/TESTSCRIPT/Box/token.box2 /home/hadoop/TESAPI/TESTSCRIPT/token.box2
# cp /home/hadoop/TESAPI/TESTSCRIPT/Box/refreshtoken.box1 /home/hadoop/TESAPI/TESTSCRIPT/refreshtoken.box1
# cp /home/hadoop/TESAPI/TESTSCRIPT/Box/refreshtoken.box2 /home/hadoop/TESAPI/TESTSCRIPT/refreshtoken.box2
#cp /home/hadoop/TESAPI/TESTSCRIPT/GoogleDrive/token.gdrive1 /home/hadoop/TESAPI/TESTSCRIPT/token.gdrive1
