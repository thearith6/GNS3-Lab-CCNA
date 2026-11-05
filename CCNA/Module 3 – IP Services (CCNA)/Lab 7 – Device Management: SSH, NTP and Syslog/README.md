# Lab 3.7: Device Management — SSH, NTP & Syslog

> **GNS3 Project:** [`Module 3 - IP Services (CCNA) | Lab 5 - Device Management: SSH, NTP and Syslog.gns3`](./Module%203%20-%20IP%20Services%20%28CCNA%29%20%7C%20Lab%205%20-%20Device%20Management%3A%20SSH%2C%20NTP%20and%20Syslog.gns3)
> **Platform:** GNS3 3.1 · Cisco IOL L3 `17.18.2` · 2 routers, an Alpine Linux client (PC1) and syslog host (SRV), GNS3 Ethernet switch
> **Key takeaway:** Secure management means SSH instead of Telnet, a synchronized clock so logs line up across devices, and a central syslog server with precise timestamps.
> *All credentials in this lab are lab-only examples.*

![Topology Diagram](image_5.png)

---

## 1. Scenario & Tasks

- **Task 1 — SSH:** Configure SSH version 2 on R1 so it can be managed securely from PC1. Use the domain name `lab.local`, a local user `admin` with privilege level 15, and allow only SSH on the VTY lines.
- **Task 2 — NTP:** Configure R2 as an NTP master with stratum 3 and synchronize R1 with it.
- **Task 3 — Syslog:** Send the logs of R1 to the syslog server `192.168.100.50` with millisecond timestamps.

### IPv4 Addressing

| Device | Interface | Address |
| :--- | :--- | :--- |
| **R1** | `E0/0` | 192.168.100.1/24 |
| **R2** | `E0/0` | 192.168.100.2/24 |
| **PC1** | — | 192.168.100.11/24 |
| **SRV** (syslog) | — | 192.168.100.50/24 |

---

## 2. Configuration & Verification

### Task 1: SSH Version 2 on R1

**R1:**
~~~cisco
hostname R1
ip domain-name lab.local
crypto key generate rsa modulus 3072
ip ssh version 2
username admin privilege 15 secret Cisco123
line vty 0 4
 login local
 transport input ssh
~~~

**PC1:**
~~~bash
ssh admin@192.168.100.1
~~~
* **Verification:** the SSH login succeeds.

![Task-1](image.png)

---

### Task 2: NTP

**R2:**
~~~cisco
ntp master 3
~~~

**R1:**
~~~cisco
ntp server 192.168.100.2
~~~
* **Verification (`show ntp status`):** after a few minutes the clock is synchronized to `192.168.100.2`.

![Task-2](image_1.png)

---

### Task 3: Syslog

**R1:**
~~~cisco
service timestamps log datetime msec
logging host 192.168.100.50
logging trap informational
logging source-interface Ethernet0/0
~~~
* **`service timestamps log datetime msec`:** stamps each log entry with date and time in milliseconds.
* **`logging host`:** sends the logs to the syslog server.
* **`logging trap informational`:** sends severity levels 0–6. Level 7 (debug) needs `logging trap debugging`.
* **`logging source-interface Ethernet0/0`:** sources the syslog packets from the `E0/0` address, so the monitoring server always sees the same source address.
* **Verification (`show logging`):** the output lists the logging host `192.168.100.50`. On the Alpine Linux server, watch the incoming logs with `tail -f /var/log/messages`.

![Task-3](image_2.png)

---

## 3. Notes & Fault-Injection (Break-It)

### Fault-Injection 1: Telnet Only on the VTY Lines
* **Injected Fault:** On R1, changed the VTY lines to `transport input telnet` and tried to connect from PC1 with SSH.
* **Symptom:** The SSH connection is refused.
* **Fix:** `transport input ssh`

![Breakit-1](image_3.png)

### Fault-Injection 2: Wrong NTP Server
* **Injected Fault:** On R1, changed the NTP server to `192.168.100.20` and checked `show ntp status`.
* **Symptom:** The clock shows as unsynchronized, because that server does not exist.
* **Fix:** `ntp server 192.168.100.2`

![Breakit-2](image_4.png)
