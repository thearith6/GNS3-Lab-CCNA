## Lab 7 - Troubleshooting from Alerts: NOC Tickets

> **GNS3 Project:** [`Module 14 - Zabbix | Lab 7 – Troubleshooting from Alerts: NOC Tickets.gns3`](./Module%2014%20-%20Zabbix%20%7C%20Lab%207%20%E2%80%93%20Troubleshooting%20from%20Alerts%3A%20NOC%20Tickets.gns3)

![topology](topology.png)

## Scenario
Ticket 1: Zabbix shows the problem Interface Ethernet0/1: Link down on R1. Prepare the fault by shutting down E 0/1 on R1. Find the cause and fix it.

- **Devices:** LNX1 (PC), R1 (IOU L3), R2 (IOU L3), SW1 (IOU L2), SW2 (IOU L2), SW-MGMT (Ethernet Switch), ZABBIX (QEMU)
- **Base Addressing:**
  - `SW2` Vlan1: `192.168.100.12` (255.255.255.0)
  - `R1` Ethernet0/0: `192.168.100.1` (255.255.255.0)
  - `R2` Ethernet0/0: `192.168.100.2` (255.255.255.0)
  - `SW1` Vlan1: `192.168.100.11` (255.255.255.0)
  - `LNX1` Ethernet0: `192.168.100.60` (GW: 192.168.100.1)

Task 1 - Ticket 1: Zabbix shows the problem Interface Ethernet0/1: Link down on R1.
  - Prepare the fault by shutting down E 0/1 on R1.
  - Find the cause and fix it.

Task 2 - Ticket 2: Zabbix shows the problem Unavailable by ICMP ping for R2.
  - Prepare the fault by shutting down the port of SW1 towards R2 (E 0/3).
  - Find the cause and fix it.

Task 3 - Ticket 3: Zabbix shows the problem Zabbix agent is not available for LNX1.
  - Prepare the fault by stopping the agent.
  - Find the cause and fix it.

## Action
Task 1 - Ticket 1: Zabbix shows the problem Interface Ethernet0/1: Link down on R1.

**R1:**
```cisco
R1 (troubleshooting)

interface Ethernet0/1
shutdown
```

Task 2 - Ticket 2: Zabbix shows the problem Unavailable by ICMP ping for R2.

**SW1:**
```cisco
ZABBIX (troubleshooting)

interface Ethernet0/3
shutdown
```

Task 3 - Ticket 3: Zabbix shows the problem Zabbix agent is not available for LNX1.

**LNX1:**
```cisco
LNX1 (troubleshooting)

systemctl stop zabbix-agent2

systemctl status zabbix-agent2
```

## Note
1. Verification commands: `Show ip interface brief`, `ping 192.168.100.2`
2. Ethernet0/1 shows administratively down. interface Ethernet0/1 no shutdown
3. The problem in Zabbix is resolved.
4. No reply. The router is not reachable, but the other hosts are. SW1: Show interfaces status
5. Ethernet0/3 is disabled. interface Ethernet0/3 no shutdown
6. The service is inactive. ss -ltn | grep 10050