## Lab 1 - Port Security

> **GNS3 Project:** [`Module 4 - Layer 2 Security (CCNA) | Lab 1 - Port Security.gns3`](./Module%204%20-%20Layer%202%20Security%20%28CCNA%29%20%7C%20Lab%201%20-%20Port%20Security.gns3)

![topology](topology.png)

## Scenario
On SW1 E 0/1, enable port security so that only one MAC address can use the port. Learn the MAC address dynamically and keep it in the running configuration. When a violation occurs, the port must drop the frames and log the event without shutting down.

- **Devices:** ATK (PC), PC1 (PC), PC2 (PC), R1 (IOU L3), SW1 (IOU L2)
- **Base Addressing:**
  - `R1` Ethernet0/0: `192.168.10.1` (255.255.255.0)
  - `ATK` Ethernet0: `192.168.10.66` (GW: 192.168.10.1)
  - `PC1` Ethernet0: `192.168.10.11` (GW: 192.168.10.1)
  - `PC2` Ethernet0: `192.168.10.12` (GW: 192.168.10.1)

Task 1 - On SW1 E 0/1, enable port security so that only one MAC address can use the port.
  - Learn the MAC address dynamically and keep it in the running configuration.
  - When a violation occurs, the port must drop the frames and log the event without shutting down.

Task 2 - On SW1 E 0/2, allow only the MAC address of PC2 (0050.7966.6802), configured statically.
  - When a violation occurs, the port must shut down.

Task 3 - Verify the port security configuration.

## Action
Task 1 - On SW1 E 0/1, enable port security so that only one MAC address can use the port.

**SW1:**
```cisco
interface Ethernet0/1
switchport mode access
switchport port-security
switchport port-security maximum 1
switchport port-security mac-address sticky
switchport port-security violation restrict
```

Task 2 - On SW1 E 0/2, allow only the MAC address of PC2 (0050.7966.6802), configured statically.

**SW1:**
```cisco
interface Ethernet0/2
switchport mode access
switchport port-security
switchport port-security mac-address 0050.7966.6802
switchport port-security violation shutdown
```

Task 3 - Verify the port security configuration.

## Note
1. Verification commands: `Show port-security`
2. E 0/1 and E 0/2 should be listed with a maximum of 1 address each. Show port-security interface ethernet0/1
3. The port status should be Secure-up and the violation mode Restrict.
4. Connect ATK to SW1 E 0/2 in place of PC2. Check the port. SW1 — The port is err-disabled. The MAC address of ATK does not match the allowed address. Note: Recover the port with the commands below after removing ATK. interface Ethernet0/2 shutdown no shutdown