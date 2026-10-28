## Lab 1 - IPv6 Addressing, SLAAC and Static Routing

> **GNS3 Project:** [`Module 5 - IPv6 (CCNA) | Lab 1 - IPv6 Addressing, SLAAC and Static Routing.gns3`](./Module%205%20-%20IPv6%20%28CCNA%29%20%7C%20Lab%201%20-%20IPv6%20Addressing%2C%20SLAAC%20and%20Static%20Routing.gns3)

![topology](topology.png)

## Scenario
Enable IPv6 routing on all routers and configure the IPv6 addresses shown in the table. Bring the interfaces up.

- **Devices:** PC1 (PC), PC3 (PC), R1 (IOU L3), R2 (IOU L3), R3 (IOU L3)
- **Base Addressing:**
  - `R1` Ethernet0/0: `2001:db8:12::1/64`
  - `R1` Ethernet0/1: `2001:db8:10::1/64`
  - `R1` Loopback0: `2001:db8:ffff::1/128`
  - `R2` Ethernet0/0: `2001:db8:12::2/64`
  - `R2` Ethernet0/1: `2001:db8:23::2/64`
  - `R2` Loopback0: `2001:db8:ffff::2/128`
  - `R3` Ethernet0/0: `2001:db8:23::3/64`
  - `R3` Ethernet0/1: `2001:db8:30::1/64`
  - `R3` Loopback0: `2001:db8:ffff::3/128`
  - `PC1` Ethernet0: `auto`
  - `PC3` Ethernet0: `auto`

Task 1 - Enable IPv6 routing on all routers and configure the IPv6 addresses shown in the table.
  - Bring the interfaces up.

Task 2 - The PCs use SLAAC.
  - Configure R1 and R3 to advertise their LAN prefix with a valid lifetime of 1 day (86400 seconds) and a preferred lifetime of 12 hours (43200 seconds).

Task 3 - Configure static routes so that all networks can reach each other.
  - R1 and R3 use a default route.
  - Verify from PC1.

## Action
Task 1 - Enable IPv6 routing on all routers and configure the IPv6 addresses shown in the table.

**R1:**
```cisco
ipv6 unicast-routing
interface Ethernet0/0
ipv6 address 2001:db8:12::1/64
no shutdown
interface Ethernet0/1
ipv6 address 2001:db8:10::1/64
no shutdown
interface Loopback0
ipv6 address 2001:db8:ffff::1/128
ipv6 unicast-routing
interface Ethernet0/0
ipv6 address 2001:db8:12::2/64
no shutdown
interface Ethernet0/1
ipv6 address 2001:db8:23::2/64
no shutdown
interface Loopback0
ipv6 address 2001:db8:ffff::2/128
ipv6 unicast-routing
interface Ethernet0/0
ipv6 address 2001:db8:23::3/64
no shutdown
interface Ethernet0/1
ipv6 address 2001:db8:30::1/64
no shutdown
interface Loopback0
ipv6 address 2001:db8:ffff::3/128
```

Task 2 - The PCs use SLAAC.

**R1:**
```cisco
interface Ethernet0/1
ipv6 nd prefix 2001:db8:10::/64 86400
43200
```

**R3:**
```cisco
interface Ethernet0/1
ipv6 nd prefix 2001:db8:30::/64 86400
43200
```

Task 3 - Configure static routes so that all networks can reach each other.

**R1:**
```cisco
ipv6 route ::/0 2001:db8:12::2
ipv6 route 2001:db8:10::/64 2001:db8:12::1
ipv6 route 2001:db8:30::/64 2001:db8:23::3
ipv6 route ::/0 2001:db8:23::2
```

## Note
1. Verification commands: `Ping 2001:db8:30::1`
2. The ping should succeed. PC1 should have an address in 2001:db8:10::/64 learned through SLAAC.
3. On R2, disable IPv6 routing with no ipv6 unicast-routing. Ping R3 from PC1. R2 — R2 stops forwarding IPv6 packets. PC1 can still reach R1 but no longer R3. Note: Fix it with ipv6 unicast-routing.
4. On R1, replace the default route with ipv6 route ::/0 2001:db8:12::3. Ping R3 from PC1. — The next hop 2001:db8:12::3 does not exist on this link, so the packets are lost. Note: Fix it by configuring the next hop 2001:db8:12::2 again.