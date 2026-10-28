## Lab 6 - OSPF Stub, Totally Stubby and NSSA Areas

> **GNS3 Project:** [`Module 8 - Advanced Routing (CCNP) | Lab 6 - OSPF Stub.gns3`](./Module%208%20-%20Advanced%20Routing%20%28CCNP%29%20%7C%20Lab%206%20-%20OSPF%20Stub.gns3)

![topology](topology.png)

## Scenario
Starting from the multi-area OSPF configuration, make area 1 a totally stubby area. R1 only needs a default route to leave the area.

- **Devices:** R1 (IOU L3), R2 (IOU L3), R3 (IOU L3), R4 (IOU L3)
- **Base Addressing:**
  - `R3` Ethernet0/0: `192.168.23.3` (255.255.255.0)
  - `R3` Ethernet0/1: `192.168.34.3` (255.255.255.0)
  - `R3` Loopback0: `3.3.3.3` (255.255.255.255)
  - `R1` Ethernet0/0: `192.168.12.1` (255.255.255.0)
  - `R1` Loopback0: `1.1.1.1` (255.255.255.255)
  - `R4` Ethernet0/0: `192.168.34.4` (255.255.255.0)
  - `R4` Loopback0: `4.4.4.4` (255.255.255.255)
  - `R4` Loopback20: `172.20.0.1` (255.255.255.0)
  - `R2` Ethernet0/0: `192.168.12.2` (255.255.255.0)
  - `R2` Ethernet0/1: `192.168.23.2` (255.255.255.0)
  - `R2` Loopback0: `2.2.2.2` (255.255.255.255)

Task 1 - Starting from the multi-area OSPF configuration, make area 1 a totally stubby area.
  - R1 only needs a default route to leave the area.

Task 2 - Make area 2 an NSSA.
  - R4 has an external network (Loopback 20, 172.20.0.0/24) that it redistributes into OSPF.
  - Redistribute only this loopback.

Task 3 - Verify the routing tables of R1, R3 and R2.

## Action
Task 1 - Starting from the multi-area OSPF configuration, make area 1 a totally stubby area.

**R1:**
```cisco
router ospf 1
area 1 stub
```

**R2:**
```cisco
router ospf 1
area 1 stub no-summary
```

Task 2 - Make area 2 an NSSA.

**R3:**
```cisco
router ospf 1
area 2 nssa
```

**R4:**
```cisco
interface Loopback20
ip address 172.20.0.1 255.255.255.0
route-map LO20 permit 10
match interface Loopback20
router ospf 1
area 2 nssa
redistribute connected subnets route-map
LO20
```

Task 3 - Verify the routing tables of R1, R3 and R2.

## Note
1. Verification commands: `Show ip route ospf`
2. R1 should only have a default route (O*IA 0.0.0.0/0 via 192.168.12.2). No inter-area routes should be listed. R3 Show ip route 172.20.0.0
3. The route should be O N2 via 192.168.34.4. R2 Show ip route 172.20.0.0
4. R3 converts the type 7 LSA into a type 5 LSA. The route should be O E2 via 192.168.23.3.
5. On R2, remove the totally stubby configuration from area 1 (no area 1 stub no-summary). Check the neighbors of R1 and R2. — R1 still treats area 1 as a stub area, and R2 does not. The stub flag in the hello packet no longer matches and the adjacency goes down. Note: Fix it with area 1 stub no-summary.
6. On R4, change area 2 from NSSA to a normal stub area (no area 2 nssa, area 2 stub). Check the neighbors of R3 and R4. — R3 is still an NSSA router, so the area type does not match and the adjacency goes down. An ASBR could not exist in a stub area anyway. Note: Fix it with area 2 nssa.