<?php
include("functions.php");


if (!is_authed()) 
{
     die ('<h1>Access Denied!!</h1>');
}

?>
<!DOCTYPE html>
<!-- Website template by freewebsitetemplates.com -->
<html>
<head>
	<meta charset="UTF-8">
	<title>Admin module</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
	<link rel="stylesheet" href="css/style.css" type="text/css">
	<!--
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
	-->
	
	
	<script src="http://code.jquery.com/jquery-2.1.1.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
	<script type="text/javascript">

		$(document).ready(function(){
// ___________________________________________________Check Disabled Textbox___________________________________________________ //
// ____________________________________________________________________________________________________________________________ //
			var chkNas = parseInt($('#numAccSaveNas').val()); //alert(chkNas);
			var chkDB = parseInt($('#numAccSaveDB').val()); //alert(chkDB);
			var chkGG = parseInt($('#numAccSaveGG').val()); //alert(chkGG);
			var chkBox = parseInt($('#numAccSaveBox').val()); //alert(chkBox);
//Dropbox --------------------------------------------------------------------------------------------------------------------- //
			var textPriDB = new Array();
			for(i=1; i<=chkDB;i++){
				textPriDB[i-1]= $('#pri_drop'+i).val();
				if(textPriDB[i-1]==0){
					$('#pri_drop'+i).attr("disabled", "disabled");
				}
			}
//Google Drive ---------------------------------------------------------------------------------------------------------------- //			
			var textPriGG = new Array();
			for(i=1; i<=chkGG;i++){
				textPriGG[i-1]= $('#pri_google'+i).val();
				if(textPriGG[i-1]==0){
					$('#pri_google'+i).attr("disabled", "disabled");
				}
			}
//Box ------------------------------------------------------------------------------------------------------------------------- //
			var textPriBox = new Array();
			for(i=1; i<=chkBox;i++){
				textPriBox[i-1]= $('#pri_box'+i).val();
				if(textPriBox[i-1]==0){
					$('#pri_box'+i).attr("disabled", "disabled");
				}
			}
// _________________________________________________________Click SAVE_________________________________________________________ //
// ____________________________________________________________________________________________________________________________ //
			$("#save").click(function(){
				var chkDB = parseInt($('#numAccSaveDB').val());
				var chkGG = parseInt($('#numAccSaveGG').val());
				var chkBox = parseInt($('#numAccSaveBox').val());
				var nas = new Array();
//Nas ------------------------------------------------------------------------------------------------------------------------- //
				for(i=1; i<=chkNas;i++){
					nas[i-1] = $('#nas'+i).val();
					if(nas[i-1]==""){
						alert("Please set On/Off secondary storage!");
					}
					else{
					    if(nas[i-1] < 0 || nas[i-1] > 1){
					    	alert("Please enter 1 or 0 only!");
					    	$("#nas"+i).val("");
					    }
				    }
				}
//Dropbox --------------------------------------------------------------------------------------------------------------------- //
				for(i=1; i<=chkDB;i++){
					textPriDB[i-1]= $('#pri_drop'+i).val();
					//alert(i+" "+textPriDB[i-1]);
					if(textPriDB[i-1]==""){
						alert("Please set priority of storage!");
						$('#pri_drop'+i).focus();
			    		return false;
					}
				}
//Google Drive ---------------------------------------------------------------------------------------------------------------- //
				for(i=1; i<=chkGG;i++){
					textPriGG[i-1]= $('#pri_google'+i).val();
					if(textPriGG[i-1]==""){
						alert("Please set priority of storage!");
						$('#pri_google'+i).focus();
			    		return false;
					}
				}
//Box ------------------------------------------------------------------------------------------------------------------------- //
				for(i=1; i<=chkBox;i++){
					textPriBox[i-1]= $('#pri_box'+i).val();
					if(textPriBox[i-1]==""){
						alert("Please set priority of storage!");
						$('#pri_box'+i).focus();
			    		return false;
					}
				}
//Clear Disabled Textbox ------------------------------------------------------------------------------------------------------ //
				for(i=1; i<=chkDB;i++){
					$('#pri_drop'+i).removeAttr('disabled');	
				}
				for(i=1; i<=chkGG;i++){
					$('#pri_google'+i).removeAttr('disabled');	
				}
				for(i=1; i<=chkBox;i++){
					$('#pri_box'+i).removeAttr('disabled');	
				}
			});
// ______________________________________________________Ajax Add Textbox______________________________________________________ //
// ____________________________________________________________________________________________________________________________ //			
			var count1=count2=count3=count4=0;
			var addNas=chkNas+1;
			var addDB=chkDB+1;
			var addGG=chkGG+1;
			var addBox=chkBox+1;
//Nas ------------------------------------------------------------------------------------------------------------------------- //
			$('#btn_add1').on('click',function(){
				var numAccSaveNas = parseInt($('#numAccSaveNas').val());
				numAccSaveNas++;
				count1++;
				$('#numAccSaveNas').val(numAccSaveNas);

				$.ajax({
                        url:'addCloud.php',
                        type:'POST',
                        data:'count1='+count1+'&addNas='+addNas,
                        dataType:'html',
                        success:callback,
                });
             	
                function callback(result){
                    $('#addRow1').html(result);
                }
			});

//Dropbox --------------------------------------------------------------------------------------------------------------------- //
			$('#btn_add2').on('click',function(){
				var numAccSaveDB = parseInt($('#numAccSaveDB').val());
				numAccSaveDB++;
				count2++;
				$('#numAccSaveDB').val(numAccSaveDB);

				$.ajax({
                        url:'addCloud.php',
                        type:'POST',
                        data:'count2='+count2+'&addDB='+addDB,
                        dataType:'html',
                        success:callback,
                });
             	
                function callback(result){
                    $('#addRow2').html(result);
                    //$('#numAccSaveDB').val(numAccSaveDB);
                }
			});
//Google Drive ---------------------------------------------------------------------------------------------------------------- //
			$('#btn_add3').on('click',function(){
				var numAccSaveGG = parseInt($('#numAccSaveGG').val());
				numAccSaveGG++;
				count3++;
				$('#numAccSaveGG').val(numAccSaveGG);

				$.ajax({
                        url:'addCloud.php',
                        type:'POST',
                        data:'count3='+count3+'&addGG='+addGG,
                        dataType:'html',
                        success:callback,
                });
             	
                function callback(result){
                    $('#addRow3').html(result);
                    //$('#numAccSaveGG').val(numAccSaveGG);
                }
			});
//Box ------------------------------------------------------------------------------------------------------------------------- //
			$('#btn_add4').on('click',function(){
				var numAccSaveBox = parseInt($('#numAccSaveBox').val());
				numAccSaveBox++;
				count4++;
				$('#numAccSaveBox').val(numAccSaveBox);

				$.ajax({
                        url:'addCloud.php',
                        type:'POST',
                        data:'count4='+count4+'&addBox='+addBox,
                        dataType:'html',
                        success:callback,
                });
             	
                function callback(result){
                    $('#addRow4').html(result);
                    //$('#numAccSaveBox').val(numAccSaveBox);
                }
			});
// _____________________________________________________Fucntions by event_____________________________________________________ //
// ____________________________________________________________________________________________________________________________ //
		});
		function selectNAS(id){
			var count1 = parseInt($('#numAccSaveNas').val());			
			$.ajax({
                url:'delCloud.php',
                type:'POST',
                data:'cloud=NAS&id='+id+'&count1='+count1,
                dataType:'html',
                success:callback,
            });
            function callback(result){
            	alert(result);
             //$('#addRow1').html(result);                    
            }	   		
		}
		function selectgdrive(id){
			var count3 = parseInt($('#numAccSaveGG').val());			
			$.ajax({
                url:'delCloud.php',
                type:'POST',
                data:'cloud=gdrive&id='+id+'&count3='+count3,
                dataType:'html',
                success:callback,
            });
            function callback(result){
            	alert(result);
             //$('#addRow1').html(result);                    
            }	   		
		}
		function GotoPage(){
	   		var loc = document.getElementById('ddlConfig').value;
	   		if(loc!="0") window.location = loc;
		}
		function textboxOnchange(storage,priority){
		    var open = $(storage).val();
		    //alert(open);
		    if(open == ""){
		    	alert("Please set On/Off secondary storage!");
		    }
		    else{
		    	//alert("555");
			    if(open == 1){
			    	$(priority).removeAttr('disabled');	
			    	$(priority).val("");
			    }
			    else if(open == 0){
			    	$(priority).val(0);
			    	$(priority).attr("disabled", "disabled");
			    	//var x = $(priority).val();
		        	//alert(x);
			    }
			    else{
			    	alert("Please enter 1 or 0 only!");
			    	$(storage).val("");
			    }
		    }
		}		  
	</script>
</head>
<!-- _______________________________________________________HTML Main Page_______________________________________________________ -->
<!-- ____________________________________________________________________________________________________________________________ -->
<body>
	<div class="border">
		<div id="bg">
			background
		</div>
		<div class="page">
			<div class="sidebar">
				<a href="status.php" id="logo"><img src="images/logo.png" alt="logo"></a>
				<ul>
					<li>
						<a href="status.php">Status</a>
					</li>
					<li>
						<a href="user.php">User Management</a>
					</li>
					<li>
						<a href="logHadoop.php">Log</a>
					</li>
					<li class="selected">
						<a href="setup.php">Setup</a>
					</li>
					<li>
						<a href="tpi.php">Third Party Storage</a>
					</li>
					<li>
						<a href="nas.php">Network Attached Storage</a>
					</li>
					<li>
						<a href="monitor.php">Monitoring System</a>
					</li>
				</ul>
				<form action="index.php">
					
				</form>
				<div class="connect">
					<a href=# id="facebook">facebook</a> <a href=# id="twitter">twitter</a> <a href=# id="googleplus">youtube</a>
				</div>
				<p>
					CPE Box
				</p>
				<p>
					Private Cloud Storage
				</p>
			</div>
			<div class="body">
				<div>
				<h2 align="right">WELCOME &nbsp;<?php echo "<a href=profile.php><font color=black><u>".$_SESSION["username"]."</u></font></a>"; ?>&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp; <a href=logout.php><font color=indigo><u> logout</u></font></a></h2>
				</div>
				<div class="services" style="padding-bottom:20px">
					<ul class="navigation">
						<li>
							<a href="setup.php">Start/Stop</a>
						</li>
						<li class="selected">
							<a href="activeStorage.php">Activate Storage</a>
						</li>
						<li>
							<a href="setAuto.php">Set-Auto</a>
						</li>
			            <li id="ddlHead">
							<select id="ddlConfig" onchange="GotoPage()">
								<option style="display:none;" disabled="disabled" selected="selected">CONFIGURE</option>
						  		<option value="config-core-site.php">CORE-SITE.XML</option>
						  		<option value="config-mapred-site.php">MAPRED-SITE.XML</option>
						  		<option value="config-hdfs-site.php">HDFS-SITE.XML</option>
							</select>
						</li>
					</ul>
<!-- _______________________________________________Submit Form (SAVE or DEFAULT)________________________________________________ -->
<!-- ____________________________________________________________________________________________________________________________ -->
<?php									
//DEFAULT button ------------------------------------------------------------------------------------------------------- //					
					if(isset($_POST["default"])){ 
//Read	NAS ------------------------------------------------------------------------------------------------------------ //
						$file1 = fopen("/home/hadoop/TESAPI/TESTSCRIPT/active_Nas.txt","r");
						$lineNas = fgets($file1,1024);
						$numAccNas = str_word_count($lineNas);
						echo $numAccNas;
						$countLoop = 2*$numAccNas-1;
						$_SESSION["numAccSaveNas"] = $numAccNas;

						$file1 = fopen("/home/hadoop/TESAPI/TESTSCRIPT/active_Nas.txt","r");
						$countline=0;
						while (!feof($file1))
						{
							$lineNas=fgets($file1,1024);
							if($countline==0){
								for($i=0;$i<$countLoop;$i++){
									$lineNas[$i]=$lineNas[$i];
								}
							}
							else if($countline==1){
								for($i=0;$i<$countLoop;$i++){
									$lineNas2[$i]=$lineNas[$i];
								}
							}
							$countline++;
						}
						$index=0;
						for($i=0;$i<$numAccNas;$i++){
							list($accNas[$i]) = $lineNas2[$index];
							$index=$index+2;
						}
//Read	Dropbox -------------------------------------------------------------------------------------------------------- //
						$file2 = fopen("/home/hadoop/TESAPI/TESTSCRIPT/active_Dropbox.txt","r");	
						$lineDB = fgets($file2,1024);
						$numAccDB = str_word_count($lineDB);
						$countLoop = 2*$numAccDB-1;
						$_SESSION["numAccSaveDB"] = $numAccDB;
						
						$file2 = fopen("/home/hadoop/TESAPI/TESTSCRIPT/active_Dropbox.txt","r");
						$countline = 0;
						while (!feof($file2))
						{
							$lineDB=fgets($file2,1024);
							if($countline==0){
								for($i=0;$i<$countLoop;$i++){
									$lineDB[$i]=$lineDB[$i];
								}
							}
							else if($countline==1){
								for($i=0;$i<$countLoop;$i++){
									$lineDB2[$i]=$lineDB[$i];
								}
							}
							else if($countline==2) {
								for($i=0;$i<$countLoop;$i++){
									$lineDB3[$i]=$lineDB[$i];
								}
							}
							$countline++;
						}
						$index=0;
						for($i=0;$i<$numAccDB;$i++){
							list($accDB[$i]) = $lineDB2[$index];
							list($priDB[$i]) = $lineDB3[$index];
							$index=$index+2;
						}
//Read	Google Drive --------------------------------------------------------------------------------------------------- //
						$file3 = fopen("/home/hadoop/TESAPI/TESTSCRIPT/active_GoogleDrive.txt","r");
						$lineGG = fgets($file3,1024);
						$numAccGG = str_word_count($lineGG);
						$countLoop = 2*$numAccGG-1;
						$_SESSION["numAccSaveGG"] = $numAccGG;

						$file3 = fopen("/home/hadoop/TESAPI/TESTSCRIPT/active_GoogleDrive.txt","r");
						$countline=0;
						while (!feof($file3))
						{
							$lineGG=fgets($file3,1024);
							if($countline==0){
								for($i=0;$i<$countLoop;$i++){
									$lineGG[$i]=$lineGG[$i];
								}
							}
							else if($countline==1){
								for($i=0;$i<$countLoop;$i++){
									$lineGG2[$i]=$lineGG[$i];
								}
							}
							else if($countline==2) {
								for($i=0;$i<$countLoop;$i++){
									$lineGG3[$i]=$lineGG[$i];
								}
							}
							$countline++;
						}
						$index=0;
						for($i=0;$i<$numAccGG;$i++){
							list($accGG[$i]) = $lineGG2[$index];
							list($priGG[$i]) = $lineGG3[$index];
							$index=$index+2;
						}
//Read	Box ------------------------------------------------------------------------------------------------------------ //
						$file4 = fopen("/home/hadoop/TESAPI/TESTSCRIPT/active_Box.txt","r");
						$lineBox = fgets($file4,1024);
						$numAccBox = str_word_count($lineBox);
						$countLoop = 2*$numAccBox-1;
						$_SESSION["numAccSaveBox"] = $numAccBox;

						$file4 = fopen("/home/hadoop/TESAPI/TESTSCRIPT/active_Box.txt","r");
						$countline=0;
						while (!feof($file4))
						{
							$lineBox=fgets($file4,1024);							
							if($countline==0){
								for($i=0;$i<$countLoop;$i++){
									$lineBox[$i]=$lineBox[$i];
								}
							}
							else if($countline==1){
								for($i=0;$i<$countLoop;$i++){
									$lineBox2[$i]=$lineBox[$i];
								}
							}
							else if($countline==2) {
								for($i=0;$i<$countLoop;$i++){
									$lineBox3[$i]=$lineBox[$i];
								}
							}
							$countline++;
						}
						$index=0;
						for($i=0;$i<$numAccBox;$i++){
							list($accBox[$i]) = $lineBox2[$index];
							list($priBox[$i]) = $lineBox3[$index];
							$index=$index+2;							
						}
					}
//SAVE button or 'No event' -------------------------------------------------------------------------------------------- //
					else{										
//W		NAS ------------------------------------------------------------------------------------------------------------ //
						if (isset($_POST["nas1"])){
							$allNas = array();
							$file1=fopen("/home/hadoop/TESAPI/TESTSCRIPT/active_Nas.txt","w");
							$countLoop = $_POST['numAccSaveNas'];

			  				for($i=1;$i<=$countLoop;$i++){
								fputs($file1,"N".$i." ");			
							}
			  				fputs($file1,"\r\n");
			  				for($i=1;$i<=$countLoop;$i++){
								$allNas[$i] = $_POST["nas".$i]." ";
								fputs($file1,$allNas[$i]);		
							}
			  				fclose($file1);
						}
//W		Dropbox -------------------------------------------------------------------------------------------------------- //
						if (isset($_POST["drop1"])){
							$allDropbox = array();
							$file2=fopen("/home/hadoop/TESAPI/TESTSCRIPT/active_Dropbox.txt","w")or die("Unable to open file!");
							$countLoop = $_POST['numAccSaveDB'];
							
							for($i=1;$i<=$countLoop;$i++){
								fputs($file2,"D".$i." ");			
							}
			  				fputs($file2,"\r\n");
			  				for($i=1;$i<=$countLoop;$i++){
								$allDropbox[$i] = $_POST["drop".$i]." ";
								fputs($file2,$allDropbox[$i]);		
							}
			  				fputs($file2,"\r\n");
			  				for($i=1;$i<=$countLoop;$i++){
								$priorityDropbox[$i] = $_POST["pri_drop".$i]." ";
								fputs($file2,$priorityDropbox[$i]);		
							}
			  				fclose($file2);
						}
//W		Google Drive --------------------------------------------------------------------------------------------------- //
						if (isset($_POST["google1"])){
							$allGoogleDrive = array();
							$file3=fopen("/home/hadoop/TESAPI/TESTSCRIPT/active_GoogleDrive.txt","w");
							$countLoop = $_POST['numAccSaveGG'];

			  				for($i=1;$i<=$countLoop;$i++){
								fputs($file3,"G".$i." ");			
							}
			  				fputs($file3,"\r\n");
			  				for($i=1;$i<=$countLoop;$i++){
								$allGoogleDrive[$i] = $_POST["google".$i]." ";
								fputs($file3,$allGoogleDrive[$i]);		
							}
			  				fputs($file3,"\r\n");
			  				for($i=1;$i<=$countLoop;$i++){
								$priorityGoogleDrive[$i] = $_POST["pri_google".$i]." ";
								fputs($file3,$priorityGoogleDrive[$i]);		
							}
			  				fclose($file3);
						} 
//W		Box ------------------------------------------------------------------------------------------------------------ //
						if (isset($_POST["box1"])){
							$allBox = array();
							$file4=fopen("/home/hadoop/TESAPI/TESTSCRIPT/active_Box.txt","w");
							$countLoop = $_POST['numAccSaveBox'];

			  				for($i=1;$i<=$countLoop;$i++){
								fputs($file4,"B".$i." ");			
							}
			  				fputs($file4,"\r\n");
			  				for($i=1;$i<=$countLoop;$i++){
								$allBox[$i] = $_POST["box".$i]." ";
								fputs($file4,$allBox[$i]);		
							}
			  				fputs($file4,"\r\n");
			  				for($i=1;$i<=$countLoop;$i++){
								$priorityBox[$i] = $_POST["pri_box".$i]." ";
								fputs($file4,$priorityBox[$i]);		
							}
			  				fclose($file4);
						} 
//Read	NAS ------------------------------------------------------------------------------------------------------------ //
						$file1 = fopen("/home/hadoop/TESAPI/TESTSCRIPT/active_Nas.txt","r");
						$lineNas = fgets($file1,1024);
						$numAccNas = str_word_count($lineNas);
						$countLoop = 2*$numAccNas-1;
						$_SESSION["numAccSaveNas"] = $numAccNas;

						$file1 = fopen("/home/hadoop/TESAPI/TESTSCRIPT/active_Nas.txt","r");
						$countline=0;
						while (!feof($file1))
						{
							$lineNas=fgets($file1,1024);
							if($countline==0){
								for($i=0;$i<$countLoop;$i++){
									$lineNas[$i]=$lineNas[$i];
								}
							}
							else if($countline==1){
								for($i=0;$i<$countLoop;$i++){
									$lineNas2[$i]=$lineNas[$i];
								}
							}
							$countline++;
						}
						$index=0;
						for($i=0;$i<$numAccNas;$i++){
							list($accNas[$i]) = $lineNas2[$index];
							$index=$index+2;
						}
//Read	Dropbox -------------------------------------------------------------------------------------------------------- //
						$file2 = fopen("/home/hadoop/TESAPI/TESTSCRIPT/active_Dropbox.txt","r");	
						$lineDB = fgets($file2,1024);
						$numAccDB = str_word_count($lineDB);
						$countLoop = 2*$numAccDB-1;
						$_SESSION["numAccSaveDB"] = $numAccDB;
						
						$file2 = fopen("/home/hadoop/TESAPI/TESTSCRIPT/active_Dropbox.txt","r");
						$countline = 0;
						while (!feof($file2))
						{
							$lineDB=fgets($file2,1024);
							if($countline==0){
								for($i=0;$i<$countLoop;$i++){
									$lineDB[$i]=$lineDB[$i];
								}
							}
							else if($countline==1){
								for($i=0;$i<$countLoop;$i++){
									$lineDB2[$i]=$lineDB[$i];
								}
							}
							else if($countline==2) {
								for($i=0;$i<$countLoop;$i++){
									$lineDB3[$i]=$lineDB[$i];
								}
							}
							$countline++;
						}
						$index=0;
						for($i=0;$i<$numAccDB;$i++){
							list($accDB[$i]) = $lineDB2[$index];
							list($priDB[$i]) = $lineDB3[$index];
							$index=$index+2;
						}
//Read	Google Drive --------------------------------------------------------------------------------------------------- //
						$file3 = fopen("/home/hadoop/TESAPI/TESTSCRIPT/active_GoogleDrive.txt","r");
						$lineGG = fgets($file3,1024);
						$numAccGG = str_word_count($lineGG);
						$countLoop = 2*$numAccGG-1;
						$_SESSION["numAccSaveGG"] = $numAccGG;

						$file3 = fopen("/home/hadoop/TESAPI/TESTSCRIPT/active_GoogleDrive.txt","r");
						$countline=0;
						while (!feof($file3))
						{
							$lineGG=fgets($file3,1024);
							if($countline==0){
								for($i=0;$i<$countLoop;$i++){
									$lineGG[$i]=$lineGG[$i];
								}
							}
							else if($countline==1){
								for($i=0;$i<$countLoop;$i++){
									$lineGG2[$i]=$lineGG[$i];
								}
							}
							else if($countline==2) {
								for($i=0;$i<$countLoop;$i++){
									$lineGG3[$i]=$lineGG[$i];
								}
							}
							$countline++;
						}
						$index=0;
						for($i=0;$i<$numAccGG;$i++){
							list($accGG[$i]) = $lineGG2[$index];
							list($priGG[$i]) = $lineGG3[$index];
							$index=$index+2;
						}
//Read	Box ------------------------------------------------------------------------------------------------------------ //
						$file4 = fopen("/home/hadoop/TESAPI/TESTSCRIPT/active_Box.txt","r");
						$lineBox = fgets($file4,1024);
						$numAccBox = str_word_count($lineBox);
						$countLoop = 2*$numAccBox-1;
						$_SESSION["numAccSaveBox"] = $numAccBox;

						$file4 = fopen("/home/hadoop/TESAPI/TESTSCRIPT/active_Box.txt","r");
						$countline=0;
						while (!feof($file4))
						{
							$lineBox=fgets($file4,1024);							
							if($countline==0){
								for($i=0;$i<$countLoop;$i++){
									$lineBox[$i]=$lineBox[$i];
								}
							}
							else if($countline==1){
								for($i=0;$i<$countLoop;$i++){
									$lineBox2[$i]=$lineBox[$i];
								}
							}
							else if($countline==2) {
								for($i=0;$i<$countLoop;$i++){
									$lineBox3[$i]=$lineBox[$i];
								}
							}
							$countline++;
						}
						$index=0;
						for($i=0;$i<$numAccBox;$i++){
							list($accBox[$i]) = $lineBox2[$index];
							list($priBox[$i]) = $lineBox3[$index];
							$index=$index+2;							
						}											
					}
?>
<!-- ________________________________________________________________HTML Storage______________________________________________________________ -->
<!-- __________________________________________________________________________________________________________________________________________ -->
					<div id="storage" style="clear:both; padding-bottom:620px">
					<form action=activeStorage.php method=post>
<!-- NAS ______________________________________________________________________________________________________________________________________ -->
						<h2>Nas</h2>
						<div style="clear:both; padding-left:50px">
							<div class="btn-group" style="margin-left:0">
								<input type="button" id="btn_add1" name="btn_add1" value="ADD" class="btn btn-default" aria-expanded="false" 
								style="width:53px; height:29px; font-size:13px; font-weight:500">
							</div>
							<!-- <button type="button" id="btn_add1" name="btn_add1">ADD</button> -->
							<table id="setTable1" border="0">
<?php 						for($i=0;$i<$numAccNas;$i++){ 
?>					
								<tr>
									<th style="padding-right:17px">Nas <?php echo $i+1; ?>: </th> 
									<th> <input type="text" id="nas<?php echo $i+1; ?>" name="nas<?php echo $i+1; ?>" maxlength="1" size="8" value=<?php echo $accNas[$i]; ?> ></th>
									<td> 1=On, 0=Off </td>
									<!-- <td> <a id="nasdel<?php echo $i+1; ?>" name="nasdel<?php echo $i+1; ?>" href="#" onclick="selectNAS(<?php echo $i+1;?>);return false;"> <img width="15px" height="15px" style="margin-left: 10px;" src="images/cross.png"> </a> </td>  -->
								</tr>
<?php 						//echo $accNas[$i];
							} 
?>				
							</table>
							<div id="addRow1" style="margin-left:0">
							</div>
						</div>
<!-- Dropbox __________________________________________________________________________________________________________________________________ -->
						<h2>Dropbox</h2>
						<div style="clear:both; padding-left:50px">
							<div class="btn-group" style="margin-left:0">
								<input type="button" id="btn_add2" name="btn_add2" value="ADD" class="btn btn-default" aria-expanded="false" 
								style="width:53px; height:29px; font-size:13px; font-weight:500">
							</div>
							<!-- <button type="button" id="btn_add2" name="btn_add2">ADD</button> -->
							<table id="setTable2" border="0">
<?php 						for($i=0;$i<$numAccDB;$i++){ 
?>
								<tr>
									<th>Cloud <?php echo $i+1; ?>: </th> 
									<th> <input type="text" id="drop<?php echo $i+1; ?>" name="drop<?php echo $i+1; ?>" onchange="textboxOnchange('#drop<?php echo $i+1; ?>','#pri_drop<?php echo $i+1; ?>')" maxlength="1" size="8" value=<?php echo $accDB[$i]; ?> ></th>
									<td> 1=On, 0=Off</td> 
									<th style="padding-left:70px">Set Priority:</th> 
									<th> <input type="text" id="pri_drop<?php echo $i+1; ?>" name="pri_drop<?php echo $i+1; ?>" maxlength="1" size="8" value=<?php echo $priDB[$i]; ?> ></th>
									<!-- <td> <a href="#"><img width="15px" height="15px" style="margin-left: 10px;" src="images/cross.png"> </a> </td> -->
								</tr>						
<?php 						//echo $accDB[$i]; echo $priDB[$i];
							} 
?>					
							</table>
							<div id="addRow2" style="margin-left:0">
							</div>
						</div>
<!-- Google Drive _____________________________________________________________________________________________________________________________ -->
						<h2>Google Drive</h2>
						<div style="clear:both; padding-left:50px">
							<div class="btn-group" style="margin-left:0">
								<input type="button" id="btn_add3" name="btn_add3" value="ADD" class="btn btn-default" aria-expanded="false" 
								style="width:53px; height:29px; font-size:13px; font-weight:500">
							</div>
							<!-- <button type="button" id="btn_add3" name="btn_add3">ADD</button> -->
							<table id="setTable3" border="0">
<?php 						for($i=0;$i<$numAccGG;$i++){ 
?>
								<tr>
									<th>Cloud <?php echo $i+1; ?>: </th> 
									<th> <input type="text" id="google<?php echo $i+1; ?>" name="google<?php echo $i+1; ?>" onchange="textboxOnchange('#google<?php echo $i+1; ?>','#pri_google<?php echo $i+1; ?>')" maxlength="1" size="8" value=<?php echo $accGG[$i]; ?> ></th>
									<td> 1=On, 0=Off</td> 
									<th style="padding-left:70px">Set Priority:</th> 
									<th> <input type="text" id="pri_google<?php echo $i+1; ?>" name="pri_google<?php echo $i+1; ?>" maxlength="1" size="8" value=<?php echo $priGG[$i]; ?> ></th>
									<!-- <td> <a id="gdrivedel<?php echo $i+1; ?>" name="gdrivedel<?php echo $i+1; ?>" href="#" onclick="selectgdrive(<?php echo $i+1;?>);return false;"> <img width="15px" height="15px" style="margin-left: 10px;" src="images/cross.png"> </a> </td>  -->
								</tr>
<?php 						//echo $accGG[$i]; echo $priGG[$i];
							} 
?>
							</table>
							<div id="addRow3" style="margin-left:0">
							</div>
						</div>					
<!-- Box ______________________________________________________________________________________________________________________________________ -->
						<h2>Box</h2>
						<div style="clear:both; padding-left:50px">
							<div class="btn-group" style="margin-left:0">
								<input type="button" id="btn_add4" name="btn_add4" value="ADD" class="btn btn-default" aria-expanded="false" 
								style="width:53px; height:29px; font-size:13px; font-weight:500">
							</div>
							<!-- <button type="button" id="btn_add4" name="btn_add4">ADD</button> -->
							<table id="setTable4" border="0">
<?php 						for($i=0;$i<$numAccBox;$i++){ 
?>
								<tr>
									<th>Cloud <?php echo $i+1; ?>: </th> 
									<th> <input type="text" id="box<?php echo $i+1; ?>" name="box<?php echo $i+1; ?>" onchange="textboxOnchange('#box<?php echo $i+1; ?>','#pri_box<?php echo $i+1; ?>')" maxlength="1" size="8" value=<?php echo $accBox[$i]; ?> ></th>
									<td> 1=On, 0=Off</td> 
									<th style="padding-left:70px">Set Priority:</th> 
									<th> <input type="text" id="pri_box<?php echo $i+1; ?>" name="pri_box<?php echo $i+1; ?>" maxlength="1" size="8" value=<?php echo $priBox[$i]; ?> ></th>
									<!-- <td> <a href="#"><img width="15px" height="15px" style="margin-left: 10px;" src="images/cross.png"> </a> </td> -->
								</tr>
<?php 						//echo $accBox[$i]; echo $priBox[$i];
							} 
?>
							</table>
							<div id="addRow4" style="margin-left:0">
							</div>
						</div>
<!-- Save & Default ___________________________________________________________________________________________________________________________ -->
						<div id="button1" class="btn-group" style="clear:both; padding-top:30px; margin-right:0">
							<input type="submit" id="save" name="save" value="Save" class="btn btn-default" aria-expanded="false">
						</div>

						<div id="button2" class="btn-group" style="padding-top:30px">
							<input type="submit" name="default" value="Default" class="btn btn-default" aria-expanded="false">
						</div>
<!-- Hidden field: for counting "Cloud" _______________________________________________________________________________________________________ -->
						<input type="hidden" name="numAccSaveNas" id="numAccSaveNas" value="<?php echo $_SESSION["numAccSaveNas"] ?>">
						<input type="hidden" name="numAccSaveDB" id="numAccSaveDB" value="<?php echo $_SESSION["numAccSaveDB"] ?>">
						<input type="hidden" name="numAccSaveGG" id="numAccSaveGG" value="<?php echo $_SESSION["numAccSaveGG"] ?>">
						<input type="hidden" name="numAccSaveBox" id="numAccSaveBox" value="<?php echo $_SESSION["numAccSaveBox"] ?>">

					</form>
					</div>

				</div>
			</div>
		</div>
	</div>
</body>
</html>
