# Lab 1.7: CDP & LLDP

> **GNS3 Project:** [`Module 1 - Switching (CCNA) | Lab 7 - CDP and LLDP.gns3`](./Module%201%20-%20Switching%20%28CCNA%29%20%7C%20Lab%207%20-%20CDP%20and%20LLDP.gns3)
> **Platform:** GNS3 3.1 · Cisco IOL L2/L3 `17.18.2` · 2 switches, 1 router, 2 VPCS hosts
> **Key takeaway:** CDP is Cisco-proprietary and LLDP is the open standard (IEEE 802.1AB). They run independently, so disabling one does not affect the other.

![Topology Diagram](image.png)

---

## 1. Scenario & Tasks

- **Task 1 — CDP:** Verify the CDP neighbors of SW1 and check the details of neighbor R1.
- **Task 2 — Limit CDP exposure:** Do not advertise R1's CDP to SW1, as if the link faced a provider. Disable CDP on R1's interface towards SW1 and check SW1's CDP neighbors again.
- **Task 3 — LLDP:** Enable LLDP on R1, SW1 and SW2 and verify the LLDP neighbors of SW1.

---

## 2. Configuration & Verification

### Task 1: CDP Neighbors on SW1

* **`show cdp neighbors`:** R1 (`E0/0`) and SW2 (`E0/1`) are listed with their capabilities.
* **`show cdp neighbors detail`:** shows the platform, IP address and remote port of each neighbor.

![Task-1](image_1.png)

---

### Task 2: Disable CDP Towards SW1

**R1:**
~~~cisco
interface Ethernet0/0
 no cdp enable
~~~

---

### Task 3: Enable LLDP

**R1** (the same on SW1 and SW2):
~~~cisco
lldp run
~~~

![Task-3](image_2.png)

---

## 3. Notes & Fault-Injection (Break-It)

| | CDP | LLDP |
| :--- | :--- | :--- |
| **Standard** | Cisco proprietary | Open standard |
| **Global** | `cdp run` / `no cdp run` | `lldp run` / `no lldp run` |
| **Per interface** | `cdp enable` / `no cdp enable` | `lldp transmit` / `lldp receive` (and `no` forms) |

### Fault-Injection: CDP Disabled Globally
* **Injected Fault:** On SW2, disabled CDP globally (`no cdp run`) and checked the CDP and LLDP neighbors of SW1.
* **Symptom:** SW1 no longer sees SW2 in the CDP neighbor table. SW2 is still visible with LLDP.
* **Fix:** `cdp run`
