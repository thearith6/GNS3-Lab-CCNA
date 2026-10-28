## Lab 2 - iBGP and next-hop-self

> **GNS3 Project:** [`Module 6 - BGP (CCNP) | Lab 2 - iBGP and next-hop-self.gns3`](./Module%206%20-%20BGP%20%28CCNP%29%20%7C%20Lab%202%20-%20iBGP%20and%20next-hop-self.gns3)

![topology](topology.png)

## Scenario
Configure eBGP between R1 (AS 65100) and R2 (AS 65200), and between R4 (AS 65200) and R5 (AS 65300), using the addresses of the directly connected links. Advertise the Loopback 1 networks of R1 and R5. Hard-code the router IDs to the Loopback 0 address of each router.

- **Devices:** R1 (IOU L3), R2 (IOU L3), R3 (IOU L3), R4 (IOU L3), R5 (IOU L3)
- **Base Addressing:**
  - `R1` Ethernet0/0: `10.12.0.1` (255.255.255.0)
  - `R1` Loopback0: `1.1.1.1` (255.255.255.255)
  - `R1` Loopback1: `192.168.1.1` (255.255.255.0)
  - `R1` Loopback2: `172.16.1.1` (255.255.255.0)
  - `R1` Loopback10: `10.1.0.1` (255.255.255.0)
  - `R1` Loopback11: `10.1.1.1` (255.255.255.0)
  - `R1` Loopback12: `10.1.2.1` (255.255.255.0)
  - `R1` Loopback13: `10.1.3.1` (255.255.255.0)
  - `R3` Ethernet0/0: `10.23.0.3` (255.255.255.0)
  - `R3` Ethernet0/1: `10.34.0.3` (255.255.255.0)
  - `R3` Loopback0: `3.3.3.3` (255.255.255.255)
  - `R5` Ethernet0/0: `10.45.0.5` (255.255.255.0)
  - `R5` Loopback0: `5.5.5.5` (255.255.255.255)
  - `R5` Loopback1: `192.168.5.1` (255.255.255.0)
  - `R4` Ethernet0/0: `10.24.0.4` (255.255.255.0)
  - `R4` Ethernet0/1: `10.34.0.4` (255.255.255.0)
  - `R4` Ethernet0/2: `10.45.0.4` (255.255.255.0)
  - `R4` Loopback0: `4.4.4.4` (255.255.255.255)
  - `R2` Ethernet0/0: `10.12.0.2` (255.255.255.0)
  - `R2` Ethernet0/1: `10.23.0.2` (255.255.255.0)
  - `R2` Ethernet0/2: `10.24.0.2` (255.255.255.0)
  - `R2` Loopback0: `2.2.2.2` (255.255.255.255)

Task 1 - Configure eBGP between R1 (AS 65100) and R2 (AS 65200), and between R4 (AS 65200) and R5 (AS 65300), using the addresses of the directly connected links.
  - Advertise the Loopback 1 networks of R1 and R5.
  - Hard-code the router IDs to the Loopback 0 address of each router.

Task 2 - Configure OSPF area 0 on R2, R3 and R4 for the internal links and the Loopback 0 networks.
  - Do not advertise the links towards R1 and R5.
  - Then build an iBGP full mesh between R2, R3 and R4 using the Loopback 0 addresses.

Task 3 - R3 learns the external networks, but the next hop is an address outside the AS.
  - Configure R2 and R4 so that R3 can use these routes, and verify on R3.

## Action
Task 1 - Configure eBGP between R1 (AS 65100) and R2 (AS 65200), and between R4 (AS 65200) and R5 (AS 65300), using the addresses of the directly connected links.

**R1:**
```cisco
router bgp 65100
bgp router-id 1.1.1.1
neighbor 10.12.0.2 remote-as 65200
network 192.168.1.0 mask 255.255.255.0
router bgp 65200
bgp router-id 2.2.2.2
neighbor 10.12.0.1 remote-as 65100
router bgp 65200
bgp router-id 4.4.4.4
neighbor 10.45.0.5 remote-as 65300
router bgp 65300
bgp router-id 5.5.5.5
neighbor 10.45.0.4 remote-as 65200
network 192.168.5.0 mask 255.255.255.0
```

Task 2 - Configure OSPF area 0 on R2, R3 and R4 for the internal links and the Loopback 0 networks.

**R2:**
```cisco
router ospf 1
router-id 2.2.2.2
network 10.23.0.0 0.0.0.255 area 0
network 10.24.0.0 0.0.0.255 area 0
network 2.2.2.2 0.0.0.0 area 0
router bgp 65200
neighbor 3.3.3.3 remote-as 65200
neighbor 3.3.3.3 update-source Loopback0
neighbor 4.4.4.4 remote-as 65200
neighbor 4.4.4.4 update-source Loopback0
router ospf 1
router-id 3.3.3.3
network 10.23.0.0 0.0.0.255 area 0
network 10.34.0.0 0.0.0.255 area 0
network 3.3.3.3 0.0.0.0 area 0
router bgp 65200
bgp router-id 3.3.3.3
neighbor 2.2.2.2 remote-as 65200
neighbor 2.2.2.2 update-source Loopback0
neighbor 4.4.4.4 remote-as 65200
neighbor 4.4.4.4 update-source Loopback0
router ospf 1
router-id 4.4.4.4
network 10.24.0.0 0.0.0.255 area 0
network 10.34.0.0 0.0.0.255 area 0
network 4.4.4.4 0.0.0.0 area 0
router bgp 65200
neighbor 2.2.2.2 remote-as 65200
neighbor 2.2.2.2 update-source Loopback0
neighbor 3.3.3.3 remote-as 65200
neighbor 3.3.3.3 update-source Loopback0
```

Task 3 - R3 learns the external networks, but the next hop is an address outside the AS.

**R2:**
```cisco
router bgp 65200
neighbor 3.3.3.3 next-hop-self
neighbor 4.4.4.4 next-hop-self
router bgp 65200
neighbor 2.2.2.2 next-hop-self
neighbor 3.3.3.3 next-hop-self
```

## Note
1. Verification commands: `Show ip bgp`
2. 192.168.1.0/24 should have the next hop 2.2.2.2 and 192.168.5.0/24 the next hop 4.4.4.4. Both routes should be marked as best (>).
3. On R4, remove next-hop-self for the neighbor 3.3.3.3 and refresh the session. Check the BGP table of R3. — R3 learns 192.168.5.0/24 with the next hop 10.45.0.5, which it cannot reach. The route is not marked as best. Note: Fix it with neighbor 3.3.3.3 next-hop-self.
4. On R3, remove update-source Loopback0 from the neighbor 2.2.2.2 and restart the session. Check the neighbor. — R3 now uses the address of its interface as source. R2 expects 3.3.3.3, so the session does not establish. Note: Fix it with neighbor 2.2.2.2 update-source Loopback0.