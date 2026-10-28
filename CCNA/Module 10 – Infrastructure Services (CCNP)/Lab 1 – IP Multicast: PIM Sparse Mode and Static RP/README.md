## Lab 1 - IP Multicast: PIM Sparse Mode and Static RP

> **GNS3 Project:** [`Module 10 - Services (CCNP) | Lab 1 - Multicast.gns3`](./Module%2010%20-%20Services%20%28CCNP%29%20%7C%20Lab%201%20-%20Multicast.gns3)

![topology](topology.png)

## Scenario
Enable multicast routing and PIM sparse mode on R1, R2 and R3. Use OSPF area 0 for the unicast routing (links, LANs and loopbacks).

- **Devices:** R1 (IOU L3), R2 (IOU L3), R3 (IOU L3), RCV (PC), SRC (PC)
- **Base Addressing:**
  - `R1` Ethernet0/0: `10.0.12.1` (255.255.255.0)
  - `R1` Ethernet0/1: `192.168.1.1` (255.255.255.0)
  - `R1` Loopback0: `1.1.1.1` (255.255.255.255)
  - `R2` Ethernet0/0: `10.0.12.2` (255.255.255.0)
  - `R2` Ethernet0/1: `10.0.23.2` (255.255.255.0)
  - `R2` Loopback0: `2.2.2.2` (255.255.255.255)
  - `R3` Ethernet0/0: `10.0.23.3` (255.255.255.0)
  - `R3` Ethernet0/1: `192.168.3.1` (255.255.255.0)
  - `R3` Loopback0: `3.3.3.3` (255.255.255.255)
  - `SRC` Ethernet0: `192.168.1.50` (GW: 192.168.1.1)
  - `RCV` Ethernet0: `192.168.3.50` (GW: 192.168.3.1)

Task 1 - Enable multicast routing and PIM sparse mode on R1, R2 and R3.
  - Use OSPF area 0 for the unicast routing (links, LANs and loopbacks).

Task 2 - Make R2 the rendezvous point (RP) with its Loopback 0 address 2.2.2.2.
  - Configure it statically on all routers and verify the PIM neighbors and the RP mapping.
  - R1, R2 and R3

Task 3 - R3 joins the group 239.1.1.1 on its LAN interface.
  - Send traffic from SRC to the group and verify the multicast routing table.

## Action
Task 1 - Enable multicast routing and PIM sparse mode on R1, R2 and R3.

**R1:**
```cisco
ip multicast-routing
router ospf 1
network 10.0.12.0 0.0.0.255 area 0
network 192.168.1.0 0.0.0.255 area 0
network 1.1.1.1 0.0.0.0 area 0
interface range Ethernet0/0 - 1
ip pim sparse-mode
ip multicast-routing
router ospf 1
network 10.0.12.0 0.0.0.255 area 0
network 10.0.23.0 0.0.0.255 area 0
network 2.2.2.2 0.0.0.0 area 0
interface range Ethernet0/0 - 1
ip pim sparse-mode
interface Loopback0
ip pim sparse-mode
ip multicast-routing
router ospf 1
network 10.0.23.0 0.0.0.255 area 0
network 192.168.3.0 0.0.0.255 area 0
network 3.3.3.3 0.0.0.0 area 0
interface range Ethernet0/0 - 1
ip pim sparse-mode
```

Task 2 - Make R2 the rendezvous point (RP) with its Loopback 0 address 2.2.2.2.

**R1:**
```cisco
ip pim rp-address 2.2.2.2
```

Task 3 - R3 joins the group 239.1.1.1 on its LAN interface.

**R3:**
```cisco
SRC

interface Ethernet0/1
ip igmp join-group 239.1.1.1
```

## Note
1. Verification commands: `Show ip pim neighbor`, `ping -c 20 -t 16 239.1.1.1`
2. R2 should be listed as a PIM neighbor. Show ip pim rp mapping
3. The RP 2.2.2.2 should be listed as static.
4. R3 answers the ping, because it joined the group.
5. On R2, remove ip pim sparse-mode from E 0/1. Check the PIM neighbors and the multicast routing table of R2. — R3 is no longer a PIM neighbor. The join of R3 does not reach the RP, and SRC does not get an answer. Note: Fix it with ip pim sparse-mode.
6. On R1, remove the OSPF network 192.168.1.0/24 (no network 192.168.1.0 0.0.0.255 area 0). Check the RPF information on R2. — The RPF check fails because R2 has no route to the source network. Multicast traffic from SRC is dropped. Note: Fix it by advertising the network again.