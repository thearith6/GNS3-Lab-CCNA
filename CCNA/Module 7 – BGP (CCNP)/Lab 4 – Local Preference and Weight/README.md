## Lab 4 - Local Preference and Weight

> **GNS3 Project:** [`Module 6 - BGP (CCNP) | Lab 4 - Local Preference and Weight.gns3`](./Module%206%20-%20BGP%20%28CCNP%29%20%7C%20Lab%204%20-%20Local%20Preference%20and%20Weight.gns3)

![topo](image_3.png)

## Scenario
Configure eBGP between R1 (AS 65100) and R2 (AS 65200), R1 and R3 (AS 65300), R2 and R4 (AS 65400), and R3 and R4. Use the addresses of the directly connected links (R1 and R2 use the E 0/0 link). Advertise the Loopback 1 network of R1 and R4. Hard-code the router IDs to the Loopback 0 address of each router.

- **Devices:** R1 (IOU L3), R2 (IOU L3), R3 (IOU L3), R4 (IOU L3)
- **Base Addressing:**
  - `R2` Ethernet0/0: `10.12.0.2` (255.255.255.0)
  - `R2` Ethernet0/1: `10.24.0.2` (255.255.255.0)
  - `R2` Ethernet0/2: `10.12.1.2` (255.255.255.0)
  - `R2` Loopback0: `2.2.2.2` (255.255.255.255)
  - `R4` Ethernet0/0: `10.24.0.4` (255.255.255.0)
  - `R4` Ethernet0/1: `10.34.0.4` (255.255.255.0)
  - `R4` Loopback0: `4.4.4.4` (255.255.255.255)
  - `R4` Loopback1: `198.51.100.1` (255.255.255.0)
  - `R4` Loopback2: `203.0.113.1` (255.255.255.0)
  - `R4` Loopback3: `192.0.2.1` (255.255.255.0)
  - `R1` Ethernet0/0: `10.12.0.1` (255.255.255.0)
  - `R1` Ethernet0/1: `10.13.0.1` (255.255.255.0)
  - `R1` Ethernet0/2: `10.12.1.1` (255.255.255.0)
  - `R1` Loopback0: `1.1.1.1` (255.255.255.255)
  - `R1` Loopback1: `192.168.10.1` (255.255.255.0)
  - `R3` Ethernet0/0: `10.13.0.3` (255.255.255.0)
  - `R3` Ethernet0/1: `10.34.0.3` (255.255.255.0)
  - `R3` Loopback0: `3.3.3.3` (255.255.255.255)

Task 1 - Configure eBGP between R1 (AS 65100) and R2 (AS 65200), R1 and R3 (AS 65300), R2 and R4 (AS 65400), and R3 and R4.
  - Use the addresses of the directly connected links (R1 and R2 use the E 0/0 link).
  - Advertise the Loopback 1 network of R1 and R4.
  - Hard-code the router IDs to the Loopback 0 address of each router.

Task 2 - R1 must prefer ISP-B (R3) for all outbound traffic.
  - Set the local preference to 200 for all routes received from R3.

Task 3 - Now R1 must use ISP-A (R2) for 198.51.100.0/24 anyway.
  - Without changing the local preference, set the weight of the routes received from R2 to 500.

## Action
Task 1 - Configure eBGP between R1 (AS 65100) and R2 (AS 65200), R1 and R3 (AS 65300), R2 and R4 (AS 65400), and R3 and R4.

**R1:**
```cisco
router bgp 65100
bgp router-id 1.1.1.1
neighbor 10.12.0.2 remote-as 65200
neighbor 10.13.0.3 remote-as 65300
network 192.168.10.0 mask 255.255.255.0
router bgp 65200
bgp router-id 2.2.2.2
neighbor 10.12.0.1 remote-as 65100
neighbor 10.24.0.4 remote-as 65400
router bgp 65300
bgp router-id 3.3.3.3
neighbor 10.13.0.1 remote-as 65100
neighbor 10.34.0.4 remote-as 65400
router bgp 65400
bgp router-id 4.4.4.4
neighbor 10.24.0.2 remote-as 65200
neighbor 10.34.0.3 remote-as 65300
network 198.51.100.0 mask 255.255.255.0
```

Task 2 - R1 must prefer ISP-B (R3) for all outbound traffic.

**R1:**
```cisco
route-map PREFER-R3 permit 10
set local-preference 200
router bgp 65100
neighbor 10.13.0.3 route-map PREFER-R3 in
clear ip bgp * in
```
![Task-2](image.png)

Task 3 - Now R1 must use ISP-A (R2) for 198.51.100.0/24 anyway.

**R1:**
```cisco
route-map WEIGHT-R2 permit 10
set weight 500
router bgp 65100
neighbor 10.12.0.2 route-map WEIGHT-R2 in
clear ip bgp * in
```
![Task-3](image_1.png)

## Note

![Note](image_5.png)

1. Weight can apply directly - 'neighbor IP weight VALUE'
2. Local-preference no per neighbor apply but can apply to all default AS - 'bgp default local-preference VALUE'
3. Verification commands: `Show ip bgp 198.51.100.0` 
  - The best path should be via 10.13.0.3 with local preference 200.
  - After setting weight, the best path should now be via 10.12.0.2. Weight is checked before local preference.

4. In the route-map PREFER-R3, change the local preference to 300 but do not refresh the session. Check the BGP table of R1. — The table still shows the old value. An inbound policy is only applied to the routes after a refresh. Note: Apply it with clear ip bgp 10.13.0.3 in.

![Breakit-1.1](image_4.png)

![Breakit-1.2](image_2.png)
