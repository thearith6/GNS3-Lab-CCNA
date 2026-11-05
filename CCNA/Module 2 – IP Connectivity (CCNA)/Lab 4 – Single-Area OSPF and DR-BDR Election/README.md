# Lab 2.4: Single-Area OSPF & DR/BDR Election

> **GNS3 Project:** [`Module 2 - OSPF (CCNA) | Lab 1 - Single-Area OSPF and DR-BDR Election.gns3`](./Module%202%20-%20OSPF%20%28CCNA%29%20%7C%20Lab%201%20-%20Single-Area%20OSPF%20and%20DR-BDR%20Election.gns3)
> **Platform:** GNS3 3.1 · Cisco IOL L3 `17.18.2` · 4 routers on one Ethernet segment (GNS3 built-in switch)
> **Key takeaway:** The DR/BDR is elected by OSPF interface priority and is not preemptive, so a priority change only takes effect after the OSPF process is cleared. Hello/dead timers and the area ID must match for neighbors to form.

![Topology Diagram](image_1.png)

---

## 1. Scenario & Tasks

- **Task 1 — OSPF:** Configure OSPF process 1 on R1–R4. Advertise `10.1.1.0/24` and each router's `Loopback0` in area 0, with the router ID hard-coded to the `Loopback0` address.
- **Task 2 — DR/BDR:** Make R4 the DR and R3 the BDR on the `10.1.1.0/24` segment using the OSPF interface priority. R1 and R2 must never become DR or BDR. Restart the OSPF process on all routers after the change.
- **Task 3 — Verify** the neighbor table and the routing table on R1.

### IPv4 Addressing

| Device | Router-ID (`Lo0`) | `E0/0` | OSPF priority |
| :--- | :---: | :--- | :---: |
| **R1** | `1.1.1.1/32` | 10.1.1.1/24 | 0 |
| **R2** | `2.2.2.2/32` | 10.1.1.2/24 | 0 |
| **R3 (BDR)** | `3.3.3.3/32` | 10.1.1.3/24 | 100 |
| **R4 (DR)** | `4.4.4.4/32` | 10.1.1.4/24 | 200 |

---

## 2. Configuration & Verification

### Task 1: OSPF Process 1, Area 0

**R1:**
~~~cisco
router ospf 1
 router-id 1.1.1.1
 network 10.1.1.0 0.0.0.255 area 0
 network 1.1.1.1 0.0.0.0 area 0
~~~

**R2:**
~~~cisco
router ospf 1
 router-id 2.2.2.2
 network 10.1.1.0 0.0.0.255 area 0
 network 2.2.2.2 0.0.0.0 area 0
~~~

**R3:**
~~~cisco
router ospf 1
 router-id 3.3.3.3
 network 10.1.1.0 0.0.0.255 area 0
 network 3.3.3.3 0.0.0.0 area 0
~~~

**R4:**
~~~cisco
router ospf 1
 router-id 4.4.4.4
 network 10.1.1.0 0.0.0.255 area 0
 network 4.4.4.4 0.0.0.0 area 0
~~~

---

### Task 2: DR/BDR Election with Interface Priority

**R1 and R2:**
~~~cisco
interface Ethernet0/0
 ip ospf priority 0
~~~

**R3:**
~~~cisco
interface Ethernet0/0
 ip ospf priority 100
~~~

**R4:**
~~~cisco
interface Ethernet0/0
 ip ospf priority 200
~~~

Then, on every router (exec mode), restart OSPF so the election runs again:
~~~cisco
clear ip ospf process
~~~

---

### Task 3: Verification (`show ip ospf neighbor` on R1)

![Task-1](image.png)

---

## 3. Notes & Fault-Injection (Break-It)

* **The `network` command enables OSPF on interfaces:** it does not "advertise a network". It enables OSPF on every interface whose IP address falls in that range.
* **Wildcard masks** are used by OSPF, EIGRP and ACLs.
* **OSPF is not preemptive:** a router with a higher priority does not take over an existing DR role, so run `clear ip ospf process` to reset OSPF and hold a new election.

### Fault-Injection 1: Mismatched Hello Interval
* **Injected Fault:** On R2, set the OSPF hello interval of `E0/0` to 5 seconds and checked the neighbors on R1 and R2.
* **Symptom:** The hello and dead intervals no longer match the other routers (5/20 against 10/40), so R2 loses its neighbors.
* **Fix:** `no ip ospf hello-interval`

![Breakit-1](image_2.png)

### Fault-Injection 2: Mismatched Area ID
* **Injected Fault:** On R3, moved the `10.1.1.0/24` network into area 1.
* **Symptom:** R3 loses all its neighbors because of a mismatched area ID.
* **Fix:** Put the network back in area 0.

![Breakit-2](image_3.png)
