#!/bin/bash
# Choose test someting
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
caldate(){
 pdate=$1 #path date
 ndate=$2 #now date
 day=$(($(($(date -d "$ndate" "+%s") - $(date -d "$pdate" "+%s"))) / 86400)) 
 return 1
}

strindex() { 
  x="${1%%$2*}"
  [[ $x = $1 ]] && indexx="-1" || indexx=${#x}
  return 1
}

cutfile(){
  cut_all=$1
  cut_a=$(awk -F'/' '{ print $NF }' <<< $cut_all)
  return 1
}

cutfilefolder(){
  cut_all=$1
  cut_b=${cut_all:12}
  return 1
}

cutfilefolder2(){
  cut_all=$1
  cut_b2=${cut_all:13}
  return 1
}

cutfolder(){
  cut_all=$1
  cutfilefolder $cut_all
  cutfile $cut_all
  strindex $cut_b $cut_a
  cut_c=${cut_b:0:$indexx}
  return 1
}

nowdatesystem=$(date +"%Y-%m-%d")
path_lsr="/home/hadoop/TESAPI/TESTSCRIPT/full-lsr.txt"
path_full="/home/hadoop/TESAPI/TESTSCRIPT/full-path.txt"
path_temptxt="/home/hadoop/TESAPI/TESTSCRIPT/temp.txt"
path_blanktext="/home/hadoop/TESAPI/TESTSCRIPT/blank_text.txt"

#caldate ${1} $nowdatesystem
#echo $cal_dum6
#createpathfile fromlsr
cutfilefolder2 "/user/hadoop/54211534@kmutt.ac.th/home/CPE403.pdf"
echo $cut_b2
#while read line || [ -n "$line" ]
#do
#	if [ `echo "$line" | grep -c "/user/hadoop/.Trash" ` -gt 0 ] || [ `echo "$line" | grep -c "/user/hadoop/.Revision" ` -gt 0 ]
#	then
#		free1 1
	#else
	#	cutfile $line
	#	cutfilefolder $line
	#	cutfilefolder2 $line
	#	echo "$cut_b2"
		#hadoop dfs -stat $line > $path_temptxt
		#valuetmp2=$(<$path_temptxt)
	  	#filedate2=${valuetmp2:0:10}
	    #caldate $filedate2 $nowdatesystem
	    #echo $day
	#fi
#done < $path_full



