#!/bin/bash

path_Dbox="/home/hadoop/TESAPI/TESTSCRIPT/Dropbox.jar"
path_Box="/home/hadoop/TESAPI/TESTSCRIPT/box.jar"
path_Gdrive="/home/hadoop/TESAPI/TESTSCRIPT/gdrive.jar"
path_Nas="/home/hadoop/TESAPI/TESTSCRIPT/nasapi"

tfile="/home/hadoop/TESAPI/TESTSCRIPT/token.pcs" 

path_conf_a1="/home/hadoop/TESAPI/TESTSCRIPT/active_Box.txt"
path_conf_a2="/home/hadoop/TESAPI/TESTSCRIPT/active_Dropbox.txt"
path_conf_a3="/home/hadoop/TESAPI/TESTSCRIPT/active_GoogleDrive.txt"
path_conf_a4="/home/hadoop/TESAPI/TESTSCRIPT/active_Nas.txt"

#Box
line=$(sed -n 1p $path_conf_a1)
count=0
for word in $line; do
	count=$((count+1))
	echo "${word}"
done
echo "${count}"

for (( i=1; i<${count}; i++)); do
	# Search id
	id=
	#download
	java -jar ${path_Box} download ${i} ${id}
	#remove	
	java -jar ${path_Box} delete ${i} ${id}
done

#Dropbox
line=$(sed -n 1p $path_conf_a2)
count=0
for word in $line; do
	count=$((count+1))
	echo "${word}"
done
echo "${count}"

for (( i=1; i<${count}; i++)); do
	#download
	java -jar ${path_Dbox} download ${i} ... ...
	#remove	
	java -jar ${path_Dbox} delete ${i} ...
done

#GDrive
line=$(sed -n 1p $path_conf_a3)
count=0
for word in $line; do
	count=$((count+1))
	echo "${word}"
done
echo "${count}"

for (( i=1; i<${count}; i++)); do
	#download
	java -jar ${path_Gdrive} download ${i} ${id}
	#remove	
	java -jar ${path_Gdrive} delete ${i} ${id}
done

#Nas
line=$(sed -n 1p $path_conf_a4)
count=0
for word in $line; do
	count=$((count+1))
	echo "${word}"
done
echo "${count}"

for (( i=1; i<${count}; i++)); do
	#download
	sh ${path_Nas} download ${i} ... ...
	#remove	
	sh ${path_Nas} delete ${i} ...
done