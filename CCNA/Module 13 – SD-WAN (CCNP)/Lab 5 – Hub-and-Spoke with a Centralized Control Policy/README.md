## Lab 5 - Hub-and-Spoke with a Centralized Control Policy

> **GNS3 Project:** [`Module 9 - SD-WAN (CCNP) | Lab 5 - Hub-and-Spoke with a Centralized Control Policy.gns3`](./Module%209%20-%20SD-WAN%20%28CCNP%29%20%7C%20Lab%205%20-%20Hub-and-Spoke%20with%20a%20Centralized%20Control%20Policy.gns3)

![topology](topology.png)

## Scenario
HQ (site 1) is the hub and the branches (sites 2 and 3) are the spokes. On vSmart, create a site list for the spokes, a TLOC list for the hub (10.255.1.1, color biz-internet) and a prefix list that matches all routes.

- **Devices:** PC-BR1 (PC), PC-BR2 (PC), PC-HQ (PC), R-HQ (IOU L3), SW-INET (Ethernet Switch), SW-MPLS (Ethernet Switch), vBond (IOU L3), vEdge1 (IOU L3), vEdge2 (IOU L3), vEdge3 (IOU L3), vManage (IOU L3), vSmart (IOU L3)
- **Base Addressing:**
  - `vBond` Ethernet0/0: `100.64.0.12` (255.255.255.0)
  - `vBond` Loopback0: `10.255.0.2` (255.255.255.255)
  - `vEdge2` Ethernet0/0: `100.64.2.2` (255.255.255.0)
  - `vEdge2` Ethernet0/1: `100.65.2.2` (255.255.255.0)
  - `vEdge2` Ethernet0/2: `192.168.2.1` (255.255.255.0)
  - `vEdge2` Loopback0: `10.255.2.1` (255.255.255.255)
  - `R-HQ` Ethernet0/0: `192.168.100.2` (255.255.255.252)
  - `R-HQ` Ethernet0/1: `192.168.1.1` (255.255.255.0)
  - `vSmart` Ethernet0/0: `100.64.0.13` (255.255.255.0)
  - `vSmart` Loopback0: `10.255.0.3` (255.255.255.255)
  - `vEdge1` Ethernet0/0: `100.64.1.2` (255.255.255.0)
  - `vEdge1` Ethernet0/1: `100.65.1.2` (255.255.255.0)
  - `vEdge1` Ethernet0/2: `192.168.100.1` (255.255.255.252)
  - `vEdge1` Loopback0: `10.255.1.1` (255.255.255.255)
  - `vEdge3` Ethernet0/0: `100.64.3.2` (255.255.255.0)
  - `vEdge3` Ethernet0/1: `100.65.3.2` (255.255.255.0)
  - `vEdge3` Ethernet0/2: `192.168.3.1` (255.255.255.0)
  - `vEdge3` Loopback0: `10.255.3.1` (255.255.255.255)
  - `vManage` Ethernet0/0: `100.64.0.11` (255.255.255.0)
  - `vManage` Loopback0: `10.255.0.1` (255.255.255.255)
  - `PC-HQ` Ethernet0: `192.168.1.11` (GW: 192.168.1.1)
  - `PC-BR1` Ethernet0: `192.168.2.11` (GW: 192.168.2.1)
  - `PC-BR2` Ethernet0: `192.168.3.11` (GW: 192.168.3.1)

Task 1 - HQ (site 1) is the hub and the branches (sites 2 and 3) are the spokes.
  - On vSmart, create a site list for the spokes, a TLOC list for the hub (10.255.1.1, color biz-internet) and a prefix list that matches all routes.

Task 2 - Create the control policy HUB-AND-SPOKE that sets the TLOC of all routes sent to the spokes to the TLOC of the hub, so that traffic between the spokes goes through the HQ.
  - Configure on vSmart

Task 3 - Apply the policy outbound to the spokes and activate it.
  - Verify the next hop of the routes on vEdge2.

## Action
Task 1 - HQ (site 1) is the hub and the branches (sites 2 and 3) are the spokes.

**vSmart:**
```cisco
policy
lists
site-list SPOKES
site-id 2-3
!
tloc-list HUB-TLOCS
tloc 10.255.1.1 color biz-internet encap ipsec
!
prefix-list ALL-ROUTES
ip-prefix 0.0.0.0/0 le 32
```

Task 2 - Create the control policy HUB-AND-SPOKE that sets the TLOC of all routes sent to the spokes to the TLOC of the hub, so that traffic between the spokes goes through the HQ.

**vSmart:**
```cisco
policy
control-policy HUB-AND-SPOKE
sequence 10
match route
prefix-list ALL-ROUTES
!
action accept
set
tloc-list HUB-TLOCS
!
!
default-action accept
```

Task 3 - Apply the policy outbound to the spokes and activate it.

**vSmart:**
```cisco
apply-policy
site-list SPOKES
control-policy HUB-AND-SPOKE out
```

## Note
1. Verification commands: `Show omp routes 192.168.3.0/24`
2. The route should use the TLOC of the hub (10.255.1.1) instead of the TLOC of vEdge3 (10.255.3.1).
3. On vSmart, apply the control policy inbound instead of outbound. vSmart — The policy now changes the routes received from the spokes. The routes sent to the spokes still point to the TLOCs of the other spokes. Note: Apply the policy with the direction out to fix it.