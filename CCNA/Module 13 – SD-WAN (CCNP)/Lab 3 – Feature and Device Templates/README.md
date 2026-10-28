## Lab 3 - Feature and Device Templates

> **GNS3 Project:** [`Module 9 - SD-WAN (CCNP) | Lab 3 - Feature and Device Templates.gns3`](./Module%209%20-%20SD-WAN%20%28CCNP%29%20%7C%20Lab%203%20-%20Feature%20and%20Device%20Templates.gns3)

![topology](topology.png)

## Scenario
Create the feature templates for the branch devices in vManage: a System template, a VPN 0 template, two VPN Interface templates (INET with color biz-internet and MPLS with color mpls), a VPN 10 template and a VPN Interface template for the LAN. Use device-specific variables for the values that differ per site.

- **Devices:** PC-BR1 (PC), PC-BR2 (PC), PC-HQ (PC), R-HQ (IOU L3), SW-INET (Ethernet Switch), SW-MPLS (Ethernet Switch), vBond (IOU L3), vEdge1 (IOU L3), vEdge2 (IOU L3), vEdge3 (IOU L3), vManage (IOU L3), vSmart (IOU L3)
- **Base Addressing:**
  - `R-HQ` Ethernet0/0: `192.168.100.2` (255.255.255.252)
  - `R-HQ` Ethernet0/1: `192.168.1.1` (255.255.255.0)
  - `vBond` Ethernet0/0: `100.64.0.12` (255.255.255.0)
  - `vBond` Loopback0: `10.255.0.2` (255.255.255.255)
  - `vEdge1` Ethernet0/0: `100.64.1.2` (255.255.255.0)
  - `vEdge1` Ethernet0/1: `100.65.1.2` (255.255.255.0)
  - `vEdge1` Ethernet0/2: `192.168.100.1` (255.255.255.252)
  - `vEdge1` Loopback0: `10.255.1.1` (255.255.255.255)
  - `vEdge2` Ethernet0/0: `100.64.2.2` (255.255.255.0)
  - `vEdge2` Ethernet0/1: `100.65.2.2` (255.255.255.0)
  - `vEdge2` Ethernet0/2: `192.168.2.1` (255.255.255.0)
  - `vEdge2` Loopback0: `10.255.2.1` (255.255.255.255)
  - `vEdge3` Ethernet0/0: `100.64.3.2` (255.255.255.0)
  - `vEdge3` Ethernet0/1: `100.65.3.2` (255.255.255.0)
  - `vEdge3` Ethernet0/2: `192.168.3.1` (255.255.255.0)
  - `vEdge3` Loopback0: `10.255.3.1` (255.255.255.255)
  - `vManage` Ethernet0/0: `100.64.0.11` (255.255.255.0)
  - `vManage` Loopback0: `10.255.0.1` (255.255.255.255)
  - `vSmart` Ethernet0/0: `100.64.0.13` (255.255.255.0)
  - `vSmart` Loopback0: `10.255.0.3` (255.255.255.255)
  - `PC-HQ` Ethernet0: `192.168.1.11` (GW: 192.168.1.1)
  - `PC-BR2` Ethernet0: `192.168.3.11` (GW: 192.168.3.1)
  - `PC-BR1` Ethernet0: `192.168.2.11` (GW: 192.168.2.1)

Task 1 - Create the feature templates for the branch devices in vManage: a System template, a VPN 0 template, two VPN Interface templates (INET with color biz-internet and MPLS with color mpls), a VPN 10 template and a VPN Interface template for the LAN.
  - Use device-specific variables for the values that differ per site.

Task 2 - Create the device template BRANCH-DEVICE from the feature templates and attach it to vEdge2.
  - Enter the device-specific values: hostname vEdge2, system IP 10.255.2.1, site ID 2, INET 100.64.2.2/24 (gateway 100.64.2.1), MPLS 100.65.2.2/24 (gateway 100.65.2.1) and LAN 192.168.2.1/24.

Task 3 - Verify that the template was pushed and that the control connections are up.
  - Configure on vManage (GUI)

## Action
Task 1 - Create the feature templates for the branch devices in vManage: a System template, a VPN 0 template, two VPN Interface templates (INET with color biz-internet and MPLS with color mpls), a VPN 10 template and a VPN Interface template for the LAN.

**vManage (GUI):**
```cisco
Configuration > Templates > Feature > Add Template
Device Model: vEdge Cloud
Cisco System: SYSTEM-BRANCH
Hostname, System IP and Site ID: device specific
Cisco VPN: VPN0-BRANCH (VPN 0)
IPv4 Route: 0.0.0.0/0, next hop: device specific
Cisco VPN Interface Ethernet: VPN0-INET
Interface: ge0/0, Tunnel Interface: On, Color: biz-internet
Cisco VPN Interface Ethernet: VPN0-MPLS
Interface: ge0/1, Tunnel Interface: On, Color: mpls
Cisco VPN: VPN10-BRANCH (VPN 10)
Cisco VPN Interface Ethernet: VPN10-LAN
Interface: ge0/2, IPv4 Address: device specific
```

Task 2 - Create the device template BRANCH-DEVICE from the feature templates and attach it to vEdge2.

**vManage (GUI):**
```cisco
Configuration > Templates > Device > Create Template > From Feature Template
Device Model: vEdge Cloud
Template Name: BRANCH-DEVICE
Add SYSTEM-BRANCH, VPN0-BRANCH, VPN0-INET, VPN0-MPLS, VPN10-BRANCH and
VPN10-LAN
Attach Devices > vEdge2
Enter the device-specific values
Configure Devices
```

Task 3 - Verify that the template was pushed and that the control connections are up.

**vManage (GUI):**
```cisco
Configuration > Devices
```

## Note
1. Verification commands: `Show control connections`
2. The vEdge2 configuration status should be In Sync.
3. The connections to vBond, vSmart and vManage should be in the up state.
4. Push the template again with the INET gateway of vEdge2 set to 100.64.2.254. Check vManage and the control connections of vEdge2. — The gateway does not exist, so vEdge2 loses its control connections. The configuration push fails or is rolled back. Note: Fix it by entering 100.64.2.1 again.