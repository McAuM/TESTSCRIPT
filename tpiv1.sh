#!/bin/bash

#refreshtoken box and gdrive
./managetoken

echo "| ---------------------------- START SCRIPT --------------------------- |"
echo " 			    ____  ____  ____ "
echo "			   (_  _)(  _ \(_  _)"
echo "			     )(   )___/ _)(_ "
echo "			    (__) (__)  (____)"

free1(){
 freevar_of_free1=$1
 return 1
}

createpathfile(){
 createpathfilecar=$1
 hadoop dfs -lsr > $path_lsr
 echo '' >>$path_full
 sed '/^\s*$/d' $path_full > $path_blanktext && mv $path_blanktext $path_full
 while read line || [ -n "$line" ]
 do
   linepath=$(awk -F' ' '{ print $8 }' <<< $line)
   hadoop dfs -test -d $linepath
   ret=$? 
   if [[ $ret -eq 0 ]]
   then
     #path
     free1 path
   else
     echo "$linepath" >>$path_full
   fi
 done < $path_lsr
 return 1
}

clear_start(){
 cs=$1
 rm -rf $path_lsr
 rm -rf $path_full
 rm -rf $path_tempfile
 mkdir $path_tempfile
 return 1
}

tobyte(){ # read mb to byte
 inbyte=$1
 mulbyte=1024
 cal_dum0=$(($1 * 1024))
 outbyte=$(($cal_dum0 * 1024))
 return 1
}

checknumber(){
 num7=$1
 if [ "$num7" -eq "$num7" ] 2>/dev/null; then
  free1 $1
 else
 #echo $num7
  err=0 # not a number
 fi
 return 1
}

caluseper(){
 caluseperper2=$1
 hadoop dfsadmin -report > $path_temptxt
 nowspaceper=0
 while read line || [ -n "$line" ]
 do
   if [ `echo "$line" | grep -c "DFS Used%" ` -gt 0 ]
   then
    linepath=$(awk -F' ' '{ print $3 }' <<< $line)
    linepath2=$(awk -F'%' '{ print $1 }' <<< $linepath)
    linepath2=$(awk -F'.' '{ print $1 }' <<< $linepath2)
    linepath3=$((($linepath3 + 1) - 1)) # cut zero padding
    nowspaceper=$(($nowspaceper + $linepath3))
   fi
 done < $path_temptxt

 nowspaceper=$(($nowspaceper / 5 ))
 return 1
}

#variable set Path
nowdatesystem=$(date +"%Y-%m-%d")
path_Dbox="/home/hadoop/TESAPI/TESTSCRIPT/Dropbox.jar"
path_Box="/home/hadoop/TESAPI/TESTSCRIPT/box.jar"
path_Gdrive="/home/hadoop/TESAPI/TESTSCRIPT/gdrive.jar"

path_conf="/home/hadoop/test/set_Auto.txt"
path_conf_a="/home/hadoop/test/conf_tpi_a.txt"

path_cloud_a="/home/hadoop/TESAPI/TESTSCRIPT/in_cloud.txt" 
path_cloud1="/home/hadoop/TESAPI/TESTSCRIPT/in_cloud1.txt" 
path_cloud2="/home/hadoop/TESAPI/TESTSCRIPT/in_cloud2.txt" 
path_cloud3="/home/hadoop/TESAPI/TESTSCRIPT/in_cloud3.txt" 
path_torm="wait to change"

path_lsr="/home/hadoop/TESAPI/TESTSCRIPT/full-lsr.txt"
path_full="/home/hadoop/TESAPI/TESTSCRIPT/full-path.txt"
path_temptxt="/home/hadoop/TESAPI/TESTSCRIPT/temp.txt"
path_tempfile="/home/hadoop/TESAPI/TESTSCRIPT/tempfile"

date_log=$(date +"%Y-%m-%d")
#path_log="/home/hadoop/test/log-tpi-$date_log.txt" # keep log by date
path_log="/home/hadoop/hadoop-1.0.4/logs/tpi/log-tpi-$date_log.log"
path_blanktext="/home/hadoop/TESAPI/TESTSCRIPT/blank_text.txt"
date2=$(date) 

#variable Configuration
nqs=0 #now queue size
total=144120455168
$onoff # on-off
$maxper #max use space
$medper #medium use space
$minper #min use space
$grate #Growth up rate
$ltu #last time update
$prob #probe checking
$mfs # max file size
$qs # queue size
err=1 #error reading flag
#$sp #space percent

#start read configure
echo -ne "Reading configure..."
value=$(<$path_conf)
while read line || [ -n "$line" ]
do
 	onoff=$(awk -F' ' '{ print $1 }' <<< $line);
  	maxper=$(awk -F' ' '{ print $2 }' <<< $line)
  	medper=$(awk -F' ' '{ print $3 }' <<< $line)
  	minper=$(awk -F' ' '{ print $4 }' <<< $line)
  	grate=$(awk -F' ' '{ print $5 }' <<< $line)
  	prob=$(awk -F' ' '{ print $6 }' <<< $line)
  	ltu=$(awk -F' ' '{ print $7 }' <<< $line)  	
  	mfs=$(awk -F' ' '{ print $8 }' <<< $line)   	
done < $path_conf
	#qs = max - mid	
	checknumber $onoff
  	checknumber $maxper
  	checknumber $medper
  	checknumber $minper
  	checknumber $grate
  	checknumber $prob
  	checknumber $ltu
  	checknumber $mfs

  clear_start folder_temp_file
  if [ "$err" -eq 0 ]
	then
 		echo "[Error]"
	else
		echo "[OK]"
  fi
  echo -ne "Waiting for initial..."
  #read local space to nowspaceper
  caluseper 100
 
  # tran mb to byte
  tobyte $mfs
  mfs=$outbyte
  qs=$(($maxper-medper))
  qs=$(($qs*$total))
  qs=$(($qs/100))
