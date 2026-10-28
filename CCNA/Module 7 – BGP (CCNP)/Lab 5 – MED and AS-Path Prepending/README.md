## Lab 5 - MED and AS-Path Prepending

> **GNS3 Project:** [`Module 6 - BGP (CCNP) | Lab 5 - MED and AS-Path Prepending.gns3`](./Module%206%20-%20BGP%20%28CCNP%29%20%7C%20Lab%205%20-%20MED%20and%20AS-Path%20Prepending.gns3)

![topology](topology.png)

## Scenario
Starting from the eBGP configuration of Lab 4 (Task 1), add a second eBGP session between R1 and R2 over the E 0/2 link (10.12.1.0/24). Configure R1 so that R2 prefers the E 0/0 link for the network 192.168.10.0/24, by sending a MED of 50 on E 0/0 and a MED of 100 on E 0/2.

- **Devices:** R1 (IOU L3), R2 (IOU L3), R3 (IOU L3), R4 (IOU L3)
- **Base Addressing:**
  - `R2` Ethernet0/0: `10.12.0.2` (255.255.255.0)
  - `R2` Ethernet0/1: `10.24.0.2` (255.255.255.0)
  - `R2` Ethernet0/2: `10.12.1.2` (255.255.255.0)
  - `R2` Loopback0: `2.2.2.2` (255.255.255.255)
  - `R1` Ethernet0/0: `10.12.0.1` (255.255.255.0)
  - `R1` Ethernet0/1: `10.13.0.1` (255.255.255.0)
  - `R1` Ethernet0/2: `10.12.1.1` (255.255.255.0)
  - `R1` Loopback0: `1.1.1.1` (255.255.255.255)
  - `R1` Loopback1: `192.168.10.1` (255.255.255.0)
  - `R4` Ethernet0/0: `10.24.0.4` (255.255.255.0)
  - `R4` Ethernet0/1: `10.34.0.4` (255.255.255.0)
  - `R4` Loopback0: `4.4.4.4` (255.255.255.255)
  - `R4` Loopback1: `198.51.100.1` (255.255.255.0)
  - `R4` Loopback2: `203.0.113.1` (255.255.255.0)
  - `R4` Loopback3: `192.0.2.1` (255.255.255.0)
  - `R3` Ethernet0/0: `10.13.0.3` (255.255.255.0)
  - `R3` Ethernet0/1: `10.34.0.3` (255.255.255.0)
  - `R3` Loopback0: `3.3.3.3` (255.255.255.255)

Task 1 - Starting from the eBGP configuration of Lab 4 (Task 1), add a second eBGP session between R1 and R2 over the E 0/2 link (10.12.1.0/24).
  - Configure R1 so that R2 prefers the E 0/0 link for the network 192.168.10.0/24, by sending a MED of 50 on E 0/0 and a MED of 100 on E 0/2.

Task 2 - ISP-B (R3) must be the preferred path into AS 65100.
  - Add AS-path prepending (65100 three times) to the routes that R1 sends to R2 on both links.

Task 3 - Verify the paths on R2 and R4.

## Action
Task 1 - Starting from the eBGP configuration of Lab 4 (Task 1), add a second eBGP session between R1 and R2 over the E 0/2 link (10.12.1.0/24).

**R1:**
```cisco
route-map MED-E00 permit 10
set metric 50
route-map MED-E02 permit 10
set metric 100
router bgp 65100
neighbor 10.12.1.2 remote-as 65200
neighbor 10.12.0.2 route-map MED-E00 out
neighbor 10.12.1.2 route-map MED-E02 out
clear ip bgp * out
```

**R2:**
```cisco
router bgp 65200
neighbor 10.12.1.1 remote-as 65100
```

Task 2 - ISP-B (R3) must be the preferred path into AS 65100.

**R1:**
```cisco
route-map MED-E00 permit 10
set as-path prepend 65100 65100 65100
route-map MED-E02 permit 10
set as-path prepend 65100 65100 65100
clear ip bgp * out
```

Task 3 - Verify the paths on R2 and R4.

## Note
1. Verification commands: `Show ip bgp 192.168.10.0`
2. R2 should have two paths. The path from 10.12.0.1 has the lower metric (50) and is the best path.
3. R4 should select the path via R3 (10.34.0.3). Its AS path 65300 65100 is shorter than 65200 65100 65100 65100 65100.
4. On R1, apply the route-map MED-E00 inbound instead of outbound for the neighbor 10.12.0.2. Check the BGP table of R4. — R2 no longer receives the prepended path and the MED from this neighbor. R4 can choose the path via R2 again. Note: Apply the route-map outbound to fix it.
5. Change the number of prepends in MED-E02 to 1 and do not refresh the session. Check the BGP table of R2. — R2 still shows the old AS path. An outbound policy is only applied to the updates after a refresh. Note: Apply it with clear ip bgp 10.12.1.2 out.