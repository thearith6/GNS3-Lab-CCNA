## Lab 5 - Symmetric IRB and the Layer 3 VNI

> **GNS3 Project:** [`Module 8 - VXLAN (CCNP) | Lab 5 - Symmetric IRB and the Layer 3 VNI.gns3`](./Module%208%20-%20VXLAN%20%28CCNP%29%20%7C%20Lab%205%20-%20Symmetric%20IRB%20and%20the%20Layer%203%20VNI.gns3)

![topology](topology.png)

## Scenario
Starting from Lab 4, create the VRF TENANT1 with the Layer 3 VNI 50001 on both leaves. Create VLAN 100 mapped to VNI 50001 with an SVI in the VRF that uses ip forward.

- **Devices:** H1 (PC), H2 (PC), H3 (PC), H4 (PC), LF1 (IOU L3), LF2 (IOU L3), SP1 (IOU L3)
- **Base Addressing:**
  - `SP1` Ethernet0/0: `10.1.1.1` (255.255.255.252)
  - `SP1` Ethernet0/1: `10.1.2.1` (255.255.255.252)
  - `SP1` Loopback0: `10.0.0.1` (255.255.255.255)
  - `LF1` Ethernet0/0: `10.1.1.2` (255.255.255.252)
  - `LF1` Loopback0: `10.0.0.11` (255.255.255.255)
  - `LF2` Ethernet0/0: `10.1.2.2` (255.255.255.252)
  - `LF2` Loopback0: `10.0.0.12` (255.255.255.255)
  - `H4` Ethernet0: `192.168.20.14` (GW: 192.168.20.1)
  - `H2` Ethernet0: `192.168.10.12` (GW: 192.168.10.1)
  - `H1` Ethernet0: `192.168.10.11` (GW: 192.168.10.1)
  - `H3` Ethernet0: `192.168.20.13` (GW: 192.168.20.1)

Task 1 - Starting from Lab 4, create the VRF TENANT1 with the Layer 3 VNI 50001 on both leaves.
  - Create VLAN 100 mapped to VNI 50001 with an SVI in the VRF that uses ip forward.

Task 2 - Configure the distributed anycast gateway (MAC address 0000.2222.3333) for VLAN 10 and VLAN 20 on both leaves.
  - VLAN 20 is mapped to VNI 10020 and H3 and H4 are connected to E 1/3.
  - Put the SVIs in the VRF, add VNI 10020 to the EVPN configuration and advertise the VRF into EVPN.

Task 3 - Add VNI 10020 and the Layer 3 VNI 50001 to the NVE interface of both leaves.
  - Verify the routing between H1 and H4.

## Action
Task 1 - Starting from Lab 4, create the VRF TENANT1 with the Layer 3 VNI 50001 on both leaves.

**LF1:**
```cisco
feature interface-vlan
vlan 100
vn-segment 50001
vrf context TENANT1
vni 50001
rd auto
address-family ipv4 unicast
route-target both auto
route-target both auto evpn
interface Vlan100
no shutdown
vrf member TENANT1
ip forward
```

**LF2:**
```cisco
feature interface-vlan
vlan 100
vn-segment 50001
vrf context TENANT1
vni 50001
rd auto
address-family ipv4 unicast
route-target both auto
route-target both auto evpn
interface Vlan100
no shutdown
vrf member TENANT1
ip forward
```

Task 2 - Configure the distributed anycast gateway (MAC address 0000.2222.3333) for VLAN 10 and VLAN 20 on both leaves.

**LF1:**
```cisco
feature fabric forwarding
fabric forwarding anycast-gateway-mac
0000.2222.3333
vlan 20
vn-segment 10020
interface Ethernet1/3
switchport
switchport access vlan 20
no shutdown
interface Vlan10
no shutdown
vrf member TENANT1
ip address 192.168.10.1/24
fabric forwarding mode anycast-gateway
interface Vlan20
no shutdown
vrf member TENANT1
ip address 192.168.20.1/24
fabric forwarding mode anycast-gateway
evpn
vni 10020 l2
rd auto
route-target import auto
route-target export auto
router bgp 65000
vrf TENANT1
address-family ipv4 unicast
advertise l2vpn evpn
```

**LF2:**
```cisco
feature fabric forwarding
fabric forwarding anycast-gateway-mac
0000.2222.3333
vlan 20
vn-segment 10020
interface Ethernet1/3
switchport
switchport access vlan 20
no shutdown
interface Vlan10
no shutdown
vrf member TENANT1
ip address 192.168.10.1/24
fabric forwarding mode anycast-gateway
interface Vlan20
no shutdown
vrf member TENANT1
ip address 192.168.20.1/24
fabric forwarding mode anycast-gateway
evpn
vni 10020 l2
rd auto
route-target import auto
route-target export auto
router bgp 65000
vrf TENANT1
address-family ipv4 unicast
advertise l2vpn evpn
```

Task 3 - Add VNI 10020 and the Layer 3 VNI 50001 to the NVE interface of both leaves.

**LF1:**
```cisco
interface nve1
member vni 10020
ingress-replication protocol bgp
member vni 50001 associate-vrf
```

**LF2:**
```cisco
interface nve1
member vni 10020
ingress-replication protocol bgp
member vni 50001 associate-vrf
```

## Note
1. Verification commands: `Show ip route vrf TENANT1`
2. The host route 192.168.20.14/32 should be learned through BGP with the next hop 10.0.0.12.
3. The ping should succeed.
4. On LF2, remove member vni 50001 associate-vrf from the NVE interface. Ping H4 from H1. — LF2 can no longer route traffic coming through the Layer 3 VNI. The ping from H1 to H4 fails. Note: Fix it by adding member vni 50001 associate-vrf again.
5. On LF1, remove advertise l2vpn evpn from the VRF TENANT1 in BGP. Ping H4 from H1. — The host routes of LF1 are no longer advertised, so LF2 cannot return the traffic to H1. Note: Fix it with advertise l2vpn evpn.