## Lab 3 - Route Maps and Policy-Based Routing

> **GNS3 Project:** [`Module 8 - Advanced Routing (CCNP) | Lab 3 - PBR.gns3`](./Module%208%20-%20Advanced%20Routing%20%28CCNP%29%20%7C%20Lab%203%20-%20PBR.gns3)

![topology](topology.png)

## Scenario
Configure the routing so that R1 can reach the loopback of R4 through R2, and R4 can answer through both R2 and R3.

- **Devices:** PC1 (PC), PC2 (PC), R1 (IOU L3), R2 (IOU L3), R3 (IOU L3), R4 (IOU L3), SW1 (Ethernet Switch)
- **Base Addressing:**
  - `R3` Ethernet0/0: `10.0.13.2` (255.255.255.252)
  - `R3` Ethernet0/1: `10.0.34.1` (255.255.255.252)
  - `R1` Ethernet0/0: `10.0.12.1` (255.255.255.252)
  - `R1` Ethernet0/1: `10.0.13.1` (255.255.255.252)
  - `R1` Ethernet0/2: `192.168.10.1` (255.255.255.0)
  - `R2` Ethernet0/0: `10.0.12.2` (255.255.255.252)
  - `R2` Ethernet0/1: `10.0.24.1` (255.255.255.252)
  - `R4` Ethernet0/0: `10.0.24.2` (255.255.255.252)
  - `R4` Ethernet0/1: `10.0.34.2` (255.255.255.252)
  - `R4` Loopback0: `198.51.100.1` (255.255.255.255)
  - `PC1` Ethernet0: `192.168.10.11` (GW: 192.168.10.1)
  - `PC2` Ethernet0: `192.168.10.12` (GW: 192.168.10.1)

Task 1 - Configure the routing so that R1 can reach the loopback of R4 through R2, and R4 can answer through both R2 and R3.
  - Configure on R1

Task 2 - The traffic of PC1 (192.168.10.11) must leave through R3.
  - All other traffic keeps following the routing table.
  - Configure policy-based routing on the LAN interface of R1.

Task 3 - Verify the path of PC1 and PC2.
  - Configure on PC1

## Action
Task 1 - Configure the routing so that R1 can reach the loopback of R4 through R2, and R4 can answer through both R2 and R3.

**R1:**
```cisco
ip route 0.0.0.0 0.0.0.0 10.0.12.2
ip route 198.51.100.1 255.255.255.255 10.0.24.2
ip route 192.168.10.0 255.255.255.0 10.0.12.1
ip route 198.51.100.1 255.255.255.255 10.0.34.2
ip route 192.168.10.0 255.255.255.0 10.0.13.1
ip route 192.168.10.0 255.255.255.0 10.0.24.1
ip route 192.168.10.0 255.255.255.0 10.0.34.1
```

Task 2 - The traffic of PC1 (192.168.10.11) must leave through R3.

**R1:**
```cisco
ip access-list extended PC1-ONLY
permit ip host 192.168.10.11 any
route-map PBR permit 10
match ip address PC1-ONLY
set ip next-hop 10.0.13.2
route-map PBR permit 20
interface Ethernet0/2
ip policy route-map PBR
```

Task 3 - Verify the path of PC1 and PC2.

**PC1:**
```cisco
Traceroute 198.51.100.1
```

## Note
1. The second hop should be 10.0.13.2 (R3). PC2 Traceroute 198.51.100.1
2. The second hop should be 10.0.12.2 (R2). R1 Show route-map PBR
3. The counter of the policy routing matches for sequence 10 should increase.
4. On R1, remove the policy from E 0/2 and apply it on E 0/0. Trace the path of PC1. R1 — A policy only affects the packets that enter the interface where it is applied. PC1 uses R2 again. Note: Apply the policy on E 0/2 to fix it.
5. In the route-map PBR, change the next hop to 10.0.13.9. Trace the path of PC1. R1 — The next hop is not reachable, so R1 ignores the policy and uses the routing table. PC1 goes through R2. Note: Fix it with the next hop 10.0.13.2.