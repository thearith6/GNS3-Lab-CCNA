## Lab 4 - Triggers and Alerts

> **GNS3 Project:** [`Module 14 - Zabbix | Lab 4 – Triggers and Alerts.gns3`](./Module%2014%20-%20Zabbix%20%7C%20Lab%204%20%E2%80%93%20Triggers%20and%20Alerts.gns3)

![topology](topology.png)

## Scenario
Link the template ICMP Ping to R1 and R2, so that Zabbix also checks the availability by ping. Then check that the link down trigger of the SNMP template works: shut down E 0/1 on R1. ZABBIX (Web GUI)

- **Devices:** LNX1 (PC), R1 (IOU L3), R2 (IOU L3), SW1 (IOU L2), SW2 (IOU L2), SW-MGMT (Ethernet Switch), ZABBIX (QEMU)
- **Base Addressing:**
  - `R1` Ethernet0/0: `192.168.100.1` (255.255.255.0)
  - `R2` Ethernet0/0: `192.168.100.2` (255.255.255.0)
  - `SW2` Vlan1: `192.168.100.12` (255.255.255.0)
  - `SW1` Vlan1: `192.168.100.11` (255.255.255.0)
  - `LNX1` Ethernet0: `192.168.100.60` (GW: 192.168.100.1)

Task 1 - Link the template ICMP Ping to R1 and R2, so that Zabbix also checks the availability by ping.
  - Then check that the link down trigger of the SNMP template works: shut down E 0/1 on R1.
  - ZABBIX (Web GUI)

Task 2 - Create an e-mail media type that uses the local mail server of ZABBIX, add an e-mail address to the user Admin and create an action that sends a message for every problem with the severity High or higher.
  - Configure on ZABBIX

Task 3 - Test the alert by making R2 unreachable and verify the action log.
  - Configure on R2

## Action
Task 1 - Link the template ICMP Ping to R1 and R2, so that Zabbix also checks the availability by ping.

**R1:**
```cisco
Data collection > Hosts > select R1 and R2 >
Mass update > Templates
Link templates: ICMP Ping

interface Ethernet0/1
shutdown
```

Task 2 - Create an e-mail media type that uses the local mail server of ZABBIX, add an e-mail address to the user Admin and create an action that sends a message for every problem with the severity High or higher.

**ZABBIX:**
```cisco
ZABBIX (Web GUI)

apt install -y postfix mailutils

Alerts > Media types > Email
SMTP server: localhost
SMTP server port: 25
SMTP helo: lab.local
SMTP email: zabbix@lab.local
Users > Users > Admin > Media > Add
Type: Email
Send to: noc@lab.local
Alerts > Actions > Trigger actions > Create
action
Name: NOC-NOTIFY
Conditions: Trigger severity >= High
Operations: Send message to user Admin,
Send only to Email
```

Task 3 - Test the alert by making R2 unreachable and verify the action log.

**R2:**
```cisco
ZABBIX (Web GUI)

interface Ethernet0/0
shutdown

Monitoring > Problems
```

## Note
1. After the next check the problem Interface Ethernet0/1: Link down appears in Monitoring > Problems. interface Ethernet0/1 no shutdown
2. The problem is resolved automatically.
3. The problem Unavailable by ICMP ping should appear for R2. Reports > Action log
4. The action NOC-NOTIFY should show an e-mail to noc@lab.local with the status Sent.
5. Change the condition of the action NOC-NOTIFY to Trigger severity >= Disaster. Shut down E 0/0 on R2 again. — The problem still appears in Monitoring > Problems, but no message is sent because the severity High is lower than the condition. Note: Fix it with Trigger severity >= High.