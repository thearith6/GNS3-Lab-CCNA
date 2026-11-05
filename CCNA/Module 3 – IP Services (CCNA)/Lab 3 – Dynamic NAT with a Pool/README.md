# Lab 3.3: Dynamic NAT with a Public Pool

> **GNS3 Project:** [`Module 3 - IP Services (CCNA) | Lab 3 - Dynamic NAT with a Pool.gns3`](./Module%203%20-%20IP%20Services%20%28CCNA%29%20%7C%20Lab%203%20-%20Dynamic%20NAT%20with%20a%20Pool.gns3)
> **Platform:** GNS3 3.1 · Cisco IOL L3 `17.18.2` · 2 routers, 3 VPCS hosts, GNS3 Ethernet switch
> **Key takeaway:** Dynamic NAT without `overload` maps each inside host to its own public address, so a pool of two addresses serves only two hosts at a time. A third host is not translated until an entry is cleared or times out.

![Topology Diagram](image.png)

---

## 1. Scenario & Tasks

Same topology and addressing as Lab 3.2.

- **Task 1 — Dynamic NAT:** Configure R1 so the inside hosts of `192.168.10.0/24` use a pool of two public addresses, `203.0.113.3` and `203.0.113.4`. Add a default route towards the ISP.
- **Task 2 — Verify:** Ping `198.51.100.1` from PC1 and PC2 and check the translations.
- **Task 3 — Pool exhaustion:** Ping `198.51.100.1` from WEB while PC1 and PC2 have active translations, and check the statistics.

---

## 2. Configuration & Verification

### Task 1: Dynamic NAT Pool

**R1:**
~~~cisco
ip nat pool PUBLIC 203.0.113.3 203.0.113.4 netmask 255.255.255.248
access-list 1 permit 192.168.10.0 0.0.0.255
interface Ethernet0/0
 ip nat inside
interface Ethernet0/1
 ip nat outside
ip nat inside source list 1 pool PUBLIC
ip route 0.0.0.0 0.0.0.0 203.0.113.1
~~~

---

### Task 2: Verification (`show ip nat translations`, `show ip nat statistics`)

* PC1 and PC2 each have their own inside global address (`203.0.113.3` and `203.0.113.4`).

![Task-2](image.png)

---

### Task 3: Pool Exhaustion

* The misses counter increases, and WEB cannot reach the ISP because no address is left in the pool.
* `clear ip nat translation *` frees the pool, and the next host can then use a free address.

![Task-3](image_1.png)

![Verification-1](image_2.png)

After clearing:

![Verification-2](image_3.png)

---

## 3. Notes & Fault-Injection (Break-It)

### Fault-Injection 1: Missing `ip nat inside`
* **Injected Fault:** On R1, removed `ip nat inside` from `E0/0` and pinged `198.51.100.1` from PC1.
* **Symptom:** No translation is created and the ping fails.
* **Fix:** `ip nat inside`

![Breakit-1](image_4.png)

### Fault-Injection 2: Wrong ACL
* **Injected Fault:** On R1, replaced ACL 1 with `access-list 1 permit 192.168.20.0 0.0.0.255` and pinged `198.51.100.1` from PC1.
* **Symptom:** The source address of PC1 does not match the ACL, so it is not translated and the ping fails.
* **Fix:** `access-list 1 permit 192.168.10.0 0.0.0.255`

![Breakit-2](image_5.png)
