#!/bin/bash

path_Dbox="/home/hadoop/TESAPI/TESTSCRIPT/Dropbox.jar"
path_Box="/home/hadoop/TESAPI/TESTSCRIPT/box.jar"
path_Gdrive="/home/hadoop/TESAPI/TESTSCRIPT/gdrive.jar"

dd if=/dev/zero of=upload_test bs=1M count=5
count=0
	#Upload 
	STARTTIME=$(date +%s)
		java -jar $path_Dbox upload /home/hadoop/TESAPI/TESTSCRIPT/token.pcs1 /home/hadoop/TESAPI/TESTSCRIPT/upload_test /53211503/home/upload_test  
	ENDTIME=$(date +%s)
	time[$count]=$(($ENDTIME - $STARTTIME))
	count=$((count+1))
	
	STARTTIME=$(date +%s)
                java -jar $path_Box 1 upload  /home/hadoop/TESAPI/TESTSCRIPT/upload_test 
        ENDTIME=$(date +%s)
	time[$count]=$(($ENDTIME - $STARTTIME))
        count=$((count+1))

	STARTTIME=$(date +%s)
                java -jar $path_Gdrive 1 upload  /home/hadoop/TESAPI/TESTSCRIPT/upload_test ""
        ENDTIME=$(date +%s)
        time[$count]=$(($ENDTIME - $STARTTIME))
	
	# END UPLOAD
        echo "Upload Time: ${time[@]}"
	count=0

	# Download
	rm -rf upload_test
	STARTTIME=$(date +%s)
                java -jar $path_Dbox download /home/hadoop/TESAPI/TESTSCRIPT/token.pcs1 /home/hadoop/TESAPI/TESTSCRIPT/upload_test /53211503/home/upload_test
        ENDTIME=$(date +%s)
        time2[$count]=$(($ENDTIME - $STARTTIME))
        count=$((count+1))

	rm -rf upload_test
	id=$(java -jar box.jar 1 listingAll | grep upload_test | awk '{print $NF}')
	STARTTIME=$(date +%s)
                java -jar $path_Box 1 download $id
        ENDTIME=$(date +%s)
        time2[$count]=$(($ENDTIME - $STARTTIME))
        count=$((count+1))
	
	rm -rf upload_test
        id=$(java -jar gdrive.jar 1 listingAll | grep upload_test | awk '{print $NF}')
	STARTTIME=$(date +%s)
                java -jar $path_Gdrive 1 download  $id ""
        ENDTIME=$(date +%s)
        time2[$count]=$(($ENDTIME - $STARTTIME))
	echo -e "$Download Time: ${time2[@]}"

	rm -rf upload_test
	java -jar $path_Dbox delete /home/hadoop/TESAPI/TESTSCRIPT/token.pcs1 /53211503/home/upload_test
	id=$(java -jar box.jar 1 listingAll | grep upload_test | awk '{print $NF}')
	java -jar $path_Box 1 deletefile  $id
	id=$(java -jar gdrive.jar 1 listingAll | grep upload_test | awk '{print $NF}')
	java -jar $path_Gdrive 1 deletefile  $id 

exit 1
