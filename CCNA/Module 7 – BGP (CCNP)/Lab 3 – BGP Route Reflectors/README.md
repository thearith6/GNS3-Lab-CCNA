# Lab 7.3: BGP Route Reflectors

> **GNS3 Project:** [`Module 6 - BGP (CCNP) | Lab 3 - BGP Route Reflectors.gns3`](./Module%206%20-%20BGP%20%28CCNP%29%20%7C%20Lab%203%20-%20BGP%20Route%20Reflectors.gns3)
> **Platform:** GNS3 3.1 · Cisco IOL `x86_64_crb_linux-adventerprisek9-ms.17.18.2.iol` · 5 routers, 3 autonomous systems
> **Key takeaway:** An iBGP router does not pass iBGP-learned routes to other iBGP peers, which is why iBGP needs a full mesh. A route reflector lifts this rule for its clients, so the full mesh is no longer required.

![Topology Diagram](image_2.png)

---

## 1. Scenario & Tasks

Same topology and addressing as Lab 7.2. The starting point is the Lab 7.2 configuration.

- **Task 1 — Remove the R3–R4 iBGP session** (on both R3 and R4).
- **Task 2 — Route reflector:** Configure R2 as a route reflector with R3 and R4 as its clients.
- **Task 3 — Verify** that R3 learns the network of R5 through the route reflector.

### IPv4 Addressing & AS Schema

| Device | ASN | Router-ID (`Lo0`) | Transit Interfaces | Other Loopbacks |
| :--- | :---: | :---: | :--- | :--- |
| **R1** | `65100` | `1.1.1.1/32` | `E0/0`: 10.12.0.1/24 | `Lo1`: 192.168.1.1/24 |
| **R2 (RR)** | `65200` | `2.2.2.2/32` | `E0/0`: 10.12.0.2/24, `E0/1`: 10.23.0.2/24, `E0/2`: 10.24.0.2/24 | — |
| **R3** | `65200` | `3.3.3.3/32` | `E0/0`: 10.23.0.3/24, `E0/1`: 10.34.0.3/24 | — |
| **R4** | `65200` | `4.4.4.4/32` | `E0/0`: 10.24.0.4/24, `E0/1`: 10.34.0.4/24, `E0/2`: 10.45.0.4/24 | — |
| **R5** | `65300` | `5.5.5.5/32` | `E0/0`: 10.45.0.5/24 | `Lo1`: 192.168.5.1/24 |

---

## 2. Configuration & Verification

### Task 1: Remove the iBGP Session Between R3 and R4

**R3:**
~~~cisco
router bgp 65200
 no neighbor 4.4.4.4 remote-as 65200
~~~

**R4:**
~~~cisco
router bgp 65200
 no neighbor 3.3.3.3 remote-as 65200
~~~

---

### Task 2: Configure R2 as Route Reflector

**R2:**
~~~cisco
router bgp 65200
 neighbor 3.3.3.3 route-reflector-client
 neighbor 4.4.4.4 route-reflector-client
~~~

---

### Task 3: Verification on R3

* **`show ip bgp 192.168.5.0`:** the route shows Originator `4.4.4.4` and Cluster list `2.2.2.2`, which proves it was reflected by R2.

![Task-3](image.png)

---

## 3. Notes & Fault-Injection (Break-It)

### Fault-Injection: Route Reflector Clients Removed
* **Injected Fault:** On R2, removed `route-reflector-client` for both neighbors.
* **Symptom:** iBGP routes are no longer passed from one iBGP neighbor to another, so R3 no longer learns `192.168.5.0/24`.
* **Fix:** Configure `route-reflector-client` again for both neighbors.

![Breakit-1](image_1.png)
