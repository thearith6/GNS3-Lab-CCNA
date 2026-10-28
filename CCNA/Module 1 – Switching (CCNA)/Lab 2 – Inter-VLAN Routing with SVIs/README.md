## Lab 2 - Inter-VLAN Routing with SVIs

> **GNS3 Project:** [`Module 1 - Switching (CCNA) | Lab 2 - Inter-VLAN Routing with SVIs.gns3`](./Module%201%20-%20Switching%20%28CCNA%29%20%7C%20Lab%202%20-%20Inter-VLAN%20Routing%20with%20SVIs.gns3)

![topo](image.png)

## Scenario
Create VLAN 10 and VLAN 20 on MLS1 and SW2. Configure the link between MLS1 and SW2 as an 802.1Q trunk and place the PC ports in their VLANs.

- **Devices:** MLS1 (IOU L2), PC1 (PC), PC2 (PC), PC3 (PC), PC4 (PC), R1 (IOU L3), SW2 (IOU L2)
- **Base Addressing:**
  - `PC3` Ethernet0: `172.16.10.12` (GW: 172.16.10.1)
  - `PC2` Ethernet0: `172.16.20.11` (GW: 172.16.20.1)
  - `PC4` Ethernet0: `172.16.20.12` (GW: 172.16.20.1)
  - `PC1` Ethernet0: `172.16.10.11` (GW: 172.16.10.1)

Task 1 - Create VLAN 10 and VLAN 20 on MLS1 and SW2.
  - Configure the link between MLS1 and SW2 as an 802.1Q trunk and place the PC ports in their VLANs.

Task 2 - Enable routing on MLS1 and create an SVI for each VLAN.
  - Use the first address of each subnet as the default gateway for the PCs.
  - Verify by pinging from PC1 to PC4.

Task 3 - Convert E 0/3 on MLS1 into a routed port towards R1 and add a default route on MLS1.
  - Add a static route on R1 so return traffic reaches the VLANs.

## Action
Task 1 - Create VLAN 10 and VLAN 20 on MLS1 and SW2.

**MLS1:**
```cisco
vlan 10
name ENGINEERING
vlan 20
name OPERATIONS
interface Ethernet0/0
switchport trunk encapsulation dot1q
switchport mode trunk
interface Ethernet0/1
switchport mode access
switchport access vlan 10
interface Ethernet0/2
switchport mode access
switchport access vlan 20
```

**SW2:**
```cisco
vlan 10
name ENGINEERING
vlan 20
name OPERATIONS
interface Ethernet0/0
switchport trunk encapsulation dot1q
switchport mode trunk
interface Ethernet0/1
switchport mode access
switchport access vlan 10
interface Ethernet0/2
switchport mode access
switchport access vlan 20
```

Task 2 - Enable routing on MLS1 and create an SVI for each VLAN.

**MLS1:**
```cisco
ip routing
interface Vlan10
ip address 172.16.10.1 255.255.255.0
no shutdown
interface Vlan20
ip address 172.16.20.1 255.255.255.0
no shutdown
```

Task 3 - Convert E 0/3 on MLS1 into a routed port towards R1 and add a default route on MLS1.

**MLS1:**
```cisco
interface Ethernet0/3
no switchport
ip address 10.0.0.2 255.255.255.252
no shutdown
ip route 0.0.0.0 0.0.0.0 10.0.0.1
```

**R1:**
```cisco
interface Ethernet0/0
ip address 10.0.0.1 255.255.255.252
no shutdown
ip route 172.16.0.0 255.255.0.0 10.0.0.2
```

## Note
1. Verification commands: `Ping 172.16.20.12`, `Show ip route static`
2. The ping should succeed. The routing is done by MLS1, so no router is needed.
3. MLS1 should have S* 0.0.0.0/0 via 10.0.0.1.
4. On MLS1, disable IP routing with no ip routing. Test the connectivity between the VLANs. — The SVIs stay up, but the switch no longer routes. PC1 cannot reach PC2 or PC4. 
![breakit-1](image_1.png)
Note: Fix it with ip routing.
5. On MLS1, shut down VLAN 20 (vlan 20, shutdown). Check the SVI and the PCs in VLAN 20. — Interface Vlan20 goes down. PC2 and PC4 lose their default gateway. 
![breakit-2](image_2.png)
Note: Fix it with no shutdown under vlan 20.
