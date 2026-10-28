## Lab 6 - External Connectivity with a Border Leaf

> **GNS3 Project:** [`Module 8 - VXLAN (CCNP) | Lab 6 - External Connectivity with a Border Leaf.gns3`](./Module%208%20-%20VXLAN%20%28CCNP%29%20%7C%20Lab%206%20-%20External%20Connectivity%20with%20a%20Border%20Leaf.gns3)

![topology](topology.png)

## Scenario
Add the border leaf BL1 to the fabric from Lab 5. On SP1, add the link to BL1 and make BL1 a route reflector client. Configure BL1 with the underlay, the VRF TENANT1 with the Layer 3 VNI 50001 and the BGP EVPN session towards SP1.

- **Devices:** BL1 (IOU L3), H1 (PC), LF1 (IOU L3), R1 (IOU L3), SP1 (IOU L3)
- **Base Addressing:**
  - `BL1` Ethernet0/0: `10.1.3.2` (255.255.255.252)
  - `BL1` Ethernet0/1: `10.99.0.1` (255.255.255.252)
  - `BL1` Loopback0: `10.0.0.13` (255.255.255.255)
  - `R1` Ethernet0/0: `10.99.0.2` (255.255.255.252)
  - `R1` Loopback1: `198.51.100.1` (255.255.255.0)
  - `LF1` Ethernet0/0: `10.1.1.2` (255.255.255.252)
  - `LF1` Loopback0: `10.0.0.11` (255.255.255.255)
  - `SP1` Ethernet0/0: `10.1.1.1` (255.255.255.252)
  - `SP1` Ethernet0/1: `10.1.3.1` (255.255.255.252)
  - `SP1` Loopback0: `10.0.0.1` (255.255.255.255)
  - `H1` Ethernet0: `192.168.10.11` (GW: 192.168.10.1)

Task 1 - Add the border leaf BL1 to the fabric from Lab 5.
  - On SP1, add the link to BL1 and make BL1 a route reflector client.
  - Configure BL1 with the underlay, the VRF TENANT1 with the Layer 3 VNI 50001 and the BGP EVPN session towards SP1.

Task 2 - Connect BL1 to the external router R1 (AS 65099) with eBGP inside the VRF TENANT1 and advertise the VRF into EVPN.
  - R1 advertises the network 198.51.100.0/24 and uses a static route to reach the tenant networks through BL1.

Task 3 - Verify that LF1 learns the external network and that H1 can reach R1.

## Action
Task 1 - Add the border leaf BL1 to the fabric from Lab 5.

**SP1:**
```cisco
interface Ethernet1/3
no switchport
mtu 9216
ip address 10.1.3.1/30
ip ospf network point-to-point
ip router ospf UNDERLAY area 0.0.0.0
no shutdown
router bgp 65000
neighbor 10.0.0.13
remote-as 65000
update-source loopback0
address-family l2vpn evpn
send-community extended
route-reflector-client
```

**BL1:**
```cisco
feature ospf
feature bgp
feature nv overlay
feature vn-segment-vlan-based
feature interface-vlan
nv overlay evpn
router ospf UNDERLAY
router-id 10.0.0.13
interface loopback0
ip address 10.0.0.13/32
ip router ospf UNDERLAY area 0.0.0.0
interface Ethernet1/1
no switchport
mtu 9216
ip address 10.1.3.2/30
ip ospf network point-to-point
ip router ospf UNDERLAY area 0.0.0.0
no shutdown
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
interface nve1
no shutdown
host-reachability protocol bgp
source-interface loopback0
member vni 50001 associate-vrf
router bgp 65000
router-id 10.0.0.13
neighbor 10.0.0.1
remote-as 65000
update-source loopback0
address-family l2vpn evpn
send-community extended
```

Task 2 - Connect BL1 to the external router R1 (AS 65099) with eBGP inside the VRF TENANT1 and advertise the VRF into EVPN.

**BL1:**
```cisco
interface Ethernet1/2
no switchport
vrf member TENANT1
ip address 10.99.0.1/30
no shutdown
router bgp 65000
vrf TENANT1
address-family ipv4 unicast
advertise l2vpn evpn
neighbor 10.99.0.2
remote-as 65099
address-family ipv4 unicast
```

**R1:**
```cisco
ip route 192.168.0.0 255.255.0.0 10.99.0.1
router bgp 65099
bgp router-id 99.99.99.99
neighbor 10.99.0.1 remote-as 65000
network 198.51.100.0 mask 255.255.255.0
```

Task 3 - Verify that LF1 learns the external network and that H1 can reach R1.

## Note
1. Verification commands: `Show ip route vrf TENANT1`, `Ping 198.51.100.1`
2. The route 198.51.100.0/24 should be learned through BGP with the next hop 10.0.0.13 (BL1).
3. The ping should succeed.
4. On BL1, remove advertise l2vpn evpn from the VRF TENANT1 in BGP. Ping 198.51.100.1 from H1. — The external network is no longer advertised into EVPN. LF1 has no route to 198.51.100.0/24 and the ping fails. Note: Fix it with advertise l2vpn evpn.