## Lab 3 - VXLAN Flood-and-Learn with Multicast

> **GNS3 Project:** [`Module 8 - VXLAN (CCNP) | Lab 3 - VXLAN Flood-and-Learn with Multicast.gns3`](./Module%208%20-%20VXLAN%20%28CCNP%29%20%7C%20Lab%203%20-%20VXLAN%20Flood-and-Learn%20with%20Multicast.gns3)

![topology](topology.png)

## Scenario
Enable PIM sparse mode on the underlay and make SP1 the rendezvous point (RP) for the group range 239.1.1.0/24, using its Loopback 0 address.

- **Devices:** H1 (PC), H2 (PC), H3 (PC), H4 (PC), LF1 (IOU L3), LF2 (IOU L3), SP1 (IOU L3)
- **Base Addressing:**
  - `LF1` Ethernet0/0: `10.1.1.2` (255.255.255.252)
  - `LF1` Loopback0: `10.0.0.11` (255.255.255.255)
  - `SP1` Ethernet0/0: `10.1.1.1` (255.255.255.252)
  - `SP1` Ethernet0/1: `10.1.2.1` (255.255.255.252)
  - `SP1` Loopback0: `10.0.0.1` (255.255.255.255)
  - `LF2` Ethernet0/0: `10.1.2.2` (255.255.255.252)
  - `LF2` Loopback0: `10.0.0.12` (255.255.255.255)
  - `H2` Ethernet0: `192.168.10.12` (GW: 192.168.10.1)
  - `H4` Ethernet0: `192.168.20.14` (GW: 192.168.20.1)
  - `H1` Ethernet0: `192.168.10.11` (GW: 192.168.10.1)
  - `H3` Ethernet0: `192.168.20.13` (GW: 192.168.20.1)

Task 1 - Enable PIM sparse mode on the underlay and make SP1 the rendezvous point (RP) for the group range 239.1.1.0/24, using its Loopback 0 address.
  - Configure on SP1

Task 2 - Starting from Lab 2, replace the static ingress replication with the multicast group 239.1.1.10 for VNI 10010 on both leaves.
  - Configure on LF1
  - Configure on LF2

Task 3 - Verify the multicast state on SP1 and the connectivity between H1 and H2.

## Action
Task 1 - Enable PIM sparse mode on the underlay and make SP1 the rendezvous point (RP) for the group range 239.1.1.0/24, using its Loopback 0 address.

**SP1:**
```cisco
feature pim
ip pim rp-address 10.0.0.1 group-list 239.1.1.0/24
interface loopback0
ip pim sparse-mode
interface Ethernet1/1-2
ip pim sparse-mode
feature pim
ip pim rp-address 10.0.0.1 group-list 239.1.1.0/24
interface loopback0
ip pim sparse-mode
interface Ethernet1/1
ip pim sparse-mode
feature pim
ip pim rp-address 10.0.0.1 group-list 239.1.1.0/24
interface loopback0
ip pim sparse-mode
interface Ethernet1/1
ip pim sparse-mode
```

Task 2 - Starting from Lab 2, replace the static ingress replication with the multicast group 239.1.1.10 for VNI 10010 on both leaves.

**LF1:**
```cisco
interface nve1
member vni 10010
no ingress-replication protocol static
mcast-group 239.1.1.10
```

**LF2:**
```cisco
interface nve1
member vni 10010
no ingress-replication protocol static
mcast-group 239.1.1.10
```

Task 3 - Verify the multicast state on SP1 and the connectivity between H1 and H2.

## Note
1. Verification commands: `Show ip mroute`, `Ping 192.168.10.12`
2. The entry (*, 239.1.1.10/32) should list the interfaces towards LF1 and LF2.
3. The ping should succeed. The ARP broadcast is carried in the multicast group.
4. On LF2, remove ip pim sparse-mode from E 1/1. Ping H2 from H1 and check the multicast routes on SP1. — LF2 cannot join the multicast group. Broadcast traffic (ARP) from H1 does not reach H2, so the ping fails. Note: Fix it with ip pim sparse-mode.