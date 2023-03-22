#!/bin/bash
totalmem=$(vmstat -s | grep -i 'total memory' | sed 's/ *//')
echo "Total memory on your $(hostname) is"
echo "$totalmem"
echo "-----------------------------------------------"
usedmem=$(vmstat -s | grep -i 'used memory' | sed 's/ *//')
echo "Used memroy on your $(hostname) is"
echo "$usedmem"
echo "-----------------------------------------------"
freemem=$(vmstat -s | grep -i 'free memory' | sed 's/ *//')
echo "Available memory on your $(hostname) is"
echo "$freemem"
echo "-----------------------------------------------"
ramusage=$(free | awk '/Mem/{printf("RAM Usage: %.2f\n"), $3/$2*100}'| awk '{print $3}' | cut -d. -f1)
if [ $ramusage -ge 45 ]; then
	SUBJECT="ALERT!!! ALERT!!! ALERT!!! : Memory Utilization is High on $(hostname) system at $(date)"
	MESSAGE="/tmp/Mail.out"
	TO="<Your-email-id>"
	echo "Memory Current Usage is: $ramusage%" >> $MESSAGE
	echo "" >> $MESSAGE
	echo "------------------------------------------------------------------" >> $MESSAGE
        echo "" >> $MESSAGE
	echo "Top 5 Memory Consuming Processes are : $(top -b -o +%MEM | head -n 5)" >> $MESSAGE
        echo "" >> $MESSAGE
	echo "------------------------------------------------------------------" >> $MESSAGE
	echo "" >> $MESSAGE
	echo "Disk usage of $(hostname) system at $(date) is : $(df -h | awk '$NF=="/"{printf "%d/%dGB (%s)\n", $3,$2,$5}')" >> $MESSAGE
	echo "" >> $MESSAGE
	echo "------------------------------------------------------------------" >> $MESSAGE
	echo "" >> $MESSAGE
	echo "CPU load on $(hostname) system at $(date) is : $(top -bn1 | grep load | awk '{printf "%.2f\n", $(NF-2)}' )" >> $MESSAGE
	mail -s "$SUBJECT" "$TO" < $MESSAGE
	rm /tmp/Mail.out
fi
