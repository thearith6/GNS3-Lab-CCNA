## Lab 5 - EIGRP Named Mode and Metric Tuning

> **GNS3 Project:** [`Module 8 - Advanced Routing (CCNP) | Lab 5 - EIGRP.gns3`](./Module%208%20-%20Advanced%20Routing%20%28CCNP%29%20%7C%20Lab%205%20-%20EIGRP.gns3)

![topology](topology.png)

## Scenario
Configure EIGRP in named mode on R1, R2 and R3. Use the name LAB and AS 100, advertise all links and the Loopback 0 network, and make the loopback passive. Hard-code the router IDs to the Loopback 0 addresses.

- **Devices:** R1 (IOU L3), R2 (IOU L3), R3 (IOU L3)
- **Base Addressing:**
  - `R3` Ethernet0/0: `10.1.23.3` (255.255.255.0)
  - `R3` Ethernet0/1: `10.1.13.3` (255.255.255.0)
  - `R3` Loopback0: `3.3.3.3` (255.255.255.255)
  - `R1` Ethernet0/0: `10.1.12.1` (255.255.255.0)
  - `R1` Ethernet0/1: `10.1.13.1` (255.255.255.0)
  - `R1` Loopback0: `1.1.1.1` (255.255.255.255)
  - `R2` Ethernet0/0: `10.1.12.2` (255.255.255.0)
  - `R2` Ethernet0/1: `10.1.23.2` (255.255.255.0)
  - `R2` Loopback0: `2.2.2.2` (255.255.255.255)

Task 1 - Configure EIGRP in named mode on R1, R2 and R3.
  - Use the name LAB and AS 100, advertise all links and the Loopback 0 network, and make the loopback passive.
  - Hard-code the router IDs to the Loopback 0 addresses.

Task 2 - R1 must use R2 as the primary path to the network 3.3.3.3/32, and keep the direct link to R3 as a backup.
  - Increase the delay of the direct link (E 0/1) on R1 to 600 (tens of microseconds).

Task 3 - Verify the successor and the feasible successor on R1.

## Action
Task 1 - Configure EIGRP in named mode on R1, R2 and R3.

**R1:**
```cisco
router eigrp LAB
address-family ipv4 unicast autonomous-system 100
eigrp router-id 1.1.1.1
network 10.1.0.0 0.0.255.255
network 1.1.1.1 0.0.0.0
af-interface Loopback0
passive-interface
router eigrp LAB
address-family ipv4 unicast autonomous-system 100
eigrp router-id 2.2.2.2
network 10.1.0.0 0.0.255.255
network 2.2.2.2 0.0.0.0
af-interface Loopback0
passive-interface
router eigrp LAB
address-family ipv4 unicast autonomous-system 100
eigrp router-id 3.3.3.3
network 10.1.0.0 0.0.255.255
network 3.3.3.3 0.0.0.0
af-interface Loopback0
passive-interface
```

Task 2 - R1 must use R2 as the primary path to the network 3.3.3.3/32, and keep the direct link to R3 as a backup.

**R1:**
```cisco
interface Ethernet0/1
delay 600
```

Task 3 - Verify the successor and the feasible successor on R1.

## Note
1. Verification commands: `Show ip eigrp topology 3.3.3.3/32`
2. The successor should be via 10.1.12.2 (R2). The path via 10.1.13.3 should be listed as a feasible successor, because its reported distance is lower than the feasible distance.
3. On R3, change the AS number of the named process to 200. Check the neighbors of R1 and R2. — The AS numbers must match. R3 is no longer a neighbor of R1 and R2. Note: Fix it with the AS number 100.
4. On R2, change the K values with metric weights 0 1 1 1 1 0 in the topology base. Check the log of R1. — The neighbors reset because of a K-value mismatch. The routers only become neighbors if all K values are equal. Note: Fix it with metric weights 0 1 0 1 0 0.