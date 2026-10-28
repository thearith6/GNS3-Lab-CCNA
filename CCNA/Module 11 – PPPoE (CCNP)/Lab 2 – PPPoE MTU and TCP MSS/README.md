## Lab 2 - PPPoE MTU and TCP MSS

> **GNS3 Project:** [`Module 7 - PPPoE (CCNP) | Lab 2 - PPPoE MTU and TCP MSS.gns3`](./Module%207%20-%20PPPoE%20%28CCNP%29%20%7C%20Lab%202%20-%20PPPoE%20MTU%20and%20TCP%20MSS.gns3)

![topology](topology.png)

## Scenario
Configure the routing that R1 needs to reach the loopback of R3 through the PPPoE link: a default route on R1 towards Dialer1, a route on R2 to the loopback of R3 and a route on R3 back to the PPPoE pool.

- **Devices:** PC1 (PC), R1 (IOU L3), R2 (IOU L3), R3 (IOU L3)
- **Base Addressing:**
  - `R1` Ethernet0/1: `192.168.10.1` (255.255.255.0)
  - `R2` Ethernet0/1: `203.0.113.1` (255.255.255.252)
  - `R2` Virtual-Template1: `10.255.0.1` (255.255.255.255)
  - `R3` Ethernet0/0: `203.0.113.2` (255.255.255.252)
  - `R3` Loopback0: `198.51.100.1` (255.255.255.255)
  - `PC1` Ethernet0: `192.168.10.11` (GW: 192.168.10.1)

Task 1 - Configure the routing that R1 needs to reach the loopback of R3 through the PPPoE link: a default route on R1 towards Dialer1, a route on R2 to the loopback of R3 and a route on R3 back to the PPPoE pool.
  - Configure on R1

Task 2 - PPPoE adds 8 bytes of overhead.
  - Set the IP MTU to 1492 on Dialer1 of R1 and on Virtual-Template 1 of R2, and adjust the TCP MSS to 1452 on both interfaces.

Task 3 - Verify the MTU and test the largest packet that can pass.

## Action
Task 1 - Configure the routing that R1 needs to reach the loopback of R3 through the PPPoE link: a default route on R1 towards Dialer1, a route on R2 to the loopback of R3 and a route on R3 back to the PPPoE pool.

**R1:**
```cisco
ip route 0.0.0.0 0.0.0.0 Dialer1
ip route 198.51.100.1 255.255.255.255 203.0.113.2
ip route 10.255.0.0 255.255.255.0 203.0.113.1
```

Task 2 - PPPoE adds 8 bytes of overhead.

**R1:**
```cisco
interface Dialer1
ip mtu 1492
ip tcp adjust-mss 1452
```

**R2:**
```cisco
interface Virtual-Template1
ip mtu 1492
ip tcp adjust-mss 1452
```

Task 3 - Verify the MTU and test the largest packet that can pass.

## Note
1. Verification commands: `Show interfaces dialer1`
2. The MTU should be 1492 bytes. Ping 198.51.100.1 size 1492 df-bit
3. The ping should succeed. Ping 198.51.100.1 size 1493 df-bit
4. The ping should fail, because the packet is larger than the MTU and cannot be fragmented.
5. On R1, set the IP MTU of Dialer1 back to 1500. Ping 198.51.100.1 with size 1500 and the df-bit. — The pings fail. With the 8 bytes of PPPoE overhead, a 1500-byte packet does not fit in an Ethernet frame. Note: Fix it with ip mtu 1492.