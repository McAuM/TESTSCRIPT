#!/bin/bash
path_growth="/home/hadoop/monitoring/keep_growth_stat.txt"
path_growth_year="/home/hadoop/monitoring/keep_growth_stat_year.txt"
path_temp="/home/hadoop/monitoring/g1.txt"
hadoophome="/home/hadoop/hadoop-1.0.4/bin/hadoop"
free1(){
 return 1
}

tomb(){ # read byte to mb
 inmb=$1
 mulmb=1024
 cal_dum0=$(($1 / 1024))
 cal_dum1=$(($cal_dum0 / 1024))
 outmb=$(($cal_dum1 / 1024))
 return 1
}
$hadoophome dfsadmin -report > $path_temp
#/home/hadoop/hadoop-1.0.4/bin/hadoop dfsadmin -report > $path_temp
#runuser -l hadoop -c 'hadoop dfsadmin -report' > $path_temp
countper=0
need1=9
 while read line || [ -n "$line" ]
 do
   if [ `echo "$line" | grep -c "DFS Used:" ` -gt 0 ]
   then
    if [ `echo "$line" | grep -c "Non DFS Used:" ` -gt 0 ]
    then
     free1 1
    else
     if [ "$need1" -eq "9" ]
     then
     linepath=$(awk -F' ' '{ print $3 }' <<< $line)     
     #linepath2=$(awk -F'%' '{ print $1 }' <<< $linepath)
     countper=$linepath
     need1=10
     fi
    fi
   fi
 done < $path_temp

 tomb $countper 
 date=$(date +"%Y-%m-%d")
 echo "$date $outmb" >> $path_growth
 echo "$date $outmb" >> $path_growth_year 
 rm $path_temp

#keep only 30day in $path_growth
l30=30
del30=0
path_301="/home/hadoop/monitoring/keep_growth_stat.txt"
path_302="/home/hadoop/monitoring/asdf.txt"
countline30=$(awk 'END{print NR}' $path_301)

#echo "$countline30 test"
if [ "$countline30" -gt "$l30" ]
then
 del30=$(($countline30 - $l30))
 #echo "del $del30"
 sed '1,'$del30'd' $path_301 > $path_302 && mv $path_302 $path_301
fi

rm -rf $path_302
#end keep30 day
exit 1
