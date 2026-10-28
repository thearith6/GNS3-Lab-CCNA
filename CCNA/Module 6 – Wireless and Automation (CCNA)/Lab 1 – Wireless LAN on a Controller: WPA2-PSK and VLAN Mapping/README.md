## Lab 1 - Wireless LAN on a Controller: WPA2-PSK and VLAN Mapping

> **GNS3 Project:** [`Module 6 - Automation (CCNA) | Lab 1 - Wireless LAN.gns3`](./Module%206%20-%20Automation%20%28CCNA%29%20%7C%20Lab%201%20-%20Wireless%20LAN.gns3)

![topology](topology.png)

## Scenario
Prepare the wired network. SW1 uses a trunk to R1 and a trunk to the controller (VLANs 10 and 20), and an access port in VLAN 10 for the access point. R1 routes between the VLANs and is the DHCP server for the access point (VLAN 10) and the clients (VLAN 20).

- **Devices:** PC1 (PC), R1 (IOU L3), SW1 (IOU L2)
- **Base Addressing:**
  - `R1` Ethernet0/0.10: `192.168.10.1` (255.255.255.0)
  - `R1` Ethernet0/0.20: `192.168.20.1` (255.255.255.0)

Task 1 - Prepare the wired network.
  - SW1 uses a trunk to R1 and a trunk to the controller (VLANs 10 and 20), and an access port in VLAN 10 for the access point.
  - R1 routes between the VLANs and is the DHCP server for the access point (VLAN 10) and the clients (VLAN 20).

Task 2 - Configure the controller.
  - Create the dynamic interface STAFF for VLAN 20, then create the WLAN CORP that uses WPA2 with a pre-shared key and is mapped to this interface.

Task 3 - Verify that the access point joined the controller and that the laptop is connected.
  - Configure on WLC (GUI)
  - Configure on Laptop

## Action
Task 1 - Prepare the wired network.

**SW1:**
```cisco
vlan 10
name MGMT
vlan 20
name STAFF
interface range Ethernet0/0 - 1
switchport trunk encapsulation dot1q
switchport trunk allowed vlan 10,20
switchport mode trunk
interface Ethernet0/2
switchport mode access
switchport access vlan 10
```

**R1:**
```cisco
interface Ethernet0/0
no shutdown
interface Ethernet0/0.10
encapsulation dot1Q 10
ip address 192.168.10.1 255.255.255.0
interface Ethernet0/0.20
encapsulation dot1Q 20
ip address 192.168.20.1 255.255.255.0
ip dhcp excluded-address 192.168.10.1
192.168.10.10
ip dhcp excluded-address 192.168.20.1
192.168.20.10
ip dhcp pool MGMT
network 192.168.10.0 255.255.255.0
default-router 192.168.10.1
ip dhcp pool STAFF
network 192.168.20.0 255.255.255.0
default-router 192.168.20.1
```

Task 2 - Configure the controller.

**WLC (GUI):**
```cisco
Controller > Interfaces > New
Interface Name: STAFF
VLAN ID: 20
IP Address: 192.168.20.5
Netmask: 255.255.255.0
Gateway: 192.168.20.1
DHCP Server: 192.168.20.1
WLANs > Create New > Go
Profile Name: CORP
SSID: CORP
ID: 1
WLANs > CORP > General
Status: Enabled
Interface/Interface Group: STAFF
WLANs > CORP > Security > Layer 2
Layer 2 Security: WPA+WPA2
WPA2 Policy-AES: checked
Auth Key Mgmt: PSK
PSK Format ASCII: Cisco-Wifi-123
```

Task 3 - Verify that the access point joined the controller and that the laptop is connected.

**WLC (GUI):**
```cisco
Monitor > Access Points
```

**Laptop:**
```cisco
Monitor > Clients
```

## Note
1. Verification commands: `Ping 192.168.20.1`
2. AP1 should be listed as registered.
3. The ping should succeed.
4. The Laptop should be associated with the SSID CORP and have an address in 192.168.20.0/24 on the interface STAFF.
5. On the controller, map the WLAN CORP to the interface management instead of STAFF. Reconnect the laptop. — The laptop gets an address from VLAN 10 (192.168.10.0/24) instead of VLAN 20. Note: Select the interface STAFF again to fix it.
6. On the laptop, enter the wrong key (Cisco-Wifi-124) for the SSID CORP. Laptop — The authentication fails and the laptop cannot associate. In Monitor > Clients the laptop is not listed.