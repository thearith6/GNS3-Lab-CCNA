# Lab 3.1: DHCP Server & DHCP Relay

> **GNS3 Project:** [`Module 3 - IP Services (CCNA) | Lab 1 - DHCP Server and DHCP Relay.gns3`](./Module%203%20-%20IP%20Services%20%28CCNA%29%20%7C%20Lab%201%20-%20DHCP%20Server%20and%20DHCP%20Relay.gns3)
> **Platform:** GNS3 3.1 · Cisco IOL L3 `17.18.2` · 2 routers, 1 VPCS host
> **Key takeaway:** DHCP discovery is a broadcast that stops at the router. A relay agent (`ip helper-address`) forwards it to a server on another network, and the server needs a route back to the client subnet.

![Topology Diagram](image_1.png)

---

## 1. Scenario & Tasks

- **Task 1 — DHCP server:** Configure R1 as a DHCP server for `192.168.10.0/24`. Exclude the first 10 addresses and hand out `192.168.10.1` (R2) as the default gateway and `192.0.2.53` as the DNS server.
- **Task 2 — DHCP relay:** The PCs are not on R1's network, so configure R2 to relay the DHCP requests to R1, and add a static route on R1 so it can answer.
- **Task 3 — Verify** that the PCs received an address.

### IPv4 Addressing

| Device | Interface | Address |
| :--- | :--- | :--- |
| **R1** (DHCP server) | `E0/0` | 10.0.12.1/30 |
| **R2** (relay, gateway) | `E0/0` | 10.0.12.2/30 |
| **R2** | `E0/1` (LAN) | 192.168.10.1/24 |
| **PC1** | — | DHCP |

---

## 2. Configuration & Verification

### Task 1: DHCP Pool on R1

**R1:**
~~~cisco
ip dhcp excluded-address 192.168.10.1 192.168.10.10
ip dhcp pool LAN10
 network 192.168.10.0 255.255.255.0
 default-router 192.168.10.1
 dns-server 192.0.2.53
~~~

---

### Task 2: DHCP Relay on R2 and Return Route on R1

**R2:**
~~~cisco
interface Ethernet0/1
 ip helper-address 10.0.12.1
~~~

**R1:**
~~~cisco
ip route 192.168.10.0 255.255.255.0 10.0.12.2
~~~

---

### Task 3: Verification

* **`show ip dhcp binding`:** PC1 has an address starting from `192.168.10.11`.
* **`show ip dhcp pool`:** leased addresses is 1.

![Task-3](image.png)

![Verify](image_2.png)

---

## 3. Notes & Fault-Injection (Break-It)

### Fault-Injection 1: Relay Removed
* **Injected Fault:** On R2, removed the helper address from `E0/1`, then released and renewed the address on PC1.
* **Symptom:** The DHCP request is not forwarded to R1, so PC1 does not get an address.
* **Fix:** `ip helper-address 10.0.12.1`

![Breakit-1](image_3.png)

### Fault-Injection 2: Wrong Default Gateway in the Pool
* **Injected Fault:** On R1, changed the default router of the pool to `192.168.10.254`, then renewed the address on PC1.
* **Symptom:** PC1 gets an address, but the wrong default gateway, so it can only reach its own subnet.
* **Fix:** `default-router 192.168.10.1`

![Breakit-2](image_4.png)

![Breakit-2-fix](image_5.png)
