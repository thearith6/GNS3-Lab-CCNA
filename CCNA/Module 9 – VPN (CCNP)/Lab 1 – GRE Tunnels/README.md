## Lab 1 - GRE Tunnels

> **GNS3 Project:** [`Module 9 - VPN (CCNP) | Lab 1 – GRE Tunnels.gns3`](./Module%209%20-%20VPN%20%28CCNP%29%20%7C%20Lab%201%20%E2%80%93%20GRE%20Tunnels.gns3)

![topology](topology.png)

## Scenario
Configure default routes on R1 and R3 so that they can reach the public address of each other through the ISP router R2.

- **Devices:** PC1 (PC), PC3 (PC), R1 (IOU L3), R2 (IOU L3), R3 (IOU L3)
- **Base Addressing:**
  - `R3` Ethernet0/0: `198.51.100.2` (255.255.255.252)
  - `R3` Ethernet0/1: `192.168.3.1` (255.255.255.0)
  - `R2` Ethernet0/0: `203.0.113.2` (255.255.255.252)
  - `R2` Ethernet0/1: `198.51.100.1` (255.255.255.252)
  - `R1` Ethernet0/0: `203.0.113.1` (255.255.255.252)
  - `R1` Ethernet0/1: `192.168.1.1` (255.255.255.0)
  - `PC1` Ethernet0: `192.168.1.11` (GW: 192.168.1.1)
  - `PC3` Ethernet0: `192.168.3.11` (GW: 192.168.3.1)

Task 1 - Configure default routes on R1 and R3 so that they can reach the public address of each other through the ISP router R2.
  - Configure on R1
  - Configure on R3

Task 2 - Configure a GRE tunnel between R1 (203.0.113.1) and R3 (198.51.100.2).
  - Use the network 172.16.0.0/30 for the tunnel, with .1 on R1 and .2 on R3.

Task 3 - Route the traffic between the LANs through the tunnel and verify from PC1.
  - Configure on R1

## Action
Task 1 - Configure default routes on R1 and R3 so that they can reach the public address of each other through the ISP router R2.

**R1:**
```cisco
ip route 0.0.0.0 0.0.0.0 203.0.113.2
```

**R3:**
```cisco
ip route 0.0.0.0 0.0.0.0 198.51.100.1
```

Task 2 - Configure a GRE tunnel between R1 (203.0.113.1) and R3 (198.51.100.2).

**R1:**
```cisco
interface Tunnel0
ip address 172.16.0.1 255.255.255.252
tunnel source Ethernet0/0
tunnel destination 198.51.100.2
```

**R3:**
```cisco
interface Tunnel0
ip address 172.16.0.2 255.255.255.252
tunnel source Ethernet0/0
tunnel destination 203.0.113.1
```

Task 3 - Route the traffic between the LANs through the tunnel and verify from PC1.

**R1:**
```cisco
ip route 192.168.3.0 255.255.255.0 172.16.0.2
ip route 192.168.1.0 255.255.255.0 172.16.0.1
Traceroute 192.168.3.11
```

## Note
1. Verification commands: `Ping 198.51.100.2`, `Show interfaces tunnel0`
2. The ping should succeed.
3. The tunnel should be up/up with the transport protocol GRE/IP.
4. The path should be R1, 172.16.0.2 and PC3. The ISP router R2 does not appear because the tunnel hides it.
5. On R3, change the tunnel destination to 203.0.113.9. Ping PC3 from PC1 and check the tunnel. — The tunnel interface stays up/up because GRE has no keepalives by default, but the packets go to a wrong address. The ping fails. Note: Fix it with tunnel destination 203.0.113.1.
6. On R1, add the route ip route 198.51.100.2 255.255.255.255 Tunnel0. Check the log. — R1 now reaches the tunnel destination through the tunnel itself. The log shows that Tunnel0 is temporarily disabled because of recursive routing, and the tunnel flaps. Note: Fix it by removing the route.