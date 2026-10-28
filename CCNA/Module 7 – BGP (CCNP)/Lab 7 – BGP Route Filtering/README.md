## Lab 7 - BGP Route Filtering

> **GNS3 Project:** [`Module 6 - BGP (CCNP) | Lab 7 - BGP Route Filtering.gns3`](./Module%206%20-%20BGP%20%28CCNP%29%20%7C%20Lab%207%20-%20BGP%20Route%20Filtering.gns3)

![topology](topology.png)

## Scenario
R4 advertises two more networks (203.0.113.0/24 and 192.0.2.0/24). R1 must only accept the network 198.51.100.0/24 from ISP-B (R3). Use a prefix-list applied inbound to the neighbor R3.

- **Devices:** R1 (IOU L3), R2 (IOU L3), R3 (IOU L3), R4 (IOU L3)
- **Base Addressing:**
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
  - `R2` Ethernet0/0: `10.12.0.2` (255.255.255.0)
  - `R2` Ethernet0/1: `10.24.0.2` (255.255.255.0)
  - `R2` Ethernet0/2: `10.12.1.2` (255.255.255.0)
  - `R2` Loopback0: `2.2.2.2` (255.255.255.255)

Task 1 - R4 advertises two more networks (203.0.113.0/24 and 192.0.2.0/24).
  - R1 must only accept the network 198.51.100.0/24 from ISP-B (R3).
  - Use a prefix-list applied inbound to the neighbor R3.

Task 2 - R1 must not become a transit AS.
  - Only routes that originate in AS 65100 may be advertised to the ISPs.
  - Use an AS-path access list with the regular expression ^$ and apply it outbound to both neighbors.

Task 3 - Verify the filters.

## Action
Task 1 - R4 advertises two more networks (203.0.113.0/24 and 192.0.2.0/24).

**R4:**
```cisco
router bgp 65400
network 203.0.113.0 mask 255.255.255.0
network 192.0.2.0 mask 255.255.255.0
```

**R1:**
```cisco
ip prefix-list ONLY-198 seq 5 permit
198.51.100.0/24
router bgp 65100
neighbor 10.13.0.3 prefix-list ONLY-198 in
clear ip bgp 10.13.0.3 in
```

Task 2 - R1 must not become a transit AS.

**R1:**
```cisco
ip as-path access-list 1 permit ^$
router bgp 65100
neighbor 10.12.0.2 filter-list 1 out
neighbor 10.13.0.3 filter-list 1 out
clear ip bgp * out
```

Task 3 - Verify the filters.

## Note
1. Verification commands: `Show ip bgp`, `Show ip bgp regexp _65100$`, `Show ip bgp regexp _65400$`
2. Through R3 only 198.51.100.0/24 should be learned. All three networks should be learned through R2.
3. Only 192.168.10.0/24 should be listed.
4. The command lists the networks that originate in AS 65400.
5. On R1, replace the prefix-list with a single entry: ip prefix-list ONLY-198 seq 5 deny 198.51.100.0/24. Check the BGP table of R1. — The prefix-list has an implicit deny at the end. R1 no longer accepts any route from R3. Note: Fix it with a permit entry.
6. On R1, replace the AS-path access list with ip as-path access-list 1 permit ^65100$. Check the BGP table of R2. — A route originated by R1 has an empty AS path when it leaves R1, so it does not match ^65100$. R1 no longer advertises 192.168.10.0/24. Note: Fix it with ^$.