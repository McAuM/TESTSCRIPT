#!/bin/bash
pathNas="/home/hadoop/TESAPI/TESTSCRIPT/nas"
function connectNas() {
	sh ${1}
	sid=$(sed -n 1p token.nas)
	ip=$(sed -n 2p ${1} | cut -d '"' -f2)
	port=$(sed -n 3p ${1} | cut -d '"' -f2)
	return 1
}
function cutfile() {
  cut_all=$1
  cut_a=$(awk -F'/' '{ print $NF }' <<< $cut_all)
  return 1
}
function helpCMD() {
	echo "          -----------NAS API------------               "
	echo "Usage :"
	echo "-command			<need> [option] {detail}"
	echo "-help 				{show detail command}"
	echo "-account			<account> {show account information}"
	echo "-space				<account> {show all space}"
	echo "-spaceper			<account> {show all space %}"
	echo "-usespace			<account> <folderpath> {show use space information}"
	echo "-metadata			<account> <filepath> {show metadata of file}"
	echo "-upload				<account> <source_filepath> <destination_folder_path>" 
	echo "-dowload			<account> <filepath> <newfile>"
	echo "-delete				<account> <filepath>"
	echo "-showlist			<account> <folderpath>"
	return 1
}
command="${1}"
case $command in
	-h | help ) shift
		helpCMD 1
	;;
	-a | account )
		connectNas ${pathNas}${2}
		tmpacc=$(curl -X GET "http://${ip}:${port}/webapi/FileStation/info.cgi?api=SYNO.FileStation.Info&version=1&method=getinfo&_sid=${sid}" -s | jq '.data.hostname' | cut -d '"' -f2)
		tmpspace=$(sh /home/hadoop/TESAPI/TESTSCRIPT/nasapi.sh space ${2})
		echo "User account info"
		echo "user id = ${sid}"
		echo "display name = $tmpacc"
		echo ""
		echo "$tmpspace"		
		#curl -X GET "http://${ip}:${port}/webapi/auth.cgi?api=SYNO.API.Auth&version=1&method=logout&_sid=${sid}&session=FileStation" -s
		#echo "Get Information of Account Complete"
	;;
	-s | space )
		connectNas ${pathNas}${2}
		freespace=$(curl -X GET "http://${ip}:${port}/webapi/FileStation/file_share.cgi?api=SYNO.FileStation.List&version=1&method=list_share&_sid=${sid}&additional=volume_status" -s | jq '.data.shares[0].additional.volume_status.freespace')
		freespaceGB=$((freespace/(1024*1024*1024)))
		freespaceMB=$((freespace/(1024*1024)))
		totalspace=$(curl -X GET "http://${ip}:${port}/webapi/FileStation/file_share.cgi?api=SYNO.FileStation.List&version=1&method=list_share&_sid=${sid}&additional=volume_status" -s | jq '.data.shares[0].additional.volume_status.totalspace')
		totalspaceGB=$((totalspace/(1024*1024*1024)))
		totalspaceMB=$((totalspace/(1024*1024)))
		usespace=$((totalspace-freespace))
		usespaceGB=$((usespace/(1024*1024*1024)))
		usespaceMB=$((usespace/(1024*1024)))
		echo "User space:"
		echo "total = ${totalspaceGB} GB or ${totalspaceMB} MB"
		echo "used = ${usespaceGB} GB or ${usespaceMB} MB"
		echo "free = ${freespaceGB} GB or ${freespaceMB} MB"
		#curl -X GET "http://${ip}:${port}/webapi/auth.cgi?api=SYNO.API.Auth&version=1&method=logout&_sid=${sid}&session=FileStation" -s
		#echo "Get Information Free Space and Total Space Complete"
	;;
	-sp | spaceper )
		connectNas ${pathNas}${2}
		freespace=$(curl -X GET "http://${ip}:${port}/webapi/FileStation/file_share.cgi?api=SYNO.FileStation.List&version=1&method=list_share&_sid=${sid}&additional=volume_status" -s | jq '.data.shares[0].additional.volume_status.freespace')
		totalspace=$(curl -X GET "http://${ip}:${port}/webapi/FileStation/file_share.cgi?api=SYNO.FileStation.List&version=1&method=list_share&_sid=${sid}&additional=volume_status" -s | jq '.data.shares[0].additional.volume_status.totalspace')
		usespaceper=$((((totalspace-freespace)*100)/totalspace))
		echo "${usespaceper}"
		#curl -X GET "http://${ip}:${port}/webapi/auth.cgi?api=SYNO.API.Auth&version=1&method=logout&_sid=${sid}&session=FileStation" -s
		#echo "Get Information Free Space and Total Space Complete"
	;;
	-us | usespace )
		connectNas ${pathNas}${2}
		taskid=$(curl -X GET "http://${ip}:${port}/webapi/FileStation/file_dirSize.cgi?api=SYNO.FileStation.DirSize&version=1&method=start&_sid=${sid}&path=${3}" -s | jq '.data.taskid' | cut -d '"' -f2)
		echo "Taskid = ${taskid}"
		space=$(curl -X GET "http://${ip}:${port}/webapi/FileStation/file_dirSize.cgi?api=SYNO.FileStation.DirSize&version=1&method=status&_sid=${sid}&taskid=${taskid}" -s | jq '.data.total_size' | cut -d '"' -f2)
		freespace=$(curl -X GET "http://${ip}:${port}/webapi/FileStation/file_share.cgi?api=SYNO.FileStation.List&version=1&method=list_share&_sid=${sid}&additional=volume_status" -s | jq '.data.shares[0].additional.volume_status.freespace')
		totalspace=$(curl -X GET "http://${ip}:${port}/webapi/FileStation/file_share.cgi?api=SYNO.FileStation.List&version=1&method=list_share&_sid=${sid}&additional=volume_status" -s | jq '.data.shares[0].additional.volume_status.totalspace')
		usespace=$((totalspace-freespace-space))
		totalspace=$((totalspace-usespace))
		totalspaceGB=$((totalspace/(1024*1024*1024)))
		totalspaceMB=$((totalspace/(1024*1024)))
		spaceGB=$((space/(1024*1024*1024)))
		spaceMB=$((space/(1024*1024)))
		freespaceGB=$((freespace/(1024*1024*1024)))
		freespaceMB=$((freespace/(1024*1024)))
		echo "total = ${totalspaceGB} GB or ${totalspaceMB} MB"
		echo "used = ${spaceGB} GB or ${spaceMB} MB"
		echo "free = ${freespaceGB} GB or ${freespaceMB} MB"
		#curl -X GET "http://${ip}:${port}/webapi/auth.cgi?api=SYNO.API.Auth&version=1&method=logout&_sid=${sid}&session=FileStation" -s
		#echo "Get Use Space Information of path ${2} Complete"
	;;
	-mt | metadata )
		connectNas ${pathNas}${2}
		title=$(curl -X GET "http://${ip}:${port}/webapi/FileStation/file_share.cgi?api=SYNO.FileStation.List&version=1&method=getinfo&_sid=${sid}&additional=real_path%2Csize%2Cowner%2Ctime%2Cperm%2Ctype&path=${3}" -s | jq  '.data.files[0].name' | cut -d '"' -f2)
		size=$(curl -X GET "http://${ip}:${port}/webapi/FileStation/file_share.cgi?api=SYNO.FileStation.List&version=1&method=getinfo&_sid=${sid}&additional=real_path%2Csize%2Cowner%2Ctime%2Cperm%2Ctype&path=${3}" -s | jq  '.data.files[0].additional.size')
		timestamp=$(curl -X GET "http://${ip}:${port}/webapi/FileStation/file_share.cgi?api=SYNO.FileStation.List&version=1&method=getinfo&_sid=${sid}&additional=real_path%2Csize%2Cowner%2Ctime%2Cperm%2Ctype&path=${3}" -s | jq  '.data.files[0].additional.time.crtime')
		datecr=$(date -d @${timestamp})
		echo "Title: ${title}"
		echo "Size: ${size} byte"
		echo "Date: ${datecr}"
	;;
	-u | upload )
		connectNas ${pathNas}${2}
		noprint=$(curl -X POST "http://${ip}:${port}/webapi/FileStation/api_upload.cgi?" -F _sid="${sid}" -F api="SYNO.FileStation.Upload" -F version="1" -F method="upload" -F dest_folder_path="/Data${4}" -F create_parents="true" -F overwrite="true" -F file=@"${3}" -s)
		#curl -X GET "http://${ip}:${port}/webapi/auth.cgi?api=SYNO.API.Auth&version=1&method=logout&_sid=${sid}&session=FileStation" -s
		cutfile ${3}
		destpath="/Data${4}${cut_a}"
		echo "Upload Complete to ${destpath}"
	;;
	-del | delete)
		connectNas ${pathNas}${2}
		noprint=$(curl -X GET "http://${ip}:${port}/webapi/FileStation/file_delete.cgi?api=SYNO.FileStation.Delete&version=1&method=delete&_sid=${sid}&path=${3}" -s)
		#curl -X GET "http://${ip}:${port}/webapi/auth.cgi?api=SYNO.API.Auth&version=1&method=logout&_sid=${sid}&session=FileStation" -s
		echo "Delete Complete to ${3}"		
	;;
	-d | download ) 
		connectNas ${pathNas}${2}
		curl -X GET "http://${ip}:${port}/webapi/FileStation/file_download.cgi?api=SYNO.FileStation.Download&version=1&method=download&_sid=${sid}&mode=download&path=${3}" -s > ${4}
		#curl -X GET "http://${ip}:${port}/webapi/auth.cgi?api=SYNO.API.Auth&version=1&method=logout&_sid=${sid}&session=FileStation" -s
		echo "Download Complete to ${4}"
	;;
	-ls | showlist )
		connectNas ${pathNas}${2}
		curl -X GET "http://${ip}:${port}/webapi/FileStation/file_share.cgi?api=SYNO.FileStation.List&version=1&method=list&_sid=${sid}&additional=real_path%2Csize%2Cowner%2Ctime%2Cperm%2Ctype&folder_path=${3}" -s | jq '.data.files[] | {name, path}' | jq '.name' | cut -d '"' -f2
		#curl -X GET "http://${ip}:${port}/webapi/auth.cgi?api=SYNO.API.Auth&version=1&method=logout&_sid=${sid}&session=FileStation" -s
		#curl -X GET "http://${ip}:${port}/webapi/FileStation/file_share.cgi?api=SYNO.FileStation.List&version=1&method=getinfo&additional=real_path%2Csize%2Cowner%2Ctime%2Cperm%2Ctype&path=${3}" -s
		#echo "Show List Complete"
	;;
	-a2 | account2 )
		connectNas ${pathNas}${2}
		accountname=$(curl -X GET "http://${ip}:${port}/webapi/FileStation/info.cgi?api=SYNO.FileStation.Info&version=1&method=getinfo&_sid=${sid}" -s | jq '.data.hostname' | cut -d '"' -f2)
		printf "user id = %s\t display name = %s\n" ${sid} ${accountname}
	;;
	-s2 | space2 )
		connectNas ${pathNas}${2}
		freespace=$(curl -X GET "http://${ip}:${port}/webapi/FileStation/file_share.cgi?api=SYNO.FileStation.List&version=1&method=list_share&_sid=${sid}&additional=volume_status" -s | jq '.data.shares[0].additional.volume_status.freespace')
		freespaceGB=$((freespace/(1024*1024*1024)))
		freespaceMB=$((freespace/(1024*1024)))
		totalspace=$(curl -X GET "http://${ip}:${port}/webapi/FileStation/file_share.cgi?api=SYNO.FileStation.List&version=1&method=list_share&_sid=${sid}&additional=volume_status" -s | jq '.data.shares[0].additional.volume_status.totalspace')
		totalspaceGB=$((totalspace/(1024*1024*1024)))
		totalspaceMB=$((totalspace/(1024*1024)))
		usespace=$((totalspace-freespace))
		usespaceGB=$((usespace/(1024*1024*1024)))
		usespaceMB=$((usespace/(1024*1024)))
		echo "User space:"
		printf "total = %s GB or %s MB\t used = %s GB or %s MB\t free = %s GB or %s MB\n" ${totalspaceGB} ${totalspaceMB} ${usespaceGB} ${usespaceMB} ${freespaceGB} ${freespaceMB}
		#curl -X GET "http://${ip}:${port}/webapi/auth.cgi?api=SYNO.API.Auth&version=1&method=logout&_sid=${sid}&session=FileStation" -s
		#echo "Get Information Free Space and Total Space Complete"
	;;
	* ) shift
		helpCMD 1
	;;
esac
logout=$(curl -X GET "http://${ip}:${port}/webapi/auth.cgi?api=SYNO.API.Auth&version=1&method=logout&_sid=${sid}&session=FileStation" -s)
#echo "Logout = $logout"
exit 1
