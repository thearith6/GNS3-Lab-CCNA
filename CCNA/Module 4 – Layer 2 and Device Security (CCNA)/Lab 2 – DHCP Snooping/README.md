## Lab 2 - DHCP Snooping

> **GNS3 Project:** [`Module 4 - Layer 2 Security (CCNA) | Lab 2 - DHCP Snooping.gns3`](./Module%204%20-%20Layer%202%20Security%20%28CCNA%29%20%7C%20Lab%202%20-%20DHCP%20Snooping.gns3)

![topo](image_5.png)

## Scenario
Configure R1 as a DHCP server for the 192.168.10.0/24 network. Exclude the first 10 addresses and use R1 as the default gateway.

- **Devices:** ATK (PC), PC1 (PC), PC2 (PC), R1 (IOU L3), SW1 (IOSvL2)
- **Base Addressing:**
  - `R1` Ethernet0/0: `192.168.10.1` (255.255.255.0)
  - `PC1` Ethernet0: `192.168.10.11` (GW: 192.168.10.1)
  - `PC2` Ethernet0: `192.168.10.12` (GW: 192.168.10.1)
  - `ATK` Ethernet0: `192.168.10.66` (GW: 192.168.10.1)

Task 1 - Configure R1 as a DHCP server for the 192.168.10.0/24 network.
  - Exclude the first 10 addresses and use R1 as the default gateway.

Task 2 - Enable DHCP snooping on SW1 for VLAN 1 and trust only the uplink to R1.
  - Disable the insertion of option 82 so that R1 accepts the requests.

Task 3 - Limit the DHCP request rate on the host ports to 15 packets per second and verify the snooping binding table.
  - Configure on SW1

## Action
Task 1 - Configure R1 as a DHCP server for the 192.168.10.0/24 network.

**R1:**
```cisco
ip dhcp excluded-address 192.168.10.1 192.168.10.10
ip dhcp pool LAN
network 192.168.10.0 255.255.255.0
default-router 192.168.10.1
```

Task 2 - Enable DHCP snooping on SW1 for VLAN 1 and trust only the uplink to R1.

**SW1:**
```cisco
ip dhcp snooping
ip dhcp snooping vlan 1
no ip dhcp snooping information option
interface G0/0
ip dhcp snooping trust
```

Task 3 - Limit the DHCP request rate on the host ports to 15 packets per second and verify the snooping binding table.

**SW1:**
```cisco
interface range G0/1 - 3
ip dhcp snooping limit rate 15
```

## Note
1. `no ip dhcp snooping information option` -> so that SW1 does not add option82. Otherwise confuse the DHCP server. (DHCP SRV think its own lan but see option 82, so no offer).
2. Verification commands: `Show ip dhcp snooping binding` - PC1 and PC2 listed with their MAC address, IP address and port.

![Verification-1](image_1.png)

2. On SW1, remove the trust from G0/0. Release and renew the address on PC1. SW1 — The DHCP offers from R1 arrive on an untrusted port and are dropped. PC1 does not get an address. Note: Fix it with ip dhcp snooping trust.

![Breakit-1](image_2.png)

4. Start a DHCP server on ATK (G0/3) that offers addresses from 192.168.10.0/24 with ATK as the gateway. Renew the address on PC2. — The offers from ATK are dropped because they arrive on an untrusted port. PC2 only gets an address from R1.

![Breakit-2](image_3.png)

![Breakit-2.1](image_4.png)
