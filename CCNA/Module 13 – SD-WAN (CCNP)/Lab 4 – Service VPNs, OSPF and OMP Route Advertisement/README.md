## Lab 4 - Service VPNs, OSPF and OMP Route Advertisement

> **GNS3 Project:** [`Module 9 - SD-WAN (CCNP) | Lab 4 - Service VPNs, OSPF and OMP Route Advertisement.gns3`](./Module%209%20-%20SD-WAN%20%28CCNP%29%20%7C%20Lab%204%20-%20Service%20VPNs%2C%20OSPF%20and%20OMP%20Route%20Advertisement.gns3)

![topology](topology.png)

## Scenario
Configure the service VPN 10 on vEdge2 and vEdge3 with their LAN interfaces (PC2 is 192.168.2.11 and PC3 is 192.168.3.11). Advertise the connected networks into OMP.

- **Devices:** PC-BR1 (PC), PC-BR2 (PC), PC-HQ (PC), R-HQ (IOU L3), SW-INET (Ethernet Switch), SW-MPLS (Ethernet Switch), vBond (IOU L3), vEdge1 (IOU L3), vEdge2 (IOU L3), vEdge3 (IOU L3), vManage (IOU L3), vSmart (IOU L3)
- **Base Addressing:**
  - `vManage` Ethernet0/0: `100.64.0.11` (255.255.255.0)
  - `vManage` Loopback0: `10.255.0.1` (255.255.255.255)
  - `vSmart` Ethernet0/0: `100.64.0.13` (255.255.255.0)
  - `vSmart` Loopback0: `10.255.0.3` (255.255.255.255)
  - `vEdge3` Ethernet0/0: `100.64.3.2` (255.255.255.0)
  - `vEdge3` Ethernet0/1: `100.65.3.2` (255.255.255.0)
  - `vEdge3` Ethernet0/2: `192.168.3.1` (255.255.255.0)
  - `vEdge3` Loopback0: `10.255.3.1` (255.255.255.255)
  - `R-HQ` Ethernet0/0: `192.168.100.2` (255.255.255.252)
  - `R-HQ` Ethernet0/1: `192.168.1.1` (255.255.255.0)
  - `vBond` Ethernet0/0: `100.64.0.12` (255.255.255.0)
  - `vBond` Loopback0: `10.255.0.2` (255.255.255.255)
  - `vEdge2` Ethernet0/0: `100.64.2.2` (255.255.255.0)
  - `vEdge2` Ethernet0/1: `100.65.2.2` (255.255.255.0)
  - `vEdge2` Ethernet0/2: `192.168.2.1` (255.255.255.0)
  - `vEdge2` Loopback0: `10.255.2.1` (255.255.255.255)
  - `vEdge1` Ethernet0/0: `100.64.1.2` (255.255.255.0)
  - `vEdge1` Ethernet0/1: `100.65.1.2` (255.255.255.0)
  - `vEdge1` Ethernet0/2: `192.168.100.1` (255.255.255.252)
  - `vEdge1` Loopback0: `10.255.1.1` (255.255.255.255)
  - `PC-HQ` Ethernet0: `192.168.1.11` (GW: 192.168.1.1)
  - `PC-BR1` Ethernet0: `192.168.2.11` (GW: 192.168.2.1)
  - `PC-BR2` Ethernet0: `192.168.3.11` (GW: 192.168.3.1)

Task 1 - Configure the service VPN 10 on vEdge2 and vEdge3 with their LAN interfaces (PC2 is 192.168.2.11 and PC3 is 192.168.3.11).
  - Advertise the connected networks into OMP.

Task 2 - At the HQ, configure OSPF area 0 in VPN 10 between vEdge1 and R-HQ.
  - Advertise the OMP routes into OSPF and the OSPF routes into OMP.

Task 3 - Verify the routes on vSmart and on vEdge2, and the connectivity between the sites.

## Action
Task 1 - Configure the service VPN 10 on vEdge2 and vEdge3 with their LAN interfaces (PC2 is 192.168.2.11 and PC3 is 192.168.3.11).

**vEdge2:**
```cisco
vpn 10
interface ge0/2
ip address 192.168.2.1/24
no shutdown
omp
advertise connected
```

**vEdge3:**
```cisco
vpn 10
interface ge0/2
ip address 192.168.3.1/24
no shutdown
omp
advertise connected
```

Task 2 - At the HQ, configure OSPF area 0 in VPN 10 between vEdge1 and R-HQ.

**vEdge1:**
```cisco
vpn 10
interface ge0/2
ip address 192.168.100.1/30
no shutdown
router
ospf
router-id 10.255.1.1
redistribute omp
area 0
interface ge0/2
exit
exit
omp
advertise ospf external
```

**R-HQ:**
```cisco
router ospf 1
network 192.168.100.0 0.0.0.3 area 0
network 192.168.1.0 0.0.0.255 area 0
```

Task 3 - Verify the routes on vSmart and on vEdge2, and the connectivity between the sites.

## Note
1. Verification commands: `Show omp routes`, `Show ip route vpn 10`
2. The networks 192.168.1.0/24, 192.168.2.0/24 and 192.168.3.0/24 should be listed.
3. The networks 192.168.1.0/24 and 192.168.3.0/24 should be learned through OMP. PC2: Ping 192.168.3.11
4. The ping should succeed.
5. On vEdge3, remove advertise connected from OMP. Ping PC3 from PC2. vEdge3 — The network 192.168.3.0/24 is no longer advertised, so the other sites cannot reach PC3. Note: Fix it with advertise connected.
6. On vEdge1, remove redistribute omp from OSPF. Ping PC2 from PC1. vEdge1 — R-HQ no longer learns the branch networks. PC1 cannot reach the branches. Note: Fix it with redistribute omp.