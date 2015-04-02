#!/bin/bash
for((i=1; i<=${3}; i++));
do
	dd if=/dev/zero of=/home/hadoop/TESAPI/TESTSCRIPT/testfile_${i} bs=1M count=${2}
	hadoop dfs -moveFromLocal /home/hadoop/TESAPI/TESTSCRIPT/testfile_${i} /user/hadoop/${1}@kmutt.ac.th/home/
done