#!/bin/bash

#path_Dbox="/home/hadoop/TESAPI/TESTSCRIPT/Dropbox.jar"
#path_Box="/home/hadoop/TESAPI/TESTSCRIPT/box.jar"
#path_Gdrive="/home/hadoop/TESAPI/TESTSCRIPT/gdrive.jar"

#./managetoken
#priority algorithm
path=("active_Dropbox.txt" "active_Box.txt" "active_GoogleDrive.txt")
tLen=${#path[@]}
count=0
for (( i=0; i<${tLen}; i++ ));
do
  line=$(awk 'END{print}' ${path[$i]})
   for word in $line; do
	if [ "$word" -ne 0 ];then
            pri[$count]=$word
	    count=$((count+1))            
        fi
   done
done

prisort=($(printf '%s\n' "${pri[@]}"|sort))
count=1
for (( i=0; i<${tLen}; i++ ));
do
  count=1
  line=$(awk 'END{print}' ${path[$i]})
   for word in $line; do
        if [ "$word" -eq "${prisort[0]}" ] && [ "$word" -ne 0  ];then
	    if [ "${path[$i]}" = "active_Dropbox.txt" ];then
		echo "Dropbox cloud $count"
		tfile="token.pcs"				
		java -jar Dropbox.jar account $tfile$count 
		
	    elif [ "${path[$i]}" = "active_Box.txt" ];then
		echo "Box cloud $count"
		java -jar box.jar $count account	
	    elif [ "${path[$i]}" = "active_GoogleDrive.txt" ];then
		echo "GoogleDrive cloud $count"
                java -jar gdrive.jar $count account
	    fi	           
        fi
	count=$((count+1))
   done
done

