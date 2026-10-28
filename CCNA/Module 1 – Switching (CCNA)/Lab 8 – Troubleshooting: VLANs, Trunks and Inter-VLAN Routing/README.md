## Lab 8 - Troubleshooting: VLANs, Trunks and Inter-VLAN Routing

> **GNS3 Project:** [`Module 1 - Switching (CCNA) | Lab 8 - Troubleshooting: VLANs, Trunks and Inter-VLAN Routing.gns3`](./Module%201%20-%20Switching%20%28CCNA%29%20%7C%20Lab%208%20-%20Troubleshooting%3A%20VLANs%2C%20Trunks%20and%20Inter-VLAN%20Routing.gns3)

![topo](image.png)

## Scenario

- **Devices:** MLS1 (IOU L2), PC1 (PC), PC2 (PC), PC3 (PC), PC4 (PC), R1 (IOU L3), SW2 (IOU L2)
- **Base Addressing:**
  - `R1` Ethernet0/0.10: `172.16.10.1` (255.255.255.0)
         Ethernet0/0.20: `172.16.20.1` (255.255.255.0)
  - `MLS1` Ethernet0/0, Ethernet0/3 trunk
  - `MLS1` Ethernet0/1 VLAN 10, Ethernet0/2 VLAN 20 
  - `SW2` Ethernet0/0 trunk
  - `SW2` Ethernet0/1 VLAN 10, Ethernet0/2 VLAN 20 

Task 1 
  - PC1 can no longer reach PC3.
  - Find and fix the fault.

Task 2 - 
  - PC4 can no longer reach its gateway.
  - Find and fix the fault.

Task 3 
  - PC2 can no longer reach PC1.
  - Find and fix the fault.

## Action
Task 1 - Troubleshoot connectivity PC1 to PC3
  - Check ipconfig on end hosts
  - Check VLANs in db, switchport modes on access switches
  - Check Trunks, allowed vlans, native vlan,
![Task-1](image_1.png)
  - Verification
![Task-1-Verification](image_5.png)

Task 2 - Troubleshoot PC4 connectivity to GW
  - Check ipconfig
  - Check VLAN/switchport modes
![Task-2](image_2.png)
  - Verification
![Task-2-Verification](image_6.png)

Task 3 - PC2 can not ping PC1 Troubleshoot
- Check ipconfig
- Check VLAN/switchport modes
- Check trunks on SW1 and encapsulation tags on R1
![Task-3](image_4.png)
- Verification
![Task-3-Verification](image_7.png)

## Note
1. Verification commands: `Show interfaces trunk`, `Show vlan brief`, `Show vlans`
  - Task 1 - VLAN 10 is missing from the allowed list. interface Ethernet0/0 switchport trunk allowed vlan add 10
  - Task 2 - E0/2 is listed under VLAN 10, but PC4 belongs in VLAN 20. interface Ethernet0/2 switchport access vlan 20
  - Task 3 - The sub-interface E 0/0.20 is mapped to VLAN 200 instead of VLAN 20. interface Ethernet0/0.20 encapsulation dot1Q 20
2. On MLS1, change E0/3 (the link to R1) to an access port in VLAN 10. Which communication still works?  
![Breakit-1](image_8.png)
 
E0/3 is no longer listed as a trunk. R1 only receives untagged frames, so routing between the VLANs stops. PC1 can still reach PC3 because they are in the same VLAN.
