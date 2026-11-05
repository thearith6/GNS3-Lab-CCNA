# Lab 1.5: STP Protection — PortFast, BPDU Guard & Root Guard

> **GNS3 Project:** [`Module 1 - Switching (CCNA) | Lab 5 - STP Protection: PortFast, BPDU Guard and Root Guard.gns3`](./Module%201%20-%20Switching%20%28CCNA%29%20%7C%20Lab%205%20-%20STP%20Protection%3A%20PortFast%2C%20BPDU%20Guard%20and%20Root%20Guard.gns3)
> **Platform:** GNS3 3.1 · Cisco IOL L2 `17.18.2` · 3 switches, 2 VPCS hosts
> **Key takeaway:** BPDU Guard protects the edge by err-disabling a PortFast port that receives a BPDU. Root Guard protects the core by blocking a port that receives a superior BPDU, and it recovers on its own once the superior BPDUs stop.

![Topology Diagram](image.png)

---

## 1. Scenario & Tasks

Starting from the Lab 1.4 configuration.

- **Task 1 — Edge protection:** Enable PortFast and BPDU Guard on the PC ports of SW2 and SW3 (`E0/2`).
- **Task 2 — Root Guard:** SW3 is an access-layer switch and must never become the root bridge. Enable Root Guard on the ports of SW1 and SW2 that face SW3.
- **Task 3 — Verify** the protection features.

---

## 2. Configuration & Verification

### Task 1: PortFast and BPDU Guard on the PC Ports

**SW2:**
~~~cisco
interface Ethernet0/2
 spanning-tree portfast
 spanning-tree bpduguard enable
~~~

**SW3:**
~~~cisco
interface Ethernet0/2
 spanning-tree portfast
 spanning-tree bpduguard enable
~~~

---

### Task 2: Root Guard Towards SW3

**SW1:**
~~~cisco
interface Ethernet0/1
 spanning-tree guard root
~~~

**SW2:**
~~~cisco
interface Ethernet0/1
 spanning-tree guard root
~~~

---

### Task 3: Verification

* **`show spanning-tree interface <id> detail`:** the port is in PortFast mode and BPDU Guard is enabled.
* **`show spanning-tree inconsistentports`:** no ports are listed while the topology is stable.

![Task-3](image_1.png)

---

## 3. Notes & Fault-Injection (Break-It)

### Fault-Injection 1: BPDU on a BPDU Guard Port
* **Injected Fault:** Removed PC1 and PC2 and connected SW2 `E0/2` directly to SW3 `E0/2` with a cable.
* **Symptom:** The port on SW2 is err-disabled, because a BPDU was received on a BPDU Guard port.

![Breakit-1](image_2.png)

### Fault-Injection 2: Superior BPDU on a Root Guard Port
* **Injected Fault:** On SW3, set the priority of VLAN 10 to 0.
* **Symptom:** `E0/1` is root-inconsistent for VLAN 10, and a `ROOTGUARD_BLOCK` message is logged.

![Breakit-2](image_3.png)

* **Fix:** On SW3, `no spanning-tree vlan 10 priority`. No `shutdown`/`no shutdown` or err-disable recovery is needed, because the port unblocks automatically.

![Breakit-2.1](image_4.png)
