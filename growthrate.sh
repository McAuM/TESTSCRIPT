#!/bin/bash
javahome="/usr/java/jdk1.7.0_09/bin/java"
hadoophome="/home/hadoop/hadoop-1.0.4/bin/hadoop"
path_temptxt="/home/hadoop/TESAPI/TESTSCRIPT/temp.txt"
path_growthrate="/home/hadoop/TESAPI/TESTSCRIPT/growthrate.txt"

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
    nowspaceper=$(($nowspaceper + $linepath2))
    break
   fi
 done < $path_temptxt
 return 1
}
caluseper test1
echo "Space percent in yesterday" > $path_growthrate
echo "$nowspaceper" >> $path_growthrate
rm -rf $path_temptxt
