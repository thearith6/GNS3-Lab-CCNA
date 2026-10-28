## Lab 2 - Onboarding WAN Edges

> **GNS3 Project:** [`Module 9 - SD-WAN (CCNP) | Lab 2 - Onboarding WAN Edges.gns3`](./Module%209%20-%20SD-WAN%20%28CCNP%29%20%7C%20Lab%202%20-%20Onboarding%20WAN%20Edges.gns3)

![topology](topology.png)

## Scenario
Configure vEdge1 with the system IP address 10.255.1.1, site ID 1 and the organization name LAB-ORG. In VPN 0, bring up ge0/0 (INET, color biz-internet) and ge0/1 (MPLS, color mpls) with tunnel interfaces and default routes.

- **Devices:** PC-BR1 (PC), PC-BR2 (PC), PC-HQ (PC), R-HQ (IOU L3), SW-INET (Ethernet Switch), SW-MPLS (Ethernet Switch), vBond (IOU L3), vEdge1 (IOU L3), vEdge2 (IOU L3), vEdge3 (IOU L3), vManage (IOU L3), vSmart (IOU L3)
- **Base Addressing:**
  - `vEdge1` Ethernet0/0: `100.64.1.2` (255.255.255.0)
  - `vEdge1` Ethernet0/1: `100.65.1.2` (255.255.255.0)
  - `vEdge1` Ethernet0/2: `192.168.100.1` (255.255.255.252)
  - `vEdge1` Loopback0: `10.255.1.1` (255.255.255.255)
  - `vManage` Ethernet0/0: `100.64.0.11` (255.255.255.0)
  - `vManage` Loopback0: `10.255.0.1` (255.255.255.255)
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
  - `vEdge3` Ethernet0/0: `100.64.3.2` (255.255.255.0)
  - `vEdge3` Ethernet0/1: `100.65.3.2` (255.255.255.0)
  - `vEdge3` Ethernet0/2: `192.168.3.1` (255.255.255.0)
  - `vEdge3` Loopback0: `10.255.3.1` (255.255.255.255)
  - `PC-HQ` Ethernet0: `192.168.1.11` (GW: 192.168.1.1)
  - `PC-BR2` Ethernet0: `192.168.3.11` (GW: 192.168.3.1)
  - `PC-BR1` Ethernet0: `192.168.2.11` (GW: 192.168.2.1)

Task 1 - Configure vEdge1 with the system IP address 10.255.1.1, site ID 1 and the organization name LAB-ORG.
  - In VPN 0, bring up ge0/0 (INET, color biz-internet) and ge0/1 (MPLS, color mpls) with tunnel interfaces and default routes.

Task 2 - Add the WAN edge to vManage.
  - Upload the WAN edge list, validate the device and send the list to the controllers.
  - Then activate the device with its chassis number and token.

Task 3 - Verify the control connections and the OMP session on vEdge1.

## Action
Task 1 - Configure vEdge1 with the system IP address 10.255.1.1, site ID 1 and the organization name LAB-ORG.

**vEdge1:**
```cisco
system
host-name vEdge1
system-ip 10.255.1.1
site-id 1
organization-name LAB-ORG
vbond 100.64.0.12
vpn 0
interface ge0/0
ip address 100.64.1.2/24
tunnel-interface
encapsulation ipsec
color biz-internet
allow-service icmp
no shutdown
interface ge0/1
ip address 100.65.1.2/24
tunnel-interface
encapsulation ipsec
color mpls restrict
allow-service icmp
no shutdown
ip route 0.0.0.0/0 100.64.1.1
ip route 0.0.0.0/0 100.65.1.1
```

Task 2 - Add the WAN edge to vManage.

**vManage (GUI):**
```cisco
Configuration > Devices > WAN Edge List
Upload WAN Edge List
Select vEdge1 and set the state to Valid
```

**vEdge1:**
```cisco
request vedge-cloud activate chassis-number
<chassis> token <token>
```

Task 3 - Verify the control connections and the OMP session on vEdge1.

## Note
1. Verification commands: `Show control connections`
2. The connections to vBond, vSmart and vManage should be in the up state. Show omp peers
3. The peer 10.255.0.3 (vSmart) should be in the up state.
4. On vEdge1, remove the default route in VPN 0 that points to 100.64.1.1. Check the control connections. — The controllers are reachable only through the INET transport. All control connections go down. Note: Fix it with ip route 0.0.0.0/0 100.64.1.1.