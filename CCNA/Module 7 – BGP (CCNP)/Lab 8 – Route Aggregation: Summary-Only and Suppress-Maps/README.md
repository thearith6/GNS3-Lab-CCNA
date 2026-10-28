## Lab 8 - Route Aggregation: Summary-Only and Suppress-Maps

> **GNS3 Project:** [`Module 6 - BGP (CCNP) | Lab 8 - Route Aggregation: Summary-Only and Suppress-Maps.gns3`](./Module%206%20-%20BGP%20%28CCNP%29%20%7C%20Lab%208%20-%20Route%20Aggregation%3A%20Summary-Only%20and%20Suppress-Maps.gns3)

![topology](topology.png)

## Scenario
Starting from the Lab 2 configuration, R1 must advertise its four loopback networks Loopback10 – Loopback13 (10.1.0.0/24 – 10.1.3.0/24) in BGP.

- **Devices:** R1 (IOU L3), R2 (IOU L3), R3 (IOU L3), R4 (IOU L3), R5 (IOU L3)
- **Base Addressing:**
  - `R4` Ethernet0/0: `10.24.0.4` (255.255.255.0)
  - `R4` Ethernet0/1: `10.34.0.4` (255.255.255.0)
  - `R4` Ethernet0/2: `10.45.0.4` (255.255.255.0)
  - `R4` Loopback0: `4.4.4.4` (255.255.255.255)
  - `R1` Ethernet0/0: `10.12.0.1` (255.255.255.0)
  - `R1` Loopback0: `1.1.1.1` (255.255.255.255)
  - `R1` Loopback1: `192.168.1.1` (255.255.255.0)
  - `R1` Loopback2: `172.16.1.1` (255.255.255.0)
  - `R1` Loopback10: `10.1.0.1` (255.255.255.0)
  - `R1` Loopback11: `10.1.1.1` (255.255.255.0)
  - `R1` Loopback12: `10.1.2.1` (255.255.255.0)
  - `R1` Loopback13: `10.1.3.1` (255.255.255.0)
  - `R5` Ethernet0/0: `10.45.0.5` (255.255.255.0)
  - `R5` Loopback0: `5.5.5.5` (255.255.255.255)
  - `R5` Loopback1: `192.168.5.1` (255.255.255.0)
  - `R2` Ethernet0/0: `10.12.0.2` (255.255.255.0)
  - `R2` Ethernet0/1: `10.23.0.2` (255.255.255.0)
  - `R2` Ethernet0/2: `10.24.0.2` (255.255.255.0)
  - `R2` Loopback0: `2.2.2.2` (255.255.255.255)
  - `R3` Ethernet0/0: `10.23.0.3` (255.255.255.0)
  - `R3` Ethernet0/1: `10.34.0.3` (255.255.255.0)
  - `R3` Loopback0: `3.3.3.3` (255.255.255.255)

Task 1 - Starting from the Lab 2 configuration, R1 must advertise its four loopback networks Loopback10 – Loopback13 (10.1.0.0/24 – 10.1.3.0/24) in BGP.
  - Configure on R1

Task 2 - Configure R2 to summarize the four networks into 10.1.0.0/22 and to suppress the more specific routes.
  - Verify on R5.

Task 3 - Change the aggregate on R2 so that 10.1.3.0/24 is still advertised, but the other three networks are suppressed.
  - Use a suppress-map.

## Action
Task 1 - Starting from the Lab 2 configuration, R1 must advertise its four loopback networks Loopback10 – Loopback13 (10.1.0.0/24 – 10.1.3.0/24) in BGP.

**R1:**
```cisco
router bgp 65100
network 10.1.0.0 mask 255.255.255.0
network 10.1.1.0 mask 255.255.255.0
network 10.1.2.0 mask 255.255.255.0
network 10.1.3.0 mask 255.255.255.0
```

Task 2 - Configure R2 to summarize the four networks into 10.1.0.0/22 and to suppress the more specific routes.

**R2:**
```cisco
router bgp 65200
aggregate-address 10.1.0.0 255.255.252.0
summary-only
```

Task 3 - Change the aggregate on R2 so that 10.1.3.0/24 is still advertised, but the other three networks are suppressed.

**R2:**
```cisco
ip prefix-list SUPP seq 5 permit 10.1.0.0/24
ip prefix-list SUPP seq 10 permit 10.1.1.0/24
ip prefix-list SUPP seq 15 permit 10.1.2.0/24
route-map SUPPRESS permit 10
match ip address prefix-list SUPP
router bgp 65200
no aggregate-address 10.1.0.0
255.255.252.0 summary-only
aggregate-address 10.1.0.0 255.255.252.0
suppress-map SUPPRESS
```

## Note
1. Verification commands: `Show ip bgp`
2. R5 should only learn 10.1.0.0/22. The four /24 routes should not be listed.
3. R5 should learn 10.1.0.0/22 and 10.1.3.0/24 only.
4. On R2, remove the suppress-map and enter the aggregate without any option. Check the BGP table of R5. — R5 now learns the aggregate and all four specific routes. Note: Fix it with summary-only or a suppress-map.