#! /bin/bash

# Para ter acesso a mais variáveis com o comando snmpwalk, adicionei a seguinte linha no arquivo /etc/snmp/snmpd.conf:
# rocommunity private 127.0.0.1 .1

# Criando BD no influx:

curl -i -XPOST http://localhost:8086/query --data-urlencode "q=CREATE DATABASE monitor"

#Inserindo dados no bd

while :
do
	CPU_LOAD=$(snmpwalk -Oqv -v2c -c private localhost .1.3.6.1.4.1.2021.10.1.3.1)
	CPU_TIME=$(snmpwalk -Oqv -v2c -c private localhost .1.3.6.1.4.1.2021.11.9.0)
	CPU_IDLE_TIME=$(snmpwalk -Oqv -v2c -c private localhost .1.3.6.1.4.1.2021.11.11.0)
	
	MEMORY_SWAP_SIZE=$(snmpwalk -Oqv -v2c -c private localhost .1.3.6.1.4.1.2021.4.3.0)
	AVAILABLE_SWAP=$(snmpwalk -Oqv -v2c -c private localhost .1.3.6.1.4.1.2021.4.4.0)
	RAM_USED=$(snmpwalk -Oqv -v2c -c private localhost .1.3.6.1.4.1.2021.4.6.0)
	RAM_FREE=$(snmpwalk -Oqv -v2c -c private localhost .1.3.6.1.4.1.2021.4.11.0)

	curl -i -XPOST "http://localhost:8086/write?db=monitor" --data-binary "cpu_load,server=localhost value=$CPU_LOAD"
	curl -i -XPOST "http://localhost:8086/write?db=monitor" --data-binary "cpu_time,server=localhost value=$CPU_TIME"
	curl -i -XPOST "http://localhost:8086/write?db=monitor" --data-binary "cpu_idle_time,server=localhost value=$CPU_IDLE_TIME"
	
	curl -i -XPOST "http://localhost:8086/write?db=monitor" --data-binary "swap_size,server=localhost value=$MEMORY_SWAP_SIZE"
	curl -i -XPOST "http://localhost:8086/write?db=monitor" --data-binary "available_swap,server=localhost value=$AVAILABLE_SWAP"
	curl -i -XPOST "http://localhost:8086/write?db=monitor" --data-binary "ram_used,server=localhost value=$RAM_USED"
	curl -i -XPOST "http://localhost:8086/write?db=monitor" --data-binary "ram_free,server=localhost value=$RAM_FREE"
		
	sleep 5
done
