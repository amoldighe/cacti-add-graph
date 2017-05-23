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
	LOGFILE=$PWD/cacti-interface-graph.log
	readarray -t array < $CPUID_LIST
	for hostid in "${array[@]}"
	do
		echo `date` >> $LOGFILE 2>&1
		echo `sudo php -q /usr/share/cacti/cli/add_graphs.php --list-hosts | grep -w $hostid` >> $LOGFILE 2>&1
		hostIPcmd="sudo php -q /usr/share/cacti/cli/add_graphs.php --host-id=$hostid --snmp-field=ifIP --list-snmp-values" 
		hostIPs=`$hostIPcmd | grep -v 127 | grep -v Known`
		hostIPsArr=($hostIPs)
		for hostip in "${hostIPsArr[@]}"
		do
			interfaceGraphadd="sudo php -q /usr/share/cacti/cli/add_graphs.php --host-id=$hostid --snmp-query-id=1 --snmp-query-type-id=13 --snmp-field=ifIP --snmp-value=$hostip --graph-template-id=2 --graph-type=ds"
			echo `$interfaceGraphadd` >> $LOGFILE 2>&1 
		done		
		echo -e "\n --------------------- \n" >> $LOGFILE 2>&1
	done
fi
