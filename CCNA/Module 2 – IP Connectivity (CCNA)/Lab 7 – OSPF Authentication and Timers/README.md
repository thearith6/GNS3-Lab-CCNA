# Lab 2.7: OSPF Authentication & Timers

> **GNS3 Project:** [`Module 2 - OSPF (CCNA) | Lab 4 - OSPF Authentication and Timers.gns3`](./Module%202%20-%20OSPF%20%28CCNA%29%20%7C%20Lab%204%20-%20OSPF%20Authentication%20and%20Timers.gns3)
> **Platform:** GNS3 3.1 · Cisco IOL L3 `17.18.2` · 2 routers
> **Key takeaway:** OSPF neighbors must agree on the authentication key and on the hello/dead timers. A mismatch on either one drops the adjacency.

![Topology Diagram](image_3.png)

---

## 1. Scenario & Tasks

- **Task 1 — MD5 authentication:** Enable MD5 authentication on the R2–R3 link with key ID 1 and key string `CCNA-KEY` on both routers.
- **Task 2 — Timers:** Change the OSPF hello interval to 5 seconds and the dead interval to 20 seconds on the R2–R3 link, on both routers.
- **Task 3 — Verify** the settings on R2.

### IPv4 Addressing

| Device | Router-ID (`Lo0`) | Link interface |
| :--- | :---: | :--- |
| **R2** | `2.2.2.2/32` | `E0/1`: 192.168.23.2/24 |
| **R3** | `3.3.3.3/32` | `E0/0`: 192.168.23.3/24 |

---

## 2. Configuration & Verification

### Task 1: MD5 Authentication

**R2:**
~~~cisco
interface Ethernet0/1
 ip ospf authentication message-digest
 ip ospf message-digest-key 1 md5 CCNA-KEY
~~~

**R3:**
~~~cisco
interface Ethernet0/0
 ip ospf authentication message-digest
 ip ospf message-digest-key 1 md5 CCNA-KEY
~~~

---

### Task 2: Hello and Dead Timers

**R2:**
~~~cisco
interface Ethernet0/1
 ip ospf hello-interval 5
 ip ospf dead-interval 20
~~~

**R3:**
~~~cisco
interface Ethernet0/0
 ip ospf hello-interval 5
 ip ospf dead-interval 20
~~~

---

### Task 3: Verification on R2

* **`show ip ospf interface ethernet0/1`:** timers are Hello 5 and Dead 20, and message-digest authentication is enabled.
* **`show ip ospf neighbor`:** R3 is in the `FULL` state.

![Task-3](image.png)

---

## 3. Notes & Fault-Injection (Break-It)

### Fault-Injection 1: Wrong MD5 Key
* **Injected Fault:** On R3, changed the MD5 key string to `WRONG-KEY`.
* **Symptom:** Authentication fails and the adjacency goes down after the dead interval.
* **Fix:** Configure the key string `CCNA-KEY` again.

![Breakit-1](image_1.png)

### Fault-Injection 2: Mismatched Dead Interval
* **Injected Fault:** On R3, changed the dead interval to 40 seconds.
* **Symptom:** R2 expects a dead interval of 20. The hello parameters do not match, so the adjacency goes down.
* **Fix:** `ip ospf dead-interval 20`

![Breakit-2](image_2.png)
