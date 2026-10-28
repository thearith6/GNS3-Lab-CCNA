## Lab 6 - BGP Communities

> **GNS3 Project:** [`Module 6 - BGP (CCNP) | Lab 6 - BGP Communities.gns3`](./Module%206%20-%20BGP%20%28CCNP%29%20%7C%20Lab%206%20-%20BGP%20Communities.gns3)

![topology](topology.png)

## Scenario
R1 must prevent its Loopback 1 network (192.168.1.0/24) from being advertised to AS 65300. When R1 advertises it to R2, mark it with the well-known community no-export. Make sure the community is sent to R2, and that R2 passes it on to R3 and R4.

- **Devices:** R1 (IOU L3), R2 (IOU L3), R3 (IOU L3), R4 (IOU L3)
- **Base Addressing:**
  - `R4` Ethernet0/0: `10.24.0.4` (255.255.255.0)
  - `R4` Ethernet0/1: `10.34.0.4` (255.255.255.0)
  - `R4` Loopback0: `4.4.4.4` (255.255.255.255)
  - `R4` Loopback1: `198.51.100.1` (255.255.255.0)
  - `R4` Loopback2: `203.0.113.1` (255.255.255.0)
  - `R4` Loopback3: `192.0.2.1` (255.255.255.0)
  - `R1` Ethernet0/0: `10.12.0.1` (255.255.255.0)
  - `R1` Ethernet0/1: `10.13.0.1` (255.255.255.0)
  - `R1` Ethernet0/2: `10.12.1.1` (255.255.255.0)
  - `R1` Loopback0: `1.1.1.1` (255.255.255.255)
  - `R1` Loopback1: `192.168.10.1` (255.255.255.0)
  - `R3` Ethernet0/0: `10.13.0.3` (255.255.255.0)
  - `R3` Ethernet0/1: `10.34.0.3` (255.255.255.0)
  - `R3` Loopback0: `3.3.3.3` (255.255.255.255)
  - `R2` Ethernet0/0: `10.12.0.2` (255.255.255.0)
  - `R2` Ethernet0/1: `10.24.0.2` (255.255.255.0)
  - `R2` Ethernet0/2: `10.12.1.2` (255.255.255.0)
  - `R2` Loopback0: `2.2.2.2` (255.255.255.255)

Task 1 - R1 must prevent its Loopback 1 network (192.168.1.0/24) from being advertised to AS 65300.
  - When R1 advertises it to R2, mark it with the well-known community no-export.
  - Make sure the community is sent to R2, and that R2 passes it on to R3 and R4.

Task 2 - R1 also advertises its Loopback 2 network (172.16.1.0/24) to R2.
  - Mark it with the community no-advertise, so that R2 keeps the route to itself.

Task 3 - Verify the communities and the BGP tables.

## Action
Task 1 - R1 must prevent its Loopback 1 network (192.168.1.0/24) from being advertised to AS 65300.

**R1:**
```cisco
ip prefix-list LO1 seq 5 permit
192.168.1.0/24
route-map SET-COMM permit 10
match ip address prefix-list LO1
set community no-export
route-map SET-COMM permit 20
router bgp 65100
neighbor 10.12.0.2 send-community
neighbor 10.12.0.2 route-map SET-COMM
out
```

**R2:**
```cisco
router bgp 65200
neighbor 3.3.3.3 send-community
neighbor 4.4.4.4 send-community
```

Task 2 - R1 also advertises its Loopback 2 network (172.16.1.0/24) to R2.

**R1:**
```cisco
ip prefix-list LO2 seq 5 permit 172.16.1.0/24
route-map SET-COMM permit 15
match ip address prefix-list LO2
set community no-advertise
router bgp 65100
network 172.16.1.0 mask 255.255.255.0
clear ip bgp 10.12.0.2 out
```

Task 3 - Verify the communities and the BGP tables.

## Note
1. Verification commands: `Show ip bgp 192.168.1.0`
2. The route should carry the community no-export. R5 Show ip bgp
3. R5 should not learn 192.168.1.0/24 or 172.16.1.0/24. R2 Show ip bgp 172.16.1.0
4. The route should carry the community no-advertise. R3 and R4 should not have it.
5. On R1, remove send-community for the neighbor R2 and refresh the session. Check the BGP table of R5. — The communities are not sent. R5 now learns 192.168.1.0/24, and R3 and R4 learn 172.16.1.0/24. Note: Fix it with neighbor 10.12.0.2 send-community.