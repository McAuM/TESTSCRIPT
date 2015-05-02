#!/bin/bash
javahome="/usr/java/jdk1.7.0_09/bin/java"
hadoophome="/home/hadoop/hadoop-1.0.4/bin/hadoop"
scritphome="/home/hadoop/TESAPI/TESTSCRIPT/tpiv1.sh"
path_temptxt="/home/hadoop/TESAPI/TESTSCRIPT/temp.txt"
path_growthrate="/home/hadoop/TESAPI/TESTSCRIPT/growthrate.txt"
path_conf="/home/hadoop/TESAPI/TESTSCRIPT/set_Auto.txt"
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

now_per=$(sed -n 2p $path_growthrate | awk -F ' ' '{print $2}')
grate_set=$(sed -n 2p $path_conf | awk -F' ' '{ print $6 }' )

now_grwth=$(($nowspaceper-$now_per))
echo "old-per now-per growthrate flag" > $path_growthrate
echo "$now_per $nowspaceper $now_grwth 0" >> $path_growthrate
rm -rf $path_temptxt

 if [ "$now_grwth" -ge "$grate_set" ]
 then
 	sh $scritphome 
 	echo "old-per now-per growthrate flag" > $path_growthrate
	echo "$now_per $nowspaceper $now_grwth 1" >> $path_growthrate
 else
 	echo "Not run tpiv1.sh"
 fi
