<?php
include("functions.php");
require '../vnstat/config.php';
require '../vnstat/localize.php';
require '../vnstat/vnstat.php';
validate_input();
require "../vnstat/themes/$style/theme.php";

if (!is_authed()) 
{
     die ('<h1>Access Denied!!</h1>');
}

function kbytes_to_string($kb)
{
    $units = array('TB','GB','MB','KB');
    $scale = 1024*1024*1024;
    $ui = 0;

    while (($kb < $scale) && ($scale > 1))
    {
        $ui++;
        $scale = $scale / 1024;
    }   
    return sprintf("%0.2f %s", ($kb/$scale),$units[$ui]);
}
function write_data_table($caption, $tab)
    {
	$max_rx=0;
	$min_rx=99999999;
	$sum_rx=0;
	$count_rx=0;
	$max_tx=0;
    $min_tx=99999999;
    $sum_tx=0;
    $count_tx=0;
        
        for ($i=0; $i<count($tab); $i++)
        {
        	$id = ($i & 1) ? 'odd' : 'even';
            if ($tab[$i]['act'] == 1)
            {
                $t[$i] = $tab[$i]['label'];
				$rx2 = $tab[$i]['rx'];					
                $rx[$i] = kbytes_to_string($tab[$i]['rx']);
				if($rx2 !=0 ){
					$count_rx++;
					$sum_rx+=$rx2;
				}
				if($rx2 > $max_rx){
					$max_rx = $rx2;
				}
				if($rx2 < $min_rx && $rx2 !=0 ){
					$min_rx = $rx2;					
				}
				$tx2 = $tab[$i]['tx'];
	            $tx[$i] = kbytes_to_string($tab[$i]['tx']);
				if($tx2 !=0 ){
	                $count_tx++;
	                $sum_tx+=$tx2;
	            }
	            if($tx2 > $max_tx){
	                $max_tx = $tx2;
	            }
	            if($tx2 < $min_tx && $tx2 !=0 ){
	                $min_tx = $tx2;
	            }
	            $total[$i] = kbytes_to_string($tab[$i]['rx']+$tab[$i]['tx']);                	            
            }
        }
        
		$avg_rx = $sum_rx/$count_rx;
		$avg_tx = $sum_tx/$count_tx;
		$min_rx = kbytes_to_string($min_rx);
		$max_rx = kbytes_to_string($max_rx);
		$avg_rx = kbytes_to_string($avg_rx);
		$min_tx = kbytes_to_string($min_tx);
	    $max_tx = kbytes_to_string($max_tx);
	    $avg_tx = kbytes_to_string($avg_tx);
	
		print "<div id=\"sum\">";	
		print "<table class=\"table table-bordered\" width=\"100%\" cellspacing=\"0\">\n";
        print "<h2>Summary</h2>\n";
        print "<tr class=\"active\">";
        print "<th class=\"\" style=\"width:120px;\">&nbsp;</th>";
        print "<th style=\"text-align: center\" class=\"\">".T('Min')."</th>";
        print "<th style=\"text-align: center\" class=\"\">".T('Max')."</th>";
        print "<th style=\"text-align: center\" class=\"\">".T('Avg')."</th>";
        print "</tr>\n";

		print "<tr>";
        print "<td style=\"text-align: center\" class=\"\">IN</td>";
        print "<td style=\"text-align: right\" class=\"\">$min_rx</td>";
        print "<td style=\"text-align: right\" class=\"\">$max_rx</td>";
        print "<td style=\"text-align: right\" class=\"\">$avg_rx</td>";
        print "</tr>\n";
		print "<tr>";
        print "<td style=\"text-align: center\" class=\"\">OUT</td>";
        print "<td style=\"text-align: right\" class=\"\">$min_tx</td>";
        print "<td style=\"text-align: right\" class=\"\">$max_tx</td>";
        print "<td style=\"text-align: right\" class=\"\">$avg_tx</td>";
        print "</tr>\n";
		print "</table>\n";
		print "</div>\n";

		print "<div id=\"Last24\">";
        print "<table class=\"table table-bordered\" width=\"100%\" cellspacing=\"0\">\n";
        print "<h2>$caption</h2>\n";
        print "<tr class=\"active\">";
        print "<th class=\"\" style=\"width:120px;\">&nbsp;</th>";
        print "<th style=\"text-align: center\" class=\"\">".T('In')."</th>";
        print "<th style=\"text-align: center\"class=\"\">".T('Out')."</th>";
        print "<th style=\"text-align: center\"class=\"\">".T('Total')."</th>";  
        print "</tr>\n";
        print "<tr>";
        for ($i=0; $i<count($tab); $i++)
        {
        	if ($tab[$i]['act'] == 1)
            {
            	print "<td style=\"text-align: center\" class=\"\">$t[$i]</td>";
			    print "<td style=\"text-align: right\" class=\"\">$rx[$i]</td>";
			    print "<td style=\"text-align: right\" class=\"\">$tx[$i]</td>";
			    print "<td style=\"text-align: right\" class=\"\">$total[$i]</td>";
			    print "</tr>\n";
            }	    
		}
	    print "</table>\n";
		print "</div>\n";
    }

    get_vnstat_data();

    //
    // html start
    //
    header('Content-type: text/html; charset=utf-8');
    print '<?xml version="1.0"?>';



?>
<!DOCTYPE html>
<!-- Website template by freewebsitetemplates.com -->
<html>
<head>
	<meta charset="UTF-8">
	<title>Admin module</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
	<link rel="stylesheet" href="css/style.css" type="text/css">
	<style>

	</style>	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
</head>
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
					<li>
						<a href="setup.php">Setup</a>
					</li>
					<li>
						<a href="tpi.php">Third Party Storage</a>
					</li>
					<li>
						<a href="nas.php">Network Attached Storage</a>
					</li>
					<li class="selected">
						<a href="monitor.php">Monitoring System</a>
					</li>
				</ul>
				<form action="index.php">
				</form>
				<div class="connect">
					<a href="#" id="facebook">facebook</a> <a href="#" id="twitter">twitter</a> <a href="#" id="googleplus">youtube</a>
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
				<div class="services" style="padding-bottom:86px">
					
					<ul class="navigation">
					   <li>
					      <a href="monitor.php">Alive</a>
					   </li>
					   <li>
					      <a href="usespace.php">Use Space</a>
					   </li>
					   <li class="selected">
					      <a href="#">Bandwidth</a>
					   </li>
					</ul>
					<h2 style="text-align:center;clear: both;">Bandwidth</h2>
					<?php
						$graph_params = "if=eth0&graph=large&style=light&page=h";				    
				        if ($graph_format == 'svg') {
					     print "<object type=\"image/svg+xml\" style=\"margin:8px\"width=\"692\" height=\"297\" data=\"../vnstat/graph_svg.php?$graph_params\"></object>\n";
				        } else {
					     print "<img src=\"../vnstat/graph.php?$graph_params\" alt=\"graph\"/>\n";	
				        }
					    write_data_table(T('Last 24 hours'), $hour);
					// echo "<div id=\"storage\" style=\"clear:both\">";
					// echo "<form action=bandwidth.php method=post>";
					// echo "<h2 style=\"text-align:center\">Bandwidth</h2>";
					// 	echo "<div style=\"padding-top:30px; text-align:center; clear:both\">";						
					// 		echo "<img src=\"images/MockupBandwidth.PNG\">";
					// 	echo "</div>";
					// 	echo "<div style=\"padding-top:30px; padding-left:37px; text-align:center;clear:both\">";
					// 		echo "<img src=\"images/MockupBandwidth2.PNG\">";
					// 	echo "</div>";
					// echo "</form>";
					// echo "</div>";
					?>
			</div>
		</div>
	</div>
</body>
</html>
