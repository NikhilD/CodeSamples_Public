
set MESSAGE_PORT 42
set BROADCAST_ADDR -1

if { $argc != 5 } {
    puts "Wrong no. of cmdline args."
	puts "Correct Usage: ns <filename.tcl> <Canvas> <Number of nodes> <PLE> <Sigma> <Expt. Number>"
    exit 0
} else {
	set nodeVal [lindex $argv 1]
	set canvas [lindex $argv 0]
	set reportNum [lindex $argv 4]
	set ple	[lindex $argv 2]
	set sigma [lindex $argv 3]
}

# variables which control the number of nodes and how they're grouped
# (see topology creation code below)
set group_size 1	
set num_groups 	$nodeVal
set num_nodes [expr $group_size * $num_groups]


set addArr {}
for {set k 0} {$k < 110} {incr k} {
	lappend addArr 0
}
set fpart1 "report"
set fpart2 $num_nodes
set fpart3 $reportNum	
set fpart4 $ple
set fpart5 $sigma
set filename "$fpart1$fpart2-$fpart4-$fpart5-$fpart3"
#puts "filename: $filename"
set outfile [open $filename.txt w]
puts $outfile "$addArr"


set TxP 5.0e-04			;# (~ -3 dBm)
set M_PI 3.14159265359
set Fr 2.45e+09	
set lambda [expr double(3.0e+08/$Fr)]
set Gt 1.0
set Gr 1.0
set ht 1.5
set hr 1.5
set PtGtGr [expr double($TxP*$Gt*$Gr)]
set PtGtGrhr2ht2 [expr double($PtGtGr*pow($hr,2)*pow($ht,2))]
set CoD [expr double((4*$M_PI*$ht*$hr)/$lambda)]
set M_fact [expr double($lambda/(4*$M_PI))]

set rssMax 1.0
set rssMin 0.0
set rssiMax1 1.89898e-09  ;# (~ -57dBm), 5m limit set by Friis model, with ref distance of 1m
set rssiMin1 4.74745e-12  ;# (~ -83dBm), Tx Range of 100m, for Pt=0.5mW

set rssiMax [expr 10*(log10($rssiMax1*1000))]
set rssiMin [expr 10*(log10($rssiMin1*1000))]
set denom [expr ($rssiMax-$rssiMin)]

set pathlossExp $ple
set std_db $sigma
set dist0 20.0
set normalRV [new RNG]
$normalRV next-substream


# Physical Channel Settings
Phy/WirelessPhy set CSThresh_       $rssiMin1		;# Carrier Sense Threshold is about 50m more than the Tr. Range
Phy/WirelessPhy set Pt_             $TxP
Phy/WirelessPhy set freq_           $Fr
Antenna/OmniAntenna set Gt_             $Gt
Antenna/OmniAntenna set Gr_           	$Gt
Phy/WirelessPhy set ht_             $ht
Phy/WirelessPhy set hr_           	$hr
Phy/WirelessPhy set L_              1.0
Phy/WirelessPhy set bandwidth_      20e6
Phy/WirelessPhy set CPThresh_       10.0
Phy/WirelessPhy set RXThresh_ 		$rssiMin1

#MAC Layer Settings
set macLayer	802_11								;# Simple OR 802_11
Mac/$macLayer set bandwidth_ 11Mb
Mac/802_11 set CWMin_               15
Mac/802_11 set CWMax_               15
Mac/802_11 set SlotTime_            0.000009
Mac/802_11 set SIFS_                0.000016
Mac/802_11 set ShortRetryLimit_     7
Mac/802_11 set LongRetryLimit_      4
Mac/802_11 set PreambleLength_      60
Mac/802_11 set PLCPHeaderLength_    60
Mac/802_11 set PLCPDataRate_        6.0e6
Mac/802_11 set RTSThreshold_        20000
Mac/802_11 set basicRate_           1Mb
Mac/802_11 set dataRate_            11Mb

set val(chan)           Channel/WirelessChannel    ;#Channel Type
set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/$macLayer              ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq

set goodProp [new Propagation/Shadowing]
$goodProp set pathlossExp_ $pathlossExp
$goodProp set std_db_ $std_db
$goodProp set dist0_ $dist0
$goodProp seed predef 0

set badProp	[new Propagation/Shadowing]
$badProp set pathlossExp_ 3.0
$badProp set std_db_ 5.0
$badProp set dist0_ 1.0
$badProp seed predef 1

set val(prop)   Propagation/Shadowing   ;# radio-propagation model
# add previously defined models
$val(prop) add-models $goodProp $badProp

#$val(prop) set pathlossExp_ $pathlossExp
#$val(prop) set std_db_ $std_db
#$val(prop) set dist0_ 1.0
#$val(prop) seed predef 0

# DumbAgent, AODV, and DSDV work.  DSR is broken
set val(rp) DumbAgent
#set val(rp)             DSDV
#set val(rp)             DSR
#set val(rp)		 AODV


# size of the topography
set val(x)          $canvas
set val(y)          $canvas


set ns [new Simulator]

#set f [open wireless-flooding-$val(rp).tr w]
set f [open $filename.tr w]
$ns trace-all $f
set nf [open shadowing.nam w]
$ns namtrace-all-wireless $nf $val(x) $val(y)

$ns use-newtrace

# set up topography object
set topo       [new Topography]

$topo load_flatgrid $val(x) $val(y)

#
# Create God
#
create-god $num_nodes



set chan_1_ [new $val(chan)]

$ns node-config -adhocRouting $val(rp) \
                -llType $val(ll) \
                -macType $val(mac) \
                -ifqType $val(ifq) \
                -ifqLen $val(ifqlen) \
                -antType $val(ant) \
                -propType $val(prop) \
                -phyType $val(netif) \
                -topoInstance $topo \
                -agentTrace ON \
                -routerTrace OFF \
                -macTrace ON \
                -movementTrace OFF \
                -channel $chan_1_ 


# subclass Agent/MessagePassing to make it do flooding

Class Agent/MessagePassing/Flooding -superclass Agent/MessagePassing

Agent/MessagePassing/Flooding instproc recv {source sport size data} {
    $self instvar messages_seen node_
	$self instvar old_data
	$self instvar pktCnt
	$self instvar hopCnt
	$self instvar pktData 	
    global ns BROADCAST_ADDR NX NY NZ hopCount pktCount nodeData rssiMin1

    # extract message ID from message
    set message_id [lindex [split $data ":"] 0]
	set hop_recd [lindex [split $data ":"] 1]
	set data_recd [lindex [split $data ":"] 2]
	set this_node [$node_ node-addr]
	set my_x $NX($this_node)
	set src_x $NX($source)
	set my_y $NY($this_node)
	set src_y $NY($source)
	set my_z $NZ($this_node)
	set src_z $NZ($source)	
	
	#puts "\n$this_node got msg $message_id AS $source:$hop_recd:$data_recd"
	set newHC [expr ($hop_recd + 1)]	
	if {double($newHC) < double($hopCnt)} {
		set hopCnt $newHC
		set hopCount($this_node) $hopCnt
	
		set dummydist [findDist $my_x $src_x $my_y $src_y $my_z $src_z]	; # Calc distance	
		set shdwRSS [shadowRSS $dummydist]
		if {double($shdwRSS) < double($rssiMin1)} {
			#puts "dropping pkt $source:$hop_recd:$data_recd"
			return
		}
		set dista [friisDist $shdwRSS]
		set new_data [expr ($data_recd + $dista)]
		#puts "\n1-hopD:$dista   newDistance:$new_data"	

		if {double($old_data) > double($new_data)} {
			#puts "\nNew Data Sent $new_data\n"
			$ns trace-annotate "$this_node received {$data} from $source"
			$ns trace-annotate "$this_node sending new message $message_id:$hopCnt:$new_data"
			set old_data $new_data
			set pktCnt [expr $pktCnt+1]
			if {($pktCnt)>($pktCount($this_node))} {
				set pktCount($this_node) $pktCnt
			}
			lappend pktData $new_data
			set nodeData($this_node) $new_data
			#puts "\nData:: $this_node:$source:$hopCnt:$pktCnt:$pktData"
			set jitter [expr int(300*rand())]; # Add random 'jitter' to make the Tx for each node an independent process
			sleep $jitter; # anywhere between '0' and '300' usec
			$self sendto $size "$message_id:$hopCnt:$new_data" $BROADCAST_ADDR $sport	
		} else {
			#puts "\nData-1:: $this_node redundant message from $source"			
			$ns trace-annotate "$this_node received redundant message {$data} from $source"
		}
	} else {
		#puts "\nData-2:: $this_node redundant message from $source"			
		$ns trace-annotate "$this_node received redundant message {$data} from $source"
	}
}

Agent/MessagePassing/Flooding instproc send_message {size message_id data port} {
    $self instvar messages_seen node_
	$self instvar old_data
    global ns MESSAGE_PORT BROADCAST_ADDR

	set hopCnt 0
	set old_data $data  
	lappend messages_seen $message_id
    $ns trace-annotate "[$node_ node-addr] sending message $data"
    $self sendto $size "$message_id:$hopCnt:$data" $BROADCAST_ADDR $port
}



# create a bunch of nodes
for {set i 0} {$i < $num_nodes} {incr i} {
    set n($i) [$ns node]
	set NX($i) [expr double($val(x)*rand())]
	set NY($i) [expr double($val(y)*rand())]	
	set NZ($i)	0.00
    $n($i) set X_ $NX($i)
    $n($i) set Y_ $NY($i)	
    $n($i) set Z_ $NZ($i)
    $ns initial_node_pos $n($i) 20
}



# attach a new Agent/MessagePassing/Flooding to each node on port $MESSAGE_PORT
for {set i 0} {$i < $num_nodes} {incr i} {
    set a($i) [new Agent/MessagePassing/Flooding]
    $n($i) attach  $a($i) $MESSAGE_PORT
    $a($i) set messages_seen {}
	$a($i) set old_data 1e6
	$a($i) set pktCnt 0
	$a($i) set hopCnt 1000
	$a($i) set pktData {}
    set if_($i) [$n($i) set netif_(0)]
}

for {set i 0} {$i < $num_nodes} {incr i} {
	set x1 $NX($i)
	set y1 $NY($i)
	set z1 $NZ($i)
	set x2 $NX(2)
	set	y2 $NY(2)
	set z2 $NZ(2)
	set dx [expr double($x1-$x2)]
	set dy [expr double($y1-$y2)]
	set dz [expr double($z1-$z2)]
	set dx2 [expr $dx*$dx]
	set dy2 [expr $dy*$dy]
	set dz2 [expr $dz*$dz]	
	set tgtDists($i) [expr sqrt($dx2 + $dy2 + $dz2)]		; # calculate distance between nodes			
}

set range 100.00		;# transmission range: 100m
for {set i 0} {$i < $num_nodes} {incr i} {    
	$if_($i) set Pt_ $TxP
	$if_($i) set fr_ $Fr
	set hopCount($i) -1
	set pktCount($i) -1
	set nodeData($i) -1
	set nodeNeigh($i) {}
	set neighDists($i) {}
	set x1 $NX($i)
	set y1 $NY($i)
	set z1 $NZ($i)
	for {set j 0} {$j < $num_nodes} {incr j} {
		if {$j != $i} {
			set x2 $NX($j)
			set	y2 $NY($j)
			set z2 $NZ($j)
			#set distance [findDist $x1 $x2 $y1 $y2 $z1 $z2]
			set dx [expr double($x1-$x2)]
			set dy [expr double($y1-$y2)]
			set dz [expr double($z1-$z2)]
			set dx2 [expr $dx*$dx]
			set dy2 [expr $dy*$dy]
			set dz2 [expr $dz*$dz]	
			set distance [expr sqrt($dx2 + $dy2 + $dz2)]		; # calculate distance between nodes			
			if {$distance < $range} {				
				lappend nodeNeigh($i) $j
				lappend neighDists($i) $distance
			}
		}
	}		
}   

proc shadowRSS {dist} {
	global M_fact PtGtGr pathlossExp normalRV std_db dist0
	
	set M [expr double($M_fact/$dist0)]
	set L 1.0	
	set Pr0 [expr double(($PtGtGr*($M*$M))/$L)]
	
	if {$dist > $dist0} {
		set avg_db [expr double((-10.0) * $pathlossExp * (log10($dist/$dist0)))]
    } else {
        set avg_db 0.0
    }
	set norRV [$normalRV normal 0 $std_db]
	set powerLoss_db [expr ($avg_db + $norRV)]
	set RxP [expr double($Pr0 * (pow(10.0, ($powerLoss_db/10.0))))]
	#puts "RV: $lnRV --- Pr0: $Pr0 --- avg_db: $avg_db --- RxP: $RxP"
	return $RxP	
}

proc friisDist {RxP} {
	global M_fact PtGtGr 
	set L 1.0	
	
	set M2 [expr double(($RxP * $L)/$PtGtGr)]
	set dist [expr double($M_fact/(sqrt($M2)))]
	return $dist
}

proc findDist {x1 x2 y1 y2 z1 z2} {
	
	set dx [expr double($x1-$x2)]
	set dy [expr double($y1-$y2)]
	set dz [expr double($z1-$z2)]
	set dx2 [expr $dx*$dx]
	set dy2 [expr $dy*$dy]
	set dz2 [expr $dz*$dz]	
	set dd [expr sqrt($dx2 + $dy2 + $dz2)]

	return $dd
}



# 'Sleep' for "usec" microseconds
proc sleep {usec} {	
	set newTime [expr {[clock clicks]+$usec}]
	while {[clock clicks]<$newTime} {}
}

# now set up some events... the data being sent is the distance to the target! {'0' for target node 2}
$ns at 0.1 "$a(2) send_message 100 1 {0.00}  $MESSAGE_PORT"
#$ns at 0.4 "$a([expr $num_nodes/2]) send_message 600 2 {some big message} $MESSAGE_PORT"
#$ns at 0.7 "$a([expr $num_nodes-2]) send_message 200 3 {another one} $MESSAGE_PORT"

$ns at 2.0 "finish"

proc finish {} {
    global ns f nf val num_nodes nodeNeigh neighDists NX NY hopCount pktCount nodeData tgtDists outfile
	
	for {set i 0} {$i < $num_nodes} {incr i} {    
		puts $outfile "-1 $i $nodeNeigh($i) -2 $neighDists($i)"			
	}
	for {set i 0} {$i < $num_nodes} {incr i} {    
		puts $outfile "-3 $i $hopCount($i) -4 $NX($i) $NY($i)"			
	}
	for {set i 0} {$i < $num_nodes} {incr i} {    
		puts $outfile "-5 $i $pktCount($i) -6 $nodeData($i) -7 $tgtDists($i)"			
	}		
	
    $ns flush-trace
    close $f
    close $nf
	close $outfile

#    puts "running nam..."
#    exec nam shadowing.nam &
    exit 0
}

$ns run

