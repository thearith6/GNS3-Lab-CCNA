## Lab 2 - Route Tags to Prevent Redistribution Loops

> **GNS3 Project:** [`Module 8 - Advanced Routing (CCNP) | Lab 2 – Route Tags to Prevent Redistribution Loops.gns3`](./Module%208%20-%20Advanced%20Routing%20%28CCNP%29%20%7C%20Lab%202%20%E2%80%93%20Route%20Tags%20to%20Prevent%20Redistribution%20Loops.gns3)

![topology](topology.png)

## Scenario
Starting from Lab 1, make R4 a second ASBR with the same mutual redistribution as R2.

- **Devices:** R1 (IOU L3), R2 (IOU L3), R3 (IOU L3), R4 (IOU L3)
- **Base Addressing:**
  - `R3` Ethernet0/0: `10.0.23.3` (255.255.255.0)
  - `R3` Ethernet0/1: `10.0.34.3` (255.255.255.0)
  - `R3` Loopback0: `3.3.3.3` (255.255.255.255)
  - `R3` Loopback1: `192.168.3.1` (255.255.255.0)
  - `R2` Ethernet0/0: `10.0.12.2` (255.255.255.0)
  - `R2` Ethernet0/1: `10.0.23.2` (255.255.255.0)
  - `R2` Loopback0: `2.2.2.2` (255.255.255.255)
  - `R1` Ethernet0/0: `10.0.12.1` (255.255.255.0)
  - `R1` Ethernet0/1: `10.0.14.1` (255.255.255.0)
  - `R1` Loopback0: `1.1.1.1` (255.255.255.255)
  - `R1` Loopback1: `192.168.1.1` (255.255.255.0)
  - `R4` Ethernet0/0: `10.0.14.4` (255.255.255.0)
  - `R4` Ethernet0/1: `10.0.34.4` (255.255.255.0)
  - `R4` Loopback0: `4.4.4.4` (255.255.255.255)

Task 1 - Starting from Lab 1, make R4 a second ASBR with the same mutual redistribution as R2.
  - Configure on R4

Task 2 - With two ASBRs a route can be redistributed back into the protocol it came from.
  - Prevent this with tags on R2 and R4.
  - Routes that are redistributed from OSPF into EIGRP get the tag 110, and routes that are redistributed from EIGRP into OSPF get the tag 90.
  - An ASBR must not redistribute a route that carries the tag of the other direction.

Task 3 - Verify the tags on R1 and R3.

## Action
Task 1 - Starting from Lab 1, make R4 a second ASBR with the same mutual redistribution as R2.

**R4:**
```cisco
router ospf 1
redistribute eigrp 100 subnets
router eigrp 100
redistribute ospf 1 metric 10000 100 255 1 1500
```

Task 2 - With two ASBRs a route can be redistributed back into the protocol it came from.

**R2 and R4:**
```cisco
route-map OSPF-TO-EIGRP deny 10
match tag 90
route-map OSPF-TO-EIGRP permit 20
set tag 110
route-map EIGRP-TO-OSPF deny 10
match tag 110
route-map EIGRP-TO-OSPF permit 20
set tag 90
router eigrp 100
redistribute ospf 1 metric 10000 100 255 1 1500 route-map OSPF-TO-EIGRP
router ospf 1
redistribute eigrp 100 subnets route-map EIGRP-TO-OSPF
```

Task 3 - Verify the tags on R1 and R3.

## Note
1. Verification commands: `Show ip route 192.168.3.0`, `Show ip route 192.168.1.0`
2. The route should show the route tag 90 and two equal paths, via R2 and via R4.
3. The route should show the route tag 110.
4. On R2, remove the route-map from the redistribution of OSPF into EIGRP. Check the route 192.168.1.0/24 on R3. — The routes redistributed by R2 no longer carry the tag 110, so the filter on R4 cannot recognize them as OSPF routes. Note: Fix it by applying the route-map OSPF-TO-EIGRP again.