## Lab 1 - VXLAN Underlay: OSPF and Jumbo MTU

> **GNS3 Project:** [`Module 8 - VXLAN (CCNP) | Lab 1 - VXLAN Underlay: OSPF and Jumbo MTU.gns3`](./Module%208%20-%20VXLAN%20%28CCNP%29%20%7C%20Lab%201%20-%20VXLAN%20Underlay%3A%20OSPF%20and%20Jumbo%20MTU.gns3)

![topology](topology.png)

## Scenario
Configure the underlay with OSPF area 0 on SP1, LF1 and LF2. Use routed ports and point-to-point OSPF on the links. Advertise Loopback 0 on every device and hard-code the router IDs to the Loopback 0 addresses.

- **Devices:** H1 (PC), H2 (PC), H3 (PC), H4 (PC), LF1 (IOU L3), LF2 (IOU L3), SP1 (IOU L3)
- **Base Addressing:**
  - `LF2` Ethernet0/0: `10.1.2.2` (255.255.255.252)
  - `LF2` Loopback0: `10.0.0.12` (255.255.255.255)
  - `SP1` Ethernet0/0: `10.1.1.1` (255.255.255.252)
  - `SP1` Ethernet0/1: `10.1.2.1` (255.255.255.252)
  - `SP1` Loopback0: `10.0.0.1` (255.255.255.255)
  - `LF1` Ethernet0/0: `10.1.1.2` (255.255.255.252)
  - `LF1` Loopback0: `10.0.0.11` (255.255.255.255)
  - `H3` Ethernet0: `192.168.20.13` (GW: 192.168.20.1)
  - `H2` Ethernet0: `192.168.10.12` (GW: 192.168.10.1)
  - `H4` Ethernet0: `192.168.20.14` (GW: 192.168.20.1)
  - `H1` Ethernet0: `192.168.10.11` (GW: 192.168.10.1)

Task 1 - Configure the underlay with OSPF area 0 on SP1, LF1 and LF2.
  - Use routed ports and point-to-point OSPF on the links.
  - Advertise Loopback 0 on every device and hard-code the router IDs to the Loopback 0 addresses.

Task 2 - VXLAN adds 50 bytes of overhead.
  - Set the MTU of all underlay links to 9216.

Task 3 - Verify the OSPF neighbors on LF1 and test the path to LF2 with a large packet.

## Action
Task 1 - Configure the underlay with OSPF area 0 on SP1, LF1 and LF2.

**SP1:**
```cisco
feature ospf
router ospf UNDERLAY
router-id 10.0.0.1
interface loopback0
ip address 10.0.0.1/32
ip router ospf UNDERLAY area 0.0.0.0
interface Ethernet1/1
no switchport
ip address 10.1.1.1/30
ip ospf network point-to-point
ip router ospf UNDERLAY area 0.0.0.0
no shutdown
interface Ethernet1/2
no switchport
ip address 10.1.2.1/30
ip ospf network point-to-point
ip router ospf UNDERLAY area 0.0.0.0
no shutdown
feature ospf
router ospf UNDERLAY
router-id 10.0.0.11
interface loopback0
ip address 10.0.0.11/32
ip router ospf UNDERLAY area 0.0.0.0
interface Ethernet1/1
no switchport
ip address 10.1.1.2/30
ip ospf network point-to-point
ip router ospf UNDERLAY area 0.0.0.0
no shutdown

feature ospf
router ospf UNDERLAY
router-id 10.0.0.12
interface loopback0
ip address 10.0.0.12/32
ip router ospf UNDERLAY area 0.0.0.0
interface Ethernet1/1
no switchport
ip address 10.1.2.2/30
ip ospf network point-to-point
ip router ospf UNDERLAY area 0.0.0.0
no shutdown
```

Task 2 - VXLAN adds 50 bytes of overhead.

**SP1:**
```cisco
interface Ethernet1/1-2
mtu 9216
interface Ethernet1/1
mtu 9216
interface Ethernet1/1
mtu 9216
```

Task 3 - Verify the OSPF neighbors on LF1 and test the path to LF2 with a large packet.

## Note
1. Verification commands: `Show ip ospf neighbors`
2. SP1 should be in the FULL state. Ping 10.0.0.12 source 10.0.0.11 packet-size 9000 df-bit
3. The ping should succeed.
4. On LF2, set the MTU of E 1/1 back to 1500. Check the OSPF neighbors on SP1. LF2 — The MTU values no longer match. The adjacency with SP1 does not reach the FULL state. Note: Fix it with mtu 9216.
5. On LF2, remove Loopback 0 from OSPF. Ping 10.0.0.12 from LF1. LF2 — LF1 can no longer reach 10.0.0.12. A VXLAN tunnel to this address cannot come up. Note: Fix it with ip router ospf UNDERLAY area 0.0.0.0.