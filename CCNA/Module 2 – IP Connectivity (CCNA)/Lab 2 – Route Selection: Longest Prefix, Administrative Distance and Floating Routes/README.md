# Lab 2.2: Route Selection — Longest Prefix, Administrative Distance & Floating Routes

> **GNS3 Project:** [`Module 2 - IP Connectivity (CCNA) | Lab 2 - Route Selection.gns3`](./Module%202%20-%20IP%20Connectivity%20%28CCNA%29%20%7C%20Lab%202%20-%20Route%20Selection.gns3)
> **Platform:** GNS3 3.1 · Cisco IOL L3 `17.18.2` · 3 routers, 2 VPCS hosts
> **Key takeaway:** A router picks the **longest prefix** first and compares **administrative distance** only between routes with the same prefix. A floating static route (higher AD) is a backup that is installed only when the primary route disappears.

![Topology Diagram](image.png)

---

## 1. Scenario & Tasks

Starting from the default routes of Lab 2.1 (same topology and addressing), use the direct R1–R3 link.

- **Task 1 — More specific routes:** Add a more specific static route on R1 and R3 for the LAN of the other router, using the direct link. R2 keeps its static routes.
- **Task 2 — Floating backup:** Make the path through R2 a backup with a floating static route (administrative distance 200) on R1 and R3 for the other router's LAN.
- **Task 3 — Test the failover:** Shut down `E0/2`, check the route and trace the path from PC1, then bring the interface back up.

### IPv4 Addressing

| Device | Interfaces |
| :--- | :--- |
| **R1** | `E0/0`: 10.0.12.1/30, `E0/1`: 192.168.1.1/24, `E0/2`: 10.0.13.1/30 |
| **R2** | `E0/0`: 10.0.12.2/30, `E0/1`: 10.0.23.1/30 |
| **R3** | `E0/0`: 10.0.23.2/30, `E0/1`: 192.168.3.1/24, `E0/2`: 10.0.13.2/30 |
| **PC1** | 192.168.1.11/24, gateway 192.168.1.1 |
| **PC3** | 192.168.3.11/24, gateway 192.168.3.1 |

---

## 2. Configuration & Verification

### Task 1: Specific Routes over the Direct Link

**R1:**
~~~cisco
ip route 192.168.3.0 255.255.255.0 10.0.13.2
~~~

**R3:**
~~~cisco
ip route 192.168.1.0 255.255.255.0 10.0.13.1
~~~

* **Verification (`trace` from PC1):** the path goes straight over the R1–R3 link and no longer through R2.

~~~
PC1> trace 192.168.3.11
trace to 192.168.3.11, 8 hops max, press Ctrl+C to stop
 1   192.168.1.1   0.276 ms  0.123 ms  0.149 ms
 2   10.0.13.2   0.365 ms  0.243 ms  0.196 ms
 3   *192.168.3.11   0.642 ms (ICMP type:3, code:3, Destination port unreachable)
~~~

---

### Task 2: Floating Static Routes (AD 200) via R2

**R1:**
~~~cisco
ip route 192.168.3.0 255.255.255.0 10.0.12.2 200
~~~

**R3:**
~~~cisco
ip route 192.168.1.0 255.255.255.0 10.0.23.1 200
~~~
* The floating routes (AD 200) are installed only when the primary route goes down.

---

### Task 3: Failover Test

**R1 and R3:**
~~~cisco
interface Ethernet0/2
 shutdown
~~~
* **Result:** the floating routes take over and traffic follows the path through R2.

![Task-3](image_1.png)

> **Both ends must fail over.** If only R1's `E0/2` is shut down, the ping fails, because R3 still chooses its primary route for the return traffic. Two ways to handle this: shut down the interface on both R1 and R3, or use IP SLA with tracking to detect the failure and change the route automatically.

---

## 3. Notes & Fault-Injection (Break-It)

### Fault-Injection 1: Same Administrative Distance
* **Injected Fault:** On R1, changed the administrative distance of the floating route to 1.
* **Symptom:** Both routes have the same administrative distance, so R1 installs both and shares the traffic between them.
* **Fix:** Use administrative distance 200 again.

![Breakit-1](image_2.png)

### Fault-Injection 2: Longest Prefix Beats Administrative Distance
* **Injected Fault:** On R1, added `ip route 192.168.3.0 255.255.255.128 10.0.12.2 250` and traced the path from PC1 to PC3.
* **Result:** The traffic goes through R2, even though this route has the worst administrative distance (250). The router first chooses the longest prefix (`/25`) and compares administrative distance only between routes with the same prefix.

![Breakit-2](image_3.png)
