## Lab 1 - Redistribution between OSPF and EIGRP

> **GNS3 Project:** [`Module 8 - Advanced Routing (CCNP) | Lab 1 – Redistribution between OSPF and EIGRP.gns3`](./Module%208%20-%20Advanced%20Routing%20%28CCNP%29%20%7C%20Lab%201%20%E2%80%93%20Redistribution%20between%20OSPF%20and%20EIGRP.gns3)

![topology](topology.png)

## Scenario
Configure OSPF area 0 on R1, R2 and R4 (links and loopbacks as shown) and EIGRP AS 100 on R2, R3 and R4. Advertise the Loopback 1 networks of R1 (OSPF) and R3 (EIGRP). Hard-code the router IDs to the Loopback 0 addresses. R1 must advertise its Loopback 1 with the real /24 mask.

- **Devices:** R1 (IOU L3), R2 (IOU L3), R3 (IOU L3), R4 (IOU L3)
- **Base Addressing:**
  - `R4` Ethernet0/0: `10.0.14.4` (255.255.255.0)
  - `R4` Ethernet0/1: `10.0.34.4` (255.255.255.0)
  - `R4` Loopback0: `4.4.4.4` (255.255.255.255)
  - `R1` Ethernet0/0: `10.0.12.1` (255.255.255.0)
  - `R1` Ethernet0/1: `10.0.14.1` (255.255.255.0)
  - `R1` Loopback0: `1.1.1.1` (255.255.255.255)
  - `R1` Loopback1: `192.168.1.1` (255.255.255.0)
  - `R3` Ethernet0/0: `10.0.23.3` (255.255.255.0)
  - `R3` Ethernet0/1: `10.0.34.3` (255.255.255.0)
  - `R3` Loopback0: `3.3.3.3` (255.255.255.255)
  - `R3` Loopback1: `192.168.3.1` (255.255.255.0)
  - `R2` Ethernet0/0: `10.0.12.2` (255.255.255.0)
  - `R2` Ethernet0/1: `10.0.23.2` (255.255.255.0)
  - `R2` Loopback0: `2.2.2.2` (255.255.255.255)

Task 1 - Configure OSPF area 0 on R1, R2 and R4 (links and loopbacks as shown) and EIGRP AS 100 on R2, R3 and R4.
  - Advertise the Loopback 1 networks of R1 (OSPF) and R3 (EIGRP).
  - Hard-code the router IDs to the Loopback 0 addresses.
  - R1 must advertise its Loopback 1 with the real /24 mask.

Task 2 - Make R2 the only ASBR.
  - Redistribute EIGRP into OSPF (including subnets) and OSPF into EIGRP.
  - For EIGRP, use the metric: bandwidth 10000 kbps, delay 100, reliability 255, load 1 and MTU 1500.

Task 3 - Verify the redistributed routes on R1 and R3.

## Action
Task 1 - Configure OSPF area 0 on R1, R2 and R4 (links and loopbacks as shown) and EIGRP AS 100 on R2, R3 and R4.

**R1:**
```cisco
router ospf 1
router-id 1.1.1.1
network 10.0.12.0 0.0.0.255 area 0
network 10.0.14.0 0.0.0.255 area 0
network 1.1.1.1 0.0.0.0 area 0
network 192.168.1.0 0.0.0.255 area 0
interface Loopback1
ip ospf network point-to-point
router ospf 1
router-id 2.2.2.2
network 10.0.12.0 0.0.0.255 area 0
router eigrp 100
eigrp router-id 2.2.2.2
network 10.0.23.0 0.0.0.255
no auto-summary
router ospf 1
router-id 4.4.4.4
network 10.0.14.0 0.0.0.255 area 0
router eigrp 100
eigrp router-id 4.4.4.4
network 10.0.34.0 0.0.0.255
no auto-summary
router eigrp 100
eigrp router-id 3.3.3.3
network 10.0.23.0 0.0.0.255
network 10.0.34.0 0.0.0.255
network 3.3.3.3 0.0.0.0
network 192.168.3.0 0.0.0.255
no auto-summary
```

Task 2 - Make R2 the only ASBR.

**R2:**
```cisco
router ospf 1
redistribute eigrp 100 subnets
router eigrp 100
redistribute ospf 1 metric 10000 100 255 1 1500
```

Task 3 - Verify the redistributed routes on R1 and R3.

## Note
1. Verification commands: `Show ip route 192.168.3.0`, `Show ip route 192.168.1.0`
2. The route should be O E2 via 10.0.12.2.
3. The route should be D EX via 10.0.23.2.
4. On R2, remove the keyword subnets from the redistribution into OSPF. Check the routing table of R1. — Without subnets only classful networks are redistributed. R1 still learns 192.168.3.0/24 (a classful network) but no longer learns the subnets 10.0.23.0/24 and 10.0.34.0/24. Note: Fix it with redistribute eigrp 100 subnets.
5. On R2, redistribute OSPF into EIGRP without the metric. Check the routing table of R3. — EIGRP needs a metric for redistributed routes. R3 no longer learns 192.168.1.0/24. Note: Fix it by adding the metric again.