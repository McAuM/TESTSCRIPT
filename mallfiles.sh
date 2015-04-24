#!/bin/bash
hadoophome="/home/hadoop/hadoop-1.0.4/bin/hadoop"
javahome="/usr/java/jdk1.7.0_09/bin/java"

path_Dbox="/home/hadoop/TESAPI/TESTSCRIPT/Dropbox.jar"
path_Box="/home/hadoop/TESAPI/TESTSCRIPT/box.jar"
path_Gdrive="/home/hadoop/TESAPI/TESTSCRIPT/gdrive.jar"
path_Nas="/home/hadoop/TESAPI/TESTSCRIPT/nasapi.sh"

tfile="/home/hadoop/TESAPI/TESTSCRIPT/token.pcs" 

#path_conf_a1="/home/hadoop/TESAPI/TESTSCRIPT/active_Box.txt"
#path_conf_a2="/home/hadoop/TESAPI/TESTSCRIPT/active_Dropbox.txt"
#path_conf_a3="/home/hadoop/TESAPI/TESTSCRIPT/active_GoogleDrive.txt"
#path_conf_a4="/home/hadoop/TESAPI/TESTSCRIPT/active_Nas.txt"

path_temptxt="/home/hadoop/TESAPI/TESTSCRIPT/temp.txt"
path_tempfile="/home/hadoop/TESAPI/TESTSCRIPT/tempfile/"

path_file_a="/home/hadoop/TESAPI/TESTSCRIPT/in_cloud_All.txt" 
#path_file_NAS="/home/hadoop/TESAPI/TESTSCRIPT/in_NAS" 
#path_file_box="/home/hadoop/TESAPI/TESTSCRIPT/in_box" 
#path_file_Dbox="/home/hadoop/TESAPI/TESTSCRIPT/in_Dbox" 
#path_file_gdrive="/home/hadoop/TESAPI/TESTSCRIPT/in_gdrive" 

while read line1 || [ -n "$line1" ]
do 
	file1=$(awk -F' ' '{ print $1 }' <<< $line1)
	path_file=$(awk -F' ' '{ print $NF }' <<< $line1)
	while read line2 || [ -n "$line2" ]
	do
		file2=$(awk -F' ' '{ print $1 }' <<< $line2)
		filename=$(awk -F'/' '{ print $NF }' <<< $file2)
		temp_download=$(awk -F' ' '{ print $NF }' <<< $line2)
		#echo "$temp_download"
		if [ "$file1" = "$file2" ]; then
			#statements
			if [ `echo "$path_file" | grep -c "Dbox" ` -eq 1 ]; then
				i=1
				temp_path_file=$(awk -F'/' '{ print $NF }' <<< $path_file)
				while [ 1 ]
				do
					if [ "$temp_path_file" = "in_Dbox${i}.txt" ]; then
						#Load File To Local
						${javahome} -jar ${path_Dbox} download ${tfile}$i ${path_tempfile}${filename} ${temp_download}
						#Upload File To Hadoop 
						hadoop dfs -moveFromLocal ${path_tempfile}${filename} ${file2}
						#Remove File In Cloud
						${javahome} -jar ${path_Dbox} delete ${tfile}$i ${temp_download}
						#Delete Line In in_gdrive?.txt
						tmp=$(grep -v "$file2" $path_file)
                    	if [ "$tmp" = "" ]                 
                    	then
                      		echo "" > $path_file && sed '/^\s*$/d' $path_file > $path_temptxt && mv $path_temptxt $path_file                      
                    	else
                      		grep -v "$file2" $path_file > $path_temptxt && mv $path_temptxt $path_file                     
                    	fi
						#Delete Line In in_cloud_All.txt
						tmp2=$(grep -v "$file1" $path_file_a)
						if [ "$tmp2" = "" ]                 
                    	then
                      		echo "" > $path_file_a && sed '/^\s*$/d' $path_file_a > $path_temptxt && mv $path_temptxt $path_file_a
                    	else
                      		grep -v "$file1" $path_file_a > $path_temptxt && mv $path_temptxt $path_file_a
                    	fi
						#echo "Download Complete to ${file2}"
						break
					fi
					i=$((i+1))
				done
			elif [ `echo "$path_file" | grep -c "box" ` -eq 1 ]; then
				i=1
				temp_path_file=$(awk -F'/' '{ print $NF }' <<< $path_file)
				while [ 1 ]
				do
					if [ "$temp_path_file" = "in_box${i}.txt" ]; then
						#Load File To Local
						${javahome} -jar ${path_Box} download2 $i ${temp_download} ${path_tempfile}
						#Upload File To Hadoop 
						hadoop dfs -moveFromLocal ${path_tempfile}${filename} ${file2}
						#Remove File In Cloud
						${javahome} -jar ${path_Box} delete $i ${temp_download}
						#Delete Line In in_gdrive?.txt
						tmp=$(grep -v "$file2" $path_file)
                    	if [ "$tmp" = "" ]                 
                    	then
                      		echo "" > $path_file && sed '/^\s*$/d' $path_file > $path_temptxt && mv $path_temptxt $path_file                      
                    	else
                      		grep -v "$file2" $path_file > $path_temptxt && mv $path_temptxt $path_file                     
                    	fi
						#Delete Line In in_cloud_All.txt
						tmp2=$(grep -v "$file1" $path_file_a)
						if [ "$tmp2" = "" ]                 
                    	then
                      		echo "" > $path_file_a && sed '/^\s*$/d' $path_file_a > $path_temptxt && mv $path_temptxt $path_file_a
                    	else
                      		grep -v "$file1" $path_file_a > $path_temptxt && mv $path_temptxt $path_file_a
                    	fi
						#echo "Download Complete to ${file2}"
						break
					fi
					i=$((i+1))
				done
			elif [ `echo "$path_file" | grep -c "gdrive" ` -eq 1 ]; then
				i=1
				temp_path_file=$(awk -F'/' '{ print $NF }' <<< $path_file)
				while [ 1 ]
				do
					if [ "$temp_path_file" = "in_gdrive${i}.txt" ]; then
						#Load File To Local
						${javahome} -jar ${path_Gdrive} download2 $i ${temp_download} ${path_tempfile}
						#Upload File To Hadoop 
						hadoop dfs -moveFromLocal ${path_tempfile}${filename} ${file2}
						#Remove File In Cloud
						${javahome} -jar ${path_Gdrive} delete $i ${temp_download}
						#Delete Line In in_gdrive?.txt
						tmp=$(grep -v "$file2" $path_file)
                    	if [ "$tmp" = "" ]                 
                    	then
                      		echo "" > $path_file && sed '/^\s*$/d' $path_file > $path_temptxt && mv $path_temptxt $path_file                      
                    	else
                      		grep -v "$file2" $path_file > $path_temptxt && mv $path_temptxt $path_file                     
                    	fi
						#Delete Line In in_cloud_All.txt
						tmp2=$(grep -v "$file1" $path_file_a)
						if [ "$tmp2" = "" ]                 
                    	then
                      		echo "" > $path_file_a && sed '/^\s*$/d' $path_file_a > $path_temptxt && mv $path_temptxt $path_file_a
                    	else
                      		grep -v "$file1" $path_file_a > $path_temptxt && mv $path_temptxt $path_file_a
                    	fi
						#echo "Download Complete to ${file2}"
						break
					fi
					i=$((i+1))
				done
			elif [ `echo "$path_file" | grep -c "NAS" ` -eq 1 ]; then
				i=1
				temp_path_file=$(awk -F'/' '{ print $NF }' <<< $path_file)
				while [ 1 ]
				do
					if [ "$temp_path_file" = "in_NAS${i}.txt" ]; then
						#Load File To Local
						sh ${path_Nas} download $i ${temp_download} ${path_tempfile}${filename}
						#Upload File To Hadoop 
						hadoop dfs -moveFromLocal ${path_tempfile}${filename} ${file2}
						#Remove File In Cloud
						sh ${path_Nas} delete $i ${temp_download}
						#Delete Line In in_gdrive?.txt
						tmp=$(grep -v "$file2" $path_file)
                    	if [ "$tmp" = "" ]                 
                    	then
                      		echo "" > $path_file && sed '/^\s*$/d' $path_file > $path_temptxt && mv $path_temptxt $path_file                      
                    	else
                      		grep -v "$file2" $path_file > $path_temptxt && mv $path_temptxt $path_file                     
                    	fi
						#Delete Line In in_cloud_All.txt
						tmp2=$(grep -v "$file1" $path_file_a)
						if [ "$tmp2" = "" ]                 
                    	then
                      		echo "" > $path_file_a && sed '/^\s*$/d' $path_file_a > $path_temptxt && mv $path_temptxt $path_file_a
                    	else
                      		grep -v "$file1" $path_file_a > $path_temptxt && mv $path_temptxt $path_file_a
                    	fi
						#echo "Download Complete to ${file2}"
						break
					fi
					i=$((i+1))
				done
			fi
			break
		fi
	done < $path_file
	echo ""
done < $path_file_a