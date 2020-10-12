#!/bin/bash

ps  
ps -u
ps -au
ps -aux
ps -eo uid,pid,ppid,cmd,stat
echo 'echo ola' > teste.sh
echo 'sleep 100' >> teste.sh
echo 'echo adeus' >> teste.sh
chmod a+x teste.sh
./teste.sh & 

jobs
jobs -l 

kill %1 
kill -l 

ping 1.1.1.1 &> /dev/null &
ping 2.2.2.2 &> /dev/null &
ping 3.3.3.3 &> /dev/null &

fg 2  

jobs -l 

kill -cont %2 
jobs 

pgrep ping 
pgrep ping -d ' '
pgrep ping -l -f 
pgrep ping -l -f -o
pgrep ping -l -f -n
pgrep ping -l -f -v

killall ping
jobs 
top 
top -d 5 

free -h 
uptime 
w 

Deve ser feito manualmente
nice -n 10 sleep 300 &
ps -lax | grep sleep
renice 15 [pid do sleep]

vmstat 3





