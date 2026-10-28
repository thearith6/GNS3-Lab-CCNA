## Lab 5 - Standard and Named ACLs

> **GNS3 Project:** [`Module 3 - IP Services (CCNA) | Lab 5 - Standard and Named ACLs.gns3`](./Module%203%20-%20IP%20Services%20%28CCNA%29%20%7C%20Lab%205%20-%20Standard%20and%20Named%20ACLs.gns3)

![topo](image_3.png)

## Scenario
Only PC1 (192.168.10.11) may open a management session to R1. Create a standard ACL and apply it to the VTY lines.

- **Devices:** PC1 (PC), PC2 (PC), R1 (IOU L3), SRV1 (PC), SW1 (Ethernet Switch)
- **Base Addressing:**
  - `R1` Ethernet0/0: `192.168.10.1` (255.255.255.0)
  - `R1` Ethernet0/1: `192.168.20.1` (255.255.255.0)
  - `PC2` Ethernet0: `192.168.10.12` (GW: 192.168.10.1)
  - `SRV1` Ethernet0: `192.168.20.80` (GW: 192.168.20.1)
  - `PC1` Ethernet0: `192.168.10.11` (GW: 192.168.10.1)

Task 1 - Only PC1 (192.168.10.11) may open a management session to R1.
  - Create a standard ACL and apply it to the VTY lines.

Task 2 - PC2 (192.168.10.12) must not reach the server network 192.168.20.0/24.
  - Create a numbered standard ACL and apply it outbound on E 0/1.
  - All other hosts must still pass.

Task 3 - Replace the numbered ACL with a named standard ACL that has a remark.
  - Verify the counters after PC2 and PC1 ping SRV1.

## Action
Task 1 - Only PC1 (192.168.10.11) may open a management session to R1.

**R1:**
```cisco
access-list 10 permit host 192.168.10.11
line vty 0 4
access-class 10 in
```

Task 2 - PC2 (192.168.10.12) must not reach the server network 192.168.20.0/24.

**R1:**
```cisco
access-list 20 deny host 192.168.10.12
access-list 20 permit any
interface Ethernet0/1
ip access-group 20 out
```

Task 3 - Replace the numbered ACL with a named standard ACL that has a remark.

**R1:**
```cisco
ip access-list standard BLOCK-PC2
remark Block PC2 from the server network
deny host 192.168.10.12
permit any
interface Ethernet0/1
no ip access-group 20 out
ip access-group BLOCK-PC2 out
no access-list 20
```

## Note
1. Verification commands: `Show access-lists`
  - The deny entry should show matches after the ping from PC2. PC1 still reaches SRV1.

![Verification-1](image.png)

2. On R1, apply BLOCK-PC2 inbound on E0/1 instead of outbound. Ping SRV1 from PC2. — Inbound on E0/1 the ACL only sees traffic coming from the server network. PC2 can reach SRV1 again. Note: Apply the ACL outbound to fix it.

![Breakit-1](image_1.png)

3. On R1, delete the permit any entry from BLOCK-PC2. Ping SRV1 from PC1. R1 — Every ACL ends with an implicit deny. Now PC1 cannot reach SRV1 either. Note: Fix it with permit any.

![Breakit-2](image_2.png)
