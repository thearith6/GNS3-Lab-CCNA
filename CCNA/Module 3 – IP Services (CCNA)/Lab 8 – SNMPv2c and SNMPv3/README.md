# Lab 3.8: SNMPv2c & SNMPv3

> **GNS3 Project:** [`Module 3 - IP Services (CCNA) | Lab 8 - SNMPv2c and SNMPv3.gns3`](./Module%203%20-%20IP%20Services%20%28CCNA%29%20%7C%20Lab%208%20-%20SNMPv2c%20and%20SNMPv3.gns3)
> **Platform:** GNS3 3.1 · Cisco IOL L3 `17.18.2` · 1 router, 1 management host (SRV)
> **Key takeaway:** SNMPv2c sends its community string in clear text, so it must at least be restricted with an ACL. SNMPv3 adds authentication (SHA) and encryption (AES-128).
> *All community strings and passwords in this lab are lab-only examples.*

![Topology Diagram](image_4.png)

---

## 1. Scenario & Tasks

- **Task 1 — SNMPv2c:** Configure SNMPv2c on R1 with the read-only community `LabRO`, usable only by the management server SRV (`192.168.100.50`). Set the location and the contact.
- **Task 2 — SNMPv3:** Configure SNMPv3 on R1 with authentication and encryption. Create the group `NOC-GROUP` with security level `priv` and the user `noc-user` (SHA with password `AuthPass123`, AES-128 with password `PrivPass123`).
- **Task 3 — Traps and verification:** Send link-up and link-down traps to SRV, and verify SNMP from SRV.

### IPv4 Addressing

| Device | Address | Gateway |
| :--- | :--- | :--- |
| **R1** `E0/0` | 192.168.100.1/24 | — |
| **SRV** | 192.168.100.50/24 | 192.168.100.1 |

---

## 2. Configuration & Verification

### Task 1: SNMPv2c with an ACL

**R1:**
~~~cisco
ip access-list standard SNMP-NMS
 permit host 192.168.100.50
snmp-server community LabRO RO SNMP-NMS
snmp-server location Lab Rack 1
snmp-server contact noc@lab.local
~~~

---

### Task 2: SNMPv3 with Authentication and Encryption

**R1:**
~~~cisco
snmp-server group NOC-GROUP v3 priv
snmp-server user noc-user NOC-GROUP v3 auth sha AuthPass123 priv aes 128 PrivPass123
~~~

---

### Task 3: Traps and Verification from SRV

**R1:**
~~~cisco
snmp-server enable traps snmp linkdown linkup
snmp-server host 192.168.100.50 version 2c LabRO
~~~

**SRV:**
~~~bash
snmpwalk -v2c -c LabRO 192.168.100.1 sysDescr
~~~
* **Verification:** the output shows the IOS description and the host name of R1.

![Task-3](image.png)

* **`show snmp` on R1:** the counters of received SNMP packets increase after the queries from SRV.

![Verification-1](image_1.png)

---

## 3. Notes & Fault-Injection (Break-It)

### Fault-Injection 1: Wrong Community String
* **Injected Fault:** Queried R1 from SRV with the wrong community string and checked `show snmp` on R1.
* **Symptom:** The query times out.

![Breakit-1](image_2.png)

### Fault-Injection 2: Wrong Host in the ACL
* **Injected Fault:** On R1, changed the ACL `SNMP-NMS` to permit the host `192.168.100.51` and queried R1 from SRV again.
* **Symptom:** The requests from SRV are not accepted and time out.
* **Fix:** Permit the host `192.168.100.50` again.

![Breakit-2](image_3.png)
