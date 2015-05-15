#!/bin/bash
path_conf="/home/hadoop/TESAPI/TESTSCRIPT/set_Auto.txt"
while read line || [ -n "$line" ]
do
  prob=$(awk -F' ' '{ print $7 }' <<< $line)
done < $path_conf
crontab -l >  /home/hadoop/TESAPI/TESTSCRIPT/probchecking.txt
grep -v tpiv1.sh /home/hadoop/TESAPI/TESTSCRIPT/probchecking.txt > /home/hadoop/TESAPI/TESTSCRIPT/tmp.txt
grep -v tpiv2.sh /home/hadoop/TESAPI/TESTSCRIPT/tmp.txt > /home/hadoop/TESAPI/TESTSCRIPT/probchecking.txt
rm -rf /home/hadoop/TESAPI/TESTSCRIPT/tmp.txt
echo "10 0 */$prob * * /home/hadoop/TESAPI/TESTSCRIPT/tpiv1.sh 2>&1" >>  /home/hadoop/TESAPI/TESTSCRIPT/probchecking.txt
echo "10 0 */$prob * * /home/hadoop/TESAPI/TESTSCRIPT/tpiv2.sh 2>&1" >>  /home/hadoop/TESAPI/TESTSCRIPT/probchecking.txt
crontab  /home/hadoop/TESAPI/TESTSCRIPT/probchecking.txt
