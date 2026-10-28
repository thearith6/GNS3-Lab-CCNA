## Lab 6 - Dashboards and Network Maps

> **GNS3 Project:** [`Module 14 - Zabbix | Lab 6 – Dashboards and Network Maps.gns3`](./Module%2014%20-%20Zabbix%20%7C%20Lab%206%20%E2%80%93%20Dashboards%20and%20Network%20Maps.gns3)

![topology](topology.png)

## Scenario
Create the dashboard NOC-OVERVIEW with widgets that show the current problems, the availability of the hosts and the traffic of E 0/0 on R1. ZABBIX (Web GUI) Dashboards > Create dashboard Name: NOC-OVERVIEW Add widget > Problems Show: Problems Severity: Warning, Average, High, Disaster Add widget > Host availability Host groups: Network devices, Linux servers Add widget > Graph Host: R1 Item: Interface Ethernet0/0: Bits received / Bits sent

- **Devices:** LNX1 (PC), R1 (IOU L3), R2 (IOU L3), SW1 (IOU L2), SW2 (IOU L2), SW-MGMT (Ethernet Switch), ZABBIX (QEMU)
- **Base Addressing:**
  - `SW1` Vlan1: `192.168.100.11` (255.255.255.0)
  - `R1` Ethernet0/0: `192.168.100.1` (255.255.255.0)
  - `R2` Ethernet0/0: `192.168.100.2` (255.255.255.0)
  - `SW2` Vlan1: `192.168.100.12` (255.255.255.0)
  - `LNX1` Ethernet0: `192.168.100.60` (GW: 192.168.100.1)

Task 1 - Create the dashboard NOC-OVERVIEW with widgets that show the current problems, the availability of the hosts and the traffic of E 0/0 on R1.
  - ZABBIX (Web GUI) Dashboards > Create dashboard Name: NOC-OVERVIEW Add widget > Problems Show: Problems Severity: Warning, Average, High, Disaster Add widget > Host availability Host groups: Network devices, Linux servers Add widget > Graph Host: R1 Item: Interface Ethernet0/0: Bits received / Bits sent

Task 2 - Create the network map LAB-MAP with all devices and the links between them.
  - Use the trigger of the interface to show the status of the link.
  - ZABBIX (Web GUI) Monitoring > Maps > Create map Name: LAB-MAP Add the elements (type Host): ZABBIX, LNX1, SW1, SW2, R1 and R2 Add the links SW1 - ZABBIX, SW1 - LNX1, SW1 - R1, SW1 - R2, SW1 - SW2 Link indicators: the trigger Interface Ethernet0/0: Link down on the router side Save the map.

Task 3 - Test the dashboard and the map by shutting down E 0/0 on R1.
  - Configure on R1

## Action
Task 1 - Create the dashboard NOC-OVERVIEW with widgets that show the current problems, the availability of the hosts and the traffic of E 0/0 on R1.

Task 2 - Create the network map LAB-MAP with all devices and the links between them.

Task 3 - Test the dashboard and the map by shutting down E 0/0 on R1.

**R1:**
```cisco
ZABBIX (Web GUI)

interface Ethernet0/0
shutdown

Dashboards > NOC-OVERVIEW
```

## Note
1. The widget Problems lists the problem and the availability widget shows R1 as unavailable. Monitoring > Maps > LAB-MAP
2. The element R1 and its link are shown in red.
3. In Data collection > Hosts, unlink the template ICMP Ping from R2 (Unlink and clear). Shut down E 0/0 on R2. — The Zabbix server no longer checks R2 with ping. The map element of R2 stays green although the router is unreachable. Note: Link the template again to fix it.