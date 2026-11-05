# Lab 2.5: Multi-Area OSPF & Inter-Area Summarization

> **GNS3 Project:** [`Module 2 - OSPF (CCNA) | Lab 2 - Multi-Area OSPF and Inter-Area Summarization.gns3`](./Module%202%20-%20OSPF%20%28CCNA%29%20%7C%20Lab%202%20-%20Multi-Area%20OSPF%20and%20Inter-Area%20Summarization.gns3)
> **Platform:** GNS3 3.1 · Cisco IOL L3 `17.18.2` · 4 routers, 3 OSPF areas
> **Key takeaway:** An ABR can summarize inter-area routes with `area <id> range`, so other areas see one `O IA` route instead of many. OSPF neighbors must agree on area ID and MTU, or the adjacency fails.

![Topology Diagram](image_4.png)

---

## 1. Scenario & Tasks

The R1–R2 link is in area 1, the R2–R3 link is in area 0, and the R3–R4 link is in area 2. R2 and R3 are the ABRs.

- **Task 1 — Multi-area OSPF:** Advertise each loopback in the area of its router (R1 in area 1, R2 and R3 in area 0, R4 in area 2). Hard-code the router IDs to `1.1.1.1` – `4.4.4.4`, and advertise the R1 loopbacks with their real `/24` mask.
- **Task 2 — Summarization:** Reduce the routing table in area 0 and area 2 by summarizing the four R1 loopbacks (`10.10.0.0/24` – `10.10.3.0/24`) into one route on the ABR (R2).
- **Task 3 — Verify** the routing table on R4.

### IPv4 Addressing & OSPF Areas

| Device | Router-ID (`Lo0`) | Interfaces | Area(s) |
| :--- | :---: | :--- | :--- |
| **R1** | `1.1.1.1/32` | `E0/0`: 192.168.12.1/24, `Lo10`–`Lo13`: 10.10.0.1 – 10.10.3.1/24 | 1 |
| **R2 (ABR)** | `2.2.2.2/32` | `E0/0`: 192.168.12.2/24, `E0/1`: 192.168.23.2/24 | 1 and 0 |
| **R3 (ABR)** | `3.3.3.3/32` | `E0/0`: 192.168.23.3/24, `E0/1`: 192.168.34.3/24 | 0 and 2 |
| **R4** | `4.4.4.4/32` | `E0/0`: 192.168.34.4/24 | 2 |

---

## 2. Configuration & Verification

### Task 1: Multi-Area OSPF

**R1:**
~~~cisco
router ospf 1
 router-id 1.1.1.1
 network 192.168.12.1 0.0.0.0 area 1
 network 1.1.1.1 0.0.0.0 area 1
 network 10.10.0.0 0.0.3.255 area 1
interface range Loopback10 - 13
 ip ospf network point-to-point
~~~

**R2:**
~~~cisco
router ospf 1
 router-id 2.2.2.2
 network 192.168.12.2 0.0.0.0 area 1
 network 192.168.23.2 0.0.0.0 area 0
 network 2.2.2.2 0.0.0.0 area 0
~~~

**R3:**
~~~cisco
router ospf 1
 router-id 3.3.3.3
 network 192.168.23.3 0.0.0.0 area 0
 network 192.168.34.3 0.0.0.0 area 2
 network 3.3.3.3 0.0.0.0 area 0
~~~

**R4:**
~~~cisco
router ospf 1
 router-id 4.4.4.4
 network 192.168.34.4 0.0.0.0 area 2
 network 4.4.4.4 0.0.0.0 area 2
~~~

* Loopbacks default to the OSPF `loopback` network type and are advertised as `/32`. Setting them to `point-to-point` makes OSPF advertise the real `/24` subnet.

---

### Task 2: Inter-Area Summarization on the ABR

**R2:**
~~~cisco
router ospf 1
 area 1 range 10.10.0.0 255.255.252.0
~~~
* `area 1 range` summarizes the four `/24` networks on the ABR, which advertises one summary route to the other areas.

![Task-2](image.png)

---

### Task 3: Verification on R4

* R4 has one route for `10.10.0.0/22`, marked `O IA`, instead of four `/24` routes. The summary was created by R2.

![Task-3](image_1.png)

---

## 3. Notes & Fault-Injection (Break-It)

### Fault-Injection 1: Mismatched Area ID
* **Injected Fault:** On R3, moved the R3–R4 network (`192.168.34.0/24`) into area 0 and checked the neighbors on R3 and R4.
* **Symptom:** R4 is still in area 2, so the adjacency fails because of the mismatched area ID. R4 loses all its OSPF routes.
* **Fix:** Put the network back in area 2.

![Breakit-1](image_2.png)

### Fault-Injection 2: MTU Mismatch
* **Injected Fault:** On R2, set the MTU of `E0/1` to 1400 and restarted the OSPF process.
* **Symptom:** The neighbor R3 gets stuck in `EXSTART` or `EXCHANGE`, because the MTU values do not match (1400 and 1500).
* **Fix:** `no ip mtu 1400`

![Breakit-2](image_3.png)
