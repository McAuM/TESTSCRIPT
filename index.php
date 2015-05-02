<?php
    //
    // vnStat PHP frontend (c)2006-2010 Bjorge Dijkstra (bjd@jooz.net)
    //
    // This program is free software; you can redistribute it and/or modify
    // it under the terms of the GNU General Public License as published by
    // the Free Software Foundation; either version 2 of the License, or
    // (at your option) any later version.
    //
    // This program is distributed in the hope that it will be useful,
    // but WITHOUT ANY WARRANTY; without even the implied warranty of
    // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    // GNU General Public License for more details.
    //
    // You should have received a copy of the GNU General Public License
    // along with this program; if not, write to the Free Software
    // Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
    //
    //
    // see file COPYING or at http://www.gnu.org/licenses/gpl.html 
    // for more information.
    //
    require 'config.php';
    require 'localize.php';
    require 'vnstat.php';

    validate_input();

    require "./themes/$style/theme.php";

    function write_side_bar()
    {
        global $iface, $page, $graph, $script, $style;
        global $iface_list, $iface_title;   
        global $page_list, $page_title;
        
        $p = "&amp;graph=$graph&amp;style=$style";

        print "<ul class=\"iface\">\n";
        foreach ($iface_list as $if)
        {
            print "<li class=\"iface\">";
            if (isset($iface_title[$if]))
            {
                print $iface_title[$if];
            }
            else
            {
                print $if;
            }
            print "<ul class=\"page\">\n";
            foreach ($page_list as $pg)
            {
                print "<li class=\"page\"><a href=\"$script?if=$if$p&amp;page=$pg\">".$page_title[$pg]."</a></li>\n";
            }
            print "</ul></li>\n";
	    
        }
        print "</ul>\n"; 
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
 
    function write_summary($p)
    {
        global $summary,$top,$day,$hour,$month;

        $trx = $summary['totalrx']*1024+$summary['totalrxk'];
        $ttx = $summary['totaltx']*1024+$summary['totaltxk'];

        //
        // build array for write_data_table
        //
        $sum[0]['act'] = 1;
        $sum[0]['label'] = T('This hour');
        $sum[0]['rx'] = $hour[0]['rx'];
        $sum[0]['tx'] = $hour[0]['tx'];

        $sum[1]['act'] = 1;
        $sum[1]['label'] = T('This day');
        $sum[1]['rx'] = $day[0]['rx'];
        $sum[1]['tx'] = $day[0]['tx'];

        $sum[2]['act'] = 1;
        $sum[2]['label'] = T('This month');
        $sum[2]['rx'] = $month[0]['rx'];
        $sum[2]['tx'] = $month[0]['tx'];

        $sum[3]['act'] = 1;
        $sum[3]['label'] = T('All time');
        $sum[3]['rx'] = $trx;
        $sum[3]['tx'] = $ttx;

        write_data_table(T('Summary'), $sum,$p);
        print "<br/>\n";
        write_data_table(T('Top 10 days'), $top,$p);
    }
    
    
    function write_data_table($caption, $tab,$p)
    {
	$max_rx=0;
	$min_rx=99999999;
	$sum_rx=0;
	$count_rx=0;

	$max_tx=0;
        $min_tx=99999999;
        $sum_tx=0;
        $count_tx=0;

        print "<table width=\"100%\" cellspacing=\"0\">\n";
        print "<caption>$caption</caption>\n";
        print "<tr>";
        print "<th class=\"label\" style=\"width:120px;\">&nbsp;</th>";
        print "<th class=\"label\">".T('In')."</th>";
        print "<th class=\"label\">".T('Out')."</th>";
        print "<th class=\"label\">".T('Total')."</th>";  
        print "</tr>\n";

        for ($i=0; $i<count($tab); $i++)
        {
            if ($tab[$i]['act'] == 1)
            {
                $t = $tab[$i]['label'];
		$rx2 = $tab[$i]['rx'];					
                $rx = kbytes_to_string($tab[$i]['rx']);
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
                $tx = kbytes_to_string($tab[$i]['tx']);
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
                $total = kbytes_to_string($tab[$i]['rx']+$tab[$i]['tx']);
                $id = ($i & 1) ? 'odd' : 'even';
                print "<tr>";
                print "<td class=\"label_$id\">$t</td>";
                print "<td class=\"numeric_$id\">$rx</td>";
                print "<td class=\"numeric_$id\">$tx</td>";
                print "<td class=\"numeric_$id\">$total</td>";
                print "</tr>\n";
             }
        }
        print "</table>\n";
	if ($p != 's'){
	$avg_rx = $sum_rx/$count_rx;
	$avg_tx = $sum_tx/$count_tx;
	$min_rx = kbytes_to_string($min_rx);
	$max_rx = kbytes_to_string($max_rx);
	$avg_rx = kbytes_to_string($avg_rx);
	$min_tx = kbytes_to_string($min_tx);
        $max_tx = kbytes_to_string($max_tx);
        $avg_tx = kbytes_to_string($avg_tx);
	
	print "<table width=\"100%\" cellspacing=\"0\">\n";
        print "<caption>Summary</caption>\n";
        print "<tr>";
        print "<th class=\"label\" style=\"width:120px;\">&nbsp;</th>";
        print "<th class=\"label\">".T('Min')."</th>";
        print "<th class=\"label\">".T('Max')."</th>";
        print "<th class=\"label\">".T('Avg')."</th>";
        print "</tr>\n";

	print "<tr>";
        print "<td class=\"label_even\">IN</td>";
        print "<td class=\"numeric_even\">$min_rx</td>";
        print "<td class=\"numeric_even\">$max_rx</td>";
        print "<td class=\"numeric_even\">$avg_rx</td>";
        print "</tr>\n";
	print "<tr>";
        print "<td class=\"label_odd\">OUT</td>";
        print "<td class=\"numeric_odd\">$min_tx</td>";
        print "<td class=\"numeric_odd\">$max_tx</td>";
        print "<td class=\"numeric_odd\">$avg_tx</td>";
        print "</tr>\n";
	print "</table>\n";
	}
    }

    get_vnstat_data();

    //
    // html start
    //
    header('Content-type: text/html; charset=utf-8');
    print '<?xml version="1.0"?>';
?>        
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <title>vnStat - PHP frontend</title>
  <link rel="stylesheet" type="text/css" href="themes/<?php echo $style ?>/style.css"/>
</head>
<body>

<div id="wrap">
  <div id="sidebar"><?php write_side_bar(); ?></div>
   <div id="content">
    <div id="header"><?php print T('Traffic data for')." $iface_title[$iface] ($iface)";?></div>
    <div id="main">
    <?php
    $graph_params = "if=$iface&amp;page=$page&amp;style=$style";
    if ($page != 's')
        if ($graph_format == 'svg') {
	     print "<object type=\"image/svg+xml\" width=\"692\" height=\"297\" data=\"graph_svg.php?$graph_params\"></object>\n";
        } else {
	     print "<img src=\"graph.php?$graph_params\" alt=\"graph\"/>\n";	
        }

    if ($page == 's')
    {
        write_summary($page);
    }
    else if ($page == 'h')
    {   
        write_data_table(T('Last 24 hours'), $hour,$page); 
    }
    else if ($page == 'd')
    {
        write_data_table(T('Last 30 days'), $day,$page);	
    }
    else if ($page == 'm')
    {
        write_data_table(T('Last 12 months'), $month,$page);   
    }
    ?>
    </div>
    <div id="footer"><a href="http://www.sqweek.com/">vnStat PHP frontend</a> 1.5.1 - &copy;2006-2010 Bjorge Dijkstra (bjd _at_ jooz.net)</div>
  </div>
</div>

</body></html>
