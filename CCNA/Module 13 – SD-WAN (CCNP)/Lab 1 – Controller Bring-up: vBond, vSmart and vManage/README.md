## Lab 1 - Controller Bring-up: vBond, vSmart and vManage

> **GNS3 Project:** [`Module 9 - SD-WAN (CCNP) | Lab 1 - Controller Bring-up: vBond, vSmart and vManage.gns3`](./Module%209%20-%20SD-WAN%20%28CCNP%29%20%7C%20Lab%201%20-%20Controller%20Bring-up%3A%20vBond%2C%20vSmart%20and%20vManage.gns3)

![topology](topology.png)

## Scenario
Configure the vBond controller. Use the system IP address 10.255.0.2, site ID 100 and the organization name LAB-ORG. The vBond role is local. Configure VPN 0 with the tunnel interface and a default route.

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
  - `vEdge3` Ethernet0/0: `100.64.3.2` (255.255.255.0)
  - `vEdge3` Ethernet0/1: `100.65.3.2` (255.255.255.0)
  - `vEdge3` Ethernet0/2: `192.168.3.1` (255.255.255.0)
  - `vEdge3` Loopback0: `10.255.3.1` (255.255.255.255)
  - `vSmart` Ethernet0/0: `100.64.0.13` (255.255.255.0)
  - `vSmart` Loopback0: `10.255.0.3` (255.255.255.255)
  - `R-HQ` Ethernet0/0: `192.168.100.2` (255.255.255.252)
  - `R-HQ` Ethernet0/1: `192.168.1.1` (255.255.255.0)
  - `vEdge2` Ethernet0/0: `100.64.2.2` (255.255.255.0)
  - `vEdge2` Ethernet0/1: `100.65.2.2` (255.255.255.0)
  - `vEdge2` Ethernet0/2: `192.168.2.1` (255.255.255.0)
  - `vEdge2` Loopback0: `10.255.2.1` (255.255.255.255)
  - `PC-BR1` Ethernet0: `192.168.2.11` (GW: 192.168.2.1)
  - `PC-HQ` Ethernet0: `192.168.1.11` (GW: 192.168.1.1)
  - `PC-BR2` Ethernet0: `192.168.3.11` (GW: 192.168.3.1)

Task 1 - Configure the vBond controller.
  - Use the system IP address 10.255.0.2, site ID 100 and the organization name LAB-ORG.
  - The vBond role is local.
  - Configure VPN 0 with the tunnel interface and a default route.

Task 2 - Configure vSmart and vManage with the same organization name and the vBond address 100.64.0.12.
  - Use the system IP addresses 10.255.0.3 (vSmart) and 10.255.0.1 (vManage) and site ID 100.

Task 3 - In vManage, set the organization name and the vBond address, add vBond and vSmart as controllers and install their certificates.
  - Then verify the control connections on vSmart.

## Action
Task 1 - Configure the vBond controller.

**vBond:**
```cisco
system
host-name vBond
system-ip 10.255.0.2
site-id 100
organization-name LAB-ORG
vbond 100.64.0.12 local
vpn 0
interface ge0/0
ip address 100.64.0.12/24
tunnel-interface
encapsulation ipsec
no shutdown
ip route 0.0.0.0/0 100.64.0.1
```

Task 2 - Configure vSmart and vManage with the same organization name and the vBond address 100.64.0.12.

**vSmart:**
```cisco
system
host-name vSmart
system-ip 10.255.0.3
site-id 100
organization-name LAB-ORG
vbond 100.64.0.12
vpn 0
interface ge0/0
ip address 100.64.0.13/24
tunnel-interface
encapsulation ipsec
no shutdown
ip route 0.0.0.0/0 100.64.0.1
```

**vManage:**
```cisco
system
host-name vManage
system-ip 10.255.0.1
site-id 100
organization-name LAB-ORG
vbond 100.64.0.12
vpn 0
interface ge0/0
ip address 100.64.0.11/24
tunnel-interface
encapsulation ipsec
no shutdown
ip route 0.0.0.0/0 100.64.0.1
```

Task 3 - In vManage, set the organization name and the vBond address, add vBond and vSmart as controllers and install their certificates.

**vManage (GUI):**
```cisco
Administration > Settings
Organization Name: LAB-ORG
vBond: 100.64.0.12
```

**vSmart:**
```cisco
Configuration > Devices > Controllers > Add
Controller > vBond
vBond Management IP Address: 100.64.0.12
Username / Password: admin
Generate CSR: checked
Configuration > Devices > Controllers > Add
Controller > vSmart
vSmart Management IP Address: 100.64.0.13
Username / Password: admin
Generate CSR: checked
Configuration > Certificates > Controllers
Install the certificate for vBond and vSmart
```

## Note
1. Verification commands: `Show control connections`
2. The connections to vBond and vManage should be in the up state.
3. On vSmart, change the organization name to WRONG-ORG. Check the control connections. — The organization name no longer matches the certificate and the other controllers. The control connections do not come up. Note: Fix it with organization-name LAB-ORG.
4. On vSmart, change the vBond address to 100.64.0.99. Check the control connections. — vSmart cannot reach the vBond controller, so it cannot start any control connection. Note: Fix it with vbond 100.64.0.12.