## Lab 3 - Subnetting and VLSM Design

> **GNS3 Project:** [`Module 2 - IP Connectivity (CCNA) | Lab 3 - Subnetting and VLSM Design.gns3`](./Module%202%20-%20IP%20Connectivity%20%28CCNA%29%20%7C%20Lab%203%20-%20Subnetting%20and%20VLSM%20Design.gns3)

![topo](image.png)

## Scenario
The address space 192.168.50.0/24 must be divided into four subnets: LAN A (100 hosts), LAN B (50 hosts), LAN C (20 hosts) and the WAN link between R1 and R2. Allocate the subnets from the largest to the smallest. Calculate the network address, the mask and the usable range of each subnet. Answer LAN A: 192.168.50.0/25 (255.255.255.128) Hosts: .1 - .126, broadcast .127 LAN B: 192.168.50.128/26 (255.255.255.192) Hosts: .129 - .190, broadcast .191 LAN C: 192.168.50.192/27 (255.255.255.224) Hosts: .193 - .222, broadcast .223 WAN: 192.168.50.224/30 (255.255.255.252) Hosts: .225 - .226, broadcast .227

- **Devices:** PCA (PC), PCB (PC), PCC (PC), R1 (IOU L3), R2 (IOU L3)
- **Base Addressing:**
  - `R2` Ethernet0/0: `192.168.50.226` (255.255.255.252)
  - `R2` Ethernet0/1: `192.168.50.193` (255.255.255.224)
  - `R1` Ethernet0/0: `192.168.50.225` (255.255.255.252)
  - `R1` Ethernet0/1: `192.168.50.1` (255.255.255.128)
  - `R1` Ethernet0/2: `192.168.50.129` (255.255.255.192)
  - `PCC` Ethernet0: `192.168.50.200` (GW: 192.168.50.193)
  - `PCB` Ethernet0: `192.168.50.135` (GW: 192.168.50.129)
  - `PCA` Ethernet0: `192.168.50.10` (GW: 192.168.50.1)

Task 1 - The address space 192.168.50.0/24 must be divided into four subnets: LAN A (100 hosts), LAN B (50 hosts), LAN C (20 hosts) and the WAN link between R1 and R2.
  - Allocate the subnets from the largest to the smallest.
  - Calculate the network address, the mask and the usable range of each subnet.
  - Answer LAN A: 192.168.50.0/25 (255.255.255.128) Hosts: .1 - .126, broadcast .127 LAN B: 192.168.50.128/26 (255.255.255.192) Hosts: .129 - .190, broadcast .191 LAN C: 192.168.50.192/27 (255.255.255.224) Hosts: .193 - .222, broadcast .223 WAN: 192.168.50.224/30 (255.255.255.252) Hosts: .225 - .226, broadcast .227

Task 2 - Configure the router interfaces.
  - Every router uses the first usable address of its LAN.
  - On the WAN link, R1 uses the first and R2 the second usable address.

Task 3 - Configure static routing so that all LANs can reach each other and verify the connectivity from PCA to PCC.
  - Configure on R1

## Action
Task 1 - The address space 192.168.50.0/24 must be divided into four subnets: LAN A (100 hosts), LAN B (50 hosts), LAN C (20 hosts) and the WAN link between R1 and R2.

Task 2 - Configure the router interfaces.

**R1:**
```cisco
interface Ethernet0/0
ip address 192.168.50.225 255.255.255.252
no shutdown
interface Ethernet0/1
ip address 192.168.50.1 255.255.255.128
no shutdown
interface Ethernet0/2
ip address 192.168.50.129 255.255.255.192
no shutdown
```

**R2:**
```cisco
interface Ethernet0/0
ip address 192.168.50.226 255.255.255.252
no shutdown
interface Ethernet0/1
ip address 192.168.50.193 255.255.255.224
no shutdown
```

Task 3 - Configure static routing so that all LANs can reach each other and verify the connectivity from PCA to PCC.

**R1:**
```cisco
ip route 192.168.50.192 255.255.255.224 192.168.50.226
```
**R2:**
```cisco
ip route 192.168.50.0 255.255.255.0 192.168.50.225
```
**PCA ping PCC:**

![Task-3](image_1.png)

## Note
1. Classful vs VLSM
  - Classful legacy fix block size.
  - VLSM flexible block size, e.g., /24 = /25 + /25 = /25 + (/26 + /26) = ...
2. On R2, change the mask of E0/1 to 255.255.255.0. Check the interface. R2 — The router rejects the command and reports that the address overlaps with another interface (Ethernet0/0). 

![Breakit-1](image_2.png)

Subnets on a router must not overlap. Note: Use the mask 255.255.255.224.
