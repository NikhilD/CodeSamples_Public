
set MESSAGE_PORT 42
set BROADCAST_ADDR -1

if { $argc != 3 } {
    puts "Wrong no. of cmdline args."
	puts "Usage: ns <filename.tcl> <Canvas> <Number of nodes> <Expt. Number>"
    exit 0
} else {
	set nodeVal [lindex $argv 1]
	set canvas [lindex $argv 0]
	set reportNum [lindex $argv 2]
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
set filename "$fpart1$fpart2-$fpart3"
#puts "filename: $filename"
set outfile [open $filename.txt w]
puts $outfile "$addArr"


set TxP 5.0e-04			;# (~ -3 dBm)
set M_PI 3.14159265359
set Fr 2.45e+09	
set lambda [expr double(3.0e+08/$Fr)]
set Gt 1.0
set Gr 1.0
set ht 1.0
set hr 1.0
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

# Physical Channel Settings
Phy/WirelessPhy set CSThresh_       $rssiMin1		;# Carrier Sense Threshold is about 50m more than the Tr. Range
Phy/WirelessPhy set Pt_             $TxP
Phy/WirelessPhy set freq_           $Fr
Phy/WirelessPhy set Gt_             $Gt
Phy/WirelessPhy set Gr_           	$Gt
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
Mac/802_11 set RTSThreshold_        10000
Mac/802_11 set basicRate_           1Mb
Mac/802_11 set dataRate_            11Mb

set val(chan)           Channel/WirelessChannel    ;#Channel Type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/$macLayer              ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq


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
set nf [open wireless-flooding-$val(rp).nam w]
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
    global ns BROADCAST_ADDR NX NY NZ hopCount pktCount nodeData

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
	if {double($newHC) <= double($hopCnt)} {
		set rxPwr [rssi $my_x $src_x $my_y $src_y $my_z $src_z]	; # Calc RSS in Watts
		set RSS [scaleRSS $rxPwr]								; # Scale 0~1 after dBm convrn
		#puts "\n$rxPwr:$RSS   hopCnt:$newHC"	
		set new_data [expr ($data_recd*$RSS)]
		#set new_data [expr (($data_recd*$RSS)/$newHC)]

		if {double($old_data) < double($new_data)} {
			set hopCnt $newHC
			set hopCount($this_node) $hopCnt
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
			#set jitter [expr int(300*rand())]; # Add random 'jitter' to make the Tx for each node an independent process
			#sleep $jitter; # anywhere between '0' and '300' usec
			$self sendto $size "$message_id:$hopCnt:$new_data" $BROADCAST_ADDR $sport
		} else {
			#puts "\nData-1:: $this_node redundant message from $source"			
			$ns trace-annotate "$this_node received redundant message {$data} from $source"
		}	
	} else {
		#puts "\nData-1:: $this_node redundant message from $source"			
    	$ns trace-annotate "$this_node received redundant message {$data} from $source"
	}
}

Agent/MessagePassing/Flooding instproc send_message {size message_id data port} {
    $self instvar messages_seen node_
	$self instvar old_data hopCnt
    global ns MESSAGE_PORT BROADCAST_ADDR hopCount

	set this_node [$node_ node-addr]
	set hopCnt 0
	set hopCount($this_node) 0
	set old_data $data  
	lappend messages_seen $message_id
    $ns trace-annotate "$this_node sending message $data"
    $self sendto $size "$message_id:$hopCnt:$data" $BROADCAST_ADDR $port
}



# create a bunch of nodes
for {set i 0} {$i < $num_nodes} {incr i} {
    set n($i) [$ns node]
	if {$i == 2} {	
		set NX($i) [expr double(25.0*($canvas/500.0))]
		set NY($i) [expr double(450.0*($canvas/500.0))]
	} else {
		set NX($i) [expr double($val(x)*rand())]
		set NY($i) [expr double($val(y)*rand())]			
	}
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
	$a($i) set old_data -1
	$a($i) set pktCnt 0
	$a($i) set hopCnt 1000
	$a($i) set pktData {}
    set if_($i) [$n($i) set netif_(0)]
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


proc rssi {x1 x2 y1 y2 z1 z2} {
	global M_fact PtGtGr PtGtGrhr2ht2 CoD
	
	set dx [expr double($x1-$x2)]
	set dy [expr double($y1-$y2)]
	set dz [expr double($z1-$z2)]
	set dx2 [expr $dx*$dx]
	set dy2 [expr $dy*$dy]
	set dz2 [expr $dz*$dz]	
	set d [expr sqrt($dx2 + $dy2 + $dz2)]

	set d4 [expr double(pow($d,4))]
	
	set M [expr double($M_fact/$d)]
	set L 1.0
	
	if {($d) < ($CoD)} {
		set RxP [expr double(($PtGtGr*($M*$M))/$L)]
	} else {
		set RxP [expr double($PtGtGrhr2ht2/($d4*$L))]
	}	
	return $RxP
}



proc scaleRSS {rxPwr} {
	global rssiMin rssiMax denom
	set RxP [expr ($rxPwr*1000)]
	set RxP1 [expr 10*(log10($RxP))]
	if {$RxP1 > $rssiMax} {
		set RxP1 $rssiMax
	}
	set RSS [expr (($RxP1-$rssiMin)/$denom)]
	return $RSS		
}


# 'Sleep' for "usec" microseconds
proc sleep {usec} {	
	set newTime [expr {[clock clicks]+$usec}]
	while {[clock clicks]<$newTime} {}
}

# now set up some events
$ns at 0.1 "$a(2) send_message 100 1 {100.00}  $MESSAGE_PORT"
#$ns at 0.4 "$a([expr $num_nodes/2]) send_message 600 2 {some big message} $MESSAGE_PORT"
#$ns at 0.7 "$a([expr $num_nodes-2]) send_message 200 3 {another one} $MESSAGE_PORT"

$ns at 10.0 "finish"

proc finish {} {
    global ns f nf val num_nodes nodeNeigh neighDists NX NY hopCount pktCount nodeData outfile
	
	for {set i 0} {$i < $num_nodes} {incr i} {    
		puts $outfile "-1 $i $nodeNeigh($i) -2 $neighDists($i)"			
	}
	for {set i 0} {$i < $num_nodes} {incr i} {    
		puts $outfile "-3 $i $hopCount($i) -4 $NX($i) $NY($i)"			
	}
	for {set i 0} {$i < $num_nodes} {incr i} {    
		puts $outfile "-5 $i $pktCount($i) -6 $nodeData($i)"			
	}		
	
    $ns flush-trace
    close $f
    close $nf
	close $outfile

#    puts "running nam..."
#    exec nam wireless-flooding-$val(rp).nam &
    exit 0
}

$ns run

