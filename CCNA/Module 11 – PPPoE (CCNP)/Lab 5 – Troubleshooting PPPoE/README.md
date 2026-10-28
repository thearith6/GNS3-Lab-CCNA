## Lab 5 - Troubleshooting PPPoE

> **GNS3 Project:** [`Module 7 - PPPoE (CCNP) | Lab 5 - Troubleshooting PPPoE.gns3`](./Module%207%20-%20PPPoE%20%28CCNP%29%20%7C%20Lab%205%20-%20Troubleshooting%20PPPoE.gns3)

![topology](topology.png)

## Scenario
Use the configuration of Lab 1. On R2, remove pppoe enable from E 0/0. The PPPoE session on R1 does not come up. Find and fix the fault.

- **Devices:** PC1 (PC), R1 (IOU L3), R2 (IOU L3), R3 (IOU L3)
- **Base Addressing:**
  - `R3` Ethernet0/0: `203.0.113.2` (255.255.255.252)
  - `R3` Loopback0: `198.51.100.1` (255.255.255.255)
  - `R1` Ethernet0/1: `192.168.10.1` (255.255.255.0)
  - `R2` Ethernet0/1: `203.0.113.1` (255.255.255.252)
  - `R2` Virtual-Template1: `10.255.0.1` (255.255.255.255)
  - `PC1` Ethernet0: `192.168.10.11` (GW: 192.168.10.1)

Task 1 - Use the configuration of Lab 1.
  - On R2, remove pppoe enable from E 0/0.
  - The PPPoE session on R1 does not come up.
  - Find and fix the fault.

Task 2 - On R2, remove peer default ip address pool from Virtual-Template 1 and restart the session.
  - The session is up, but Dialer1 gets no usable address.
  - Find and fix the fault.

Task 3 - On R1, change Dialer1 to dialer pool 2.
  - The session does not come up.
  - Find and fix the fault.

## Action
Task 1 - Use the configuration of Lab 1.

**R1:**
```cisco
interface Ethernet0/0
pppoe enable group BBA1
```

Task 2 - On R2, remove peer default ip address pool from Virtual-Template 1 and restart the session.

**R1:**
```cisco
interface Virtual-Template1
peer default ip address pool PPPOE-POOL
```

Task 3 - On R1, change Dialer1 to dialer pool 2.

## Note
1. Verification commands: `Show pppoe session`, `Show ip interface brief`
2. No session is listed. Show ip interface brief
3. Dialer1 has no usable IP address.
4. Dialer1 did not receive an address from R2.
5. No session is listed. E 0/0 uses dial-pool-number 1, but Dialer1 uses pool 2. interface Dialer1 dialer pool 1
6. On R2, replace the user CPE1 with CPE2 (no username CPE1, username CPE2 password PPPoE123). Restart Dialer1 on R1. — R2 does not know the user CPE1. The CHAP authentication fails and the session closes. Note: Fix it by creating the user CPE1 again.