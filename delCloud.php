<?php
	$count1 = $_POST['count1'];
	$count3 = $_POST['count3'];
	$cloud = $_POST['cloud'];
	$id = $_POST['id'];
		
?>
	<?php
		if ($cloud=='NAS'){
			echo "count1= ".$count1." ".$cloud." ".$id; 
	?>

	<?php
		}
		else if ($cloud=='gdrive'){
			echo "count3= ".$count3." ".$cloud." ".$id; 
	?>

	<?php
		}		
	?>