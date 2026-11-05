# Lab X.Y: <Title>

> **GNS3 Project:** [`<project name>.gns3`](./<project%20name>.gns3)
> **Platform:** GNS3 3.1 · FortiGate-VM `<FortiOS version>` · <other devices>
> **Key takeaway:** <one or two sentences>

![Topology Diagram](image.png)

---

## 1. Scenario & Tasks

- **Task 1 — <name>:** <what to build>
- **Task 2 — <name>:** <what to build>

### IPv4 Addressing

| Device | Interface | Address | Gateway |
| :--- | :--- | :--- | :--- |
| **FGT1** | `port1` | 10.0.0.1/24 | — |
| **PC1** | `eth0` | 10.0.0.11/24 | 10.0.0.1 |

---

## 2. Configuration & Verification

### Task 1: <name>

**FGT1:**
~~~fortios
config system interface
    edit "port2"
        set mode static
        set ip 192.168.10.1 255.255.255.0
        set allowaccess ping https ssh
    next
end
~~~
* **Verification:** `get system interface physical`, `get router info routing-table all`

---

## 3. Notes & Fault-Injection (Break-It)

### Fault-Injection 1: <name>
* **Injected Fault:** <what was broken>
* **Symptom:** <what you saw, e.g. `diagnose debug flow` output>
* **Fix:** <command>
