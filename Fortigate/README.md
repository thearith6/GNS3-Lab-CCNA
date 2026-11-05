# FortiGate Labs
### Hands-on FortiGate (FortiOS) practice in GNS3, with fault-injection exercises

For the other labs in this repository, see the [main README](../README.md) and [CCNA](../CCNA/README.md).

---

## Summary

This folder documents my FortiGate practice labs: topologies, CLI configuration, verification and troubleshooting. Each lab follows the same layout as the CCNA labs:

1. **A topology** built and tested in GNS3.
2. **FortiOS configuration** with a documented IP addressing scheme.
3. **Verification** with CLI output and screenshots.
4. **A "Break-It" exercise:** a deliberate misconfiguration, the symptom, and the fix.

## Lab Environment

| Component | Specification | Purpose |
| :--- | :--- | :--- |
| **Network Emulator** | GNS3 Server / Client v3.1 | Topology orchestration |
| **Firewall** | FortiGate-VM (QEMU appliance), FortiOS version: _fill in_ | Policies, NAT, VPN, UTM |
| **Switching / Routing** | Cisco IOL (L2 / L3) | Upstream and downstream devices |
| **End Systems** | VPCS & Alpine Linux (`alpine-ssh:latest`) | Connectivity and service testing |

> FortiGate images and licenses are **not** stored in this repository (see `.gitignore`).

---

## Lab Matrix

Labs are added here as they are completed. Planned topics are in the [Roadmap](#roadmap).

### Module 1: Fundamentals

| Lab | Title | Key Technologies | Documentation |
| :---: | :--- | :--- | :---: |
| _none yet_ | | | |

---

## Roadmap

- **Module 1: Fundamentals** (first boot and management access, interfaces and zones, static routing, firewall policy, SNAT/VIP)
- **Module 2: Security profiles** (web filter, application control, antivirus, SSL inspection)
- **Module 3: VPN** (IPsec site-to-site, SSL VPN / ZTNA)
- **Module 4: Routing & HA** (OSPF, BGP, SD-WAN, FGCP HA)
- **Module 5: Management & logging** (admin profiles, syslog, SNMP, FortiAnalyzer)
