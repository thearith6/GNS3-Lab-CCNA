## Lab 2 - Static VXLAN with Ingress Replication

> **GNS3 Project:** [`Module 8 - VXLAN (CCNP) | Lab 2 - Static VXLAN with Ingress Replication.gns3`](./Module%208%20-%20VXLAN%20%28CCNP%29%20%7C%20Lab%202%20-%20Static%20VXLAN%20with%20Ingress%20Replication.gns3)

![topology](topology.png)

## Scenario
Create VLAN 10 on LF1 and LF2 and map it to VNI 10010. Place the host ports (E 1/2 on both leaves) in VLAN 10.

- **Devices:** H1 (PC), H2 (PC), H3 (PC), H4 (PC), LF1 (IOU L3), LF2 (IOU L3), SP1 (IOU L3)
- **Base Addressing:**
  - `LF2` Ethernet0/0: `10.1.2.2` (255.255.255.252)
  - `LF2` Loopback0: `10.0.0.12` (255.255.255.255)
  - `LF1` Ethernet0/0: `10.1.1.2` (255.255.255.252)
  - `LF1` Loopback0: `10.0.0.11` (255.255.255.255)
  - `SP1` Ethernet0/0: `10.1.1.1` (255.255.255.252)
  - `SP1` Ethernet0/1: `10.1.2.1` (255.255.255.252)
  - `SP1` Loopback0: `10.0.0.1` (255.255.255.255)
  - `H3` Ethernet0: `192.168.20.13` (GW: 192.168.20.1)
  - `H1` Ethernet0: `192.168.10.11` (GW: 192.168.10.1)
  - `H2` Ethernet0: `192.168.10.12` (GW: 192.168.10.1)
  - `H4` Ethernet0: `192.168.20.14` (GW: 192.168.20.1)

Task 1 - Create VLAN 10 on LF1 and LF2 and map it to VNI 10010.
  - Place the host ports (E 1/2 on both leaves) in VLAN 10.

Task 2 - Create the NVE interface on each leaf with Loopback 0 as the source.
  - Use static ingress replication for VNI 10010 with the Loopback 0 address of the other leaf as the peer.

Task 3 - Verify the NVE peer and the connectivity between H1 and H2.

## Action
Task 1 - Create VLAN 10 on LF1 and LF2 and map it to VNI 10010.

**LF1:**
```cisco
feature vn-segment-vlan-based
vlan 10
vn-segment 10010
interface Ethernet1/2
switchport
switchport access vlan 10
no shutdown
```

**LF2:**
```cisco
feature vn-segment-vlan-based
vlan 10
vn-segment 10010
interface Ethernet1/2
switchport
switchport access vlan 10
no shutdown
```

Task 2 - Create the NVE interface on each leaf with Loopback 0 as the source.

**LF1:**
```cisco
feature nv overlay
interface nve1
no shutdown
source-interface loopback0
member vni 10010
ingress-replication protocol static
peer-ip 10.0.0.12
```

**LF2:**
```cisco
feature nv overlay
interface nve1
no shutdown
source-interface loopback0
member vni 10010
ingress-replication protocol static
peer-ip 10.0.0.11
```

Task 3 - Verify the NVE peer and the connectivity between H1 and H2.

## Note
1. Verification commands: `Show nve peers`, `Ping 192.168.10.12`, `Show nve vni`
2. The peer 10.0.0.12 should be Up.
3. The ping should succeed.
4. VNI 10010 should be Up and mapped to VLAN 10.
5. On LF1, replace the peer address with 10.0.0.99. Ping H2 from H1. LF1 — The peer is unreachable, so the tunnel does not come up. H1 cannot reach H2. Note: Fix it with peer-ip 10.0.0.12.