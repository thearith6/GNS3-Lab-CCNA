# Lab 4.4: Device Hardening

> **GNS3 Project:** [`Module 4 - Layer 2 Security (CCNA) | Lab 4 - Device Hardening.gns3`](./Module%204%20-%20Layer%202%20Security%20%28CCNA%29%20%7C%20Lab%204%20-%20Device%20Hardening.gns3)
> **Platform:** GNS3 3.1 · Cisco IOS router (QEMU appliance) · Alpine Linux SSH client (Docker `alpine-ssh`)
> **Key takeaway:** Use `secret` (a one-way hash) instead of `password`, block brute-force logins with `login block-for`, and turn off services you do not need. A type 7 password is only obfuscated and can be reversed easily.
> *All passwords in this lab are lab-only examples.*

![Topology Diagram](image_7.png)

---

## 1. Scenario & Tasks

- **Task 1 — Passwords:** Protect privileged mode with a hashed secret, encrypt the other passwords in the configuration, and require a minimum length of 10 characters for new passwords.
- **Task 2 — Brute-force protection:** Block the login for 120 seconds after 3 failed attempts within 60 seconds. Log the failures, close idle sessions after 5 minutes, and show a warning banner.
- **Task 3 — Reduce the attack surface:** Disable services that are not needed, shut down the unused interface `G0/3`, and verify the result.

### IPv4 Addressing

| Device | Address | Gateway |
| :--- | :--- | :--- |
| **R1** `G0/0` | 192.168.1.1/24 | — |
| **PC1** (Alpine) | 192.168.1.11/24 | 192.168.1.1 |

---

## 2. Configuration & Verification

### Task 1: Password Hardening

**R1:**
~~~cisco
enable secret Str0ng!Secret
service password-encryption
security passwords min-length 10
username admin privilege 15 secret Adm1n!Password
~~~

---

### Task 2: Login Protection

**R1:**
~~~cisco
login block-for 120 attempts 3 within 60
login on-failure log
login on-success log
line vty 0 4
 exec-timeout 5 0
 login local
 transport input ssh
line con 0
 exec-timeout 5 0
 logging synchronous
banner motd # Authorized access only #
~~~
* **Verification (`show login`):** the output shows the `block-for` settings and whether the router is in quiet mode.

![Verification-1](image.png)

---

### Task 3: Disable Unneeded Services

**R1:**
~~~cisco
no ip http server
no ip http secure-server
no ip source-route
no service pad
no ip domain-lookup
interface G0/3
 shutdown
~~~
* **Verification (`show running-config | include http`):** both HTTP servers are disabled.

![Verification-2](image_1.png)

---

### Verification: Quiet Mode

Entered a wrong password 3 times within a minute when connecting to R1 with SSH from PC1, then checked the login state on R1. R1 enters quiet mode for 120 seconds, and new login attempts are not accepted until the time has passed.

![Verification-3](image_2.png)

![Verification-3.1](image_3.png)

After 120 seconds, logging in again with the correct password works:

![Verification-3.2](image_6.png)

---

## 3. Notes & Fault-Injection (Break-It)

### Fault-Injection: Weak Privileged Password
* **Injected Fault:** On R1, configured the privileged password with `enable password Cisco123` and looked at the running configuration.
* **Symptom:** With `service password-encryption`, the password is stored as a type 7 string instead of clear text (type 0), but type 7 can be reversed easily. An `enable secret` uses a one-way hash and is much safer.
* **Fix:** `no enable password`

![Breakit-1](image_4.png)
