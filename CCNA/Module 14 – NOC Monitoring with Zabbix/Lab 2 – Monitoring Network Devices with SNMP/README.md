## Lab 2 - Monitoring Network Devices with SNMP

> **GNS3 Project:** [`Module 14 - Zabbix | Lab 2 – Monitoring Network Devices with SNMP.gns3`](./Module%2014%20-%20Zabbix%20%7C%20Lab%202%20%E2%80%93%20Monitoring%20Network%20Devices%20with%20SNMP.gns3)

![topology](topology.png)

## Scenario
Enable SNMPv2c with the read-only community LabRO on R1 and R2. Configure the same community on the switches SW1 and SW2 and give every device a management address in VLAN 1.

- **Devices:** LNX1 (PC), R1 (IOU L3), R2 (IOU L3), SW1 (IOU L2), SW2 (IOU L2), SW-MGMT (Ethernet Switch), ZABBIX (QEMU)
- **Base Addressing:**
  - `R1` Ethernet0/0: `192.168.100.1` (255.255.255.0)
  - `R2` Ethernet0/0: `192.168.100.2` (255.255.255.0)
  - `SW1` Vlan1: `192.168.100.11` (255.255.255.0)
  - `SW2` Vlan1: `192.168.100.12` (255.255.255.0)
  - `LNX1` Ethernet0: `192.168.100.60` (GW: 192.168.100.1)

Task 1 - Enable SNMPv2c with the read-only community LabRO on R1 and R2.
  - Configure the same community on the switches SW1 and SW2 and give every device a management address in VLAN 1.

Task 2 - Add the router R1 to Zabbix with the template Cisco IOS by SNMP.
  - Define the SNMP community as a macro on the host.
  - Add R2, SW1 and SW2 in the same way.
  - ZABBIX (Web GUI) Data collection > Hosts > Create host Host name: R1 Templates: Cisco IOS by SNMP Host groups: Network devices Interfaces: Add > SNMP IP address: 192.168.100.1 Port: 161 SNMP version: SNMPv2 SNMP community: {$SNMP_COMMUNITY} Macros: {$SNMP_COMMUNITY} = LabRO Repeat for R2 (192.168.100.2), SW1 (192.168.100.11) and SW2 (192.168.100.12).

Task 3 - Verify the data collection.
  - ZABBIX (Web GUI) Data collection > Hosts Note: The SNMP availability icon of every host should be green.
  - Monitoring > Latest data > Host: R1 Note: Items such as the system description, the uptime and the traffic of every interface should show values.

## Action
Task 1 - Enable SNMPv2c with the read-only community LabRO on R1 and R2.

**R1 and R2:**
```cisco
snmp-server community LabRO RO
snmp-server location Lab Rack 1
```

**SW1 and SW2:**
```cisco
snmp-server community LabRO RO
interface Vlan1
ip address 192.168.100.11 255.255.255.0
no shutdown
```

Task 2 - Add the router R1 to Zabbix with the template Cisco IOS by SNMP.

Task 3 - Verify the data collection.

## Note
1. Use 192.168.100.12 on SW2.
2. On the host R1 in Zabbix, change the macro {$SNMP_COMMUNITY} to wrong. ZABBIX (Web GUI) — The SNMP availability icon turns red and the host shows a timeout error. R1 ignores the requests with the wrong community. Note: Fix it with LabRO.
3. On R1, restrict the community to the address 192.168.100.99 with an access list. Check the availability of R1 in Zabbix. — The requests of the Zabbix server (192.168.100.50) are not accepted, so the SNMP availability turns red. Note: Fix it by permitting the host 192.168.100.50.