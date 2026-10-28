## Lab 3 - PPPoE Edge with PAT and Default Route

> **GNS3 Project:** [`Module 7 - PPPoE (CCNP) | Lab 3 - PPPoE Edge with PAT and Default Route.gns3`](./Module%207%20-%20PPPoE%20%28CCNP%29%20%7C%20Lab%203%20-%20PPPoE%20Edge%20with%20PAT%20and%20Default%20Route.gns3)

![topology](topology.png)

## Scenario
Configure PAT on R1 so that the LAN 192.168.10.0/24 can reach the Internet using the address of Dialer1.

- **Devices:** PC1 (PC), R1 (IOU L3), R2 (IOU L3), R3 (IOU L3)
- **Base Addressing:**
  - `R2` Ethernet0/1: `203.0.113.1` (255.255.255.252)
  - `R2` Virtual-Template1: `10.255.0.1` (255.255.255.255)
  - `R3` Ethernet0/0: `203.0.113.2` (255.255.255.252)
  - `R3` Loopback0: `198.51.100.1` (255.255.255.255)
  - `R1` Ethernet0/1: `192.168.10.1` (255.255.255.0)
  - `PC1` Ethernet0: `192.168.10.11` (GW: 192.168.10.1)

Task 1 - Configure PAT on R1 so that the LAN 192.168.10.0/24 can reach the Internet using the address of Dialer1.
  - Configure on R1

Task 2 - Configure the routing.
  - R1 uses Dialer1 as its default route, R2 uses R3 as its default gateway and R3 needs a route back to the PPPoE pool.

Task 3 - Ping 198.51.100.1 from PC1 and verify the translation on R1.

## Action
Task 1 - Configure PAT on R1 so that the LAN 192.168.10.0/24 can reach the Internet using the address of Dialer1.

**R1:**
```cisco
access-list 1 permit 192.168.10.0 0.0.0.255
interface Ethernet0/1
ip nat inside
interface Dialer1
ip nat outside
ip nat inside source list 1 interface Dialer1 overload
```

Task 2 - Configure the routing.

**R1:**
```cisco
ip route 0.0.0.0 0.0.0.0 Dialer1
ip route 0.0.0.0 0.0.0.0 203.0.113.2
ip route 10.255.0.0 255.255.255.0 203.0.113.1
```

Task 3 - Ping 198.51.100.1 from PC1 and verify the translation on R1.

## Note
1. Verification commands: `Ping 198.51.100.1`, `Show ip nat translations`
2. The ping should succeed.
3. The icmp entry should translate 192.168.10.11 to the address of Dialer1 (from the pool 10.255.0.10 – 10.255.0.50).
4. On R1, remove ip nat outside from Dialer1. Ping 198.51.100.1 from PC1. R1 — The ping fails. The private source address leaves R1 without translation, so the replies do not return. Note: Fix it with ip nat outside.
5. On R1, remove the default route. Ping 198.51.100.1 from PC1. R1 — R1 has no route to 198.51.100.1 and drops the packets. Note: Fix it with ip route 0.0.0.0 0.0.0.0 Dialer1.