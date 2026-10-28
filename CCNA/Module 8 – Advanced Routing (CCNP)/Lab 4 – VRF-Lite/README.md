## Lab 4 - VRF-Lite

> **GNS3 Project:** [`Module 8 - Advanced Routing (CCNP) | Lab 4 - VRF-Lite.gns3`](./Module%208%20-%20Advanced%20Routing%20%28CCNP%29%20%7C%20Lab%204%20-%20VRF-Lite.gns3)

![topology](topology.png)

## Scenario
Create the VRFs A and B on R1 and R2. Place the customer interfaces in the VRFs. Both customers use overlapping addresses, which is only possible because each VRF has its own routing table.

- **Devices:** A1 (PC), A2 (PC), B1 (PC), B2 (PC), R1 (IOU L3), R2 (IOU L3)
- **Base Addressing:**
  - `R1` Ethernet0/0.10: `10.10.10.1` (255.255.255.252)
  - `R1` Ethernet0/0.20: `10.10.20.1` (255.255.255.252)
  - `R1` Ethernet0/1: `192.168.1.1` (255.255.255.0)
  - `R1` Ethernet0/2: `192.168.1.1` (255.255.255.0)
  - `R2` Ethernet0/0.10: `10.10.10.2` (255.255.255.252)
  - `R2` Ethernet0/0.20: `10.10.20.2` (255.255.255.252)
  - `R2` Ethernet0/1: `192.168.2.1` (255.255.255.0)
  - `R2` Ethernet0/2: `192.168.2.1` (255.255.255.0)
  - `B2` Ethernet0: `192.168.2.11` (GW: 192.168.2.1)
  - `A1` Ethernet0: `192.168.1.11` (GW: 192.168.1.1)
  - `B1` Ethernet0: `192.168.1.11` (GW: 192.168.1.1)
  - `A2` Ethernet0: `192.168.2.11` (GW: 192.168.2.1)

Task 1 - Create the VRFs A and B on R1 and R2.
  - Place the customer interfaces in the VRFs.
  - Both customers use overlapping addresses, which is only possible because each VRF has its own routing table.

Task 2 - Connect R1 and R2 with one physical link that carries both VRFs.
  - Use the sub-interfaces .10 (VRF A) and .20 (VRF B).
  - Run a separate OSPF process in each VRF.

Task 3 - Verify the routing tables of both VRFs and the connectivity inside each VRF.

## Action
Task 1 - Create the VRFs A and B on R1 and R2.

**R1:**
```cisco
vrf definition A
address-family ipv4
exit-address-family
vrf definition B
address-family ipv4
exit-address-family
interface Ethernet0/1
vrf forwarding A
ip address 192.168.1.1 255.255.255.0
no shutdown
interface Ethernet0/2
vrf forwarding B
ip address 192.168.1.1 255.255.255.0
no shutdown
```

**R2:**
```cisco
vrf definition A
address-family ipv4
exit-address-family
vrf definition B
address-family ipv4
exit-address-family
interface Ethernet0/1
vrf forwarding A
ip address 192.168.2.1 255.255.255.0
no shutdown
interface Ethernet0/2
vrf forwarding B
ip address 192.168.2.1 255.255.255.0
no shutdown
```

Task 2 - Connect R1 and R2 with one physical link that carries both VRFs.

**R1:**
```cisco
interface Ethernet0/0
no shutdown
interface Ethernet0/0.10
encapsulation dot1Q 10
vrf forwarding A
ip address 10.10.10.1 255.255.255.252
interface Ethernet0/0.20
encapsulation dot1Q 20
vrf forwarding B
ip address 10.10.20.1 255.255.255.252
router ospf 10 vrf A
network 10.10.10.0 0.0.0.3 area 0
network 192.168.1.0 0.0.0.255 area 0
router ospf 20 vrf B
network 10.10.20.0 0.0.0.3 area 0
network 192.168.1.0 0.0.0.255 area 0
```

**R2:**
```cisco
interface Ethernet0/0
no shutdown
interface Ethernet0/0.10
encapsulation dot1Q 10
vrf forwarding A
ip address 10.10.10.2 255.255.255.252
interface Ethernet0/0.20
encapsulation dot1Q 20
vrf forwarding B
ip address 10.10.20.2 255.255.255.252
router ospf 10 vrf A
network 10.10.10.0 0.0.0.3 area 0
network 192.168.2.0 0.0.0.255 area 0
router ospf 20 vrf B
network 10.10.20.0 0.0.0.3 area 0
network 192.168.2.0 0.0.0.255 area 0
```

Task 3 - Verify the routing tables of both VRFs and the connectivity inside each VRF.

## Note
1. Verification commands: `Show ip route vrf A`
2. The route 192.168.2.0/24 should be learned through OSPF via 10.10.10.2. Show ip route vrf B
3. The route 192.168.2.0/24 should be learned through OSPF via 10.10.20.2. Ping vrf A 192.168.2.1
4. The ping should succeed. The same test in VRF B also works, and traffic never crosses between the VRFs.
5. On R1, configure the IP address of E 0/2 first and then put the interface in VRF B (remove vrf forwarding B and enter it again). — R1 removes the IP address and reports that the address was removed when the VRF was enabled. Always configure vrf forwarding before the IP address. Note: Enter the IP address again to fix it.
6. On R2, replace router ospf 20 vrf B with router ospf 20 (without the VRF). Check the neighbors of R2 and the connectivity between B1 and B2. — The process runs in the global routing table, but the interfaces are in VRF B. R2 has no OSPF neighbor in VRF B and B1 cannot reach B2. Note: Fix it with router ospf 20 vrf B.