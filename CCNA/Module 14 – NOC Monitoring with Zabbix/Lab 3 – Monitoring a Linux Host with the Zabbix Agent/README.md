## Lab 3 - Monitoring a Linux Host with the Zabbix Agent

> **GNS3 Project:** [`Module 14 - Zabbix | Lab 3 – Monitoring a Linux Host with the Zabbix Agent.gns3`](./Module%2014%20-%20Zabbix%20%7C%20Lab%203%20%E2%80%93%20Monitoring%20a%20Linux%20Host%20with%20the%20Zabbix%20Agent.gns3)

![topology](topology.png)

## Scenario
Install the Zabbix agent 2 on LNX1 (with the Zabbix repository of the server). Configure it to accept requests from the Zabbix server and to report as LNX1.

- **Devices:** LNX1 (PC), R1 (IOU L3), R2 (IOU L3), SW1 (IOU L2), SW2 (IOU L2), SW-MGMT (Ethernet Switch), ZABBIX (QEMU)
- **Base Addressing:**
  - `R1` Ethernet0/0: `192.168.100.1` (255.255.255.0)
  - `SW1` Vlan1: `192.168.100.11` (255.255.255.0)
  - `SW2` Vlan1: `192.168.100.12` (255.255.255.0)
  - `R2` Ethernet0/0: `192.168.100.2` (255.255.255.0)
  - `LNX1` Ethernet0: `192.168.100.60` (GW: 192.168.100.1)

Task 1 - Install the Zabbix agent 2 on LNX1 (with the Zabbix repository of the server).
  - Configure it to accept requests from the Zabbix server and to report as LNX1.

Task 2 - Add the host LNX1 to Zabbix with the template Linux by Zabbix agent.
  - ZABBIX (Web GUI) Data collection > Hosts > Create host Host name: LNX1 Templates: Linux by Zabbix agent Host groups: Linux servers Interfaces: Add > Agent IP address: 192.168.100.60 Port: 10050

Task 3 - Verify the data collection and test the high CPU trigger.
  - ZABBIX (Web GUI)

## Action
Task 1 - Install the Zabbix agent 2 on LNX1 (with the Zabbix repository of the server).

**LNX1:**
```cisco
apt install -y zabbix-agent2
/etc/zabbix/zabbix_agent2.conf
Server=192.168.100.50
ServerActive=192.168.100.50
Hostname=LNX1
systemctl enable --now zabbix-agent2
```

Task 2 - Add the host LNX1 to Zabbix with the template Linux by Zabbix agent.

Task 3 - Verify the data collection and test the high CPU trigger.

**LNX1:**
```cisco
Data collection > Hosts

yes > /dev/null &

Monitoring > Latest data > Host: LNX1

pkill yes
```

## Note
1. The ZBX availability icon of LNX1 should be green.
2. Start one process per CPU core. After the time of the trigger (5 minutes by default) the problem High CPU utilization appears in Monitoring > Problems.
3. Items such as CPU utilization, memory and file system usage should show values.
4. On LNX1, change Server=192.168.100.50 to Server=192.168.100.99 and restart the agent. — The agent drops the connections of the Zabbix server because the address is not allowed. The ZBX icon of LNX1 turns red. Note: Fix it with Server=192.168.100.50.
5. On LNX1, block the agent port with ufw deny 10050/tcp. LNX1 — The Zabbix server cannot reach the agent. The ZBX icon turns red with a timeout error. Note: Fix it with ufw allow 10050/tcp.