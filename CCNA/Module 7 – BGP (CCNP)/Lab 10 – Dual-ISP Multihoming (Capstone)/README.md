## Lab 10 - Dual-ISP Multihoming (Capstone)

> **GNS3 Project:** [`Module 6 - BGP (CCNP) | Lab 10 - Dual-ISP Multihoming (Capstone).gns3`](./Module%206%20-%20BGP%20%28CCNP%29%20%7C%20Lab%2010%20-%20Dual-ISP%20Multihoming%20%28Capstone%29.gns3)

![topology](topology.png)

## Scenario
R2, R3 and R4 use the eBGP configuration of Lab 4 (Task 1). Configure R1 as a customer of both ISPs. R1 must only advertise its own network 192.168.10.0/24, so it can never become a transit AS. Use a prefix-list applied outbound to both neighbors.

- **Devices:** R1 (IOU L3), R2 (IOU L3), R3 (IOU L3), R4 (IOU L3)
- **Base Addressing:**
  - `R4` Ethernet0/0: `10.24.0.4` (255.255.255.0)
  - `R4` Ethernet0/1: `10.34.0.4` (255.255.255.0)
  - `R4` Loopback0: `4.4.4.4` (255.255.255.255)
  - `R4` Loopback1: `198.51.100.1` (255.255.255.0)
  - `R4` Loopback2: `203.0.113.1` (255.255.255.0)
  - `R4` Loopback3: `192.0.2.1` (255.255.255.0)
  - `R2` Ethernet0/0: `10.12.0.2` (255.255.255.0)
  - `R2` Ethernet0/1: `10.24.0.2` (255.255.255.0)
  - `R2` Ethernet0/2: `10.12.1.2` (255.255.255.0)
  - `R2` Loopback0: `2.2.2.2` (255.255.255.255)
  - `R3` Ethernet0/0: `10.13.0.3` (255.255.255.0)
  - `R3` Ethernet0/1: `10.34.0.3` (255.255.255.0)
  - `R3` Loopback0: `3.3.3.3` (255.255.255.255)
  - `R1` Ethernet0/0: `10.12.0.1` (255.255.255.0)
  - `R1` Ethernet0/1: `10.13.0.1` (255.255.255.0)
  - `R1` Ethernet0/2: `10.12.1.1` (255.255.255.0)
  - `R1` Loopback0: `1.1.1.1` (255.255.255.255)
  - `R1` Loopback1: `192.168.10.1` (255.255.255.0)

Task 1 - R2, R3 and R4 use the eBGP configuration of Lab 4 (Task 1).
  - Configure R1 as a customer of both ISPs.
  - R1 must only advertise its own network 192.168.10.0/24, so it can never become a transit AS.
  - Use a prefix-list applied outbound to both neighbors.

Task 2 - ISP-A (R2) is the primary provider and ISP-B (R3) is the backup.
  - For outbound traffic, set the local preference to 200 on the routes from R2.
  - For inbound traffic, prepend AS 65100 twice on the routes advertised to R3.

Task 3 - Test the failover.
  - Check the path to 198.51.100.0/24, shut down E 0/0 on R1 and check the path again.
  - Then bring the interface back up.

## Action
Task 1 - R2, R3 and R4 use the eBGP configuration of Lab 4 (Task 1).

**R1:**
```cisco
ip prefix-list MYNET seq 5 permit 192.168.10.0/24
router bgp 65100
bgp router-id 1.1.1.1
neighbor 10.12.0.2 remote-as 65200
neighbor 10.12.0.2 prefix-list MYNET out
neighbor 10.13.0.3 remote-as 65300
neighbor 10.13.0.3 prefix-list MYNET out
network 192.168.10.0 mask 255.255.255.0
```

Task 2 - ISP-A (R2) is the primary provider and ISP-B (R3) is the backup.

**R1:**
```cisco
route-map FROM-ISPA permit 10
set local-preference 200
route-map TO-ISPB permit 10
set as-path prepend 65100 65100
router bgp 65100
neighbor 10.12.0.2 route-map FROM-ISPA in
neighbor 10.13.0.3 route-map TO-ISPB out
clear ip bgp *
```

Task 3 - Test the failover.

## Note
1. Verification commands: `Show ip bgp 198.51.100.0`
2. The best path should be via 10.12.0.2 with local preference 200. interface Ethernet0/0 shutdown Show ip route 198.51.100.0
3. The traffic should now use ISP-B via 10.13.0.3. interface Ethernet0/0 no shutdown
4. On R1, remove both prefix-lists from the neighbors and refresh the sessions. Check the BGP table of R3. — R1 now advertises the routes of one ISP to the other. R3 learns 198.51.100.0/24 through AS 65100 as well, so R1 became a transit AS. Note: Fix it by applying the prefix-list outbound again.