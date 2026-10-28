## Lab 2 - NAT: PAT and Static NAT

> **GNS3 Project:** [`Module 3 - IP Services (CCNA) | Lab 2 - NAT: PAT and Static NAT.gns3`](./Module%203%20-%20IP%20Services%20%28CCNA%29%20%7C%20Lab%202%20-%20NAT%3A%20PAT%20and%20Static%20NAT.gns3)

![topo](image.png)

## Scenario
Configure R1 so that all hosts in 192.168.10.0/24 can reach the ISP using the address of the outside interface (PAT). Add a default route towards the ISP.

- **Devices:** ISP (IOU L3), PC1 (PC), PC2 (PC), R1 (IOU L3), SW1 (Ethernet Switch), WEB (PC)
- **Base Addressing:**
  - `ISP` Ethernet0/0: `203.0.113.1` (255.255.255.248)
  - `ISP` Loopback0: `198.51.100.1` (255.255.255.255)
  - `R1` Ethernet0/0: `192.168.10.1` (255.255.255.0)
  - `R1` Ethernet0/1: `203.0.113.2` (255.255.255.248)
  - `PC2` Ethernet0: `192.168.10.12` (GW: 192.168.10.1)
  - `WEB` Ethernet0: `192.168.10.80` (GW: 192.168.10.1)
  - `PC1` Ethernet0: `192.168.10.11` (GW: 192.168.10.1)

Task 1 - Configure R1 so that all hosts in 192.168.10.0/24 can reach the ISP using the address of the outside interface (PAT).
  - Add a default route towards the ISP.

Task 2 - Publish the WEB server (192.168.10.80) on the Internet using static NAT and the public address 203.0.113.3.
  - Configure on R1

Task 3 - Ping 198.51.100.1 from PC1 and verify the translations on R1.

## Action
Task 1 - Configure R1 so that all hosts in 192.168.10.0/24 can reach the ISP using the address of the outside interface (PAT).

**R1:**
```cisco
access-list 1 permit 192.168.10.0 0.0.0.255
interface Ethernet0/0
ip nat inside
interface Ethernet0/1
ip nat outside
ip nat inside source list 1 interface Ethernet0/1 overload
ip route 0.0.0.0 0.0.0.0 203.0.113.1
```

Task 2 - Publish the WEB server (192.168.10.80) on the Internet using static NAT and the public address 203.0.113.3.

**R1:**
```cisco
ip nat inside source static 192.168.10.80 203.0.113.3
```

Task 3 - Ping 198.51.100.1 from PC1 and verify the translations on R1.
![Task-3](image_1.png)

## Note
1. Verification commands: `Show ip nat translations`
  - The icmp entry should translate the inside local address 192.168.10.11 to the inside global address 203.0.113.2. 
  - Show ip nat statistics - The hits counter should increase and the static translation for WEB should be listed.

![Verification](image_2.png)

2. On R1, remove ip nat outside from E0/1. Ping 198.51.100.1 from PC1. R1 — The ping fails and no new translations are created. Note: Fix it with ip nat outside.

![Breakit-1](image_3.png)

3. On R1, change ACL 1 so that it only permits the host 192.168.10.11. Ping 198.51.100.1 from PC1 and from PC2. — PC1 still works, but PC2 can no longer reach the ISP because its traffic is not translated.

![Breakit-2](image_4.png)

Note: Restore the ACL with access-list 1 permit 192.168.10.0 0.0.0.255.

![Breakit-2-fix](image_5.png)
