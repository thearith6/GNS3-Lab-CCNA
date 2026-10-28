## Lab 1 - eBGP Neighbors and Loopback Peering

> **GNS3 Project:** [`Module 6 - BGP (CCNP) | Lab 1 - eBGP Neighbors and Loopback Peering.gns3`](./Module%206%20-%20BGP%20%28CCNP%29%20%7C%20Lab%201%20-%20eBGP%20Neighbors%20and%20Loopback%20Peering.gns3)

![topology](topology.png)

## Scenario
Configure an eBGP neighbor relationship between R2 (AS 65200) and R3 (AS 65300) using the addresses of the directly connected link. Hard-code the router IDs to 2.2.2.2 and 3.3.3.3. Advertise the Loopback 1 networks in BGP.

- **Devices:** R1 (IOU L3), R2 (IOU L3), R3 (IOU L3)
- **Base Addressing:**
  - `R3` Ethernet0/0: `10.23.1.3` (255.255.255.0)
  - `R3` Loopback0: `3.3.3.3` (255.255.255.255)
  - `R3` Loopback1: `192.168.3.1` (255.255.255.0)
  - `R1` Ethernet0/0: `10.12.1.1` (255.255.255.0)
  - `R1` Ethernet0/1: `10.12.2.1` (255.255.255.0)
  - `R1` Loopback0: `1.1.1.1` (255.255.255.255)
  - `R1` Loopback1: `192.168.1.1` (255.255.255.0)
  - `R2` Ethernet0/0: `10.12.1.2` (255.255.255.0)
  - `R2` Ethernet0/1: `10.12.2.2` (255.255.255.0)
  - `R2` Ethernet0/2: `10.23.1.2` (255.255.255.0)
  - `R2` Loopback0: `2.2.2.2` (255.255.255.255)
  - `R2` Loopback1: `192.168.2.1` (255.255.255.0)

Task 1 - Configure an eBGP neighbor relationship between R2 (AS 65200) and R3 (AS 65300) using the addresses of the directly connected link.
  - Hard-code the router IDs to 2.2.2.2 and 3.3.3.3.
  - Advertise the Loopback 1 networks in BGP.

Task 2 - Configure an eBGP neighbor relationship between R1 (AS 65100) and R2 using the Loopback 0 addresses, so that the session survives the failure of one of the two links.
  - Use static routes over both links to reach the loopbacks.
  - Hard-code the router ID of R1 to 1.1.1.1 and advertise its Loopback 1 network.

Task 3 - Verify the BGP neighbor and the BGP table on R1.

## Action
Task 1 - Configure an eBGP neighbor relationship between R2 (AS 65200) and R3 (AS 65300) using the addresses of the directly connected link.

**R2:**
```cisco
router bgp 65200
bgp router-id 2.2.2.2
neighbor 10.23.1.3 remote-as 65300
network 192.168.2.0 mask 255.255.255.0
```

**R3:**
```cisco
router bgp 65300
bgp router-id 3.3.3.3
neighbor 10.23.1.2 remote-as 65200
network 192.168.3.0 mask 255.255.255.0
```

Task 2 - Configure an eBGP neighbor relationship between R1 (AS 65100) and R2 using the Loopback 0 addresses, so that the session survives the failure of one of the two links.

**R1:**
```cisco
ip route 2.2.2.2 255.255.255.255 10.12.1.2
ip route 2.2.2.2 255.255.255.255 10.12.2.2
router bgp 65100
bgp router-id 1.1.1.1
neighbor 2.2.2.2 remote-as 65200
neighbor 2.2.2.2 update-source Loopback0
neighbor 2.2.2.2 ebgp-multihop 2
network 192.168.1.0 mask 255.255.255.0
```

**R2:**
```cisco
ip route 1.1.1.1 255.255.255.255 10.12.1.1
ip route 1.1.1.1 255.255.255.255 10.12.2.1
router bgp 65200
neighbor 1.1.1.1 remote-as 65100
neighbor 1.1.1.1 update-source Loopback0
neighbor 1.1.1.1 ebgp-multihop 2
```

Task 3 - Verify the BGP neighbor and the BGP table on R1.

## Note
1. Verification commands: `Show ip bgp summary`
2. Neighbor 2.2.2.2 should be established and show 2 prefixes received. Show ip bgp
3. 192.168.3.0/24 should have the AS path 65200 65300.
4. On R1, remove ebgp-multihop from the neighbor 2.2.2.2. Check the BGP neighbor. R1 — The session no longer establishes because the loopback address of R2 is not on a directly connected network. Note: Fix it with neighbor 2.2.2.2 ebgp-multihop 2.
5. On R1, shut down E 0/0. Check the BGP neighbor. R1 — The BGP session stays up because the static route over E 0/1 still reaches 2.2.2.2. Note: Fix it with no shutdown.