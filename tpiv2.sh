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

clear_start(){
 cs=$1
 touch $path_temptxt
 rm -rf $path_tempfile
 mkdir $path_tempfile
 return 1
}

clear_end(){
 fmdd=$1
 rm -rf $path_tempfile
 mkdir $path_tempfile
 rm -rf $path_temptxt
 $hadoophome dfs -rmr .Trash/*
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
 $hadoophome dfsadmin -report > $path_temptxt
 nowspaceper=0
 while read line || [ -n "$line" ]
 do
   if [ `echo "$line" | grep -c "DFS Used%" ` -gt 0 ]
   then    
    linepath=$(awk -F' ' '{ print $3 }' <<< $line)
    linepath2=$(awk -F'%' '{ print $1 }' <<< $linepath)
    linepath2=$(awk -F'.' '{ print $1 }' <<< $linepath2)    
    linepath3=$((($linepath3 + 1) - 1)) # cut zero padding
    #echo "linepath2 -- $linepath2"
    #echo "linepath3 -- $linepath3"
    nowspaceper=$(($nowspaceper + $linepath2))
    break
    #echo "nowspaceper----$nowspaceper"
   fi
 done < $path_temptxt
 #nowspaceper=$(($nowspaceper / 4 ))
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
path_Nas="/home/hadoop/TESAPI/TESTSCRIPT/nasapi.sh"

tfile="/home/hadoop/TESAPI/TESTSCRIPT/token.pcs" 

path_conf="/home/hadoop/TESAPI/TESTSCRIPT/set_Auto.txt"
path_conf_a1="/home/hadoop/TESAPI/TESTSCRIPT/active_Box.txt"
path_conf_a2="/home/hadoop/TESAPI/TESTSCRIPT/active_Dropbox.txt"
path_conf_a3="/home/hadoop/TESAPI/TESTSCRIPT/active_GoogleDrive.txt"
path_conf_a4="/home/hadoop/TESAPI/TESTSCRIPT/active_Nas.txt"
path_conf_b="/home/hadoop/TESAPI/TESTSCRIPT/baseperformance2.txt"

path_file_a="/home/hadoop/TESAPI/TESTSCRIPT/in_cloud_All.txt" 
path_file_NAS="/home/hadoop/TESAPI/TESTSCRIPT/in_NAS" 
path_file_box="/home/hadoop/TESAPI/TESTSCRIPT/in_box" 
path_file_Dbox="/home/hadoop/TESAPI/TESTSCRIPT/in_Dbox" 
path_file_gdrive="/home/hadoop/TESAPI/TESTSCRIPT/in_gdrive" 
path_toupload="wait to change"

path_temptxt="/home/hadoop/TESAPI/TESTSCRIPT/temp_2.txt"
path_tempfile="/home/hadoop/TESAPI/TESTSCRIPT/tempfile_2/"

date_log=$(date +"%Y-%m-%d")
path_log_NAS="/home/hadoop/hadoop-1.0.4/logs/tpi/NAS/log-nas-$date_log-download.log"
path_log_box="/home/hadoop/hadoop-1.0.4/logs/tpi/Box/log-box-$date_log-download.log"
path_log_Dbox="/home/hadoop/hadoop-1.0.4/logs/tpi/Dropbox/log-dropbox-$date_log-download.log"
path_log_gdrive="/home/hadoop/hadoop-1.0.4/logs/tpi/GoogleDrive/log-gdrive-$date_log-download.log"
path_blanktext="/home/hadoop/TESAPI/TESTSCRIPT/blank_text_2.txt"
date2=$(date) 

#variable Configuration
nqs=0 #now queue size
total=154816032768   
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
  qs=$((medper - nowspaceper))  
  qs=$(($qs * $total))
  qs=$(($qs/100))
  qs=$(($qs/3))
  echo "[OK]"  
  #echo "now spaceper is: $nowspaceper"
  #echo "que size is : $qs"  
  #echo "$nowspaceper"  
  #START PROCCESS
  #nowspaceper=9
  #qs=2882378137
  #echo "Max file size : $mfs"      
  if [ "$onoff" -eq "0" ]
  then
    echo "TPSI mode is >>off<<"
  else
    if [ "$nowspaceper" -gt "$minper" ]
    then
      echo "More than 'space use' configure"      
    else      
      echo "START PROCESS"
      cmd=""
      path_full=""
      id=""      

      #choose NAS
      nonas=1
      count1=1
      #chper=0
      line=$(awk 'END{print}' $path_conf_a4)
      for word in $line 
      do 
        if [ "$word" -ne 0 ]; then      
          chper=$(sh $path_Nas usespace $count1 /Data | grep -i "used" | awk -F ' ' '{print $9}')                          
          if [ "$chper" -gt 0 ];then          
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
          echo "choose 2nd Storage with priority "
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
                        chper=$(java -jar $path_Box space $count2 | grep -i "used" | awk -F ' ' '{print $9}')                                                                                       
                        if [ "$chper" -gt 0 ];then
                          Path_java=$path_Box
                          flag=1                  
                          break
                        else                  
                          p=$((p-1))                          
                          break              
                        fi
                      elif [ "$i" -eq 1 ];then #Choose Dropbox                          
                        #check usespaceper          
                        chper=$(java -jar $path_Dbox space $tfile$count2 | grep -i "used" | awk -F ' ' '{print $9}')                                                                   
                        #chper=0
                        if [ "$chper" -gt 0 ];then
                          Path_java=$path_Dbox
                          flag=1                  
                          break
                        else                  
                          p=$((p-1))                          
                          break              
                        fi         
                      elif [ "$i" -eq 2 ];then #Choose GoogleDrive          
                        #check usespaceper                                      
                        chper=$(java -jar $path_Gdrive space $count2 | grep -i "used" | awk -F ' ' '{print $9}')                                                                  
                        #chper=0
                        if [ "$chper" -gt 0 ];then
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
          echo "Choose Priority with $Path_java with account $count2"
          if [ "$Path_java" =  "$path_Box" ]; then  
            cmd="$javahome -jar $Path_java download2 $count2"
            cmd2="$javahome -jar $Path_java metadata $count2"
            cmd3="$javahome -jar $Path_java delete $count2"
            path_log="$path_log_box"
            path_full="$path_file_box$count2.txt"            
          elif [ "$Path_java" =  "$path_Dbox" ]; then
            cmd="$javahome -jar $Path_java download $tfile$count2"
            cmd2="$javahome -jar $Path_java metadata $tfile$count2"
            cmd3="$javahome -jar $Path_java delete $tfile$count2"
            path_log="$path_log_Dbox"
            path_full="$path_file_Dbox$count2.txt"
          elif [ "$Path_java" =  "$path_Gdrive" ]; then
            cmd="$javahome -jar $Path_java download2 $count2"
            cmd2="$javahome -jar $Path_java metadata $count2"
            cmd3="$javahome -jar $Path_java delete $count2"
            path_log="$path_log_gdrive"
            path_full="$path_file_gdrive$count2.txt"            
          fi                        
        else  #Choose base performace
          echo "choose 2nd Storage with Base Performance "
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
            echo "Choose Base Performance with $Path_java with account $count3"                   
            if [ "$Path_java" =  "$path_Box" ]; then  
              cmd="$javahome -jar $Path_java download2 $count3"
              cmd2="$javahome -jar $Path_java metadata $count3"
              cmd3="$javahome -jar $Path_java delete $count3"
              path_log="$path_log_box"
              path_full="$path_file_box$count3.txt"              
            elif [ "$Path_java" =  "$path_Dbox" ]; then
              cmd="$javahome -jar $Path_java download /home/hadoop/TESAPI/TESTSCRIPT/token.pcs$count3"
              cmd2="$javahome -jar $Path_java metadata /home/hadoop/TESAPI/TESTSCRIPT/token.pcs$count3"
              cmd3="$javahome -jar $Path_java delete /home/hadoop/TESAPI/TESTSCRIPT/token.pcs$count3"
              path_log="$path_log_Dbox"
              path_full="$path_file_Dbox$count3.txt"
            elif [ "$Path_java" =  "$path_Gdrive" ]; then
              cmd="$javahome -jar $Path_java download2 $count3"
              cmd2="$javahome -jar $Path_java metadata $count3"
              cmd3="$javahome -jar $Path_java delete $count3"
              path_full="$path_file_gdrive$count3.txt"              
              path_log="$path_log_gdrive"
            fi  
          fi              
        fi
      else #Upload NAS          
          echo "choose 2nd Storage with NAS "
          echo "Choose NAS with account $count1"          
          cmd="sh $path_Nas download $count1"          
          cmd2="sh $path_Nas metadata $count1"          
          cmd3="sh $path_Nas delete $count1"
          path_log="$path_log_NAS"
          path_full="$path_file_NAS$count1.txt"
      fi      
      ####################  END Choose Secondary Stroage ######################
      if [ "$nonas" -eq 1 ] &&  [ "$nocloud" -eq 1 ]
      then
        echo "ERROR -- No cloud available or empty all storage"
        echo "ERROR -- No cloud available or empty all storage" >> $path_log   
      else
        ########################## CHOOSE FILE ##############################        
      #echo "choosefile"
      #echo "cmd $cmd"
      #echo "path full $path_full"
      while read line
        do
          if [ `echo "$line" | grep -c "54211536" ` -gt 0 ] 
          then             
            echo "CHECKING... -- $line"
            # Get Date and File Size                          
            id=$(echo "$line" | awk '{print $NF}')
            result=$(eval "$cmd2 $id")
            if [ "$nonas" -eq 1 ]                                                  
            then
              if [ "$Path_java" =  "$path_Box" ]; then  
                size=$(echo "$result" | grep -i "Size" | awk -F ' ' '{print $2}')
                date=$(echo "$result" | grep -i "Date" )
                date=${date:6}
                date=$(date +%F -d "$date")
              elif [ "$Path_java" =  "$path_Dbox" ]; then
                size=$(echo "$result" | grep -i "numBytes" | awk -F ' ' '{print $3}')
                date=$(echo "$result" | grep -i "lastModified" | awk -F ' ' '{print $3}')
                date=${date:1:10}
                date=$(date +%F -d "$date")
              elif [ "$Path_java" =  "$path_Gdrive" ]; then
                size=$(echo "$result" | grep -i "Size" | awk -F ' ' '{print $2}')
                date=$(echo "$result" | grep -i "Date" | awk -F ' ' '{print $2}')
                date=${date:0:10}
              fi                          
            else                        
              size=$(echo "$result" | grep -i "Size" | awk -F ' ' '{print $2}')
              date=$(echo "$result" | grep -i "Date") 
              date=${date:6}             
              date=$(date +%F -d "$date")
            fi            
            echo "Size: $size"
            echo "Date: $date"
            
            #check Last Update
            caldate $date $nowdatesystem
            if [ "$day" -gt "$ltu" ] 
            then
              free1 2 #don't get file more than ltu
              echo "SKIP -- more than last update time -- $line" 
              echo "SKIP -- more than last update time -- $line" >> $path_log 
            else
              #check Max File Size
              if [ "$nqs" -le "$qs" ] 
              then
                if [ "$size" -ge "$mfs" ]
                then
                  free1 3 # overload size
                  echo "SKIP -- oversize -- $line"
                  echo "SKIP -- oversize -- $line" >> $path_log                  
                else
                  #START MOVE                  
                  cutfile $line # cut file 
                  nqs=$(($nqs + $size))
                  #Load File To Local
                  if [ "$nonas" -eq 1 ]                                                  
                  then                        
                    if [ "$Path_java" =  "$path_Box" ]; then  
                      eval "$cmd $id $path_tempfile  "
                    elif [ "$Path_java" =  "$path_Dbox" ]; then                                          
                      eval "$cmd $path_tempfile$cut_a $id "
                    elif [ "$Path_java" =  "$path_Gdrive" ]; then
                      eval "$cmd $id $path_tempfile "
                    fi                          
                  else                                        
                    eval "$cmd $id $path_tempfile$cut_a"                    
                  fi
                  #Upload File To Hadoop
                  path_toupload=$(echo "$line" | awk -F ' ' '{print $1}')                
                  $hadoophome dfs -moveFromLocal $path_tempfile$cut_a $path_toupload
                  ret=$?
                  if [ "$ret" -eq 0 ]
                  then                  
                    echo "MOVE -- $size -- $path_tempfile$cut_a -- $path_toupload"
                    echo "MOVE -- $size -- $path_tempfile$cut_a -- $path_toupload" >> $path_log
                    #Remove line To Upload , File in cloud All 
                    tmp=$(grep -v "$path_toupload" $path_full)                  
                    tmp2=$(grep -v "$path_toupload" $path_file_a)
                    if [ "$tmp" = "" ]                 
                    then
                      echo "" > $path_full && sed '/^\s*$/d' $path_full > $path_temptxt && mv $path_temptxt $path_full                      
                    else
                      grep -v "$path_toupload" $path_full > $path_temptxt && mv $path_temptxt $path_full                      
                    fi
                    if [ "$tmp2" = "" ]                 
                    then
                      echo "" > $path_file_a && sed '/^\s*$/d' $path_file_a > $path_temptxt && mv $path_temptxt $path_file_a
                    else
                      grep -v "$path_toupload" $path_file_a > $path_temptxt && mv $path_temptxt $path_file_a
                    fi                                        
                     #Remove file in cloud,NAS
                    if [ "$nonas" -eq 1 ]
                    then                        
                      if [ "$Path_java" =  "$path_Box" ]; then  
                        eval "$cmd3 $id  "
                      elif [ "$Path_java" =  "$path_Dbox" ]; then                                          
                        eval "$cmd3 $id "
                      elif [ "$Path_java" =  "$path_Gdrive" ]; then
                        eval "$cmd3 $id "
                      fi                          
                    else                                        
                      eval "$cmd3 $id "                      
                    fi
                    nqs=$(($nqs + $size))
                  else
                    echo "Error to move file to Hadoop --- $line"
                    echo "Error to move file to Hadoop --- $line" >> $path_log
                  fi
                fi                                                             
              else
                echo "Full Queue Size"
                break
              fi
            fi
            echo " "                        
          fi
        done < $path_full
      fi
      # Keep Log
      finishlogdate=$(date)
      echo "FINISH:$finishlogdate" >> $path_log
      echo "" >> $path_log
      echo "Save log: $path_log"
    fi
  fi  
      
clear_end 1
end_exit 1