#!/bin/bash

echo "WiFi throttle"

valid_input () {
	echo "Valid arguments: "
	echo "---- stop  --------stops any throttling"
	echo "---- rate  --------set network rate (bps)"
	echo "---- delay --------set network delay (ms)"
}

# check if argument
if [ ! -z $1 ]
then
	# stop throttle
	if [ "$1" = "stop" ]
	then
		echo "Stopping WiFi throttle"
 		sudo tc qdisc del dev wlp6s0 root
 		sudo tc qdisc del dev enp7s0 root
		exit 0
	
	# rate limit
	elif [ "$1" = "rate" ]
	then

		read -p "Enter WiFi rate (bps): " rate
		COMMAND0="sudo tc qdisc add dev wlp6s0 handle 1: root htb default 11"
		COMMAND1="sudo tc class add dev wlp6s0 parent 1: classid 1:1 htb rate "$rate"bps"
		COMMAND2="sudo tc class add dev wlp6s0 parent 1:1 classid 1:11 htb rate "$rate"bps"

		echo "Setup: "  $COMMAND0
		$COMMAND0
		echo "Trying: " $COMMAND1
		$COMMAND1
		echo "Trying: " $COMMAND2
		$COMMAND2
	# delay
	elif [ "$1" = "delay" ]
	then
		read -p "Enter WiFi delay (ms): " delay
		COMMAND0="sudo tc qdisc add dev wlp6s0 root netem delay "$delay"ms"
		$COMMAND0
		COMMAND1="sudo tc qdisc add dev enp7s0 root netem delay "$delay"ms"
		$COMMAND1
	else
		echo "No valid command entered"
		valid_input
	fi
else
	valid_input
fi
