# Shell-script-memroy-utilization
#!/bin/bash

##It is a sequence of characters (#!) called shebang at the beginning of the script that is used to tell the operating system which interpreter to use to parse the rest of the file 

totalmem=$(vmstat -s | grep -i 'total memory' | sed 's/ *//')

##vmstat stands for Virtual memory statistics. It is a command line tool that collects and displays summary information about operating system memory, processes, interrupts, paging and block I/O. This command check the total memory of your operating system and store the value in totalmem variable 

echo "Total memory on your $(hostname) is"
echo "$totalmem"
echo "-----------------------------------------------"

##echo command in linux is used to display lines of text/string. This command prints the value of the totalmem variable. 

usedmem=$(vmstat -s | grep -i 'used memory' | sed 's/ *//')

##This command check the used memory of your operating system and store the value in usedmem variable

echo "Used memroy on your $(hostname) is"
echo "$usedmem"
echo "-----------------------------------------------"

##This command prints the value of the usedmem variable. 

freemem=$(vmstat -s | grep -i 'free memory' | sed 's/ *//')

##This command check the free memory of your operating system and store the value in freemem variable 

echo "Available memory on your $(hostname) is"
echo "$freemem"
echo "-----------------------------------------------"

##This command prints the value of the freemem variable. 

ramusage=$(free | awk '/Mem/{printf("RAM Usage: %.2f\n"), $3/$2*100}'| awk '{print $3}' | cut -d. -f1)

##The free command in the linux operating system gives information about RAM usage, including total, used, free, shared, and available memory and swap space. This command check the ram usage of your operating system and store the value in the ramusage variable 

if [ $ramusage -ge 45 ]; then

##if command in Linux is used to execute the commands based on conditions. The if statement starts with the if keyword followed by the conditional expression and the then keyword. The statement ends with the fi keyword. If the ram usage is greater than 45 then the statement gets executed 

SUBJECT="ALERT!!! ALERT!!! ALERT!!! : Memory Utilization is High on $(hostname) system at $(date)"

##This is the subject of the Email displaying the alert message with the hostname and the date 

TO="<Your-email-id>"

##Enter your EMAIL ID in TO variable where you want to send the email 

echo "Memory Current Usage is: $ramusage%" >> $MESSAGE

##This command will store the ramusage value in the MESSAGE variable    

echo "Top 5 Memory Consuming Processes are : $(top -b -o +%MEM | head -n 5)" >> $MESSAGE

##top command in linux is used to show the Linux processes and for memory monitoring. It works only on the Linux platform. The top command produces an ordered list of running processes. This command will check the top 5 memory consuming process of your operating system and store the output in MESSAGE variable 

echo "Disk usage of $(hostname) system at $(date) is : $(df -h | awk '$NF=="/"{printf "%d/%dGB (%s)\n", $3,$2,$5}')" >> $MESSAGE

##The df command stands for Disk Free. It is used to display information related to file systems about total space and available space. This command checks the Disk Usage of your operating system and stores the output in the MESSAGE variable. 

echo "CPU load on $(hostname) system at $(date) is : $(top -bn1 | grep load | awk '{printf "%.2f\n", $(NF-2)}' )" >> $MESSAGE

##This command checks theCPU load on your operating system and stores the output in the MESSAGE variable. 

 mail -s "$SUBJECT" "$TO" < $MESSAGE

##Linux mail command is a command-line utility that allows the users to send emails from the command line. We can specify the subject and message in a single line. -s argument stands for the subject and < message is used to pass the message in the mail. 
