## Lab 5 - Syslog Collection and Log Monitoring

> **GNS3 Project:** [`Module 14 - Zabbix | Lab 5 – Syslog Collection and Log Monitoring.gns3`](./Module%2014%20-%20Zabbix%20%7C%20Lab%205%20%E2%80%93%20Syslog%20Collection%20and%20Log%20Monitoring.gns3)

![topology](topology.png)

## Scenario
Send the logs of the routers to the Zabbix server. Add millisecond timestamps and send events of the level informational and higher.

- **Devices:** LNX1 (PC), R1 (IOU L3), R2 (IOU L3), SW1 (IOU L2), SW2 (IOU L2), SW-MGMT (Ethernet Switch), ZABBIX (QEMU)
- **Base Addressing:**
  - `SW1` Vlan1: `192.168.100.11` (255.255.255.0)
  - `R2` Ethernet0/0: `192.168.100.2` (255.255.255.0)
  - `R1` Ethernet0/0: `192.168.100.1` (255.255.255.0)
  - `SW2` Vlan1: `192.168.100.12` (255.255.255.0)
  - `LNX1` Ethernet0: `192.168.100.60` (GW: 192.168.100.1)

Task 1 - Send the logs of the routers to the Zabbix server.
  - Add millisecond timestamps and send events of the level informational and higher.

Task 2 - Configure rsyslog on ZABBIX to receive the messages on UDP 514 and write the messages of the network devices to a separate file that the Zabbix agent can read.
  - Configure on ZABBIX

Task 3 - Create a log item on the host Zabbix server that follows the file and looks for link changes.
  - Add a trigger that fires when such a message arrives.
  - ZABBIX (Web GUI) Data collection > Hosts > Zabbix server > Items > Create item Name: Network syslog link changes Type: Zabbix agent (active) Key: log[/var/log/network/network.log,"LINEPROTO-5-UPDOWN"] Type of information: Log Data collection > Hosts > Zabbix server > Triggers > Create trigger Name: Link change in the network syslog Severity: Warning Expression: find(/Zabbix server/log[/var/log/network/network.log,"LINEPROTO-5-UPDOWN"],,"like","UPDOWN")=1 Note: Shut down an interface on R1.
  - The problem should appear in Monitoring > Problems.

## Action
Task 1 - Send the logs of the routers to the Zabbix server.

**R1 and R2:**
```cisco
service timestamps log datetime msec
logging host 192.168.100.50
logging trap informational
```

Task 2 - Configure rsyslog on ZABBIX to receive the messages on UDP 514 and write the messages of the network devices to a separate file that the Zabbix agent can read.

**ZABBIX:**
```cisco
mkdir /var/log/network
/etc/rsyslog.d/10-network.conf
module(load="imudp")
input(type="imudp" port="514")
$FileCreateMode 0644
if $fromhost-ip startswith '192.168.100.' then /var/log/network/network.log
& stop
systemctl restart rsyslog
```

Task 3 - Create a log item on the host Zabbix server that follows the file and looks for link changes.

## Note
1. After a change on R1 (for example shutdown and no shutdown of an interface) the file /var/log/network/network.log should contain the messages.
2. On ZABBIX, block the syslog port with ufw deny 514/udp. Make a change on R1 and check the log file. — The messages of R1 are dropped, the file network.log does not grow and Zabbix creates no problem. Note: Fix it with ufw allow 514/udp.
3. On R1, change the logging level to errors (logging trap errors). Shut down an interface on R1. — A link change has the severity notifications, which is lower than errors. R1 does not send the message and Zabbix creates no problem. Note: Fix it with logging trap informational.