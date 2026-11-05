# Lab 3.6: Extended ACLs

> **GNS3 Project:** [`Module 3 - IP Services (CCNA) | Lab 4 - Extended ACLs.gns3`](./Module%203%20-%20IP%20Services%20%28CCNA%29%20%7C%20Lab%204%20-%20Extended%20ACLs.gns3)
> **Platform:** GNS3 3.1 · Cisco IOL L3 `17.18.2` · 1 router, 3 VPCS hosts, GNS3 Ethernet switch
> **Key takeaway:** An ACL is processed top to bottom and stops at the first match, so entry order (sequence numbers) decides the result. An extended ACL matches source, destination and protocol/port, so it belongs close to the source.

![Topology Diagram](image_4.png)

---

## 1. Scenario & Tasks

Same topology and addressing as Lab 3.5.

- **Task 1 — Web access:** Create an extended ACL named `SERVER_ACCESS` that permits HTTP and HTTPS from `192.168.10.0/24` to SRV1 (`192.168.20.80`), and apply it inbound on `E0/0` of R1.
- **Task 2 — Restrict ping:** Allow only PC1 (`192.168.10.11`) to ping SRV1. All other traffic from the LAN to SRV1 is denied and logged.
- **Task 3 — Permit the rest:** Permit all remaining traffic so the LAN can still reach every other destination, then ping SRV1 from PC1 and PC2 and verify the ACL.

---

## 2. Configuration & Verification

### Task 1: Permit HTTP and HTTPS to SRV1

**R1:**
~~~cisco
ip access-list extended SERVER_ACCESS
 permit tcp 192.168.10.0 0.0.0.255 host 192.168.20.80 eq 80
 permit tcp 192.168.10.0 0.0.0.255 host 192.168.20.80 eq 443
interface Ethernet0/0
 ip access-group SERVER_ACCESS in
~~~

---

### Task 2: Ping Only from PC1, Deny and Log the Rest

**R1:**
~~~cisco
ip access-list extended SERVER_ACCESS
 30 permit icmp host 192.168.10.11 host 192.168.20.80 echo
 40 deny ip 192.168.10.0 0.0.0.255 host 192.168.20.80 log
~~~

---

### Task 3: Permit All Remaining Traffic

**R1:**
~~~cisco
ip access-list extended SERVER_ACCESS
 50 permit ip any any
~~~

---

### Verification (`show access-lists`)

* The match counter of the ICMP entry increases after the ping from PC1, and the counter of the deny entry increases after the ping from PC2.

![Verification-1](image.png)

![Verification-2](image_2.png)

---

## 3. Notes & Fault-Injection (Break-It)

### Fault-Injection 1: Early `permit ip any any`
* **Injected Fault:** On R1, added `permit ip any any` at sequence 5 and pinged SRV1 from PC2.
* **Symptom:** The ACL is processed from top to bottom, so everything is permitted at the first entry. The ping from PC2 now succeeds.
* **Fix:** `no 5`

![Breakit-1](image_1.png)

### Fault-Injection 2: ACL on the Wrong Interface
* **Injected Fault:** Removed the ACL from `E0/0` and applied it inbound on `E0/1`, then pinged SRV1 from PC2.
* **Symptom:** Traffic from the LAN is no longer filtered, because the ACL looks at the wrong interface. The ping from PC2 succeeds.
* **Fix:** Apply the ACL inbound on `E0/0` again.

![Breakit-2](image_3.png)
