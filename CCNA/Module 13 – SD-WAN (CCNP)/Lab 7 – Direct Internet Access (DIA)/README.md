## Lab 7 - Direct Internet Access (DIA)

> **GNS3 Project:** [`Module 9 - SD-WAN (CCNP) | Lab 7 - Direct Internet Access (DIA).gns3`](./Module%209%20-%20SD-WAN%20%28CCNP%29%20%7C%20Lab%207%20-%20Direct%20Internet%20Access%20%28DIA%29.gns3)

![topology](topology.png)

## Scenario
Branch 1 users must reach the Internet directly through the INET transport. Enable NAT on the INET interface of vEdge2 in VPN 0.

- **Devices:** PC-BR1 (PC), PC-BR2 (PC), PC-HQ (PC), R-HQ (IOU L3), SW-INET (Ethernet Switch), SW-MPLS (Ethernet Switch), vBond (IOU L3), vEdge1 (IOU L3), vEdge2 (IOU L3), vEdge3 (IOU L3), vManage (IOU L3), vSmart (IOU L3)
- **Base Addressing:**
  - `R-HQ` Ethernet0/0: `192.168.100.2` (255.255.255.252)
  - `R-HQ` Ethernet0/1: `192.168.1.1` (255.255.255.0)
  - `vEdge2` Ethernet0/0: `100.64.2.2` (255.255.255.0)
  - `vEdge2` Ethernet0/1: `100.65.2.2` (255.255.255.0)
  - `vEdge2` Ethernet0/2: `192.168.2.1` (255.255.255.0)
  - `vEdge2` Loopback0: `10.255.2.1` (255.255.255.255)
  - `vBond` Ethernet0/0: `100.64.0.12` (255.255.255.0)
  - `vBond` Loopback0: `10.255.0.2` (255.255.255.255)
  - `vEdge1` Ethernet0/0: `100.64.1.2` (255.255.255.0)
  - `vEdge1` Ethernet0/1: `100.65.1.2` (255.255.255.0)
  - `vEdge1` Ethernet0/2: `192.168.100.1` (255.255.255.252)
  - `vEdge1` Loopback0: `10.255.1.1` (255.255.255.255)
  - `vEdge3` Ethernet0/0: `100.64.3.2` (255.255.255.0)
  - `vEdge3` Ethernet0/1: `100.65.3.2` (255.255.255.0)
  - `vEdge3` Ethernet0/2: `192.168.3.1` (255.255.255.0)
  - `vEdge3` Loopback0: `10.255.3.1` (255.255.255.255)
  - `vSmart` Ethernet0/0: `100.64.0.13` (255.255.255.0)
  - `vSmart` Loopback0: `10.255.0.3` (255.255.255.255)
  - `vManage` Ethernet0/0: `100.64.0.11` (255.255.255.0)
  - `vManage` Loopback0: `10.255.0.1` (255.255.255.255)
  - `PC-BR2` Ethernet0: `192.168.3.11` (GW: 192.168.3.1)
  - `PC-HQ` Ethernet0: `192.168.1.11` (GW: 192.168.1.1)
  - `PC-BR1` Ethernet0: `192.168.2.11` (GW: 192.168.2.1)

Task 1 - Branch 1 users must reach the Internet directly through the INET transport.
  - Enable NAT on the INET interface of vEdge2 in VPN 0.

Task 2 - Create a default route in the service VPN 10 of vEdge2 that points to VPN 0.
  - Configure on vEdge2

Task 3 - Verify the default route on vEdge2 and ping an Internet address from PC2.

## Action
Task 1 - Branch 1 users must reach the Internet directly through the INET transport.

**vEdge2:**
```cisco
vpn 0
interface ge0/0
nat
!
!
```

Task 2 - Create a default route in the service VPN 10 of vEdge2 that points to VPN 0.

**vEdge2:**
```cisco
vpn 10
ip route 0.0.0.0/0 vpn 0
```

Task 3 - Verify the default route on vEdge2 and ping an Internet address from PC2.

## Note
1. Verification commands: `Show ip route vpn 10`, `Ping 198.51.100.1`
2. The default route 0.0.0.0/0 should point to VPN 0.
3. The ping should succeed.
4. On vEdge2, remove NAT from ge0/0. Ping the Internet address from PC2. vEdge2 — The private source address leaves the router without translation, so the replies do not return. Note: Fix it with nat.