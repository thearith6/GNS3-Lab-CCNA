# Lab 1.1: VLANs, Trunking & Router-on-a-Stick

> **GNS3 Project:** [`Module 1 - Switching (CCNA) | Lab 1 - VLANs, Trunking and Router-on-a-Stick.gns3`](./Module%201%20-%20Switching%20%28CCNA%29%20%7C%20Lab%201%20-%20VLANs%2C%20Trunking%20and%20Router-on-a-Stick.gns3)
> **Platform:** GNS3 3.1 · Cisco IOL L2/L3 `17.18.2` · 2 switches, 1 router, 4 VPCS hosts
> **Key takeaway:** A native VLAN mismatch only logs a warning, because tagged VLANs keep working. Removing a VLAN from a trunk's allowed list cuts that VLAN off completely.

![Topology Diagram](image.png)

---

## 1. Scenario & Tasks

- **Task 1 — VLANs:** Create VLAN 10 (ENGINEERING), VLAN 20 (OPERATIONS) and VLAN 99 (NATIVE) on SW1 and SW2. Place the PC ports in the VLANs shown in the topology.
- **Task 2 — Trunks:** Configure the SW1–SW2 and SW1–R1 links as 802.1Q trunks. Allow only VLANs 10, 20 and 99, with VLAN 99 as the native VLAN.
- **Task 3 — Router-on-a-stick:** Configure R1 so that VLAN 10 and VLAN 20 can reach each other, using the first address of each subnet as the gateway. Verify with a ping from PC1 to PC4.

### IPv4 Addressing

| Device | VLAN | Address | Gateway |
| :--- | :---: | :--- | :--- |
| **R1** `E0/0.10` | 10 | 172.16.10.1/24 | — |
| **R1** `E0/0.20` | 20 | 172.16.20.1/24 | — |
| **PC1** | 10 | 172.16.10.11/24 | 172.16.10.1 |
| **PC3** | 10 | 172.16.10.12/24 | 172.16.10.1 |
| **PC2** | 20 | 172.16.20.11/24 | 172.16.20.1 |
| **PC4** | 20 | 172.16.20.12/24 | 172.16.20.1 |

---

## 2. Configuration & Verification

### Task 1: VLANs and Access Ports

**SW1:**
~~~cisco
vlan 10
 name ENGINEERING
vlan 20
 name OPERATIONS
vlan 99
 name NATIVE
interface Ethernet0/2
 switchport mode access
 switchport access vlan 10
interface Ethernet0/3
 switchport mode access
 switchport access vlan 20
~~~

**SW2:**
~~~cisco
vlan 10
 name ENGINEERING
vlan 20
 name OPERATIONS
vlan 99
 name NATIVE
interface Ethernet0/1
 switchport mode access
 switchport access vlan 10
interface Ethernet0/2
 switchport mode access
 switchport access vlan 20
~~~

---

### Task 2: 802.1Q Trunks

**SW1:**
~~~cisco
interface range Ethernet0/0 - 1
 switchport trunk encapsulation dot1q
 switchport trunk native vlan 99
 switchport trunk allowed vlan 10,20,99
 switchport mode trunk
~~~

**SW2:**
~~~cisco
interface Ethernet0/0
 switchport trunk encapsulation dot1q
 switchport trunk native vlan 99
 switchport trunk allowed vlan 10,20,99
 switchport mode trunk
~~~
* **Verification (`show interfaces trunk`):** `Ethernet0/0` and `Ethernet0/1` on SW1 are trunking with native VLAN 99.

---

### Task 3: Router-on-a-Stick

**R1:**
~~~cisco
interface Ethernet0/0
 no shutdown
interface Ethernet0/0.10
 encapsulation dot1Q 10
 ip address 172.16.10.1 255.255.255.0
interface Ethernet0/0.20
 encapsulation dot1Q 20
 ip address 172.16.20.1 255.255.255.0
~~~
* **Verification:** `ping 172.16.20.12` from PC1 succeeds, because R1 routes between VLAN 10 and VLAN 20.

---

## 3. Notes & Fault-Injection (Break-It)

### Fault-Injection 1: Native VLAN Mismatch
* **Injected Fault:** On SW2, changed the native VLAN of the trunk to VLAN 1, then compared the trunk on both switches.
* **Symptom:** A native VLAN mismatch message is logged. VLAN 10 and VLAN 20 traffic is tagged, so PC1 can still reach PC3.
* **Fix:** `switchport trunk native vlan 99`

### Fault-Injection 2: VLAN Removed from the Trunk
* **Injected Fault:** On SW1, removed VLAN 20 from the allowed list of the trunk towards SW2.
* **Symptom:** PC2 can no longer reach PC4, because VLAN 20 is blocked between the switches. PC2 can still reach PC1, because R1 is connected to SW1.
* **Fix:** `switchport trunk allowed vlan add 20`
