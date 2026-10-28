## Lab 4 - BGP EVPN Control Plane for Layer 2 VNIs

> **GNS3 Project:** [`Module 8 - VXLAN (CCNP) | Lab 4 - BGP EVPN Control Plane for Layer 2 VNIs.gns3`](./Module%208%20-%20VXLAN%20%28CCNP%29%20%7C%20Lab%204%20-%20BGP%20EVPN%20Control%20Plane%20for%20Layer%202%20VNIs.gns3)

![topology](topology.png)

## Scenario
Configure SP1 as a BGP route reflector for the EVPN address family in AS 65000. LF1 and LF2 are the clients and are reached through their Loopback 0 addresses.

- **Devices:** H1 (PC), H2 (PC), H3 (PC), H4 (PC), LF1 (IOU L3), LF2 (IOU L3), SP1 (IOU L3)
- **Base Addressing:**
  - `SP1` Ethernet0/0: `10.1.1.1` (255.255.255.252)
  - `SP1` Ethernet0/1: `10.1.2.1` (255.255.255.252)
  - `SP1` Loopback0: `10.0.0.1` (255.255.255.255)
  - `LF2` Ethernet0/0: `10.1.2.2` (255.255.255.252)
  - `LF2` Loopback0: `10.0.0.12` (255.255.255.255)
  - `LF1` Ethernet0/0: `10.1.1.2` (255.255.255.252)
  - `LF1` Loopback0: `10.0.0.11` (255.255.255.255)
  - `H2` Ethernet0: `192.168.10.12` (GW: 192.168.10.1)
  - `H3` Ethernet0: `192.168.20.13` (GW: 192.168.20.1)
  - `H4` Ethernet0: `192.168.20.14` (GW: 192.168.20.1)
  - `H1` Ethernet0: `192.168.10.11` (GW: 192.168.10.1)

Task 1 - Configure SP1 as a BGP route reflector for the EVPN address family in AS 65000.
  - LF1 and LF2 are the clients and are reached through their Loopback 0 addresses.

Task 2 - Remove the static or multicast NVE configuration from the earlier labs.
  - On the leaves, configure BGP towards SP1 and an EVPN instance for VNI 10010 with automatic route distinguishers and route targets.
  - Configure the NVE interface to use BGP for host reachability and for the replication of broadcast traffic.

Task 3 - Verify the BGP session and the learned MAC addresses on LF1, and the connectivity between H1 and H2.

## Action
Task 1 - Configure SP1 as a BGP route reflector for the EVPN address family in AS 65000.

**SP1:**
```cisco
feature bgp
nv overlay evpn
router bgp 65000
router-id 10.0.0.1
neighbor 10.0.0.11
remote-as 65000
update-source loopback0
address-family l2vpn evpn
send-community extended
route-reflector-client
neighbor 10.0.0.12
remote-as 65000
update-source loopback0
address-family l2vpn evpn
send-community extended
route-reflector-client
```

Task 2 - Remove the static or multicast NVE configuration from the earlier labs.

**LF1:**
```cisco
no interface nve1
feature bgp
nv overlay evpn
router bgp 65000
router-id 10.0.0.11
neighbor 10.0.0.1
remote-as 65000
update-source loopback0
address-family l2vpn evpn
send-community extended
evpn
vni 10010 l2
rd auto
route-target import auto
route-target export auto
interface nve1
no shutdown
host-reachability protocol bgp
source-interface loopback0
member vni 10010
ingress-replication protocol bgp
```

**LF2:**
```cisco
no interface nve1
feature bgp
nv overlay evpn
router bgp 65000
router-id 10.0.0.12
neighbor 10.0.0.1
remote-as 65000
update-source loopback0
address-family l2vpn evpn
send-community extended
evpn
vni 10010 l2
rd auto
route-target import auto
route-target export auto
interface nve1
no shutdown
host-reachability protocol bgp
source-interface loopback0
member vni 10010
ingress-replication protocol bgp
```

Task 3 - Verify the BGP session and the learned MAC addresses on LF1, and the connectivity between H1 and H2.

## Note
1. Verification commands: `Show bgp l2vpn evpn summary`, `Ping 192.168.10.12`, `Show l2route evpn mac all`
2. The neighbor 10.0.0.1 should be established and prefixes should be received.
3. The ping should succeed.
4. The MAC address of H2 should be listed as learned through BGP from 10.0.0.12.
5. On SP1, remove send-community extended for the neighbor 10.0.0.11 (address-family l2vpn evpn). Check the MAC addresses on LF1. — The route targets are extended communities. LF1 receives the routes without them and does not import them, so the MAC address of H2 is missing. Note: Fix it with send-community extended.
6. On LF2, change the import route target of VNI 10010 to 65000:20010. Ping H2 from H1. — LF2 no longer imports the routes of LF1. H2 cannot learn the MAC address of H1 and the ping fails. Note: Fix it with route-target import auto.