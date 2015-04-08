#!/bin/bash
command="$1";
path_conf_active="/home/hadoop/TESAPI/TESTSCRIPT/active_Box.txt"
path_cliID="/home/hadoop/TESAPI/TESTSCRIPT/Box/cliID.box"
path_cliSecret="/home/hadoop/TESAPI/TESTSCRIPT/Box/cliSECRET.box"
path_refreshtoken="/home/hadoop/TESAPI/TESTSCRIPT/Box/refreshtoken.box"
path_token="/home/hadoop/TESAPI/TESTSCRIPT/Box/token.box"
countBox=$(awk 'END{print NF}' $path_conf_active)

for (( i=1; i<=$countBox; i++ ))
do
	client_id=$(awk "NR==$i{print;exit}" $path_cliID)
	client_secret=$(awk "NR==$i{print;exit}" $path_cliSecret)
	refresh_token=$(awk END"{print}" $path_refreshtoken$i)
	#echo "$i"
	#echo "client_id: $client_id"
	#echo "client_secret: $client_secret"	
	#echo "refresh token : $refresh_token"		
	curl "https://app.box.com/api/oauth2/token"  -d "grant_type=refresh_token&refresh_token=${refresh_token}&client_id=${client_id}&client_secret=${client_secret}"  -X "POST" -s | jq '.access_token' | cut -d'"' -f2 > $path_token$i
	curl "https://app.box.com/api/oauth2/token"  -d "grant_type=refresh_token&refresh_token=${refresh_token}&client_id=${client_id}&client_secret=${client_secret}"  -X "POST" -s | jq '.refresh_token' | cut -d'"' -f2 > $path_refreshtoken$i
done