## Lab 2 - OSPFv3 for IPv6

> **GNS3 Project:** [`Module 5 - IPv6 (CCNA) | Lab 2 - OSPFv3 for IPv6.gns3`](./Module%205%20-%20IPv6%20%28CCNA%29%20%7C%20Lab%202%20-%20OSPFv3%20for%20IPv6.gns3)

![topo](image_3.png)

## Scenario
Remove the static routes from Lab 1. Configure OSPFv3 (IPv6 OSPF process 1) in area 0 on all links and loopbacks. The routers have no IPv4 address, so hard-code the router IDs to 1.1.1.1, 2.2.2.2 and 3.3.3.3.

- **Devices:** PC1 (PC), PC3 (PC), R1 (IOU L3), R2 (IOU L3), R3 (IOU L3)
- **Base Addressing:**
  - `R3` Ethernet0/0: `2001:db8:23::3/64`
  - `R3` Ethernet0/1: `2001:db8:30::1/64`
  - `R3` Loopback0: `2001:db8:ffff::3/128`
  - `R2` Ethernet0/0: `2001:db8:12::2/64`
  - `R2` Ethernet0/1: `2001:db8:23::2/64`
  - `R2` Loopback0: `2001:db8:ffff::2/128`
  - `R1` Ethernet0/0: `2001:db8:12::1/64`
  - `R1` Ethernet0/1: `2001:db8:10::1/64`
  - `R1` Loopback0: `2001:db8:ffff::1/128`
  - `PC1` Ethernet0: `auto`
  - `PC3` Ethernet0: `auto`

Task 1 - Remove the static routes from Lab 1.
  - Configure OSPFv3 (IPv6 OSPF process 1) in area 0 on all links and loopbacks.
  - The routers have no IPv4 address, so hard-code the router IDs to 1.1.1.1, 2.2.2.2 and 3.3.3.3.

Task 2 - Prevent OSPFv3 neighbors on the LAN links by making E 0/1 passive on R1 and R3.
  - Configure on R1
  - Configure on R3

Task 3 - Verify the neighbors and the routes on R1.

## Action
Task 1 - Remove the static routes from Lab 1.

**R1:**
```cisco
no ipv6 route ::/0 2001:db8:12::2
router ospfv3 1
router-id 1.1.1.1
interface range Ethernet0/0 - 1
ipv6 ospf 1 area 0
interface Loopback0
ipv6 ospf 1 area 0
```
**R2:**
```cisco
no ipv6 route 2001:db8:10::/64 2001:db8:12::1
no ipv6 route 2001:db8:30::/64 2001:db8:23::3
router ospfv3 1
router-id 2.2.2.2
interface range Ethernet0/0 - 1
ipv6 ospf 1 area 0
interface Loopback0
ipv6 ospf 1 area 0
```
**R3:**
```cisco
no ipv6 route ::/0 2001:db8:23::2
router ospfv3 1
router-id 3.3.3.3
interface range Ethernet0/0 - 1
ipv6 ospf 1 area 0
interface Loopback0
ipv6 ospf 1 area 0
```



Task 2 - Prevent OSPFv3 neighbors on the LAN links by making E 0/1 passive on R1 and R3.

**R1:**
```cisco
router ospfv3 1
passive-interface Ethernet0/1
```

**R3:**
```cisco
router ospfv3 1
passive-interface Ethernet0/1
```

Task 3 - Verify the neighbors and the routes on R1.

![Task-3](image_1.png)

## Note
1. 'router ospfv3 PROCESS-ID' is new version. Legacy: 'ipv6 router ospf PROCESS-ID'
2. R1 learn 2001:db8:23::/64, 2001:db8:30::/64 and the loopbacks of R2 and R3 through OSPF.
3. On R3, remove the router ID and restart the OSPFv3 process. R3 has no IPv4 address, so it cannot select a router ID and the OSPFv3 process does not start. But the lab demonstrate that R3 somehow still pick up its previous R-ID.

![Breakit-1.1](image_2.png)

 Unless we remove and reconfig OSPF process. Then R2 loses its neighbor.

![Breakit-1.2](image.png)


5. On R2, set the OSPFv3 hello interval of E0/1 to 5 seconds. Check the neighbors on R2. — The hello timers no longer match, and the adjacency with R3 goes down. Note: Fix it with no ipv6 ospf hello-interval.


![Breakit-2](image_4.png)
