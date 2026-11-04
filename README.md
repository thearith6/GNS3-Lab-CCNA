# Cisco Enterprise Network Engineering Lab Portfolio
### Practical Implementations, Protocol Deep-Dives & Fault-Injection Troubleshooting

[![Labs Completed](https://img.shields.io/badge/Completed%20Labs-36%20Verified-success?style=for-the-badge&logo=cisco)](https://github.com/thearith6/GNS3-Lab-CCNA)
[![Platform](https://img.shields.io/badge/Platform-GNS3%20v3.1-blue?style=for-the-badge&logo=gnometerminal)](https://www.gns3.com/)
[![Images](https://img.shields.io/badge/Appliances-Cisco%20IOL%2017.18.2%20%7C%20Docker-orange?style=for-the-badge)](https://github.com/thearith6/GNS3-Lab-CCNA)
[![Methodology](https://img.shields.io/badge/Testing-Fault%20Injection%20%26%20Root--Cause-purple?style=for-the-badge)](https://github.com/thearith6/GNS3-Lab-CCNA)

---

## 📌 Executive Summary

This repository documents hands-on network topologies, configurations, protocol analyses, and troubleshooting scenarios designed for enterprise architectures (covering **CCNA** through **CCNP Enterprise ENCOR / ENARSI** concepts).

Unlike theoretical configurations, **every completed lab in this repository includes:**
1. **Production-aligned network topologies** built and validated in GNS3.
2. **Complete device configurations** with strict IP addressing schemes.
3. **Show-command verification** with expected CLI outputs and routing tables.
4. **"Break-It" / Fault-Injection Testing:** Deliberate misconfigurations (e.g., mismatched MTU, STP root bridge hijacking, asymmetric BGP route-maps, DHCP exhaustion) with terminal screenshots, symptom analysis, root-cause diagnostics, and step-by-step remediation.

---

## 🛠️ Lab Environment & Appliance Specifications

All topologies are deployed and benchmarked on a standardized virtualized infrastructure:

| Component | Specification | Purpose |
| :--- | :--- | :--- |
| **Network Emulator** | GNS3 Server / Client v3.1 | Core network topology orchestration |
| **Layer 3 Routing** | Cisco IOU / IOL (`x86_64_crb_linux-adventerprisek9-ms.17.18.2.iol`) | BGP, OSPFv2/OSPFv3, EIGRP, Policy Routing |
| **Layer 2 Switching** | Cisco IOU / IOL (`x86_64_crb_linux_l2-adventerprisek9-ms.17.18.2.iol`) | VLANs, Trunks, EtherChannel, Rapid PVST+, Port Security |
| **Authentication & AAA** | Docker (`freeradius-server:latest`) | 802.1X and centralized RADIUS AAA testing |
| **End Systems & Testing** | VPCS & Alpine Linux (`alpine-ssh:latest`) | Host IP testing, DHCP client verification, SSH automation |

---

## 📚 Portfolio Lab Matrix (36 Fully Validated Labs)

The `main` branch maintains only **100% completed, fully validated labs** with zero broken dependencies.

### 🔷 Module 1: Layer 2 Switching & STP Architecture (8 Labs)
Focuses on enterprise campus switching, trunk negotiation, loop prevention, and Spanning Tree hardening.

| Lab | Title | Key Protocols / Technologies | Documentation |
| :---: | :--- | :--- | :---: |
| **1.1** | VLANs, Trunking & Router-on-a-Stick | 802.1Q Trunks, Native VLAN 99, Subinterfaces | [View Lab](CCNA/Module%201%20–%20Switching%20%28CCNA%29/Lab%201%20–%20VLANs%2C%20Trunking%20and%20Router-on-a-Stick/README.md) |
| **1.2** | Inter-VLAN Routing with SVIs | Multilayer Switching, Switched Virtual Interfaces, Routed Ports | [View Lab](CCNA/Module%201%20–%20Switching%20%28CCNA%29/Lab%202%20–%20Inter-VLAN%20Routing%20with%20SVIs/README.md) |
| **1.3** | EtherChannel with LACP | 802.3ad LACP, Channel-Groups, Port-Channel Trunks | [View Lab](CCNA/Module%201%20–%20Switching%20%28CCNA%29/Lab%203%20–%20EtherChannel%20with%20LACP/README.md) |
| **1.4** | Rapid PVST+ & Root Bridge Tuning | 802.1w Rapid-PVST, Bridge Priority, Cost Manipulation | [View Lab](CCNA/Module%201%20–%20Switching%20%28CCNA%29/Lab%204%20–%20Rapid%20PVST%2B%20and%20Root%20Bridge%20Tuning/README.md) |
| **1.5** | STP Protection Mechanisms | PortFast, BPDU Guard, Root Guard | [View Lab](CCNA/Module%201%20–%20Switching%20%28CCNA%29/Lab%205%20–%20STP%20Protection%3A%20PortFast%2C%20BPDU%20Guard%20and%20Root%20Guard/README.md) |
| **1.6** | DTP & Trunk Negotiation | Dynamic Trunking Protocol (desirable/auto vs nonegotiate) | [View Lab](CCNA/Module%201%20–%20Switching%20%28CCNA%29/Lab%206%20–%20DTP%20and%20Trunk%20Negotiation/README.md) |
| **1.7** | Device Discovery (CDP & LLDP) | Cisco Discovery Protocol, 802.1AB LLDP TLVs | [View Lab](CCNA/Module%201%20–%20Switching%20%28CCNA%29/Lab%207%20–%20CDP%20and%20LLDP/README.md) |
| **1.8** | L2 Troubleshooting Capstone | Multi-switch VLAN leak, trunk mismatch & STP loops | [View Lab](CCNA/Module%201%20–%20Switching%20%28CCNA%29/Lab%208%20–%20Troubleshooting%3A%20VLANs%2C%20Trunks%20and%20Inter-VLAN%20Routing/README.md) |

---

### 🔷 Module 2: IP Connectivity & OSPF Routing (8 Labs)
Focuses on route decision logic, administrative distance, and multi-area OSPF design.

| Lab | Title | Key Protocols / Technologies | Documentation |
| :---: | :--- | :--- | :---: |
| **2.1** | Static & Default Routes | Next-hop vs Outgoing Interface, Recursive Lookups | [View Lab](CCNA/Module%202%20–%20IP%20Connectivity%20%28CCNA%29/Lab%201%20–%20Static%20and%20Default%20Routes/README.md) |
| **2.2** | Route Selection & Floating Routes | Longest Prefix Match, Administrative Distance, Floating Static | [View Lab](CCNA/Module%202%20–%20IP%20Connectivity%20%28CCNA%29/Lab%202%20–%20Route%20Selection%3A%20Longest%20Prefix%2C%20Administrative%20Distance%20and%20Floating%20Routes/README.md) |
| **2.3** | Subnetting & VLSM Design | Variable Length Subnet Masking, Address Allocation | [View Lab](CCNA/Module%202%20–%20IP%20Connectivity%20%28CCNA%29/Lab%203%20–%20Subnetting%20and%20VLSM%20Design/README.md) |
| **2.4** | Single-Area OSPF & DR/BDR Election | Broadcast network type, Router Priority, Router-ID | [View Lab](CCNA/Module%202%20–%20IP%20Connectivity%20%28CCNA%29/Lab%204%20–%20Single-Area%20OSPF%20and%20DR-BDR%20Election/README.md) |
| **2.5** | Multi-Area OSPF & Inter-Area Summarization | ABRs, Backbone Area 0, Type 3 LSA reduction | [View Lab](CCNA/Module%202%20–%20IP%20Connectivity%20%28CCNA%29/Lab%205%20–%20Multi-Area%20OSPF%20and%20Inter-Area%20Summarization/README.md) |
| **2.6** | Default Route Origination & Failover | `default-information originate [always]`, Floating Backups | [View Lab](CCNA/Module%202%20–%20IP%20Connectivity%20%28CCNA%29/Lab%206%20–%20Default%20Route%20Origination%20and%20Floating%20Static%20Route/README.md) |
| **2.7** | OSPF Authentication & Fast Timers | MD5 / SHA Cryptographic Authentication, Hello/Dead Deadlines | [View Lab](CCNA/Module%202%20–%20IP%20Connectivity%20%28CCNA%29/Lab%207%20–%20OSPF%20Authentication%20and%20Timers/README.md) |
| **2.8** | OSPF Network Types & Cost Tuning | Point-to-Point vs Broadcast, Interface Cost, Auto-Cost Reference | [View Lab](CCNA/Module%202%20–%20IP%20Connectivity%20%28CCNA%29/Lab%208%20–%20OSPF%20Network%20Types%20and%20Cost%20Tuning/README.md) |

---

### 🔷 Module 3: IP Services & High Availability (8 Labs)
Focuses on NAT/PAT, First-Hop Redundancy Protocols, Access Control Lists, and Device Management.

| Lab | Title | Key Protocols / Technologies | Documentation |
| :---: | :--- | :--- | :---: |
| **3.1** | DHCP Server & DHCP Relay | Cisco IOS DHCP Pools, Excluded Addresses, `ip helper-address` | [View Lab](CCNA/Module%203%20–%20IP%20Services%20%28CCNA%29/Lab%201%20–%20DHCP%20Server%20and%20DHCP%20Relay/README.md) |
| **3.2** | NAT: PAT (Overload) & Static 1:1 NAT | Inside/Outside NAT definitions, Overload, Static Server Mapping | [View Lab](CCNA/Module%203%20–%20IP%20Services%20%28CCNA%29/Lab%202%20–%20NAT%3A%20PAT%20and%20Static%20NAT/README.md) |
| **3.3** | Dynamic NAT with a Public Pool | IP NAT Pools, ACL Matching, Address Translations | [View Lab](CCNA/Module%203%20–%20IP%20Services%20%28CCNA%29/Lab%203%20–%20Dynamic%20NAT%20with%20a%20Pool/README.md) |
| **3.4** | HSRP with Interface Tracking | Hot Standby Router Protocol, Preempt, Active/Standby Priority Tuning | [View Lab](CCNA/Module%203%20–%20IP%20Services%20%28CCNA%29/Lab%204%20–%20HSRP%20with%20Interface%20Tracking/README.md) |
| **3.5** | Standard & Named ACLs | Source filtering, numbered vs named ACL structure | [View Lab](CCNA/Module%203%20–%20IP%20Services%20%28CCNA%29/Lab%205%20–%20Standard%20and%20Named%20ACLs/README.md) |
| **3.6** | Extended Access Control Lists | Layer 4 TCP/UDP Port Filtering, Established Flag, ICMP Control | [View Lab](CCNA/Module%203%20–%20IP%20Services%20%28CCNA%29/Lab%206%20–%20Extended%20ACLs/README.md) |
| **3.7** | Device Management (SSH, NTP, Syslog) | RSA Crypto Keys, VTY Lines, Stratum Clock Sync, Remote Logging | [View Lab](CCNA/Module%203%20–%20IP%20Services%20%28CCNA%29/Lab%207%20–%20Device%20Management%3A%20SSH%2C%20NTP%20and%20Syslog/README.md) |
| **3.8** | Network Management (SNMPv2c & SNMPv3) | RO/RW Community Strings, SNMPv3 USM (AuthNoPriv, AuthPriv SHA/AES) | [View Lab](CCNA/Module%203%20–%20IP%20Services%20%28CCNA%29/Lab%208%20–%20SNMPv2c%20and%20SNMPv3/README.md) |

---

### 🔷 Module 4: Layer 2 & Infrastructure Security (5 Labs)
Hardening campus networks against Layer 2 attacks and rogue devices.

| Lab | Title | Key Protocols / Technologies | Documentation |
| :---: | :--- | :--- | :---: |
| **4.1** | Port Security | Static, Dynamic & Sticky MACs, Violations (Protect, Restrict, Shutdown) | [View Lab](CCNA/Module%204%20–%20Layer%202%20and%20Device%20Security%20%28CCNA%29/Lab%201%20–%20Port%20Security/README.md) |
| **4.2** | DHCP Snooping | Trusted vs Untrusted Ports, DHCP Binding Database, Rate Limiting | [View Lab](CCNA/Module%204%20–%20Layer%202%20and%20Device%20Security%20%28CCNA%29/Lab%202%20–%20DHCP%20Snooping/README.md) |
| **4.3** | Dynamic ARP Inspection (DAI) | ARP Poisoning prevention, Snooping Binding Validation, ARP ACLs | [View Lab](CCNA/Module%204%20–%20Layer%202%20and%20Device%20Security%20%28CCNA%29/Lab%203%20–%20Dynamic%20ARP%20Inspection/README.md) |
| **4.4** | Control Plane & Device Hardening | Password encryption (Type 8/9), Login banners, CoPP, Service disabling | [View Lab](CCNA/Module%204%20–%20Layer%202%20and%20Device%20Security%20%28CCNA%29/Lab%204%20–%20Device%20Hardening/README.md) |
| **4.5** | AAA Security with RADIUS | Cisco IOS AAA New-Model, FreeRADIUS Docker Integration, Local Fallback | [View Lab](CCNA/Module%204%20–%20Layer%202%20and%20Device%20Security%20%28CCNA%29/Lab%205%20–%20AAA%20with%20RADIUS%20and%20Local%20Fallback/README.md) |

---

### 🔷 Module 5: IPv6 Infrastructure (2 Labs)
Deployment of native IPv6 addressing and dynamic routing.

| Lab | Title | Key Protocols / Technologies | Documentation |
| :---: | :--- | :--- | :---: |
| **5.1** | IPv6 Addressing, SLAAC & Static Routes | Global Unicast, Link-Local, EUI-64, ICMPv6 Router Advertisements | [View Lab](CCNA/Module%205%20–%20IPv6%20%28CCNA%29/Lab%201%20–%20IPv6%20Addressing%2C%20SLAAC%20and%20Static%20Routing/README.md) |
| **5.2** | OSPFv3 for IPv6 | OSPFv3 Neighbor Adjacencies, Router-IDs, Link-Local Next-Hops | [View Lab](CCNA/Module%205%20–%20IPv6%20%28CCNA%29/Lab%202%20–%20OSPFv3%20for%20IPv6/README.md) |

---

### 🔷 Module 7: Border Gateway Protocol (BGP - CCNP Level) (5 Labs)
Deep dive into enterprise exterior routing, iBGP/eBGP peering, and path manipulation.

| Lab | Title | Key Protocols / Technologies | Documentation |
| :---: | :--- | :--- | :---: |
| **7.1** | eBGP Neighbors & Loopback Peering | Autonomous Systems, `ebgp-multihop`, Update-Source Loopbacks | [View Lab](CCNA/Module%207%20–%20BGP%20%28CCNP%29/Lab%201%20–%20eBGP%20Neighbors%20and%20Loopback%20Peering/README.md) |
| **7.2** | iBGP Full-Mesh & `next-hop-self` | iBGP Split-Horizon Rule, Next-hop preservation, Recursive Lookups | [View Lab](CCNA/Module%207%20–%20BGP%20%28CCNP%29/Lab%202%20–%20iBGP%20and%20next-hop-self/README.md) |
| **7.3** | BGP Route Reflectors | Route Reflector Clients, Cluster-IDs, Non-Client Reflection rules | [View Lab](CCNA/Module%207%20–%20BGP%20%28CCNP%29/Lab%203%20–%20BGP%20Route%20Reflectors/README.md) |
| **7.4** | Path Selection: Local Preference & Weight | Influencing outbound traffic, Cisco Weight vs BGP Local Preference | [View Lab](CCNA/Module%207%20–%20BGP%20%28CCNP%29/Lab%204%20–%20Local%20Preference%20and%20Weight/README.md) |
| **7.5** | Path Selection: MED & AS-Path Prepending | Influencing inbound return traffic, Multi-Exit Discriminator, Prepend tuning | [View Lab](CCNA/Module%207%20–%20BGP%20%28CCNP%29/Lab%205%20–%20MED%20and%20AS-Path%20Prepending/README.md) |

---

## 🔬 Featured Troubleshooting Spotlights

### Spotlight 1: BGP Inbound vs. Outbound Path Control (Lab 7.4 & 7.5)
* **Objective:** Control asymmetric traffic between autonomous systems.
* **Mechanism:** 
  - Used `weight` (local to router) and `local-preference` (advertised across iBGP) to steer outbound campus flows.
  - Used `AS-Path Prepending` and `MED` outbound to influence how external AS upstream providers route return traffic.
* **Fault Injection:** Inverted route-map direction (applying inbound instead of outbound); verified that external AS neighbors fell back to alternative transit links and diagnosed via `show ip bgp` and `debug ip bgp updates`.

### Spotlight 2: Defense-in-Depth L2 Protection (Module 4)
* **Objective:** Prevent rogue DHCP servers, ARP cache poisoning, and CAM table exhaustion attacks.
* **Mechanism:** Co-deployed DHCP Snooping + Dynamic ARP Inspection (DAI) on trunk and access switches.
* **Fault Injection:** Simulated an attacker attempting to answer DHCP DISCOVER requests with malicious gateways; validated switch dropped spoofed frames, incremented DAI error counters, and placed offending ports into `err-disabled`.

---

## 🚀 Active Development Roadmap (`dev` Branch)

The following advanced CCNP ENCOR / ENARSI and enterprise modules are currently being built and validated on the [`dev`](https://github.com/thearith6/GNS3-Lab-CCNA/tree/dev) branch:

- [ ] **Module 6:** Wireless LAN Architecture & Network Automation (RESTCONF / Ansible)
- [ ] **Module 7 (Labs 6–10):** Advanced BGP (Communities, Route Filtering, BFD, Dual-ISP Multihoming)
- [ ] **Module 8:** Advanced Routing (Mutual Route Redistribution, Route Tags, Policy-Based Routing, VRF-Lite)
- [ ] **Module 9:** Enterprise VPN Technologies (GRE, Site-to-Site IPsec with IKEv2, DMVPN Phase 1 & 3)
- [ ] **Module 10:** Infrastructure Services (PIM-SM Multicast, Flexible NetFlow, IP SLA)
- [ ] **Module 11:** Carrier Access (PPPoE Server/Client, MTU/MSS clamping, Dual-WAN Failover)
- [ ] **Module 12:** Data Center VXLAN (Underlay OSPF, Ingress Replication, BGP EVPN Control Plane, Symmetric IRB)
- [ ] **Module 13:** Cisco SD-WAN (vBond, vSmart, vManage bring-up, Service VPNs, OMP, Application-Aware Routing)
- [ ] **Module 14:** Enterprise NOC Monitoring (SNMP & Syslog telemetry collection with Zabbix)

---

## 👨‍💻 Author & Contact

**Thearith**  
*Network Engineer & Infrastructure Enthusiast*  
- **GitHub:** [@thearith6](https://github.com/thearith6)  
- **Focus:** Enterprise Campus & Data Center Networking, BGP/OSPF Routing, Network Automation
