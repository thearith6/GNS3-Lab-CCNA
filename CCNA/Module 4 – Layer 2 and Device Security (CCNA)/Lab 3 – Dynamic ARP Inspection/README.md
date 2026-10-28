## Lab 3 - Dynamic ARP Inspection

> **GNS3 Project:** [`Module 4 - Layer 2 Security (CCNA) | Lab 3 - Dynamic ARP Inspection.gns3`](./Module%204%20-%20Layer%202%20Security%20%28CCNA%29%20%7C%20Lab%203%20-%20Dynamic%20ARP%20Inspection.gns3)

![topology](topology.png)

## Scenario
Starting from the Lab 2 configuration, enable Dynamic ARP Inspection on SW1 for VLAN 1 and trust the uplink to R1.

- **Devices:** ATK (PC), PC1 (PC), PC2 (PC), R1 (IOU L3), SW1 (IOU L2)
- **Base Addressing:**
  - `R1` Ethernet0/0: `192.168.10.1` (255.255.255.0)
  - `ATK` Ethernet0: `192.168.10.66` (GW: 192.168.10.1)
  - `PC1` Ethernet0: `192.168.10.11` (GW: 192.168.10.1)
  - `PC2` Ethernet0: `192.168.10.12` (GW: 192.168.10.1)

Task 1 - Starting from the Lab 2 configuration, enable Dynamic ARP Inspection on SW1 for VLAN 1 and trust the uplink to R1.
  - Configure on SW1

Task 2 - Make DAI drop ARP packets that contain an invalid source MAC address, destination MAC address or IP address.
  - Configure on SW1

Task 3 - Limit the ARP rate on the host ports to 15 packets per second and verify the inspection.
  - Configure on SW1

## Action
Task 1 - Starting from the Lab 2 configuration, enable Dynamic ARP Inspection on SW1 for VLAN 1 and trust the uplink to R1.

**SW1:**
```cisco
ip arp inspection vlan 1
interface Ethernet0/0
ip arp inspection trust
```

Task 2 - Make DAI drop ARP packets that contain an invalid source MAC address, destination MAC address or IP address.

**SW1:**
```cisco
ip arp inspection validate src-mac dst-mac ip
```

Task 3 - Limit the ARP rate on the host ports to 15 packets per second and verify the inspection.

**SW1:**
```cisco
interface range Ethernet0/1 - 3
ip arp inspection limit rate 15
```

## Note
1. Verification commands: `Show ip arp inspection vlan 1`
2. DAI should be enabled and active for VLAN 1. Show ip arp inspection statistics
3. ARP packets from PC1 and PC2 should be forwarded because they match the DHCP snooping binding table.
4. Configure the static address 192.168.10.66/24 on ATK without using DHCP and ping R1. — The ARP packets from ATK are dropped because ATK is not in the DHCP snooping binding table. A DHCP_SNOOPING_DENY message is logged.
5. On SW1, remove the trust from E 0/0. Clear the ARP table on PC1 and ping R1. SW1 — The ARP replies from R1 are dropped, because R1 is not in the binding table. PC1 cannot resolve the gateway. Note: Fix it with ip arp inspection trust.