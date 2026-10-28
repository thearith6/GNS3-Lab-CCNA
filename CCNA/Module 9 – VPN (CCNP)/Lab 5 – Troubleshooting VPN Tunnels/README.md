## Lab 5 - Troubleshooting VPN Tunnels

> **GNS3 Project:** [`Module 9 - VPN (CCNP) | Lab 5 – Troubleshooting VPN Tunnels.gns3`](./Module%209%20-%20VPN%20%28CCNP%29%20%7C%20Lab%205%20%E2%80%93%20Troubleshooting%20VPN%20Tunnels.gns3)

![topology](topology.png)

## Scenario
Use the GRE configuration of Lab 1. On R2, apply the ACL NO-GRE inbound on E 0/0. PC1 can no longer reach PC3, although Tunnel0 is up/up. Find and fix the fault.

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

Task 1 - Use the GRE configuration of Lab 1.
  - On R2, apply the ACL NO-GRE inbound on E 0/0.
  - PC1 can no longer reach PC3, although Tunnel0 is up/up.
  - Find and fix the fault.

Task 2 - On R3, change the tunnel destination to 203.0.113.9.
  - The tunnel still shows up/up, but the traffic is lost.
  - Find and fix the fault.

Task 3 - On R1, set the IP MTU of Tunnel0 to 1500 and test with a large packet that cannot be fragmented.
  - Find and fix the fault.
  - GRE adds 24 bytes, so use 1400 for the MTU and 1360 for the TCP MSS.

## Action
Task 1 - Use the GRE configuration of Lab 1.

**R2:**
```cisco
ip access-list extended NO-GRE
deny gre any any
permit ip any any
interface Ethernet0/0
ip access-group NO-GRE in
```

Task 2 - On R3, change the tunnel destination to 203.0.113.9.

Task 3 - On R1, set the IP MTU of Tunnel0 to 1500 and test with a large packet that cannot be fragmented.

**R1:**
```cisco
interface Tunnel0
ip mtu 1500
```

## Note
1. Verification commands: `Show access-lists NO-GRE`, `Show interfaces tunnel0`, `Ping 172.16.0.2 size 1500 df-bit`
2. The counter of the deny gre entry increases when PC1 sends traffic. interface Ethernet0/0 no ip access-group NO-GRE in
3. The output lists the tunnel destination 203.0.113.9, which is not the public address of R1. interface Tunnel0 tunnel destination 203.0.113.1
4. The ping fails, because the packet with the GRE header is larger than the 1500 bytes the link can carry. interface Tunnel0 ip mtu 1400 ip tcp adjust-mss 1360 Ping 172.16.0.2 size 1400 df-bit
5. The ping should succeed.
6. On R2, shut down E 0/1 (the link towards R3). Check Tunnel0 on R1, then enable keepalives on Tunnel0 with keepalive 5 3. — Without keepalives the tunnel stays up/up although the path is broken. interface Tunnel0 keepalive 5 3 Note: After a few missed keepalives the tunnel goes down, so a routing protocol or a tracked route can use a backup path.