# Lab 1.3: EtherChannel with LACP

> **GNS3 Project:** [`Module 1 - Switching (CCNA) | Lab 3 - EtherChannel with LACP.gns3`](./Module%201%20-%20Switching%20%28CCNA%29%20%7C%20Lab%203%20-%20EtherChannel%20with%20LACP.gns3)
> **Platform:** GNS3 3.1 · Cisco IOL L2 `17.18.2` · 2 switches, 2 VPCS hosts
> **Key takeaway:** Every member port must match the port-channel settings (mode, encapsulation, allowed VLANs) before it can bundle. LACP needs at least one active side, and `mode on` on one side never forms a bundle with an LACP peer.

![Topology Diagram](image.png)

---

## 1. Scenario & Tasks

- **Task 1 — LACP bundle:** Create VLAN 10 on both switches and place the PC ports in it. Bundle `E0/0` and `E0/1` between SW1 and SW2 into `Port-channel1` with LACP (SW1 active, SW2 passive) and configure it as an 802.1Q trunk.
- **Task 2 — Third link and load balancing:** Add `E0/2` to the same EtherChannel and load-balance on source and destination IP on both switches.
- **Task 3 — Verify** that all three links are bundled and that PC1 can reach PC2 (`172.16.10.12`).

---

## 2. Configuration & Verification

### Task 1: LACP Port-Channel (SW1 Active, SW2 Passive)

**SW1:**
~~~cisco
vlan 10
interface Ethernet0/3
 switchport mode access
 switchport access vlan 10
interface Port-channel1
 switchport trunk encapsulation dot1q
 switchport trunk allowed vlan 10
 switchport mode trunk
interface range Ethernet0/0 - 1
 channel-protocol lacp
 channel-group 1 mode active
~~~

**SW2:**
~~~cisco
vlan 10
interface Ethernet0/3
 switchport mode access
 switchport access vlan 10
interface Port-channel1
 switchport trunk encapsulation dot1q
 switchport trunk allowed vlan 10
 switchport mode trunk
interface range Ethernet0/0 - 1
 channel-protocol lacp
 channel-group 1 mode passive
~~~

---

### Task 2: Add the Third Link and Set Load Balancing

**SW1:**
~~~cisco
interface Ethernet0/2
 switchport trunk encapsulation dot1q
 switchport trunk allowed vlan 10
 switchport mode trunk
 channel-group 1 mode active
port-channel load-balance src-dst-ip
~~~

**SW2:**
~~~cisco
interface Ethernet0/2
 switchport trunk encapsulation dot1q
 switchport trunk allowed vlan 10
 switchport mode trunk
 channel-group 1 mode passive
port-channel load-balance src-dst-ip
~~~

---

### Task 3: Verification

* **`show etherchannel summary`:** all three links are bundled into `Po1`, which is trunking.
* **`ping 172.16.10.12`** from PC1 succeeds.

---

## 3. Notes & Fault-Injection (Break-It)

### Pitfall: Member Port Does Not Match the Port-Channel
A port can only join an existing port-channel if its settings match. On SW2, `E0/2` was still in access mode, so it did not bundle:

![Task-2](image_1.png)

* **Fix, method 1:** Match the settings first (switchport mode, encapsulation, allowed VLANs), then add the port.
* **Fix, method 2 (recommended):** Select all member interfaces and bundle them in one step.

### Fault-Injection 1: Mismatched Channel Mode
* **Injected Fault:** On SW2, removed the three member ports from the channel and put them back with `mode on`.
* **Symptom:** SW1 still sends LACP packets, but SW2 does not answer them. The EtherChannel does not form, and the ports on SW1 show as suspended (`s`).
* **Fix:** `channel-group 1 mode passive`

![Breakit-1](image_2.png)

### Resilience Test: Member Link Failure
* **Test:** On SW1, shut down `E0/0`.
* **Result:** `Po1` stays up with `Et0/1` and `Et0/2`, and PC1 still reaches PC2 because the traffic uses the remaining links.
* **Restore:** `no shutdown`

![Breakit-2](image_3.png)
