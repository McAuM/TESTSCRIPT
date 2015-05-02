#!/bin/bash

tobyte(){ # read mb to byte
 inbyte=$1
 mulbyte=1024
 cal_dum0=$(($1*1024))
 outbyte=$(($cal_dum0*1024))
 return 1
}

path_Dbox="/home/hadoop/TESAPI/TESTSCRIPT/Dropbox.jar"
path_Box="/home/hadoop/TESAPI/TESTSCRIPT/box.jar"
path_Gdrive="/home/hadoop/TESAPI/TESTSCRIPT/gdrive.jar"

tfile="/home/hadoop/TESAPI/TESTSCRIPT/token.pcs" 

path_conf_a1="/home/hadoop/TESAPI/TESTSCRIPT/active_Box.txt"
path_conf_a2="/home/hadoop/TESAPI/TESTSCRIPT/active_Dropbox.txt"
path_conf_a3="/home/hadoop/TESAPI/TESTSCRIPT/active_GoogleDrive.txt"

dd if=/dev/zero of=/home/hadoop/TESAPI/TESTSCRIPT/upload_test2 bs=1M count=5

path=($path_conf_a1 $path_conf_a2 $path_conf_a3)
tLen=${#path[@]} 
count2=0
for (( i=0; i<${tLen}; i++ ));
do
  line=$(awk 'END{print}' ${path[$i]})  
  count=1
  nocloud=0    
   for word in $line; do   
     if [ "$word" -ne "0" ];then
     	if [ "$i" -eq 0 ]; then
     		#chper=81
     		chper=$(java -jar $path_Box space $count | grep -i "used" | awk -F ' ' '{print $6}')
     	elif [ "$i" -eq 1 ]; then
     		#chper=81
     		chper=$(java -jar $path_Dbox space $tfile$count | grep -i "used" | awk -F ' ' '{print $6}')
     	elif [ "$i" -eq 2 ]; then
     		#chper=81     		
     		chper=$(java -jar $path_Gdrive space $count | grep -i "used" | awk -F ' ' '{print $6}')     		
     	fi
     	tobyte $chper
        chper=$outbyte    	
     	if [ "$chper" -gt 0 ]; then
            account[$count2]=$count
            count2=$((count2+1))
            nocloud=1        
            break            
        fi
     fi       
     count=$((count+1))
   done
   if [ "$nocloud" -eq 0 ]; then
   		account[$count2]=0
        count2=$((count2+1))
   fi    
done

echo "account ${account[@]}"

	count=0
	# Upload 
	if [ "${account[0]}" -ne 0 ]; then
		STARTTIME=$(date +%s)
	        java -jar $path_Box  upload ${account[0]} /home/hadoop/TESAPI/TESTSCRIPT/upload_test2 /home/hadoop/TESAPI/TESTSCRIPT/upload_test2
	    ENDTIME=$(date +%s)
	 	time[$count]=$(($ENDTIME - $STARTTIME))    
	else 
		time[$count]=99999
	fi
	count=$((count+1))

	if [ "${account[1]}" -ne 0 ]; then
	 	STARTTIME=$(date +%s)
	 		java -jar $path_Dbox upload /home/hadoop/TESAPI/TESTSCRIPT/token.pcs${account[1]} /home/hadoop/TESAPI/TESTSCRIPT/upload_test2 /53211503/home/upload_test2
	 	ENDTIME=$(date +%s)
		time[$count]=$(($ENDTIME - $STARTTIME))
	else
 		time[$count]=99999
 	fi
	count=$((count+1))

	if [ "${account[2]}" -ne 0 ]; then
		STARTTIME=$(date +%s)
	        java -jar $path_Gdrive  upload ${account[2]} /home/hadoop/TESAPI/TESTSCRIPT/upload_test2 /home/hadoop/TESAPI/TESTSCRIPT/upload_test2
	    ENDTIME=$(date +%s)
	    time[$count]=$(($ENDTIME - $STARTTIME))
	else
		time[$count]=99999
	fi
	# END UPLOAD
    #echo "Upload Time: ${time[@]}"

	count=0
 	# Download 	
 	rm -rf /home/hadoop/TESAPI/TESTSCRIPT/upload_test2 
 	if [ "${account[0]}" -ne 0 ]; then 				
		id=$(java -jar $path_Box listingAll ${account[0]} | grep upload_test2 | awk '{print $NF}')
		STARTTIME=$(date +%s)
	        java -jar $path_Box download ${account[0]} $id ""
	    ENDTIME=$(date +%s)
	    time2[$count]=$(($ENDTIME - $STARTTIME))    
	else
		time2[$count]=99999
	fi
	count=$((count+1))

 	rm -rf /home/hadoop/TESAPI/TESTSCRIPT/upload_test2
 	if [ "${account[1]}" -ne 0 ]; then 		 	
	 	STARTTIME=$(date +%s)
	        java -jar $path_Dbox download /home/hadoop/TESAPI/TESTSCRIPT/token.pcs${account[1]} /home/hadoop/TESAPI/TESTSCRIPT/upload_test2 /53211503/home/upload_test2
	    ENDTIME=$(date +%s)
	    time2[$count]=$(($ENDTIME - $STARTTIME))	    
	else
		time2[$count]=99999
	fi
	count=$((count+1))

	rm -rf /home/hadoop/TESAPI/TESTSCRIPT/upload_test2
	if [ "${account[2]}" -ne 0 ]; then		
	  	id=$(java -jar $path_Gdrive listingAll ${account[2]} | grep upload_test2 | awk '{print $NF}')
		STARTTIME=$(date +%s)
	        java -jar $path_Gdrive download ${account[2]} $id ""
	  	ENDTIME=$(date +%s)
	    time2[$count]=$(($ENDTIME - $STARTTIME))
	else
		time2[$count]=99999
	fi

	#echo -e "$Download Time: ${time2[@]}"
 	rm -rf /home/hadoop/TESAPI/TESTSCRIPT/upload_test2
 	if [ "${account[0]}" -ne 0 ]; then 	
	 	id=$(java -jar $path_Box listingAll ${account[0]} | grep upload_test2 | awk '{print $NF}')
		java -jar $path_Box delete ${account[0]} $id
	fi
	if [ "${account[1]}" -ne 0 ]; then 	
		java -jar $path_Dbox delete /home/hadoop/TESAPI/TESTSCRIPT/token.pcs${account[1]} /53211503/home/upload_test2
	fi
	if [ "${account[2]}" -ne 0 ]; then 	
		id=$(java -jar $path_Gdrive listingAll ${account[2]} | grep upload_test2 | awk '{print $NF}')
		java -jar $path_Gdrive delete ${account[2]}  $id 
	fi

	score_box=$(echo "((${time[0]}*30)+(${time2[0]}*70))/100" | bc)
	score_Dbox=$(echo "((${time[1]}*30)+(${time2[1]}*70))/100" | bc)
	score_gdrive=$(echo "((${time[2]}*30)+(${time2[2]}*70))/100" | bc)
	echo "Box Dbox Gdrive" > /home/hadoop/TESAPI/TESTSCRIPT/baseperformance2.txt
	echo "$score_box $score_Dbox $score_gdrive" >>	/home/hadoop/TESAPI/TESTSCRIPT/baseperformance2.txt
	echo "${account[0]} ${account[1]} ${account[2]}" >>	/home/hadoop/TESAPI/TESTSCRIPT/baseperformance2.txt

exit 1
