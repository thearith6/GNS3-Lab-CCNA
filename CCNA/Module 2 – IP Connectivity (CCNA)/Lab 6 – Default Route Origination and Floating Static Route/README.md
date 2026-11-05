# Lab 2.6: Default Route Origination & Floating Static Route

> **GNS3 Project:** [`Module 2 - OSPF (CCNA) | Lab 3 - Default Route Origination and Floating Static Route.gns3`](./Module%202%20-%20OSPF%20%28CCNA%29%20%7C%20Lab%203%20-%20Default%20Route%20Origination%20and%20Floating%20Static%20Route.gns3)
> **Platform:** GNS3 3.1 · Cisco IOL L3 `17.18.2` · 4 routers (R1, R2, ISP1, ISP2)
> **Key takeaway:** `default-information originate` advertises a default route into OSPF only while the originating router itself has one. A floating static default route keeps the router, and therefore the network behind it, online when the primary ISP link fails.

![Topology Diagram](image_4.png)

---

## 1. Scenario & Tasks

R1 and R2 run OSPF; R2 is the edge router with two ISP links.

- **Task 1 — OSPF:** Configure OSPF area 0 between R1 and R2 on `192.168.12.0/24`, with router IDs `1.1.1.1` and `2.2.2.2`. R1 also advertises its `Loopback1` with its real `/24` mask.
- **Task 2 — ISP failover:** R2 uses ISP1 as the primary exit and ISP2 as the backup, with a static default route towards ISP1 and a floating static default route towards ISP2 (administrative distance 10).
- **Task 3 — Originate the default route:** Advertise the default route from R2 into OSPF and verify on R1.

### IPv4 Addressing

| Device | Interfaces |
| :--- | :--- |
| **R1** | `E0/0`: 192.168.12.1/24, `Lo1`: 172.16.1.1/24 |
| **R2** | `E0/0`: 192.168.12.2/24, `E0/1`: 203.0.113.1/30 (to ISP1), `E0/2`: 198.51.100.1/30 (to ISP2) |
| **ISP1** | `E0/0`: 203.0.113.2/30 |
| **ISP2** | `E0/0`: 198.51.100.2/30 |

---

## 2. Configuration & Verification

### Task 1: OSPF Area 0 between R1 and R2

**R1:**
~~~cisco
router ospf 1
 router-id 1.1.1.1
 network 192.168.12.1 0.0.0.0 area 0
 network 172.16.1.1 0.0.0.0 area 0
interface Loopback1
 ip ospf network point-to-point
~~~

**R2:**
~~~cisco
router ospf 1
 router-id 2.2.2.2
 network 192.168.12.0 0.0.0.255 area 0
~~~

---

### Task 2: Primary and Floating Default Routes

**R2:**
~~~cisco
ip route 0.0.0.0 0.0.0.0 203.0.113.2
ip route 0.0.0.0 0.0.0.0 198.51.100.2 10
~~~
* Only the route via `203.0.113.2` is installed. The route to ISP2 is installed only when the primary route goes down.

---

### Task 3: Originate the Default Route into OSPF

**R2:**
~~~cisco
router ospf 1
 default-information originate
~~~
* **Verification:** R1 has `O*E2 0.0.0.0/0 via 192.168.12.2`.

![Task-3](image_1.png)

---

## 3. Notes & Fault-Injection (Break-It)

### Failover Test: Primary ISP Link Down
* **Test:** On R2, shut down `E0/1` (the link to ISP1) and checked the default route on R2 and R1.
* **Result:** R2 installs the floating static route via `198.51.100.2` with `[10/0]`. R1 still has its OSPF default route.
* **Restore:** `no shutdown`

![Breakit-1](image_2.png)

### Fault-Injection: Both ISP Links Down
* **Injected Fault:** Also shut down `E0/2` on R2 and checked the default route on R1.
* **Symptom:** R2 has no default route left, so `default-information originate` stops advertising, and R1 loses its default route.
* **Fix:** `no shutdown` on both interfaces.

![Breakit-2](image_3.png)
