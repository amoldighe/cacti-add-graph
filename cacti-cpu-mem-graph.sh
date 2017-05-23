#!/bin/bash

usage ()
{
	echo -e "\n RUN:"
        echo -e "    $0 <file containing host ids>"
	echo -e "\n Create a host id file using command: "
        echo -e "    sudo php -q /usr/share/cacti/cli/add_graphs.php --list-hosts | awk '{print \$1}' > host-id-list \n"
	exit 0
}

CPUID_LIST=$1

if [ "$CPUID_LIST" == "-h" ] || [ "$CPUID_LIST" == "--help" ]
then 
	usage

elif [ ! -f "$CPUID_LIST" ] 
then
	echo -e "\n $CPUID_LIST File does not exist "
	echo "Please create one using this command: "
	echo "sudo php -q /usr/share/cacti/cli/add_graphs.php --list-hosts | awk '{print \$1}' > host-id-list "
	echo "RUN:"
	echo -e "    $0 <file containing host ids> \n"
	exit 0
else
	LOGFILE=$PWD/cacti-cpu-mem-graph.log
	readarray -t array < $CPUID_LIST
	for i in "${array[@]}"
	do
		echo `date` >> $LOGFILE 2>&1
		echo `sudo php -q /usr/share/cacti/cli/add_graphs.php --list-hosts | grep -w $i` >> $LOGFILE
		mem_usage="sudo php -q /usr/share/cacti/cli/add_graphs.php  --host-id=$i --graph-template-id=40 --graph-type=cg"
		echo `$mem_usage` >> $LOGFILE 2>&1 
		load_avg="sudo php -q /usr/share/cacti/cli/add_graphs.php  --host-id=$i --graph-template-id=41 --graph-type=cg"
		echo `$load_avg` >> $LOGFILE 2>&1 
		cpu_usage="sudo php -q /usr/share/cacti/cli/add_graphs.php  --host-id=$i --graph-template-id=42 --graph-type=cg"
		echo `$cpu_usage` >> $LOGFILE 2>&1 
		echo -e "\n --------------------- \n" >> $LOGFILE 2>&1
	done
fi
