#!/bin/bash
path_conf_active="/home/hadoop/TESAPI/TESTSCRIPT/active_GoogleDrive.txt"
path_cliID="/home/hadoop/TESAPI/TESTSCRIPT/GoogleDrive/cliID.gdrive"
path_cliSecret="/home/hadoop/TESAPI/TESTSCRIPT/GoogleDrive/cliSECRET.gdrive"
path_refreshtoken="/home/hadoop/TESAPI/TESTSCRIPT/GoogleDrive/refreshtoken.gdrive"
path_token="/home/hadoop/TESAPI/TESTSCRIPT/GoogleDrive/token.gdrive"
countGdrive=$(awk 'END{print NF}' $path_conf_active)

#client_id=$(awk "NR==1{print;exit}" /home/hadoop/TESAPI/TESTSCRIPT/GoogleDrive/cliID.gdrive)
#client_secret=$(awk "NR==1{print;exit}" /home/hadoop/TESAPI/TESTSCRIPT/GoogleDrive/cliSECRET.gdrive)
#client_id="239045167544-7cdofigo9aroldln3340n1bfqjbv0ksi.apps.googleusercontent.com"
#client_secret="3nj6cTgKqVYovs9cIijfGFhV"
#refresh_token="1/skB6ZW8ppotsHGbOz_kcXVWqZ1MGL2Jxwbv11x5D1jo"


for (( i=1; i<=$countGdrive; i++ ))
do
	client_id=$(awk "NR==$i{print;exit}" $path_cliID)
	client_secret=$(awk "NR==$i{print;exit}" $path_cliSecret)
	refresh_token=$(awk END"{print}" $path_refreshtoken$i)
	#echo "$i"
	#echo "client_id: $client_id"
	#echo "client_secret: $client_secret"	
	#echo "refresh token : $refresh_token"
	curl -X "POST"  "https://accounts.google.com/o/oauth2/token"  -d "client_id=${client_id}&client_secret=${client_secret}&refresh_token=${refresh_token}&grant_type=refresh_token" -s  | jq '.access_token' | cut -d'"' -f2 >  $path_token$i
done



