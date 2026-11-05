# Lab 1.6: DTP & Trunk Negotiation

> **GNS3 Project:** [`Module 1 - Switching (CCNA) | Lab 6 - DTP and Trunk Negotiation.gns3`](./Module%201%20-%20Switching%20%28CCNA%29%20%7C%20Lab%206%20-%20DTP%20and%20Trunk%20Negotiation.gns3)
> **Platform:** GNS3 3.1 · Cisco IOL L2 `17.18.2` · 2 switches, 2 VPCS hosts
> **Key takeaway:** `dynamic auto` on both ends never forms a trunk, and a static trunk with `nonegotiate` on one side leaves a dynamic peer in access mode. Configure both ends as static trunks with DTP off.

![Topology Diagram](image_1.png)

---

## 1. Scenario & Tasks

The trunk runs between **SW1 `E0/1`** and **SW2 `E0/0`**.

- **Task 1 — DTP negotiation:** Form a trunk through DTP. SW1 asks for a trunk actively (`dynamic desirable`) and SW2 accepts it (`dynamic auto`).
- **Task 2 — Verify** the administrative and operational mode on both switches.
- **Task 3 — Harden:** Negotiation is a security risk, so configure both ends as static trunks and turn DTP off.

---

## 2. Configuration & Verification

### Task 1: Trunk via DTP

**SW1:**
~~~cisco
interface Ethernet0/1
 switchport trunk encapsulation dot1q
 switchport mode dynamic desirable
~~~

**SW2:**
~~~cisco
interface Ethernet0/0
 switchport trunk encapsulation dot1q
 switchport mode dynamic auto
~~~

---

### Task 2: Verification (`show interfaces <id> switchport`)

* **SW1:** Administrative Mode is `dynamic desirable` and Operational Mode is `trunk`.
* **SW2:** Administrative Mode is `dynamic auto` and Operational Mode is `trunk`.

![Task-2](image.png)

---

### Task 3: Static Trunks with DTP Off

**SW1:**
~~~cisco
interface Ethernet0/1
 switchport mode trunk
 switchport nonegotiate
~~~

**SW2:**
~~~cisco
interface Ethernet0/0
 switchport mode trunk
 switchport nonegotiate
~~~
* **Verification:** trunking negotiation is off on both ends.

---

## 3. Notes & Fault-Injection (Break-It)

### Fault-Injection 1: Both Ends `dynamic auto`
* **Injected Fault:** Set both ends back to `dynamic auto`.
* **Symptom:** Both sides wait for the other to start the negotiation. The operational mode is `static access` and the VLANs do not pass between the switches.

![Breakit-1](image_2.png)

### Fault-Injection 2: Static Trunk with `nonegotiate` Against a Dynamic Peer
* **Injected Fault:** Configured SW1 as a static trunk with `switchport nonegotiate` and set SW2 to `dynamic desirable`.
* **Symptom:** SW1 does not answer the DTP frames, so SW2 stays in access mode while SW1 sends tagged frames. The VLANs do not work between the switches.
* **Fix:** Configure both ends as static trunks.

![Breakit-2](image_3.png)
