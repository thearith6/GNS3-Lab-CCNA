# Lab 2.1: Static & Default Routes

> **GNS3 Project:** [`Module 2 - IP Connectivity (CCNA) | Lab 1 - Static and Default Routes.gns3`](./Module%202%20-%20IP%20Connectivity%20%28CCNA%29%20%7C%20Lab%201%20-%20Static%20and%20Default%20Routes.gns3)
> **Platform:** GNS3 3.1 · Cisco IOL L3 `17.18.2` · 3 routers, 2 VPCS hosts
> **Key takeaway:** A stub router has only one way out, so a single default route replaces all its specific routes. A route whose next hop is unreachable is never installed in the routing table.

![Topology Diagram](image.png)

---

## 1. Scenario & Tasks

- **Task 1 — Static routes:** Configure static routes so PC1 and PC3 can reach each other through R2, using the next-hop address in every route. R1 and R3 also need a route to the link network on the far side of R2.
- **Task 2 — Stub routers and summarization:** R1 and R3 are stub routers, so replace their specific routes with a default route towards R2. R1 has four loopbacks (`172.16.0.0/24` – `172.16.3.0/24`), so configure one summary static route on R2 instead of four.
- **Task 3 — Verify** the routing tables and the connectivity from PC1 to PC3.

### IPv4 Addressing

| Device | Interfaces |
| :--- | :--- |
| **R1** | `E0/0`: 10.0.12.1/30, `E0/1`: 192.168.1.1/24, `E0/2`: 10.0.13.1/30, `Lo10`–`Lo13`: 172.16.0.1 – 172.16.3.1/24 |
| **R2** | `E0/0`: 10.0.12.2/30, `E0/1`: 10.0.23.1/30 |
| **R3** | `E0/0`: 10.0.23.2/30, `E0/1`: 192.168.3.1/24, `E0/2`: 10.0.13.2/30 |
| **PC1** | 192.168.1.11/24, gateway 192.168.1.1 |
| **PC3** | 192.168.3.11/24, gateway 192.168.3.1 |

---

## 2. Configuration & Verification

### Task 1: Static Routes via R2

**R1:**
~~~cisco
ip route 192.168.3.0 255.255.255.0 10.0.12.2
ip route 10.0.23.0 255.255.255.252 10.0.12.2
~~~

**R2:**
~~~cisco
ip route 192.168.1.0 255.255.255.0 10.0.12.1
ip route 192.168.3.0 255.255.255.0 10.0.23.2
~~~

**R3:**
~~~cisco
ip route 192.168.1.0 255.255.255.0 10.0.23.1
ip route 10.0.12.0 255.255.255.252 10.0.23.1
~~~

---

### Task 2: Default Routes on the Stubs and a Summary on R2

**R1:**
~~~cisco
no ip route 192.168.3.0 255.255.255.0 10.0.12.2
no ip route 10.0.23.0 255.255.255.252 10.0.12.2
ip route 0.0.0.0 0.0.0.0 10.0.12.2
~~~

**R3:**
~~~cisco
no ip route 192.168.1.0 255.255.255.0 10.0.23.1
no ip route 10.0.12.0 255.255.255.252 10.0.23.1
ip route 0.0.0.0 0.0.0.0 10.0.23.1
~~~

**R2:**
~~~cisco
ip route 172.16.0.0 255.255.252.0 10.0.12.1
~~~

---

### Task 3: Verification (`show ip route static`)

* **R1:** `S* 0.0.0.0/0 via 10.0.12.2`
* **R3:** `S* 0.0.0.0/0 via 10.0.23.1`
* **R2:** one route for `172.16.0.0/22` instead of four `/24` routes.

![Task3-1](image_2.png)

![Task-1](image_1.png)

---

## 3. Notes & Fault-Injection (Break-It)

### Fault-Injection 1: Unreachable Next Hop
* **Injected Fault:** On R2, changed the next hop of the route to `192.168.3.0/24` to `10.0.23.5`.
* **Symptom:** The route is not installed, because the next hop is not reachable. PC1 cannot reach PC3.
* **Fix:** Use the next hop `10.0.23.2`.

![Breakit-1](image_3.png)

### Fault-Injection 2: Default Route Removed
* **Injected Fault:** On R3, removed the default route and pinged PC1 from PC3.
* **Symptom:** R3 has no route to `192.168.1.0/24`, so the ping fails with destination unreachable from R3.

![Breakit-2](image_4.png)

**Why do pings from PC3 and from R3 look different when there is no route to PC1?**
* **From PC3:** the packet reaches R3, R3 has no route, and R3 sends an ICMP destination-unreachable back to PC3.
* **From R3:** R3 checks its own routing table and drops the packet before it leaves the router. A router does not send ICMP to itself.
