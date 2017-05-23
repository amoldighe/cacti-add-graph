**cacti-cpu-mem-graph.sh** is a shell script for addition cacti graphs for cpu, memory, load average for multiple servers.

**Usage :**

* **For addition of cpu, memory, load average graphs**

> bash ./cacti-cpu-mem-graph.sh    host-id-list-file

Please note the host-id-list-file needs to be generated using the below command, which will awk only the ids' for the host to a file.  

> sudo php -q /usr/share/cacti/cli/add_graphs.php --list-hosts | awk '{print $1}' > host-id-list-file

I am using graph templete id - 40, 41, 42 (for cpu, memoy, load average) in my script. You can list graph template using the following command 

> sudo php -q /usr/share/cacti/cli/add_graphs.php --list-graph-templates


* **Addition of interface graphs**

> bash ./cacti-interface-graph.sh   host-id-list-file

Please note, I am using specific parameters & their values in my script:
> -- --snmp-query-id=1 
> -- --snmp-query-type-id=13 
> -- --snmp-field=ifIP 
> -- --snmp-value=192.168.4.171 
> -- --graph-template-id=2 

Below commands will help list the required parameter values.

List the snmp queries to be used while adding graphs for interface 

> sudo php -q /usr/share/cacti/cli/add_graphs.php --list-snmp-queries

List the snmp field type for interface graphing

> (jpe2)amold@consul-03:~$ sudo php -q
> /usr/share/cacti/cli/add_graphs.php --host-id=47 --list-snmp-fields

List all the interfaces with IP

> (jpe2)amold@consul-03:~$ sudo php -q
> /usr/share/cacti/cli/add_graphs.php --host-id=47 --snmp-field=ifIP
> --list-snmp-values 





