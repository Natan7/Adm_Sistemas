#! /bin/bash

# Para ter acesso a mais variáveis com o comando snmpwalk, adicionei a seguinte linha no arquivo /etc/snmp/snmpd.conf:
# rocommunity private 127.0.0.1 .1

CPU_LOAD=$(snmpwalk -v2c -c private localhost .1.3.6.1.4.1.2021.10.1.3.1)
CPU_TIME=$(snmpwalk -v2c -c private localhost .1.3.6.1.4.1.2021.11.9.0)
CPU_IDLE_TIME=$(snmpwalk -v2c -c private localhost .1.3.6.1.4.1.2021.11.11.0)

MEMORY_SWAP_SIZE=$(snmpwalk -v2c -c private localhost .1.3.6.1.4.1.2021.4.3.0)
AVAILABLE_SWAP=$(snmpwalk -v2c -c private localhost .1.3.6.1.4.1.2021.4.4.0)
RAM_USED=$(snmpwalk -v2c -c private localhost .1.3.6.1.4.1.2021.4.6.0)
RAM_FREE=$(snmpwalk -v2c -c private localhost .1.3.6.1.4.1.2021.4.11.0)

