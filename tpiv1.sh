#!/bin/bash

hadoophome="/home/hadoop/hadoop-1.0.4/bin/hadoop"
javahome="/usr/java/jdk1.7.0_09/bin/java"
#refreshtoken box and gdrive
#sh /home/hadoop/TESAPI/TESTSCRIPT/managetoken

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
 #rm -rf $path_full
 rm -rf $path_tempfile
 mkdir $path_tempfile
 return 1
}

clear_end(){
 fmdd=$1
 rm -rf $path_lsr
 #rm -rf $path_full
 rm -rf $path_tempfile
 mkdir $path_tempfile
 rm -rf $path_temptxt
 hadoop dfs -rmr .Trash/*
 return 1
}

end_exit(){
 in_end_exit=$1
 echo "| ------------------------------- FINISH ------------------------------ |"
 exit 1
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

caldate(){
 pdate=$1 #path date
 ndate=$2 #now date
 day=$(($(($(date -d "$ndate" "+%s") - $(date -d "$pdate" "+%s"))) / 86400)) 
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

 nowspaceper=$(($nowspaceper / 4 ))
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

#variable set Path
nowdatesystem=$(date +"%Y-%m-%d")
path_Dbox="/home/hadoop/TESAPI/TESTSCRIPT/Dropbox.jar"
path_Box="/home/hadoop/TESAPI/TESTSCRIPT/box.jar"
path_Gdrive="/home/hadoop/TESAPI/TESTSCRIPT/gdrive.jar"
path_Nas="/home/hadoop/TESAPI/TESTSCRIPT/nasapi"

tfile="/home/hadoop/TESAPI/TESTSCRIPT/token.pcs" 

path_conf="/home/hadoop/TESAPI/TESTSCRIPT/set_Auto.txt"
path_conf_a1="/home/hadoop/TESAPI/TESTSCRIPT/active_Box.txt"
path_conf_a2="/home/hadoop/TESAPI/TESTSCRIPT/active_Dropbox.txt"
path_conf_a3="/home/hadoop/TESAPI/TESTSCRIPT/active_GoogleDrive.txt"
path_conf_a4="/home/hadoop/TESAPI/TESTSCRIPT/active_Nas.txt"
path_conf_b="/home/hadoop/TESAPI/TESTSCRIPT/baseperformance.txt"

path_cloud_a="/home/hadoop/TESAPI/TESTSCRIPT/in_cloud_All.txt" 
#path_cloud1="/home/hadoop/TESAPI/TESTSCRIPT/in_cloud1.txt" 
#path_cloud2="/home/hadoop/TESAPI/TESTSCRIPT/in_cloud2.txt" 
#path_cloud3="/home/hadoop/TESAPI/TESTSCRIPT/in_cloud3.txt" 
path_toupload="wait to change"

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
$maxper #max use space (%)
$medper #medium use space (%)
$minper #min use space (%)
$grate #Growth up rate (%)
$ltu #last time update (day)
$prob #probe checking (day)
$mfs # max file size (mb)
$qs # queue size (mb)
err=1 #error reading flag

#start read configure
echo -ne "Reading configure..."
value=$(<$path_conf)
while read line || [ -n "$line" ]
do
 	  onoff=$(awk -F' ' '{ print $1 }' <<< $line)
    active=$(awk -F' ' '{ print $2 }' <<< $line)
  	maxper=$(awk -F' ' '{ print $3 }' <<< $line)
  	medper=$(awk -F' ' '{ print $4 }' <<< $line)
  	minper=$(awk -F' ' '{ print $5 }' <<< $line)
  	grate=$(awk -F' ' '{ print $6 }' <<< $line)
  	prob=$(awk -F' ' '{ print $7 }' <<< $line)
  	ltu=$(awk -F' ' '{ print $8 }' <<< $line)  	
  	mfs=$(awk -F' ' '{ print $9 }' <<< $line)   	
done < $path_conf
	#qs = max - mid	
	  checknumber $onoff
    checknumber $active
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
  echo "[OK]"    
  #echo "$nowspaceper"
  #createpathfile fromlsr
  #START PROCCESS
  nowspaceper=77
  qs=800000  
  #echo "Max file size : $mfs"
  if [ "$onoff" -eq "0" ]
  then
    echo "TPSI mode is >>off<<"
  else
    if [ "$nowspaceper" -lt "$maxper" ]
    then
      echo "less then 'space use' configure"      
    else      
      echo "START PROCESS"
      cmd=""
      Path_java=""
      #createpathfile fromlsr

      #choose NAS
      nonas=1
      count1=1
      chper=81
      line=$(awk 'END{print}' $path_conf_a4)
      for word in $line 
      do 
        if [ "$word" -ne 0 ]; then      
          #chper=$(sh $path_Nas spaceper $count1)
          if [ "$chper" -le 80 ];then
              nonas=0
              break
          fi
        fi
        count1=$((count1+1))
      done

      #Choose Plublic Cloud when NAS FULL
      if [ "$nonas" -ne 0 ] 
      then
        if [ "$active" -ne 0 ]  #Choose Priority
        then
          #choose 2nd Storage with priority
          path=($path_conf_a1 $path_conf_a2 $path_conf_a3)
          tLen=${#path[@]} 
          count2=0
          for (( i=0; i<${tLen}; i++ ));
          do
            line=$(awk 'END{print}' ${path[$i]})    
             for word in $line; do      
               if [ "$word" -ne "0" ];then
                      pri[$count2]=$word
                      count2=$((count2+1))            
               fi       
             done     
          done
          prisort=($(printf '%s\n' "${pri[@]}"|sort))
          p=${#prisort[@]} #count prisort array
          p=$((p-1))  
          flag=0
          nocloud=0
          #chper=81
          count2=1 # count Account number  
          while [ "$flag" -ne 1 ]
            do                  
              for (( i=0; i<${tLen} && ${flag}==0; i++ ));
                do          
                  count2=1
                  line=$(awk 'END{print}' ${path[$i]})          
                   for word in $line; do
                    if [ "$p" -lt 0 ]; then
                      flag=1
                      nocloud=1
                      break
                    fi
                    if [ "$word" = "${prisort[$p]}" ] && [ "$word" -ne 0  ];then
                      if [ "$i" -eq 0 ];then #Choose Box                   
                        #check usespaceper
                        chper=$(java -jar $path_Box spaceper $count2)                                          
                        if [ "$chper" -le 80 ];then
                          Path_java=$path_Box
                          flag=1                  
                          break
                        else                  
                          p=$((p-1))                          
                          break              
                        fi
                      elif [ "$i" -eq 1 ];then #Choose Dropbox                          
                        #check usespaceper          
                        chper=$(java -jar $path_Dbox spaceper $tfile$count2)                                          
                        if [ "$chper" -le 80 ];then
                          Path_java=$path_Dbox
                          flag=1                  
                          break
                        else                  
                          p=$((p-1))                          
                          break              
                        fi         
                      elif [ "$i" -eq 2 ];then #Choose GoogleDrive          
                        #check usespaceper               
                        chper=$(java -jar $path_Gdrive spaceper $count2)                                          
                        if [ "$chper" -le 80 ];then
                          Path_java=$path_Gdrive
                          flag=1                  
                          break
                        else                  
                          p=$((p-1))                          
                          break              
                        fi
                      fi             
                    fi
                    count2=$((count2+1))
                   done           
                done     
            done
          #echo "Priority java $Path_java with account $count2"
          if [ "$Path_java" =  "$path_Box" ]; then  
            cmd="$javahome -jar $Path_java upload $count2"
          elif [ "$Path_java" =  "$path_Dbox" ]; then
            cmd="$javahome -jar $Path_java upload $tfile$count2"
          elif [ "$Path_java" =  "$path_Gdrive" ]; then
            cmd="$javahome -jar $Path_java upload $count2"
          fi                
        else  #Choose base performace
          nocloud=0
          choose_base=0
          min_score=99999
          count=0
          line1=$(sed -n 2p ${path_conf_b})
          line2=$(sed -n 3p ${path_conf_b})
          for word in $line2; do
            account[count]=$word
            count=$((count+1))
          done
          count=0
          for word in $line1; do
            if [ "$word" -lt "$min_score" ] &&  [ "${account[$count]}" -ne 0 ] ; then
              min_score=$((word))
              choose_base=$((count))
              #echo "$count"
            fi
            count=$((count+1))
          done
          if [ "${account[0]}" -eq 0 ] && [ "${account[1]}" -eq 0 ] && [ "${account[2]}" -eq 0 ]
          then
            nocloud=1
          else
            if [ "$choose_base" -eq 0 ]
            then
              Path_java=$path_Box
            elif [ "$choose_base" -eq 1 ]
            then
              Path_java=$path_Dbox
            elif [ "$choose_base" -eq 2 ]
            then
              Path_java=$path_Gdrive
            fi
            count3=${account[$choose_base]}
            #echo "Base Performance java $Path_java with account $count3"          
            if [ "$Path_java" =  "$path_Box" ]; then  
              cmd="$javahome -jar $Path_java upload $count3"
            elif [ "$Path_java" =  "$path_Dbox" ]; then
              cmd="$javahome -jar $Path_java upload /home/hadoop/TESAPI/TESTSCRIPT/token.pcs$count3"
            elif [ "$Path_java" =  "$path_Gdrive" ]; then
              cmd="$javahome -jar $Path_java upload $count3"
            fi  
          fi              
        fi
      else #Upload NAS          
          #echo "NAS with Account $count1"
          cmd="sh $path_Nas upload $count1"
          
      fi
      ####################  END Choose Secondary Stroage ######################

      if [ "$nonas" -eq 1 ] &&  [ "$nocloud" -eq 1 ]
      then
        echo "All Secondary Storage is full.."
      else
        ########################## CHOOSE FILE ##############################                
        while read line || [ -n "$line" ]
        do
          if [ `echo "$line" | grep -c "54211534" ` -gt 0 ] || [ `echo "$line" | grep -c "54211536" ` -gt 0 ]
          then          
            if [ `echo "$line" | grep -c "/user/hadoop/.Trash" ` -gt 0 ] || [ `echo "$line" | grep -c "/user/hadoop/.Revision" ` -gt 0 ]
            then
              free1 1 #don't in trash and revision
            else
              echo "CHECKING... -- $line"
              hadoop dfs -stat $line > $path_temptxt
              valuetmp=$(<$path_temptxt)
              filedate=${valuetmp:0:10}
              caldate $filedate $nowdatesystem
              echo "day :$day"
              if [ "$day" -lt "$ltu" ] #check Last Update
              then
                free1 2 #don't get file less than ltu
                echo "SKIP -- lastupdate -- $line"
              else
                # check max file size
                size=$(hadoop dfs -dus $line)
                size_of_file=$(awk -F' ' '{ print $2 }' <<< $size)                
                echo "size = $size_of_file"                
                if [ "$nqs" -le "$qs" ]
                then                  
                  if [ "$size_of_file" -ge "$mfs" ]
                  then
                      free1 3 # overload size
                      echo "SKIP -- oversize -- $line"
                  else                    
                    cutfile $line #a only fliename
                    cutfilefolder $line #b have /
                    cutfilefolder2 $line #b2 no /
                    path_toupload="$path_tempfile/$cut_a"                    
                    hadoop dfs -get $line $path_tempfile
                    ret=$?
                    if [ "$ret" -eq 0 ]
                    then
                      a2421=$(grep -i $cut_b2 $path_cloud_a)
                      ret=$?
                      if [ "$ret" -eq 0 ]
                      then
                          echo "SKIP -- file already in cloud"
                      else                        
                        nqs=$(($nqs + $size_of_file))                                              
                        # START TO MOVE                        
                        id=$(eval "$cmd $path_toupload $cut_b" | awk '{print $NF}')
                        #hadoop dfs -rm $cut_b2
                        #hadoop dfs -touchz $cut_b2 
                        echo "$cut_b2 $Path_java" >> $path_cloud_a
                        #echo "$cut_b2" >> $path_cloud_t
                        echo "MOVE -- $size_of_file -- $path_torm -- $cut_b"
                      fi                      
                    else
                      echo "ERROR -- fail to get file from local -- $line"
                    fi
                  fi
                else
                  echo "Full Queue Size"
                  break
                fi 
              fi
            fi
            echo " "
          fi
        done < $path_full
        
      fi
      # Keep Log

    fi    
  fi 
clear_end 1
end_exit 1