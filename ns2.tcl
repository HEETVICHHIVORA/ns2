# Create a simulator object
set ns [new Simulator]

# Define different colors for data flows
$ns color 1 Blue
$ns color 2 Red

# Open the nam trace file
set nf [open out.nam w]
$ns namtrace-all $nf

# Create two nodes
set n0 [$ns node]
set n1 [$ns node]

# Create a duplex link between the nodes
$ns duplex-link $n0 $n1 1Mb 10ms DropTail

# Create a UDP agent and attach it to node n0
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0

# Create a Null agent (a sink) and attach it to node n1
set null1 [new Agent/Null]
$ns attach-agent $n1 $null1

# Connect the UDP agent to the Null agent
$ns connect $udp0 $null1

# Create a CBR traffic generator and attach it to the UDP agent
set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 500
$cbr set interval_ 0.005
$cbr attach-agent $udp0

# Schedule the traffic to start at time 0.5 seconds and stop at 4.5 seconds
$ns at 0.5 "$cbr start"
$ns at 4.5 "$cbr stop"

# Schedule the finish procedure to be called after 5 seconds
$ns at 5.0 "finish"

# Define a 'finish' procedure
proc finish {} {
    	global ns nf
    	$ns flush-trace

    	# Close the trace file
    	close $nf

    	# Execute nam on the trace file
    	exec nam out.nam &
    	exit 0
}

# Run the simulation
$ns run
