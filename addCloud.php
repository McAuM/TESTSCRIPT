<?php
	$count1 = $_POST['count1'];
	$count2 = $_POST['count2'];
	$count3 = $_POST['count3'];
	$count4 = $_POST['count4'];
	$addNas = $_POST['addNas'];
	$addDB = $_POST['addDB'];
	$addGG = $_POST['addGG'];
	$addBox = $_POST['addBox'];
?>

<!-- NAS _________________________________________________________________________________________________________________________________ -->
		<table id="setTable1" border="0">
		<?php 	for($i=0;$i<$count1;$i++){
		?>
					<tr>
						<th style="padding-right:17px">Nas <?php echo $i+$addNas; ?>: </th> 
						<th> <input type="text" id="nas<?php echo $i+$addNas; ?>" name="nas<?php echo $i+$addNas; ?>" maxlength="1" size="8" ></th>
						<td> 1=On, 0=Off</td>
					</tr>
		<?php 	}
		?>
		</table>
<!-- Dropbox _____________________________________________________________________________________________________________________________ -->
		<table id="setTable2" border="0">
		<?php 	for($i=0;$i<$count2;$i++){
		?>

					<tr>
						<th>Cloud <?php echo $i+$addDB; ?>:</th> 
						<th> <input type="text" id="drop<?php echo $i+$addDB; ?>" name="drop<?php echo $i+$addDB; ?>" onchange="textboxOnchange('#drop<?php echo $i+$addDB; ?>','#pri_drop<?php echo $i+$addDB; ?>')" maxlength="1" size="8" ></th>
						<td> 1=On, 0=Off</td> 
						<th style="padding-left:70px">Set Priority:</th> 
						<th> <input type="text" id="pri_drop<?php echo $i+$addDB; ?>" name="pri_drop<?php echo $i+$addDB; ?>" maxlength="1" size="8"></th>
					</tr>
		<?php 	}
		?>
		</table>
<!-- Google Drive ________________________________________________________________________________________________________________________ -->
		<table id="setTable3" border="0">
		<?php 	for($i=0;$i<$count3;$i++){ 
		?>
					<tr>
						<th>Cloud <?php echo $i+$addGG; ?>: </th> 
						<th> <input type="text" id="google<?php echo $i+$addGG; ?>" name="google<?php echo $i+$addGG; ?>" onchange="textboxOnchange('#google<?php echo $i+$addGG; ?>','#pri_google<?php echo $i+$addGG; ?>')" maxlength="1" size="8" ></th>
						<td> 1=On, 0=Off</td> 
						<th style="padding-left:70px">Set Priority:</th> 
						<th> <input type="text" id="pri_google<?php echo $i+$addGG; ?>" name="pri_google<?php echo $i+$addGG; ?>" maxlength="1" size="8" ></th>
					</tr>
		<?php 		} 
		?>
		</table>
<!-- Box _________________________________________________________________________________________________________________________________ -->
		<table id="setTable4" border="0">
		<?php 	for($i=0;$i<$count4;$i++){ 
		?>
					<tr>
						<th>Cloud <?php echo $i+$addBox; ?>: </th> 
						<th> <input type="text" id="box<?php echo $i+$addBox; ?>" name="box<?php echo $i+$addBox; ?>" onchange="textboxOnchange('#box<?php echo $i+$addBox; ?>','#pri_box<?php echo $i+$addBox; ?>')" maxlength="1" size="8" ></th>
						<td> 1=On, 0=Off</td> 
						<th style="padding-left:70px">Set Priority:</th> 
						<th> <input type="text" id="pri_box<?php echo $i+$addBox; ?>" name="pri_box<?php echo $i+$addBox; ?>" maxlength="1" size="8" ></th>
					</tr>
		<?php 		} 
		?>
		</table>