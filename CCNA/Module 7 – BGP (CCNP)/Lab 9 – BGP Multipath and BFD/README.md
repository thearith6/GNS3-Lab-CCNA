## Lab 9 - BGP Multipath and BFD

> **GNS3 Project:** [`Module 6 - BGP (CCNP) | Lab 9 - BGP Multipath and BFD.gns3`](./Module%206%20-%20BGP%20%28CCNP%29%20%7C%20Lab%209%20-%20BGP%20Multipath%20and%20BFD.gns3)

![topology](topology.png)

## Scenario
Configure two eBGP sessions between R1 (AS 65100) and R2 (AS 65200), one over each link, using the addresses of the directly connected links. R2 advertises its Loopback 1 network. Hard-code the router IDs to 1.1.1.1 and 2.2.2.2.

- **Devices:** R1 (IOU L3), R2 (IOU L3)
- **Base Addressing:**
  - `R1` Ethernet0/0: `10.12.1.1` (255.255.255.0)
  - `R1` Ethernet0/1: `10.12.2.1` (255.255.255.0)
  - `R1` Loopback0: `1.1.1.1` (255.255.255.255)
  - `R2` Ethernet0/0: `10.12.1.2` (255.255.255.0)
  - `R2` Ethernet0/1: `10.12.2.2` (255.255.255.0)
  - `R2` Loopback0: `2.2.2.2` (255.255.255.255)
  - `R2` Loopback1: `192.168.2.1` (255.255.255.0)

Task 1 - Configure two eBGP sessions between R1 (AS 65100) and R2 (AS 65200), one over each link, using the addresses of the directly connected links.
  - R2 advertises its Loopback 1 network.
  - Hard-code the router IDs to 1.1.1.1 and 2.2.2.2.

Task 2 - R1 learns 192.168.2.0/24 over both sessions but installs only one path.
  - Allow R1 to install both paths in the routing table.

Task 3 - Detect link failures quickly.
  - Enable BFD on both links with an interval of 300 ms, a minimum receive interval of 300 ms and a multiplier of 3.
  - Make BGP depend on BFD on both routers.

## Action
Task 1 - Configure two eBGP sessions between R1 (AS 65100) and R2 (AS 65200), one over each link, using the addresses of the directly connected links.

**R1:**
```cisco
router bgp 65100
bgp router-id 1.1.1.1
neighbor 10.12.1.2 remote-as 65200
neighbor 10.12.2.2 remote-as 65200
```

**R2:**
```cisco
router bgp 65200
bgp router-id 2.2.2.2
neighbor 10.12.1.1 remote-as 65100
neighbor 10.12.2.1 remote-as 65100
network 192.168.2.0 mask 255.255.255.0
```

Task 2 - R1 learns 192.168.2.0/24 over both sessions but installs only one path.

**R1:**
```cisco
router bgp 65100
maximum-paths 2
```

Task 3 - Detect link failures quickly.

**R1:**
```cisco
interface range Ethernet0/0 - 1
bfd interval 300 min_rx 300 multiplier 3
router bgp 65100
neighbor 10.12.1.2 fall-over bfd
neighbor 10.12.2.2 fall-over bfd
```

**R2:**
```cisco
interface range Ethernet0/0 - 1
bfd interval 300 min_rx 300 multiplier 3
router bgp 65200
neighbor 10.12.1.1 fall-over bfd
neighbor 10.12.2.1 fall-over bfd
```

## Note
1. Verification commands: `Show ip route 192.168.2.0`, `Show bfd neighbors`
2. The route should list two next hops, 10.12.1.2 and 10.12.2.2.
3. Both BFD sessions should be Up.
4. On R1, remove maximum-paths 2. Check the routing table for 192.168.2.0/24. R1 — Only one path is installed in the routing table. The other path stays in the BGP table. Note: Fix it with maximum-paths 2.
5. On R1, shut down E 0/0. Check the routing table for 192.168.2.0/24. R1 — Only the path via 10.12.2.2 remains. The failed session is detected immediately. Note: Fix it with no shutdown.